## golang 基于 drone CI检测 (.drone.yml)
```yml
kind: pipeline
type: docker
name: specdemo

steps:
  - name: go cycle
    image: golang:1.16
    environment:
      GOPROXY: "https://goproxy.cn"
    commands:
      - go install github.com/fzipp/gocyclo/cmd/gocyclo@latest
      - echo "top 10"
      - gocyclo -top 10 -ignore vendor .
      - echo "over 20"
      - gocyclo -over 20 -ignore vendor .
    when:
      branch:
        - main
      event:
        - pull_request

  - name: lint
    image: golang:1.16
    environment:
      GOPROXY: "https://goproxy.cn"
    commands:
      - export PKG_LIST="$(go list ./... | grep -v /vendor/ )"
      - echo $PKG_LIST
      - |
        if [ "$(gofmt -s -l $(find . -type f -name '*.go'| grep -v "/vendor/") | wc -l)" -gt 0 ]; then
          echo "code fmt does not pass, the non-standard files are as follows:"
          echo "\033[31m `gofmt -s -l $(find . -type f -name '*.go'| grep -v "/vendor/")` \033[0m"
          exit 1;
        fi
      - |
        if [ "$(go vet $PKG_LIST 2>&1 | wc -l)" -gt 0 ]; then
          echo "code go vet does not pass, the non-standard code is as follows:"
          echo "\033[31m `go vet $PKG_LIST 2>&1` \033[0m"
          exit 1;
        fi
      - go install github.com/golangci/golangci-lint/cmd/golangci-lint@v1.44.0
      - golangci-lint run --disable-all -E errcheck
    when:
      branch:
        - main
      event:
        - pull_request

  - name: race test  
    image: golang:1.16
    environment:
      GOPROXY: "https://goproxy.cn"
    commands:
      - export PKG_LIST="$(go list ./... | grep -v /vendor/)"
      - go test -run=TestCI -race -v $PKG_LIST
    when:
      branch:
        - main
      event:
        - pull_request

  - name: cover test
    image: golang:1.16
    environment:
      GOPROXY: "https://goproxy.cn"
    commands:
      - export PKG_LIST="$(go list ./... | grep -v /vendor/)"
      - go test -run=TestCI -covermode=count -coverprofile=coverage.out $PKG_LIST
      - go tool cover -func=coverage.out -o coverage.txt
      - tail -n 1 coverage.txt | awk '{print $$1,$$3}'
      - rm -rf coverage.txt coverage.out
    when:
      branch:
        - main
      event:
        - pull_request

  - name: bench test
    image: golang:1.16
    environment:
      GOPROXY: "https://goproxy.cn"
    commands:
      - go install golang.org/x/perf/cmd/benchstat@latest
      - go test -bench=BenchmarkCI -benchtime=5s -count 10 -benchmem -cpuprofile=cpu.out -memprofile=mem.out -trace=trace.out | tee bench.txt
      - benchstat bench.txt
      - rm cpu.out mem.out trace.out *.test bench.txt
    when:
      branch:
        - main
      event:
        - pull_request

```

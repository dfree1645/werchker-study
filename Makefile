##### init #####

# 開発に必要なパッケージをインストールする
install:
	@which direnv || go get -v github.com/zimbatm/direnv
	@direnv allow
	@which glide || go get -v github.com/Masterminds/glide
	@which goimports || go get -v golang.org/x/tools/cmd/goimports
	@which golint || go get -v github.com/golang/lint/golint
	@glide install

# 実行する
run:
	@go run main.go

### wercker ###

# werckerのテストに使うコマンドなど

deps:
	@which golint || go get -v github.com/golang/lint/golint
	@which goimports || go get -v golang.org/x/tools/cmd/goimports
	@which glide || go get -v github.com/Masterminds/glide
	@glide install

build:
	go build -o outBinary ./main.go

test:
	go test -v $(shell glide novendor)

DIRS=$(shell go list -f {{.Dir}} ./... | grep -vf .golint_exclude)

lint:
	@for d in $(DIRS) ; do \
		if [ "`gofmt -l $$d/*.go | tee /dev/stderr`" ]; then \
			echo "^ - gofmtしてください。gofmtしてください。gofmtしてください。" && echo && exit 1; \
		fi \
	done
	@for d in $(DIRS) ; do \
		if [ "`goimports -l $$d/*.go | tee /dev/stderr`" ]; then \
			echo "^ - 上記のファイルはgoimportsが実行されていません。実行してください。" && echo && exit 1; \
		fi \
	done
	@if [ "`golint ./... | grep -vf .golint_exclude | tee /dev/stderr`" ]; then \
		echo "^ - godocを書いてください。" && echo && exit 1; \
fi

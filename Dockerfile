FROM alpine:3.4

MAINTAINER Deepak Prabhakara <deepak.prabhakara@gmail.com> (@deepakprab)

ENV GLIDE=0.10.2

RUN apk update && apk add curl git go && rm -rf /var/cache/apk/*

ENV GOROOT /usr/lib/go
ENV GOPATH /gopath
ENV GOBIN /gopath/bin
ENV PATH $PATH:$GOROOT/bin:$GOPATH/bin

# Install glide for Go dependency management
RUN cd /tmp && \
	curl -L https://github.com/Masterminds/glide/releases/download/$GLIDE/glide-$GLIDE-linux-amd64.tar.gz -o glide.tar.gz && \
	tar -xzf glide.tar.gz && \
	cp /tmp/linux-amd64/glide /usr/local/bin

# Install go-bindata to package files inside binary
RUN go get -u github.com/jteeuwen/go-bindata && \
	cd $GOPATH/src && \
	go build github.com/jteeuwen/go-bindata/go-bindata && \
	mv go-bindata $GOROOT/bin && \
	go-bindata -version

RUN go version
RUN glide -v

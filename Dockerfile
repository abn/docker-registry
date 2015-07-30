FROM fedora:latest
MAINTAINER Arun Neelicattu <arun.neelicattu@gmail.com>

RUN dnf -y upgrade

# install base requirements
RUN dnf -y install golang git hg

# prepare gopath
ENV GOPATH /go
ENV PATH /go/bin:${PATH}
RUN mkdir -p ${GOPATH}

# install build dependencies
RUN dnf -y install librados2 librados2-devel httpd-tools make

ENV PACKAGE github.com/docker/distribution
ENV VERSION 2.0.1
ENV GO_BUILD_TAGS netgo include_rados
ENV CGO_ENABLED 0

RUN go get github.com/tools/godep
RUN go get ${PACKAGE}

WORKDIR ${GOPATH}/src/${PACKAGE}
RUN git checkout -b v${VERSION} v${VERSION}

RUN godep restore

RUN mkdir bin
RUN GOPATH=`godep path`:${GOPATH} go build \
        -tags "${GO_BUILD_TAGS}" \
        -ldflags "-s -w -X ${PACKAGE}/version.Version ${VERSION}" \
        -v -a -installsuffix cgo \
        -o ./bin/registry \
        ./cmd/registry

RUN du -hs ./bin/registry
RUN mkdir -p data tmp log var/lib/registry

RUN rm -f ${PWD}/Dockerfile
COPY Dockerfile.final ./Dockerfile

CMD docker build -t alectolytic/registry ${PWD}

#
# Copyright (c) 2020
# Intel Corporation
#
# SPDX-License-Identifier: Apache-2.0
#
FROM golang:1.13-alpine

LABEL license='SPDX-License-Identifier: Apache-2.0' \
      copyright='Copyright (c) 2020: Intel Corporation'

RUN sed -e 's/dl-cdn[.]alpinelinux.org/nl.alpinelinux.org/g' -i~ /etc/apk/repositories

RUN apk add --update --no-cache git linux-headers make gcc musl-dev curl bash

#Optional dependencies. These are useful for generating reports for tools like SonarQube and Jenkins

# Installing gometalinter
# Usage example: gometalinter.v2 --checkstyle --vendor --disable gotype --deadline=120s --config=/linter-settings.json ./...
RUN  go get -u gopkg.in/alecthomas/gometalinter.v2 &&  gometalinter.v2 --install
COPY linter-settings.json /

# Installing gocov to output code coverage xml files. Useful for SonarQube code coverage
# Usage Example: gocov test ./... | gocov-xml
RUN go get github.com/axw/gocov/... && \
    go get github.com/AlekSi/gocov-xml

# Install JUnit style plugin for exporting to report.xml files. Useful for Jenkins JUnit Plugin
# Usage example: go test ./... -v 2>&1 | go-junit-report
RUN go get -u github.com/jstemmer/go-junit-report

ENV GO111MODULE=on
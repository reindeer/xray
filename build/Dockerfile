FROM            golang:1.21-alpine as build
ARG             RELEASE
WORKDIR         /build
RUN             apk update; \
                apk add --no-cache wget;
RUN             wget https://github.com/XTLS/Xray-core/archive/refs/tags/v$RELEASE.tar.gz; \
                tar xf v$RELEASE.tar.gz && rm v$RELEASE.tar.gz
WORKDIR         /build/Xray-core-$RELEASE
RUN             go mod tidy
RUN             go build -o bin/xray -trimpath -ldflags "-s -w -buildid=" ./main; \
                mkdir /xray && mv bin/ /xray/

FROM            alpine:latest as app
COPY            --from=build /xray/bin/* /bin/
WORKDIR         /xray
RUN             touch config.json
CMD             ["/bin/xray", "-c", "./config.json"]

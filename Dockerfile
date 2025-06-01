# syntax=docker/dockerfile:1.7
FROM alpine:3.20 AS build
LABEL org.opencontainers.image.authors="Nazar Malizderskyi"
RUN apk add --no-cache gcc musl-dev upx binutils

WORKDIR /src
COPY server.S server.c page_html.h page.html .

ARG TARGETPLATFORM
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
      gcc -nostdlib -nostartfiles -static -Os -s server.S -o server; \
    else \
      gcc -static -Os -s server.c -o server; \
    fi \
 && upx --ultra-brute server

FROM scratch
COPY --from=build /src/server /server
EXPOSE 8080
CMD ["/server"]

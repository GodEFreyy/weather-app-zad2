#include <stdio.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <time.h>
#include <string.h>
#include "page_html.h"

static const char hdr[] =
  "HTTP/1.0 200 OK\r\n"
  "Content-Type: text/html\r\n\r\n";

int main() {
    char buf[128];
    size_t n = snprintf(buf, sizeof(buf),
      "[%lu] Container started. Author: Nazar Malizderskyi Port:8080\n",
      (unsigned long)time(NULL));
    write(1, buf, n);

    int s = socket(AF_INET, SOCK_STREAM, 0);
    struct sockaddr_in a = { .sin_family=AF_INET,
                             .sin_port=htons(8080),
                             .sin_addr.s_addr=INADDR_ANY };
    bind(s, (struct sockaddr*)&a, sizeof(a));
    listen(s, 5);

    for (;;) {
        int c = accept(s, NULL, NULL);
        char req[512];
        read(c, req, sizeof(req));
        write(c, hdr, strlen(hdr));
        write(c, page_html, page_html_len);
        close(c);
    }
    return 0;
}

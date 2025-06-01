.intel_syntax noprefix
.text
.global _start

_start:
    mov   rax,41
    mov   rdi,2
    mov   rsi,1
    xor   rdx,rdx
    syscall
    mov   r12,rax

    mov   rax,1
    mov   rdi,1
    lea   rsi,[rip+msg]
    mov   rdx,msg_end-msg
    syscall

    mov   rax,49
    mov   rdi,r12
    lea   rsi,[rip+sockaddr]
    mov   rdx,16
    syscall

    mov   rax,50
    mov   rdi,r12
    mov   rsi,5
    syscall

accept_loop:
    mov   rax,43
    mov   rdi,r12
    xor   rsi,rsi
    xor   rdx,rdx
    syscall
    mov   r13,rax

    mov   rax,0
    mov   rdi,r13
    lea   rsi,[rsp-512]
    mov   rdx,512
    syscall

    mov   rax,1
    mov   rdi,r13
    lea   rsi,[rip+hdr]
    lea   rdx,[rip+hdr_end]
    sub   rdx,rsi
    syscall

    mov   rax,1
    mov   rdi,r13
    lea   rsi,[rip+page]
    lea   rdx,[rip+page_end]
    sub   rdx,rsi
    syscall

    mov   rax,3
    mov   rdi,r13
    syscall

    jmp   accept_loop

.section .rodata
msg:
    .ascii "Container started. Author: Nazar Malizderskyi Port:8080\n"
msg_end:

hdr:
    .ascii "HTTP/1.0 200 OK\r\nContent-Type: text/html\r\n\r\n"
hdr_end:

page:
    .incbin "page.html"
page_end:

.section .data
sockaddr:
    .short 2
    .short 0x901f
    .long 0
    .long 0

extern be_egesz
extern ki_egesz
extern be_logikai
extern ki_logikai
global main

section .bss
Label0 resb 4
Label1 resb 4
Label2 resb 1

section .text
main:
call be_egesz
mov [Label0],eax
mov eax,1
push eax
mov eax,[Label0]
pop ebx
add eax,ebx
mov [Label0],eax
mov eax,2
push eax
mov eax,[Label0]
pop ebx
sub eax,ebx
mov [Label0],eax
mov eax,[Label0]
push eax
mov eax,[Label0]
pop ebx
mov edx,0
mul ebx
mov [Label0],eax
mov eax,2
push eax
mov eax,[Label0]
pop ebx
mov edx,0
div ebx
mov [Label0],eax
call be_logikai
mov [Label2],al
mov al,[Label2]
xor al,1
push ax
mov eax,32
push eax
mov eax,[Label0]
pop ebx
cmp eax,ebx
je Label3
mov al,0
jmp Label4
Label3:
mov al,1
Label4:
pop bx
or al,bl
cmp al,1
jne near Label5
mov eax,[Label0]
push eax
call ki_egesz
add esp,4
jmp Label_endif1
Label5:
mov eax,18
push eax
mov eax,[Label0]
pop ebx
cmp eax,ebx
je Label6
mov al,0
jmp Label7
Label6:
mov al,1
Label7:
cmp al,1
jne near Label11
mov eax,1
push eax
call ki_egesz
add esp,4
jmp Label_endif1
Label11:
mov eax,8
push eax
mov eax,[Label0]
pop ebx
cmp eax,ebx
je Label8
mov al,0
jmp Label9
Label8:
mov al,1
Label9:
cmp al,1
jne near Label10
mov eax,2
push eax
call ki_egesz
add esp,4
jmp Label_endif1
Label10:
mov al,[Label2]
push eax
call ki_logikai
add esp,4
jmp Label_endif1
Label_endif1:
ret

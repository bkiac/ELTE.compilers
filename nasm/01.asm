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
mov eax,0
mov [Label1],eax
call be_logikai
mov [Label2],al
Label8:
mov al,[Label2]
cmp al,1
je Label9
jmp Label10
Label9:
call be_egesz
mov [Label0],eax
mov eax,100
push eax
mov eax,[Label0]
pop ebx
cmp eax,ebx
jb Label5
mov al,0
jmp Label6
Label5:
mov al,1
Label6:
push ax
mov eax,10
push eax
mov eax,[Label0]
pop ebx
cmp eax,ebx
ja Label3
mov al,0
jmp Label4
Label3:
mov al,1
Label4:
pop bx
and al,bl
cmp al,1
jne near Label7
mov eax,[Label0]
push eax
mov eax,[Label1]
pop ebx
add eax,ebx
mov [Label1],eax
jmp Label_endif1
Label7:
Label_endif1:
call be_logikai
mov [Label2],al
jmp Label8
Label10:
mov eax,[Label1]
push eax
call ki_egesz
add esp,4
ret

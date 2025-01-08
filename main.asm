.386
.model flat, stdcall
.stack 4096

INCLUDE io.h

.data
filename BYTE "input.txt", 0
fileHandle DWORD ?
buffer BYTE 256 DUP(0)
array DWORD 10 DUP(0)
arraySize DWORD 0
bytesRead DWORD ?
outputBuffer BYTE 256 DUP(0)
outputLength DWORD ?
consoleHandle DWORD ?
space BYTE " ", 0

.code
main PROC
    ; Open file
    push NULL
    push FILE_ATTRIBUTE_NORMAL
    push OPEN_EXISTING
    push NULL
    push 0
    push GENERIC_READ
    push OFFSET filename
    call CreateFile
    mov fileHandle, eax

    cmp eax, INVALID_HANDLE_VALUE
    je FileOpenError

    ; Read file
    push NULL
    push OFFSET bytesRead
    push 256
    push OFFSET buffer
    push fileHandle
    call ReadFile

    ; Close the file
    push fileHandle
    call CloseHandle

    ; Parse the buffer and store numbers in array
    lea esi, buffer
    lea edi, array
    mov ecx, 0

ParseLoop:
    mov al, [esi]
    cmp al, 0
    je ParseDone
    cmp al, ' '
    je SkipSpace

    ; ASCII to integer
    sub al, '0'
    movzx eax, al
    
    ; Multiply by 10 and add the next digit
    push eax
    mov eax, [edi]
    mov ebx, 10
    mul ebx
    pop ebx
    add eax, ebx
    mov [edi], eax
    jmp NextChar

; Skip the space
SkipSpace:
    add edi, 4
    inc arraySize
    mov DWORD PTR [edi], 0 

NextChar:
    inc esi
    jmp ParseLoop

ParseDone:
    inc arraySize  

    ; Bubble sort
    mov ecx, arraySize
    dec ecx         ; Array size - 1

OuterLoop:
    cmp ecx, 0
    je Done

    mov ebx, ecx
    mov edi, OFFSET array

InnerLoop:
    mov eax, [edi]
    mov edx, [edi + 4]

    cmp eax, edx
    jle SkipSwap

    ; Swap the numbers
    mov [edi], edx
    mov [edi + 4], eax

SkipSwap:
    add edi, 4
    dec ebx
    jnz InnerLoop

    dec ecx
    jmp OuterLoop

Done:
    push STD_OUTPUT_HANDLE
    call GetStdHandle
    mov consoleHandle, eax

    ; Print sorted array
    mov ecx, arraySize
    mov esi, OFFSET array
    mov edi, OFFSET outputBuffer
    
PrintLoop:
    mov eax, [esi]    
    add esi, 4        
    
    ; Convert number to ASCII
    push ecx          
    mov ecx, 0        
    mov ebx, 10
    
ConvertLoop:
    mov edx, 0
    div ebx         
    add dl, '0'       
    push edx         
    inc ecx           
    test eax, eax     
    jnz ConvertLoop
    
StoreLoop:
    pop eax          
    mov [edi], al     
    inc edi
    loop StoreLoop    
    
    mov BYTE PTR [edi], ' '
    inc edi
    
    pop ecx           
    loop PrintLoop   
    
    ; Calculate output length
    mov eax, edi
    sub eax, OFFSET outputBuffer
    mov outputLength, eax
    
    ; Write to console
    push 0
    push OFFSET bytesRead
    push outputLength
    push OFFSET outputBuffer
    push consoleHandle
    call WriteConsole

    push 0
    call ExitProcess

FileOpenError:
    push 1
    call ExitProcess

main ENDP
END main
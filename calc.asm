; File: ReverMachine.asm

; geneer code voor Intel 80386 processor of hoger,
;  zorgt voor de win32 API

.386
.model flat, stdcall
option casemap:none

include C:\masm32\include\windows.inc
include C:\masm32\include\kernel32.inc
include C:\masm32\include\user32.inc
includelib C:\masm32\lib\kernel32.lib
includelib C:\masm32\lib\user32.lib

WinMain proto :DWORD,:DWORD,:DWORD,:DWORD
WndProc  proto :DWORD,:DWORD,:DWORD,:DWORD

.const
    ; Constante gegevens
    ClassName   db "Rever Machine", 0
    AppName     db "Rever Machine", 0
    ID_EDIT     equ 1002
    ID_INSBTN1  equ 1003
    ID_INSBTN2  equ 1004
    ID_INSBTN3  equ 1005
    ID_INSBTN4  equ 1006
    ID_INSBTN5  equ 1007
    ID_INSBTN6  equ 1008
    ID_INSBTN7  equ 1009
    ID_INSBTN8  equ 1010
    ID_INSBTN9  equ 1011
    ID_INSBTN0  equ 1012

    ID_MBTN     equ 1013
    ID_PBTN     equ 1014
    ID_KBTN     equ 1015
    ID_DBTN     equ 1016
    ID_IBTN     equ 1017
    ID_BBTN     equ 1018
    ID_CBTN     equ 1019

.data?
    ; Ongeïnitialiseerde data

    hInstance   HINSTANCE ?
    CommandLine LPSTR ?
    hEdit       HWND ?
    hInsertBtn1 HWND ?
    hInsertBtn2 HWND ?
    hInsertBtn3 HWND ?
    hInsertBtn4 HWND ?
    hInsertBtn5 HWND ?
    hInsertBtn6 HWND ?
    hInsertBtn7 HWND ?
    hInsertBtn8 HWND ?
    hInsertBtn9 HWND ?
    hInsertBtn0 HWND ?
    hInsertBtnM HWND ?
    hInsertBtnP HWND ?
    hInsertBtnK HWND ?
    hInsertBtnD HWND ?
    hInsertBtnI HWND ?
    hInsertBtnB HWND ?
    hInsertBtnC HWND ?

    hOutputEdit HWND ?
    finalResult DWORD ?
    resultBuffer db 16 dup(?)
    negativeFlag db ?

.data
    ; Geïnitialiseerde Data

    szEdit      db "edit", 0
    szButton    db "button", 0
    szInsert1   db "1", 0
    szInsert2   db "2", 0
    szInsert3   db "3", 0
    szInsert4   db "4", 0
    szInsert5   db "5", 0
    szInsert6   db "6", 0
    szInsert7   db "7", 0
    szInsert8   db "8", 0
    szInsert9   db "9", 0
    szInsert0   db "0", 0

    szInsertM   db "-", 0
    szInsertP   db "+", 0
    szInsertK   db "*", 0
    szInsertD   db "/", 0
    szInsertI   db "=", 0

    digit1      db "1", 0
    digit2      db "2", 0
    digit3      db "3", 0
    digit4      db "4", 0
    digit5      db "5", 0
    digit6      db "6", 0
    digit7      db "7", 0
    digit8      db "8", 0
    digit9      db "9", 0
    digit0      db "0", 0

    symboolM    db "-", 0
    symboolP    db "+", 0
    symboolK    db "*", 0
    symboolD    db "/", 0
    delendoor0  db "Je hebt gedeeld door 0, dat kan niet!", 0
    symboolI    db "=", 0

    actionB     db "C", 0
    actionC     db "Ce", 0

    msgTitle    db "Info", 0
    msgError    db "Error", 0
    editBuffer  db 256 dup(0)

.code
start:
    ; Startpunt van het programma

    invoke GetModuleHandle, NULL

    ; Een uniek ID

    mov hInstance, eax
    invoke GetCommandLine

    ; GetCommandLine is een Windows-functie die een pointer geeft naar de command line waarmee dit programma gestart is

    mov CommandLine, eax
    invoke WinMain, hInstance, NULL, CommandLine, SW_SHOWDEFAULT

    ; Dit regelt alles wat met het venster en de gebruikersinterface te maken heeft:
    ; het aanmaken van het venster
    ; de knoppen en invoervelden aanmaken
    ; de Windows message loop starten (dus dat je op knoppen kunt klikken, enz.)


    ; Als dit stukje klaar is, dan wordt ExitProcess aangeroepen om het programma netjes af te sluiten
    invoke ExitProcess, eax



WinMain proc hInst:HINSTANCE, hPrevInst:HINSTANCE, CmdLine:LPSTR, CmdShow:DWORD

    ; Dit maakt een beschrijving van het venster bijv kleur, en naam

    LOCAL wc:WNDCLASSEX
    LOCAL msg:MSG
    LOCAL hwnd:HWND

    mov wc.cbSize, SIZEOF WNDCLASSEX
    mov wc.style, CS_HREDRAW or CS_VREDRAW
    mov wc.lpfnWndProc, OFFSET WndProc
    mov wc.cbClsExtra, 0
    mov wc.cbWndExtra, 0
    push hInst
    pop wc.hInstance
    mov wc.hbrBackground, COLOR_WINDOW+1
    mov wc.lpszMenuName, NULL
    mov wc.lpszClassName, OFFSET ClassName
    invoke LoadIcon, NULL, IDI_APPLICATION
    mov wc.hIcon, eax
    mov wc.hIconSm, eax
    invoke LoadCursor, NULL, IDC_ARROW
    mov wc.hCursor, eax

    ; 400 bij 400 venster
    ; Registreer de klasse voor het venster
    invoke RegisterClassEx, addr wc
    invoke CreateWindowEx, 0, ADDR ClassName, ADDR AppName,
           WS_OVERLAPPED or WS_CAPTION or WS_SYSMENU or WS_MINIMIZEBOX,
           CW_USEDEFAULT, CW_USEDEFAULT, 400, 400,
           NULL, NULL, hInst, NULL
    mov hwnd, eax

    ; Input box
    invoke CreateWindowEx, WS_EX_CLIENTEDGE, addr szEdit, NULL,
           WS_CHILD or WS_VISIBLE or ES_READONLY or ES_AUTOHSCROLL,
           20, 20, 360, 40, hwnd, ID_EDIT, hInst, NULL
    mov hEdit, eax

    ; Output box
    invoke CreateWindowEx, WS_EX_CLIENTEDGE, addr szEdit, NULL,
           WS_CHILD or WS_VISIBLE or ES_READONLY or ES_AUTOHSCROLL,
           20, 60, 360, 40, hwnd, ID_EDIT, hInst, NULL
       mov hOutputEdit, eax

    ; Button 1
    invoke CreateWindowEx, 0, addr szButton, addr szInsert1,
           WS_CHILD or WS_VISIBLE or BS_PUSHBUTTON,
           20, 270, 80, 30, hwnd, ID_INSBTN1, hInst, NULL
    mov hInsertBtn1, eax

    ; Button 2
    invoke CreateWindowEx, 0, addr szButton, addr szInsert2,
           WS_CHILD or WS_VISIBLE or BS_PUSHBUTTON,
           110, 270, 80, 30, hwnd, ID_INSBTN2, hInst, NULL
    mov hInsertBtn2, eax

    ; Button 3
    invoke CreateWindowEx, 0, addr szButton, addr szInsert3,
           WS_CHILD or WS_VISIBLE or BS_PUSHBUTTON,
           200, 270, 80, 30, hwnd, ID_INSBTN3, hInst, NULL
    mov hInsertBtn3, eax

    ; Button 4
    invoke CreateWindowEx, 0, addr szButton, addr szInsert4,
           WS_CHILD or WS_VISIBLE or BS_PUSHBUTTON,
           20, 220, 80, 30, hwnd, ID_INSBTN4, hInst, NULL
    mov hInsertBtn4, eax

    ; Button 5
    invoke CreateWindowEx, 0, addr szButton, addr szInsert5,
           WS_CHILD or WS_VISIBLE or BS_PUSHBUTTON,
           110, 220, 80, 30, hwnd, ID_INSBTN5, hInst, NULL
    mov hInsertBtn5, eax

    ; Button 6
    invoke CreateWindowEx, 0, addr szButton, addr szInsert6,
           WS_CHILD or WS_VISIBLE or BS_PUSHBUTTON,
           200, 220, 80, 30, hwnd, ID_INSBTN6, hInst, NULL
    mov hInsertBtn6, eax

    ; Button 7
    invoke CreateWindowEx, 0, addr szButton, addr szInsert7,
           WS_CHILD or WS_VISIBLE or BS_PUSHBUTTON,
           20, 170, 80, 30, hwnd, ID_INSBTN7, hInst, NULL
    mov hInsertBtn7, eax
    
    ; Button 8
    invoke CreateWindowEx, 0, addr szButton, addr szInsert8,
           WS_CHILD or WS_VISIBLE or BS_PUSHBUTTON,
           110, 170, 80, 30, hwnd, ID_INSBTN8, hInst, NULL
    mov hInsertBtn8, eax

    ; Button 9
    invoke CreateWindowEx, 0, addr szButton, addr szInsert9,
           WS_CHILD or WS_VISIBLE or BS_PUSHBUTTON,
           200, 170, 80, 30, hwnd, ID_INSBTN9, hInst, NULL
    mov hInsertBtn9, eax
    
    ; Button 0
    invoke CreateWindowEx, 0, addr szButton, addr szInsert0,
           WS_CHILD or WS_VISIBLE or BS_PUSHBUTTON,
           70, 320, 160, 30, hwnd, ID_INSBTN0, hInst, NULL
    mov hInsertBtn0, eax

    ; Button M
    invoke CreateWindowEx, 0, addr szButton, addr szInsertM,
           WS_CHILD or WS_VISIBLE or BS_PUSHBUTTON,
           290, 170, 80, 30, hwnd, ID_MBTN, hInst, NULL
    mov hInsertBtnM, eax

    ; Button P
    invoke CreateWindowEx, 0, addr szButton, addr szInsertP,
           WS_CHILD or WS_VISIBLE or BS_PUSHBUTTON,
           290, 220, 80, 30, hwnd, ID_PBTN, hInst, NULL
    mov hInsertBtnP, eax

    ; Button K
    invoke CreateWindowEx, 0, addr szButton, addr szInsertK,
           WS_CHILD or WS_VISIBLE or BS_PUSHBUTTON,
           290, 120, 80, 30, hwnd, ID_KBTN, hInst, NULL
    mov hInsertBtnK, eax

    ; Button D
    invoke CreateWindowEx, 0, addr szButton, addr szInsertD,
           WS_CHILD or WS_VISIBLE or BS_PUSHBUTTON,
           200, 120, 80, 30, hwnd, ID_DBTN, hInst, NULL
    mov hInsertBtnD, eax

    ; Button I
    invoke CreateWindowEx, 0, addr szButton, addr szInsertI,
           WS_CHILD or WS_VISIBLE or BS_PUSHBUTTON,
           290, 270, 80, 30, hwnd, ID_IBTN, hInst, NULL
    mov hInsertBtnI, eax

    ; Button B
    invoke CreateWindowEx, 0, addr szButton, addr actionB,
           WS_CHILD or WS_VISIBLE or BS_PUSHBUTTON,
           110, 120, 80, 30, hwnd, ID_BBTN, hInst, NULL
    mov hInsertBtnB, eax

    ; Button C
    invoke CreateWindowEx, 0, addr szButton, addr actionC,
           WS_CHILD or WS_VISIBLE or BS_PUSHBUTTON,
           20, 120, 80, 30, hwnd, ID_CBTN, hInst, NULL
    mov hInsertBtnC, eax

    invoke ShowWindow, hwnd, SW_SHOWNORMAL
    invoke UpdateWindow, hwnd

msg_loop:
    invoke GetMessage, addr msg, NULL, 0, 0
    cmp eax, 0
    je end_loop
    invoke TranslateMessage, addr msg
    invoke DispatchMessage, addr msg
    jmp msg_loop

end_loop:
    mov eax, msg.wParam
    ret
WinMain endp

WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
    .if uMsg == WM_COMMAND
        .if wParam == ID_INSBTN1
            invoke GetWindowText, hEdit, addr editBuffer, 255
            invoke lstrcat, addr editBuffer, addr digit1
            invoke SetWindowText, hEdit, addr editBuffer
        .elseif wParam == ID_INSBTN2
            invoke GetWindowText, hEdit, addr editBuffer, 255
            invoke lstrcat, addr editBuffer, addr digit2
            invoke SetWindowText, hEdit, addr editBuffer
        .elseif wParam == ID_INSBTN3
            invoke GetWindowText, hEdit, addr editBuffer, 255
            invoke lstrcat, addr editBuffer, addr digit3
            invoke SetWindowText, hEdit, addr editBuffer
        .elseif wParam == ID_INSBTN4
            invoke GetWindowText, hEdit, addr editBuffer, 255
            invoke lstrcat, addr editBuffer, addr digit4
            invoke SetWindowText, hEdit, addr editBuffer
        .elseif wParam == ID_INSBTN5
            invoke GetWindowText, hEdit, addr editBuffer, 255
            invoke lstrcat, addr editBuffer, addr digit5
            invoke SetWindowText, hEdit, addr editBuffer
        .elseif wParam == ID_INSBTN6
            invoke GetWindowText, hEdit, addr editBuffer, 255
            invoke lstrcat, addr editBuffer, addr digit6
            invoke SetWindowText, hEdit, addr editBuffer
        .elseif wParam == ID_INSBTN7
            invoke GetWindowText, hEdit, addr editBuffer, 255
            invoke lstrcat, addr editBuffer, addr digit7
            invoke SetWindowText, hEdit, addr editBuffer
        .elseif wParam == ID_INSBTN8
            invoke GetWindowText, hEdit, addr editBuffer, 255
            invoke lstrcat, addr editBuffer, addr digit8
            invoke SetWindowText, hEdit, addr editBuffer
        .elseif wParam == ID_INSBTN9
            invoke GetWindowText, hEdit, addr editBuffer, 255
            invoke lstrcat, addr editBuffer, addr digit9
            invoke SetWindowText, hEdit, addr editBuffer
        .elseif wParam == ID_INSBTN0
            invoke GetWindowText, hEdit, addr editBuffer, 255
            invoke lstrcat, addr editBuffer, addr digit0
            invoke SetWindowText, hEdit, addr editBuffer
        .elseif wParam == ID_MBTN
            invoke GetWindowText, hEdit, addr editBuffer, 255
            invoke lstrcat, addr editBuffer, addr symboolM
            invoke SetWindowText, hEdit, addr editBuffer
        .elseif wParam == ID_PBTN
            invoke GetWindowText, hEdit, addr editBuffer, 255
            invoke lstrcat, addr editBuffer, addr symboolP
            invoke SetWindowText, hEdit, addr editBuffer
        .elseif wParam == ID_KBTN
            invoke GetWindowText, hEdit, addr editBuffer, 255
            invoke lstrcat, addr editBuffer, addr symboolK
            invoke SetWindowText, hEdit, addr editBuffer
        .elseif wParam == ID_DBTN
            invoke GetWindowText, hEdit, addr editBuffer, 255
            invoke lstrcat, addr editBuffer, addr symboolD
            invoke SetWindowText, hEdit, addr editBuffer
        .elseif wParam == ID_BBTN

            ; Haalt de input en zet het in editBuffer
            ; Berekent de lengte van de input

            ; Als de lengte groter is dan 0, verwijdert het laatste karakter
            ; Dat doet dec
            ; Zet een null terminator op de laatste positie
            ; Zet de nieuwe tekst in het invoerveld


            invoke GetWindowText, hEdit, addr editBuffer, 255
            invoke lstrlen, addr editBuffer
            .if eax > 0
                dec eax
                mov byte ptr [editBuffer+eax], 0
                invoke SetWindowText, hEdit, addr editBuffer
            .endif
        .elseif wParam == ID_CBTN
            mov byte ptr [editBuffer], 0
            invoke SetWindowText, hEdit, addr editBuffer

            ; Reset de ouptput

        .elseif wParam == ID_IBTN

            ; Dit stukje code leest de input van de input box, Loopt door elk teken (Parsing)
            ; Voert de berekening uit
            ; Zet het resultaat in de output box
            ; Geeft ook een foutmelding als er wordt gedeelt door 0

            invoke GetWindowText, hEdit, addr editBuffer, 255
            invoke lstrlen, addr editBuffer
            test eax, eax
            jz end_if        ; skip empty input

            xor eax, eax
            mov finalResult, eax
            xor ebx, ebx         ; current number
            lea esi, editBuffer
            mov dl, '+'          ; default operator

            eval_loop: ; loopt door de string
                mov al, [esi] ; lees het volgende teken
                cmp al, 0
                je eval_done ; einde van de string dus klaar

                cmp al, '+'
                je do_op
                cmp al, '-'
                je do_op
                cmp al, '*'
                je do_op
                cmp al, '/'
                je do_op

                sub al, '0' ; converteer ASCII naar integer
                movzx ecx, al
                imul ebx, ebx, 10
                add ebx, ecx
                inc esi
                jmp eval_loop

            do_op: ; Als er in de loop een operator is gevonden doe dan
                cmp dl, '+'
                jne chk_sub
                mov eax, finalResult
                add eax, ebx
                mov finalResult, eax
                jmp set_op
            chk_sub:
                cmp dl, '-'
                jne chk_mul
                mov eax, finalResult
                sub eax, ebx
                mov finalResult, eax
                jmp set_op
            chk_mul:
                cmp dl, '*'
                jne chk_div
                mov eax, finalResult
                imul eax, ebx
                mov finalResult, eax
                jmp set_op
            chk_div:
                cmp ebx, 0
                je show_div_zero
                mov eax, finalResult
                xor edx, edx
                div ebx
                mov finalResult, eax
                jmp set_op

            show_div_zero:
                invoke MessageBox, NULL, addr delendoor0, addr msgError, MB_OK
                jmp end_if

            set_op: ; Zet de operator voor de volgende iteratie
                mov dl, [esi]
                xor ebx, ebx
                inc esi
                jmp eval_loop

            eval_done: ; Einde van de string, voer de laatste operatie uit
                cmp dl, '+'
                jne chk_sub2
                mov eax, finalResult
                add eax, ebx
                mov finalResult, eax
                jmp to_string
            chk_sub2:
                cmp dl, '-'
                jne chk_mul2
                mov eax, finalResult
                sub eax, ebx
                mov finalResult, eax
                jmp to_string
            chk_mul2:
                cmp dl, '*'
                jne chk_div2
                mov eax, finalResult
                imul eax, ebx
                mov finalResult, eax
                jmp to_string
            chk_div2:
                cmp ebx, 0
                je show_div_zero
                mov eax, finalResult
                xor edx, edx
                div ebx
                mov finalResult, eax
            to_string: ; Zet het resultaat om naar een string
                mov ecx, finalResult
                lea edi, resultBuffer
                add edi, 15
                mov byte ptr [edi], 0 ; null terminator

                mov ebx, 10

                ; check if negative
                mov eax, ecx
                sar eax, 31           ; eax = 0 or -1
                jz positive
                neg ecx               ; -ecx = ecx
                mov negativeFlag, 1   ; negatieve flag zetten
                jmp convert

            positive:
                mov negativeFlag, 0   ; positive ; niet negatief

            convert:
                test ecx, ecx
                jnz convert_loop
                dec edi
                mov byte ptr [edi], '0'
                jmp addsign

            convert_loop:
                mov edx, 0
                mov eax, ecx
                div ebx
                add dl, '0'
                dec edi
                mov [edi], dl
                mov ecx, eax
                test eax, eax
                jnz convert_loop

            addsign: ; Voeg een teken toe als het negatief is
                cmp negativeFlag, 0   ; negative?
                je show_result
                dec edi
                mov byte ptr [edi], '-'

            show_result:
                invoke SetWindowText, hOutputEdit, edi

        end_if:
        .endif

    .elseif uMsg == WM_DESTROY
        invoke PostQuitMessage, 0
    .else
        invoke DefWindowProc, hWnd, uMsg, wParam, lParam
        ret
    .endif
    xor eax, eax
    ret
WndProc endp

end start
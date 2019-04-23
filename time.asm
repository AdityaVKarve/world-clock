;MPMC PROJECT-WORLD CLOCK
;###########################################
;#Author-Aditya Karve, 179301021, Section A#
;###########################################
   
include 'emu8086.inc'
.MODEL SMALL
.DATA
.CODE
START:
PRINTN 'Select City'
PRINTN '1-TORONTO'
PRINTN '2-BEIJING'
PRINTN '3-DELHI'
PRINTN '4-QUIT'
MOV Ah,01H
INT 21H
MOV Bl,Al  
PRINTN ''
SUB Bl,30H ;Converting to hexa
CMP Bl,01H
JZ TORONTO
CMP Bl, 02H
JZ BEIJING
CMP Bl,03H
JZ DELHI 
CMP Bl, 04H
JZ QUIT
PRINTN 'ENTER A VALID INPUT'
JMP START
TORONTO:
MOV Ah,2Ch ;GET TIME
INT 21H
; Hours is in CH
;Minutes is in CL
;Seconds is in DH
MOV Al,Ch
MOV Dl,10d  ;Since Toronto is 1030 hours behind
MOV Dh,24d  ;Since A day has 24 hours
CALL decrLoop 
AAM
MOV [1000],Al ;Move left hand side away
MOV Al,00H;Set it to 0
MOV Bx,10H;Right hand side into base
MUL Bx
ADD [1000],Ah;Get proper value
MOV Al,[1000]
MOV Ch,Al   ;Got the hours in Toronto

MOV Al,Cl
MOV Dl,30d  ;Since Toronto is 1030 hours behind  
MOV Dh,60d  ;Since an hour has 60 minutes
CALL decrLoop
AAM 
MOV [1000],Al ;Move left hand side away
MOV Al,00H;Set it to 0
MOV Bx,10H;Right hand side into base
MUL Bx
ADD [1000],Ah;Get proper value
MOV Al,[1000]
MOV Cl,Al
MOV [1002],Ch
MOV [1004],Cl 
JMP DISP 

BEIJING:
MOV Ah,2Ch
INT 21H 
MOV Al,Ch
MOV Dl,2d  ;Since Beijing is 0230 hours ahead
MOV Dh,24d  ;Since A day has 24 hours
CALL incrLoop 
AAM
MOV [1000],Al ;Move left hand side away
MOV Al,00H;Set it to 0
MOV Bx,10H;Right hand side into base
MUL Bx
ADD [1000],Ah;Get proper value
MOV Al,[1000]
MOV Ch,Al   ;Got the hours in Beijing

MOV Al,Cl
MOV Dl,30d  ;Since Beijing is 0230 hours ahead  
MOV Dh,60d  ;Since an hour has 60 minutes
CALL incrLoop
AAM 
MOV [1000],Al ;Move left hand side away
MOV Al,00H;Set it to 0
MOV Bx,10H;Right hand side into base
MUL Bx
ADD [1000],Ah;Get proper value
MOV Al,[1000]
MOV Cl,Al
MOV [1002],Ch
MOV [1004],Cl 
JMP DISP 

DELHI:
MOV Ah,2CH
INT 21H 
MOV Al,Ch
AAM
MOV [1000],Al ;Move left hand side away
MOV Al,00H;Set it to 0
MOV Bx,10H;Right hand side into base
MUL Bx
ADD [1000],Ah;Get proper value
MOV Al,[1000]
MOV Ch,Al   ;Got the hours in Delhi
MOV [1002],Ch

MOV Al,Cl
AAM
MOV [1000],Al ;Move left hand side away
MOV Al,00H;Set it to 0
MOV Bx,10H;Right hand side into base
MUL Bx
ADD [1000],Ah;Get proper value
MOV Al,[1000]
MOV Ch,Al   ;Got the minutes in Delhi
MOV [1004],Cl  
JMP DISP
QUIT:
    IRET
decrLoop PROC  
    L1:
        CMP Al,00H
        JZ L3 
    L2:
        DEC Al
        DEC Dl
        CMP Dl,00H 
        JZ L4
        JMP L1
    L3: 
        ADD Al,Dh
        JMP L2
    L4:
        RET    
       
incrLoop PROC           
    L5:
        INC Al
        CMP Al,Dh
        JGE L7
    L6:
        DEC Dl
        CMP Dl,00H 
        JZ L8
        JMP L5
    L7: 
        SUB Al,Dh
        JMP L6
    L8:
        RET

DISP:
    MOV Dl,[1002] ;Get hours
    ROL Dl,4H     ;Get Right hand side digit
    AND Dl,0xF    ;Isolate it
    ADD Dl,'0'    ;Get ASCII
    MOV Ah,02H
    INT 21H       ;Print it
    MOV Dl,[1002] ;Get hours
    AND Dl,0xF    ;Isolate left hand side digit
    ADD Dl,'0'    ;ASCII
    MOV Ah,02H
    INT 21H
    PRINT ':'
    MOV Dl,[1004] 
    ROL Dl,4H
    AND Dl,0xF
    ADD Dl,'0'
    MOV Ah,02h
    INT 21H
    MOV Dl,[1004]
    AND Dl,0xF
    ADD Dl,'0'
    MOV Ah,02h
    INT 21H
    PRINTN ''
    PRINTN '' 
    JMP START
IRET 

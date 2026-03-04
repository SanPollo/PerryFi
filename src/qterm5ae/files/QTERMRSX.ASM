; QTERMRSX.ASM - RSX to handle interrupt driven serial I/P for Qterm.com
; Coding in Philip Wade's VDU program has provided inspiration for this RSX.
; Coding to send Remote Off if buffer nearly full added 25/04/95
; Some elements of Z80.LIB imported 24/05/95
;
; Stephen Younger - 14th June 1995

; Assemble with RMAC

YES	EQU	-1
NO	EQU	0

FAXLINK	EQU	NO  		; will be set to YES by QTERMNEW.BAS
				;  if required	        ~~~~~~~~~~~~
ZMP	EQU	NO		; set TRUE if RSX is for ZMP, not QTERM
IF FAXLINK			; Values for Serial ports with Fax link fitted
				; 			       ~~~~~~~~~~~~~~~
STATP	EQU	0C9H		; Status channel
DATAP	EQU	0C8H		; Data channel

ELSE				; Port addresses for CPS8256

STATP	EQU	0E1H		; Status channel
DATAP	EQU	0E0H		; Data channel

ENDIF

XOFF	EQU	'S'-40H		; Remote Off & On
XON	EQU	'Q'-40H

SYSINF	EQU	00E6H		; System information getter
SIPGES	EQU	32		; No of 256 byte pages in buffer
				;  use 8, 16 or 32 * ONLY * (largest
				;  buffer gives best results but
				;  bulkiest file)

;;	NECESSARY FRAGMENTS OF Z80.LIB FOLLOW

;;	@CHKJ MACRO USED FOR CHECKING RELATIVE JUMPS
;;
@CHKJ	MACRO	?DD	;; USED FOR CHECKING RANGE OF 8-BIT DISP.S
	IF (?DD GT 7FH) AND (?DD LT 0FF80H)
 'RELATIVE JUMP ERROR'
	ENDIF
	ENDM

JR	MACRO	?N
	@CHKJ	?N-$-1
	DB	18H,?N-$-1
	ENDM
JRC	MACRO	?N
	@CHKJ	?N-$-1
	DB	38H,?N-$-1
	ENDM
JRNC	MACRO	?N
	@CHKJ	?N-$-1
	DB	30H,?N-$-1
	ENDM
JRZ	MACRO	?N
	@CHKJ	?N-$-1
	DB	28H,?N-$-1
	ENDM
JRNZ	MACRO	?N
	@CHKJ	?N-$-1
	DB	20H,?N-$-1
	ENDM
DJNZ	MACRO	?N
	@CHKJ	?N-$-1
	DB	10H,?N-$-1
	ENDM

BC	EQU	0
DE	EQU	2
HL	EQU	4

DSBC	MACRO	?R		; Covers for - SBC  RR
	DB	0EDH,?R*8+42H	;  where RR may be BC, DE or HL
	ENDM
OUTI	MACRO		
	DB	0EDH,0A3H
	ENDM
OUTIR	MACRO		
	DB	0EDH,0B3H
	ENDM
OUTP	MACRO	?R		; OUT    (C),R
	DB	0EDH,?R*8+41H
	ENDM
RETI	MACRO		
	DB	0EDH,4DH
	ENDM

CR	EQU	13
LF	EQU	10

	CSEG
	
	; -----------
	; RSX Header
	; -----------

	DS	6
	JMP	CPM
CPM:	JMP	$-$
PREV:	DW	$-$
REMOV:	DB	-1		; Set remove flag on
NBANK:	DB	0		; shows banked system
IF	ZMP
NAM:	DB	'ZMPRSX  '
ELSE
NAM:	DB	'QTERMRSX'
ENDIF
LOADER:	DB	0
SPARE:	DW	0

INIT:	JMP	INI		; initialize
QUIT:	JMP	QUII		; and quit

JPHL:	PCHL

INI:	LHLD	6
	LXI	D,0C100H	; allow for stack
	ORA	A
	DSBC	DE
	JRNC	INI1
	LXI	D,NOMEM
FAIL:	MVI	C,9
	CALL	CPM
	JMP	0

NOMEM:	DB	'Not enough memory',CR,LF,LF,'$'
NOSIO:	DB	' ERROR: Serial Interface NOT fitted',7,CR,LF,LF,'$'

SELMEM:	JMP	$-$

INI1:	LHLD	1
	LXI	D,3*(27-1)	; Selmem offset
	DAD	D
	SHLD	SELMEM+1
	LXI	D,9
	DAD	D
	CALL	JPHL
	DW	SYSINF
	INR	C
	JRZ	INI2
	LXI	D,NOSIO		; lifted from main program
	JR	FAIL

INI2:
	LXI	H,CHRTST	; covers for ModIst - Modem in state
IF	ZMP
	SHLD	20BH		; set up call address
	LXI	H,GTCHR
	SHLD	1F0H		; covers for ModIn
ELSE
	SHLD	111H		; set up call address
	LXI	H,GTCHR
	SHLD	121H		; covers for ModIn
ENDIF
	DI
	CALL	SETINT		; Divert interrupt in bank 1
	XRA	A
	CALL	SELMEM
	DI			; selmem clears the interrupt
	CALL	SETINT		; Divert interrupt in bank 0
	MVI	A,1
	CALL	SELMEM
IF FAXLINK
	DI
	LXI	B,0BCBH		; Reset Channel B
	LXI	H,CHBTAB	;	~~~~~~~~~
	OUTIR
	JR	TAKWT

CHBTAB:	DB	18h		; Reset the Channel
	DB	4,0C4h		; x 64 Clock Mode, 1 Stop bit
	DB	3,0C0h		; Rx 8 bits/Char
	DB	2,0		; Set Interrupt Vector to nul
	DB	5,0E0h		; DTR & 8 bits
	DB	1,4		; Status Affects Vector
	
TAKWT:	EI
	CALL	InWait
ENDIF		
	RET

SETINT:	MVI	A,0DFH		; is RST 18h
	STA	38H
	LXI	H,18H		; RST 18h Address
	LXI	D,GTSIX
	MVI	M,0C3H		; jump op
	INX	H
	MOV	M,E
	INX	H
	MOV	M,D
	RET

QUII:	DI
	LXI	H,38H
	MVI	M,0C3H		; restore normal interrupt
	XRA	A
	CALL	SELMEM
	DI
	MVI	M,0C3H		; in both banks
	MVI	A,1
	CALL	SELMEM		; back to TPA
IF	FAXLINK
	DI
	MVI	A,1		; Select Reg 1
	OUT	0C9h
	XRA	A		; Clear WR1
	OUT	0C9h
	INR	A
	OUT	0CBh
	XRA	A
	OUT	0CBh		; Clear Stat Reg 1
	EI
ENDIF
	RET

GTSIX:				; Read a Char to store in Buffer
	PUSH	PSW
	IN	STATP
	RAR			; Has a '1'?
	JRC	GTSI00		; if the jump fails, use of relative jump
	LDA	WAIBYT		;  is quicker
	ORA	A
	JRZ	GTSIX1
	DCR	A
	STA	WAIBYT
GTSIX1:	POP	PSW
	XTHL
	LHLD	039H		; go directly to normal interrupt address
	XTHL
	RET

GTSI00:
IF FAXLINK

	MVI	A,2		; Look at Modified Interrupt Vector
	OUT	0CBh
	IN	0CBh
	ANI	6		; Will return '4' if byte to deliver
	JRZ	GTSI02
	RRC
	DCR	A
	JRZ	GTSI01
	DCR	A
	JRZ	GTSIA
	MVI	A,30h		; Error Reset
	OUT	0C9h
	OUT	0C9h
	IN	0C8h
	JR	GTSI04

GTSI01:	MVI	A,10h		; Reset Ext/Status Interrupts
	OUT	0C9h
	OUT	0C9h
	JR	GTSI04

GTSI02:	MVI	A,10h		; Reset Ext/Status Interrupts
	OUT	0C9h
	OUT	0C9h
	MVI	A,28h		; Reset Tx Int Pending
	OUT	0C9h
	OUT	0C9h

ELSE
	JR	GTSIA
ENDIF

GTSI04:	MVI	A,38h		; Return from Interrupt
	OUT	STATP
	POP	PSW
	XTHL
	POP	H
	EI
	RETI

GTSIA:	PUSH	D
	PUSH	H
GTSIA1:	IN	DATAP
	LHLD	BUFWT		; get addr to put byte
	MOV	M,A
	LXI	D,BUFBAS-1	; bump address
	ORA	A
	DSBC	DE
	MOV	A,H
	ANI	SIPGES-1	; set buffer limit
	MOV	H,A
	INX	D		; Set DE to BUFBAS
	DAD	D
	SHLD	BUFWT		; and store address for next write
	LHLD	BUFCNT
	INX	H		; bump buffer count
	SHLD	BUFCNT
	LDA	XOFFFG		; Test for impending overflow
	ORA	A
	JRNZ	GTSIB
	LDA	BUFCNT+1
	CPI	SIPGES-8
	JRC	GTSIB		; if few spare pages left
	MVI	A,XOFF		; send XOFF
	CALL	CHRSND
	MVI	A,-1
	STA	XOFFFG		; and set flag
GTSIB:	IN	STATP
	RAR			; Char ready?
	JRC	GTSIA1		; Loop back for any more
	POP	H
	POP	D
	JR	GTSI04

CHRTST:				; Test for Char Ready
	LHLD	BUFCNT		; Anything to lift?
	MOV	A,H
	ORA	L
	RET
GTCHR:				; Get Char from buffer
	LDA	XOFFFG
	ORA	A
	JZ	GTCHR1
	LDA	BUFCNT+1
	CPI	SIPGES/8
	JNC	GTCHR1
	MVI	A,XON		; re-start flow
	CALL	CHRSND
	XRA	A
	STA	XOFFFG		; flag off
GTCHR1:	DI
	LHLD	BUFCNT		; Anything to lift?
	MOV	A,H
	ORA	L
	JZ	GTCHR3		; quit if not
	DCX	H		; bump down contents
	SHLD	BUFCNT
	EI
	LHLD	BUFRD		; get read address
	MOV	A,M
	PUSH	PSW
	LXI	D,BUFBAS-1	; bump address
	ORA	A
	DSBC	DE
	MOV	A,H
	ANI	SIPGES-1	; set buffer limit
	MOV	H,A
	INX	D
	DAD	D
	SHLD	BUFRD		; store address for next read
	POP	PSW
GTCHR3:	EI
	RET

CHRSND:				; SEND A CHAR
	PUSH	PSW
CHRSN1:	IN	STATP
	ANI	4
	JZ	CHRSN1
	POP	PSW
	OUT	DATAP
	RET

InWait:	PUSH	PSW		; Count off 30 Interrupts
	PUSH	H
	LXI	H,WAIBYT
	MVI	M,30
InWt01:	MOV	A,M
	ORA	A
	JNZ	InWt01
	POP	H
	POP	PSW
	RET

XOFFFG:	DB	0		; Set true if Remote Off called
WAIBYT:	DB	0		; Used to allow DART to settle?
BUFCNT:	DW	0		; No. of bytes in buffer
BUFWT:	DW	BUFBAS		; Address of SI byte written to buffer
BUFRD:	DW	BUFBAS		; 	"	"    read from buffer

BUFBAS	EQU	$		; buffer origin
BUFFER:	DS	(SIPGES*256)

END
 in Philip Wade's VDU program has provided ins
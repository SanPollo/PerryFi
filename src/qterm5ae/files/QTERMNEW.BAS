1 ' QTERM patcher - Stephen Younger 14/06/95
10 '
100 PRINT "QTERMNEW - Patcher for fast version of QTERM": PRINT: PRINT
110 Fax.Link=0: Sprinter=0: Speed=0: nt.Fnd$=" not Found"
120 FxStP$=CHR$(&HC9): FxDtP$=CHR$(&HC8): SprtSpd$=CHR$(6)
130 DIM Bit.Tb$(19): Bit.Tb$(2)=CHR$(&HA8)
140 Bit.Tb$(4)=CHR$(&HA6): Bit.Tb$(9)=CHR$(&HA4)
150 Rsx.Fax$="FAXLINK"+CHR$(9)+"EQU"+CHR$(9)
160 Ipt1$="To set default Baud Rate FROM 1200 TO 2400, 4800"
170 Ipt2$=" or 9600 Enter 2, 4 or 9"
180 Ipt3$=", 9600 or 19200 Enter 2, 4, 9 or 19"
190 fil1$="QTERMCOM.COM": fil2$="QTERM5F.COM"
200 fil3$="QTERMRSX.ASM": fil4$="QTNEWASM.SUB"
210 INPUT "Is a Sprinter fitted Y/N";i$
220 IF UPPER$(LEFT$(i$,1))="Y" THEN Sprinter=-1
230 INPUT "Is a Fax Link fitted Y/N";i$
240 IF UPPER$(LEFT$(i$,1))="Y" THEN Fax.Link=-1: Bit.Tb$(19)=CHR$(&HA2)
250 IF Fax.Link THEN Ipt$=Ipt1$+Ipt3$ ELSE Ipt$=Ipt1$+Ipt2$
260 PRINT Ipt$;: INPUT i
270 IF i=0 THEN 290
280 IF Bit.Tb$(i)<>"" THEN Speed=-1: Speed$=Bit.Tb$(i)
290 ' IF FIND$(fil1$)="" THEN PRINT fil1$;nt.Fnd$: STOP
300 ' OPEN "R",#1,fil1$: FIELD #1,128 AS a$
310 IF FIND$(fil1$)="" THEN PRINT fil1$;nt.Fnd$: STOP
320 IF FIND$(fil3$)="" THEN PRINT fil3$;nt.Fnd$: STOP
330 IF FIND$(fil2$)<>"" THEN KILL fil2$
340 NAME fil1$ AS fil2$
350 OPEN "R",#2,fil2$: FIELD #2,128 AS b$
360 FOR a=1 TO 8
370 IF Fax.Link AND a=1 THEN GET #2,a: GOSUB 570: PUT #2,a
380 IF Sprinter AND a=2 THEN GET #2,a: MID$(b$,79)=SprtSpd$: PUT #2,a
390 IF Speed AND a=4 THEN GET #2,a: MID$(b$,92)=Speed$: PUT #2,a
400 NEXT
410 CLOSE: GOSUB 600 'Set Switch in QtermRSX.ASM
420 OPEN "O",#1,fil4$
430 PRINT #1,"a:rmac qtermrsx $$pz"
440 PRINT #1,"a:link qtermrsx[op nr]"
450 PRINT #1,"era qtermrsx.rsx"
455 PRINT #1,"ren qtermrsx.rsx=qtermrsx.prl"
460 PRINT #1,"a:gencom qterm5f qtermrsx"
470 CLOSE 
480 :
490 chain$=fil4$+CHR$(0)
500 dest=127 ' CP/M default buffer - 1
510 FOR a=1 TO LEN(chain$): POKE dest+a,ASC(MID$(chain$,a,1)): NEXT
520 DATA 14,47,30,0,195,5,0
530 RESTORE 520: dest=192
540 FOR a=0 TO 6: READ c: POKE dest+a,c: NEXT
550 CALL dest
560 END
570 MID$(b$,50)=FxStP$: MID$(b$,66)=FxDtP$: MID$(b$,89)=FxStP$
580 MID$(b$,92)=FxStP$: MID$(b$,103)=FxStP$: MID$(b$,106)=FxStP$: RETURN
590 :
600 OPEN "R",#1,fil3$: FIELD #1,128 AS a$: GET #1,3
610 pn=INSTR(a$,Rsx.Fax$): IF pn=0 THEN STOP
620 IF Fax.Link THEN MID$(a$,pn+12)="YES" ELSE MID$(a$,pn+12)="NO "
630 PUT #1,3: CLOSE: RETURN
 QTERM patcher - Stephen Younger 14/06/95
10 '
100 PRINT "QTERMNEW - Patcher for fast version of QTERM": PRINT: PRINT
110 
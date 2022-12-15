
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 1.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _state=R5
	.DEF _i=R6
	.DEF _i_msb=R7
	.DEF _tin_high=R8
	.DEF _tin_high_msb=R9
	.DEF _tin_low=R10
	.DEF _tin_low_msb=R11
	.DEF _t_highint=R12
	.DEF _t_highint_msb=R13
	.DEF __lcd_x=R4

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _ext_int2_isr
	JMP  0x00
	JMP  0x00

_shift:
	.DB  0xFE,0xFD,0xFB,0xF7
_layout:
	.DB  0x37,0x38,0x39,0x2F,0x34,0x35,0x36,0x2A
	.DB  0x31,0x32,0x33,0x2D,0x43,0x30,0x3D,0x2B
_tbl10_G102:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G102:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0

_0x3:
	.DB  0x7F
_0x0:
	.DB  0x6D,0x6F,0x64,0x65,0x3A,0x68,0x69,0x67
	.DB  0x68,0x0,0x6D,0x6F,0x64,0x65,0x3A,0x6E
	.DB  0x6F,0x72,0x6D,0x61,0x6C,0x0,0x6D,0x6F
	.DB  0x64,0x65,0x3A,0x6F,0x66,0x66,0x0,0x2F
	.DB  0x3A,0x20,0x54,0x65,0x6D,0x70,0x0,0x2A
	.DB  0x3A,0x20,0x49,0x6E,0x74,0x65,0x72,0x76
	.DB  0x61,0x6C,0x0,0x54,0x65,0x6D,0x70,0x3D
	.DB  0x20,0x25,0x64,0x0,0x2B,0x3A,0x20,0x48
	.DB  0x69,0x67,0x68,0x0,0x2D,0x3A,0x20,0x4C
	.DB  0x6F,0x77,0x0,0x54,0x65,0x6D,0x70,0x3A
	.DB  0x20,0x2B,0x25,0x64,0x20,0x2D,0x25,0x64
	.DB  0x0,0x43,0x3A,0x20,0x42,0x61,0x63,0x6B
	.DB  0x0,0x3D,0x3A,0x20,0x69,0x6E,0x20,0x68
	.DB  0x69,0x67,0x68,0x20,0x74,0x65,0x6D,0x70
	.DB  0x0,0x3D,0x3A,0x20,0x69,0x6E,0x20,0x6C
	.DB  0x6F,0x77,0x20,0x74,0x65,0x6D,0x70,0x0
	.DB  0x2B,0x3A,0x20,0x68,0x69,0x67,0x68,0x0
	.DB  0x2B,0x3A,0x20,0x75,0x70,0x70,0x65,0x72
	.DB  0x20,0x69,0x6E,0x74,0x65,0x72,0x76,0x61
	.DB  0x6C,0x0,0x2D,0x3A,0x20,0x6C,0x6F,0x77
	.DB  0x65,0x72,0x20,0x69,0x6E,0x74,0x65,0x72
	.DB  0x76,0x61,0x6C,0x0,0x69,0x6E,0x74,0x65
	.DB  0x72,0x76,0x61,0x6C,0x3A,0x20,0x2B,0x25
	.DB  0x64,0x20,0x2D,0x25,0x64,0x0,0x3D,0x3A
	.DB  0x20,0x69,0x6E,0x20,0x68,0x69,0x67,0x68
	.DB  0x20,0x69,0x6E,0x74,0x65,0x72,0x76,0x61
	.DB  0x6C,0x0,0x2D,0x3A,0x20,0x6C,0x6F,0x77
	.DB  0x20,0x69,0x6E,0x74,0x65,0x72,0x76,0x61
	.DB  0x6C,0x0,0x3D,0x3A,0x20,0x73,0x61,0x76
	.DB  0x65,0x20,0x69,0x6E,0x74,0x65,0x72,0x76
	.DB  0x61,0x6C,0x0,0x2B,0x3A,0x20,0x68,0x69
	.DB  0x67,0x68,0x20,0x69,0x6E,0x74,0x65,0x72
	.DB  0x76,0x61,0x6C,0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x09
	.DW  0x05
	.DW  __REG_VARS*2

	.DW  0x01
	.DW  _speed
	.DW  _0x3*2

	.DW  0x08
	.DW  _0x41
	.DW  _0x0*2+31

	.DW  0x0C
	.DW  _0x41+8
	.DW  _0x0*2+39

	.DW  0x08
	.DW  _0x41+20
	.DW  _0x0*2+60

	.DW  0x07
	.DW  _0x41+28
	.DW  _0x0*2+68

	.DW  0x08
	.DW  _0x41+35
	.DW  _0x0*2+89

	.DW  0x10
	.DW  _0x41+43
	.DW  _0x0*2+97

	.DW  0x07
	.DW  _0x41+59
	.DW  _0x0*2+68

	.DW  0x08
	.DW  _0x41+66
	.DW  _0x0*2+89

	.DW  0x0F
	.DW  _0x41+74
	.DW  _0x0*2+113

	.DW  0x08
	.DW  _0x41+89
	.DW  _0x0*2+128

	.DW  0x08
	.DW  _0x41+97
	.DW  _0x0*2+89

	.DW  0x12
	.DW  _0x41+105
	.DW  _0x0*2+136

	.DW  0x12
	.DW  _0x41+123
	.DW  _0x0*2+154

	.DW  0x08
	.DW  _0x41+141
	.DW  _0x0*2+89

	.DW  0x14
	.DW  _0x41+149
	.DW  _0x0*2+190

	.DW  0x10
	.DW  _0x41+169
	.DW  _0x0*2+210

	.DW  0x08
	.DW  _0x41+185
	.DW  _0x0*2+89

	.DW  0x11
	.DW  _0x41+193
	.DW  _0x0*2+226

	.DW  0x11
	.DW  _0x41+210
	.DW  _0x0*2+243

	.DW  0x08
	.DW  _0x41+227
	.DW  _0x0*2+89

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 6/5/2022
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega16
;Program type            : Application
;AVR Core Clock frequency: 1.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;#include <mega16.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <alcd.h>
;#include <delay.h>
;#include <string.h>
;#include <stdint.h>
;#include <stdio.h>
;enum States{s0,s1,s2,s3,s4,s5,s6}state=s0;
;#define C0 PINC.4
;#define C1 PINC.5
;#define C2 PINC.6
;#define C3 PINC.7
;
;// Declare your global variables here
;flash char shift[4]={0xFE,0xFD,0xFB,0xF7};
;flash char layout[16]={'7','8','9','/',
;                       '4','5','6','*',
;                       '1','2','3','-',
;                       'C','0','=','+'};
;
;char num[2];
;char motor[16];
;char dis1[16];
;char dis2[16];
;char dis3[16];
;char keypad(void);
;int i=0,tin_high=0,tin_low=0,t_highint=0,t_lowint=0,speed=127;

	.DSEG
;int temp,t1,t2,t3,t4;
;
;void StateMachine(char input){
; 0000 0033 void StateMachine(char input){

	.CSEG
_StateMachine:
; .FSTART _StateMachine
; 0000 0034     switch(state)
	ST   -Y,R26
;	input -> Y+0
	MOV  R30,R5
	LDI  R31,0
; 0000 0035     {
; 0000 0036     case s0:
	SBIW R30,0
	BRNE _0x7
; 0000 0037         if(input=='/') state=s1;
	LD   R26,Y
	CPI  R26,LOW(0x2F)
	BRNE _0x8
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0000 0038         if(input=='*') state=s4;
_0x8:
	LD   R26,Y
	CPI  R26,LOW(0x2A)
	BRNE _0x9
	LDI  R30,LOW(4)
	MOV  R5,R30
; 0000 0039     break;
_0x9:
	RJMP _0x6
; 0000 003A 
; 0000 003B     case s1:
_0x7:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xA
; 0000 003C         if(input=='+') state=s2;
	LD   R26,Y
	CPI  R26,LOW(0x2B)
	BRNE _0xB
	LDI  R30,LOW(2)
	MOV  R5,R30
; 0000 003D         if(input=='-') state=s3;
_0xB:
	LD   R26,Y
	CPI  R26,LOW(0x2D)
	BRNE _0xC
	LDI  R30,LOW(3)
	MOV  R5,R30
; 0000 003E         if(input=='C') state=s0;
_0xC:
	LD   R26,Y
	CPI  R26,LOW(0x43)
	BRNE _0xD
	CLR  R5
; 0000 003F     break;
_0xD:
	RJMP _0x6
; 0000 0040 
; 0000 0041     case s4:
_0xA:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xE
; 0000 0042         if(input=='+') state=s5;
	LD   R26,Y
	CPI  R26,LOW(0x2B)
	BRNE _0xF
	LDI  R30,LOW(5)
	MOV  R5,R30
; 0000 0043         if(input=='-') state=s6;
_0xF:
	LD   R26,Y
	CPI  R26,LOW(0x2D)
	BRNE _0x10
	LDI  R30,LOW(6)
	MOV  R5,R30
; 0000 0044         if(input=='C') state=s0;
_0x10:
	LD   R26,Y
	CPI  R26,LOW(0x43)
	BRNE _0x11
	CLR  R5
; 0000 0045     break;
_0x11:
	RJMP _0x6
; 0000 0046 
; 0000 0047     case s2:
_0xE:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x12
; 0000 0048     if(input=='C') state=s1;
	LD   R26,Y
	CPI  R26,LOW(0x43)
	BRNE _0x13
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0000 0049     if(input=='-') state=s3;
_0x13:
	LD   R26,Y
	CPI  R26,LOW(0x2D)
	BRNE _0x14
	LDI  R30,LOW(3)
	MOV  R5,R30
; 0000 004A     if(input=='='){ tin_high = ((num[0]-48)*10 + (num[1]-48));}
_0x14:
	LD   R26,Y
	CPI  R26,LOW(0x3D)
	BRNE _0x15
	CALL SUBOPT_0x0
	MOVW R8,R30
; 0000 004B     break;
_0x15:
	RJMP _0x6
; 0000 004C 
; 0000 004D     case s3:
_0x12:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x16
; 0000 004E     if(input=='C') state=s1;
	LD   R26,Y
	CPI  R26,LOW(0x43)
	BRNE _0x17
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0000 004F     if(input=='+') state=s2;
_0x17:
	LD   R26,Y
	CPI  R26,LOW(0x2B)
	BRNE _0x18
	LDI  R30,LOW(2)
	MOV  R5,R30
; 0000 0050     if(input=='='){ tin_low = ((num[0]-48)*10 + (num[1]-48));}
_0x18:
	LD   R26,Y
	CPI  R26,LOW(0x3D)
	BRNE _0x19
	CALL SUBOPT_0x0
	MOVW R10,R30
; 0000 0051     break;
_0x19:
	RJMP _0x6
; 0000 0052 
; 0000 0053     case s5:
_0x16:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x1A
; 0000 0054     if(input=='C') state=s4;
	LD   R26,Y
	CPI  R26,LOW(0x43)
	BRNE _0x1B
	LDI  R30,LOW(4)
	MOV  R5,R30
; 0000 0055     if(input=='-') state=s6;
_0x1B:
	LD   R26,Y
	CPI  R26,LOW(0x2D)
	BRNE _0x1C
	LDI  R30,LOW(6)
	MOV  R5,R30
; 0000 0056     if(input=='='){ t_highint = ((num[0]-48)*10 + (num[1]-48));}
_0x1C:
	LD   R26,Y
	CPI  R26,LOW(0x3D)
	BRNE _0x1D
	CALL SUBOPT_0x0
	MOVW R12,R30
; 0000 0057     break;
_0x1D:
	RJMP _0x6
; 0000 0058 
; 0000 0059     case s6:
_0x1A:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x6
; 0000 005A     if(input=='C') state=s4;
	LD   R26,Y
	CPI  R26,LOW(0x43)
	BRNE _0x1F
	LDI  R30,LOW(4)
	MOV  R5,R30
; 0000 005B     if(input=='+') state=s5;
_0x1F:
	LD   R26,Y
	CPI  R26,LOW(0x2B)
	BRNE _0x20
	LDI  R30,LOW(5)
	MOV  R5,R30
; 0000 005C     if(input=='='){ t_lowint = ((num[0]-48)*10 + (num[1]-48));}
_0x20:
	LD   R26,Y
	CPI  R26,LOW(0x3D)
	BRNE _0x21
	CALL SUBOPT_0x0
	STS  _t_lowint,R30
	STS  _t_lowint+1,R31
; 0000 005D     break;
_0x21:
; 0000 005E     }
_0x6:
; 0000 005F }
	JMP  _0x2080002
; .FEND
;
;// External Interrupt 2 service routine
;interrupt [EXT_INT2] void ext_int2_isr(void)
; 0000 0063 {
_ext_int2_isr:
; .FSTART _ext_int2_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0064 char ch=keypad();
; 0000 0065 StateMachine(ch);
	ST   -Y,R17
;	ch -> R17
	RCALL _keypad
	MOV  R17,R30
	MOV  R26,R17
	RCALL _StateMachine
; 0000 0066 
; 0000 0067 if(ch=='0'||ch=='1'||ch=='2'||ch=='3'||ch=='4'||ch=='5'||ch=='6'||ch=='7'||ch=='8'||ch=='9')
	CPI  R17,48
	BREQ _0x23
	CPI  R17,49
	BREQ _0x23
	CPI  R17,50
	BREQ _0x23
	CPI  R17,51
	BREQ _0x23
	CPI  R17,52
	BREQ _0x23
	CPI  R17,53
	BREQ _0x23
	CPI  R17,54
	BREQ _0x23
	CPI  R17,55
	BREQ _0x23
	CPI  R17,56
	BREQ _0x23
	CPI  R17,57
	BRNE _0x22
_0x23:
; 0000 0068     { num[i]=ch; i++;}
	MOVW R30,R6
	SUBI R30,LOW(-_num)
	SBCI R31,HIGH(-_num)
	ST   Z,R17
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
; 0000 0069 if(i>1){i=0;}
_0x22:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R6
	CPC  R31,R7
	BRGE _0x25
	CLR  R6
	CLR  R7
; 0000 006A }
_0x25:
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;// Voltage Reference: AREF pin
;#define ADC_VREF_TYPE ((0<<REFS1) | (0<<REFS0) | (0<<ADLAR))
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 0071 {
_read_adc:
; .FSTART _read_adc
; 0000 0072 ADMUX=adc_input | ADC_VREF_TYPE;
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	OUT  0x7,R30
; 0000 0073 // Delay needed for the stabilization of the ADC input voltage
; 0000 0074 delay_us(10);
	__DELAY_USB 3
; 0000 0075 // Start the AD conversion
; 0000 0076 ADCSRA|=(1<<ADSC);
	SBI  0x6,6
; 0000 0077 // Wait for the AD conversion to complete
; 0000 0078 while ((ADCSRA & (1<<ADIF))==0);
_0x26:
	SBIS 0x6,4
	RJMP _0x26
; 0000 0079 ADCSRA|=(1<<ADIF);
	SBI  0x6,4
; 0000 007A return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	JMP  _0x2080002
; 0000 007B }
; .FEND
;
;void main(void)
; 0000 007E {
_main:
; .FSTART _main
; 0000 007F // Declare your local variables here
; 0000 0080 
; 0000 0081 // Input/Output Ports initialization
; 0000 0082 // Port A initialization
; 0000 0083 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0084 DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 0085 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0086 PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 0087 
; 0000 0088 // Port B initialization
; 0000 0089 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=Out Bit2=In Bit1=In Bit0=In
; 0000 008A DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (1<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(8)
	OUT  0x17,R30
; 0000 008B // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=0 Bit2=T Bit1=T Bit0=T
; 0000 008C PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 008D 
; 0000 008E // Port C initialization
; 0000 008F // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0090 DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0000 0091 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0092 PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 0093 
; 0000 0094 // Port D initialization
; 0000 0095 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0096 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
; 0000 0097 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0098 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0000 0099 
; 0000 009A // Timer/Counter 0 initialization
; 0000 009B // Clock source: System Clock
; 0000 009C // Clock value: 1000.000 kHz
; 0000 009D // Mode: Phase correct PWM top=0xFF
; 0000 009E // OC0 output: Non-Inverted PWM
; 0000 009F // Timer Period: 0.51 ms
; 0000 00A0 // Output Pulse(s):
; 0000 00A1 // OC0 Period: 0.51 ms Width: 0 us
; 0000 00A2 TCCR0=(1<<WGM00) | (1<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (1<<CS00);
	LDI  R30,LOW(97)
	OUT  0x33,R30
; 0000 00A3 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 00A4 OCR0=0x00;
	OUT  0x3C,R30
; 0000 00A5 
; 0000 00A6 // Timer/Counter 1 initialization
; 0000 00A7 // Clock source: System Clock
; 0000 00A8 // Clock value: Timer1 Stopped
; 0000 00A9 // Mode: Normal top=0xFFFF
; 0000 00AA // OC1A output: Disconnected
; 0000 00AB // OC1B output: Disconnected
; 0000 00AC // Noise Canceler: Off
; 0000 00AD // Input Capture on Falling Edge
; 0000 00AE // Timer1 Overflow Interrupt: Off
; 0000 00AF // Input Capture Interrupt: Off
; 0000 00B0 // Compare A Match Interrupt: Off
; 0000 00B1 // Compare B Match Interrupt: Off
; 0000 00B2 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 00B3 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 00B4 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 00B5 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00B6 ICR1H=0x00;
	OUT  0x27,R30
; 0000 00B7 ICR1L=0x00;
	OUT  0x26,R30
; 0000 00B8 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00B9 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00BA OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00BB OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00BC 
; 0000 00BD // Timer/Counter 2 initialization
; 0000 00BE // Clock source: System Clock
; 0000 00BF // Clock value: Timer2 Stopped
; 0000 00C0 // Mode: Normal top=0xFF
; 0000 00C1 // OC2 output: Disconnected
; 0000 00C2 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 00C3 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 00C4 TCNT2=0x00;
	OUT  0x24,R30
; 0000 00C5 OCR2=0x00;
	OUT  0x23,R30
; 0000 00C6 
; 0000 00C7 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00C8 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 00C9 
; 0000 00CA // External Interrupt(s) initialization
; 0000 00CB // INT0: On
; 0000 00CC // INT0 Mode: Falling Edge
; 0000 00CD // INT1: Off
; 0000 00CE // INT2: Off
; 0000 00CF GICR|=(0<<INT1) | (0<<INT0) | (1<<INT2);
	IN   R30,0x3B
	ORI  R30,0x20
	OUT  0x3B,R30
; 0000 00D0 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 00D1 MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 00D2 GIFR=(0<<INTF1) | (0<<INTF0) | (1<<INTF2);
	LDI  R30,LOW(32)
	OUT  0x3A,R30
; 0000 00D3 
; 0000 00D4 // USART initialization
; 0000 00D5 // USART disabled
; 0000 00D6 UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(0)
	OUT  0xA,R30
; 0000 00D7 
; 0000 00D8 // Analog Comparator initialization
; 0000 00D9 // Analog Comparator: Off
; 0000 00DA // The Analog Comparator's positive input is
; 0000 00DB // connected to the AIN0 pin
; 0000 00DC // The Analog Comparator's negative input is
; 0000 00DD // connected to the AIN1 pin
; 0000 00DE ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00DF 
; 0000 00E0 // ADC initialization
; 0000 00E1 // ADC Clock frequency: 500.000 kHz
; 0000 00E2 // ADC Voltage Reference: AREF pin
; 0000 00E3 // ADC Auto Trigger Source: Free Running
; 0000 00E4 ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(0)
	OUT  0x7,R30
; 0000 00E5 ADCSRA=(1<<ADEN) | (0<<ADSC) | (1<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (1<<ADPS0);
	LDI  R30,LOW(161)
	OUT  0x6,R30
; 0000 00E6 SFIOR=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00E7 
; 0000 00E8 // SPI initialization
; 0000 00E9 // SPI disabled
; 0000 00EA SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 00EB 
; 0000 00EC // TWI initialization
; 0000 00ED // TWI disabled
; 0000 00EE TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 00EF 
; 0000 00F0 // Alphanumeric LCD initialization
; 0000 00F1 // Connections are specified in the
; 0000 00F2 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 00F3 // RS - PORTD Bit 0
; 0000 00F4 // RD - PORTD Bit 1
; 0000 00F5 // EN - PORTD Bit 2
; 0000 00F6 // D4 - PORTD Bit 4
; 0000 00F7 // D5 - PORTD Bit 5
; 0000 00F8 // D6 - PORTD Bit 6
; 0000 00F9 // D7 - PORTD Bit 7
; 0000 00FA // Characters/line: 16
; 0000 00FB lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 00FC 
; 0000 00FD // Global enable interrupts
; 0000 00FE #asm("sei")
	sei
; 0000 00FF DDRC = 0x0F;
	LDI  R30,LOW(15)
	OUT  0x14,R30
; 0000 0100 PORTC = 0xF0;
	LDI  R30,LOW(240)
	OUT  0x15,R30
; 0000 0101 DDRB.0=1;
	SBI  0x17,0
; 0000 0102 DDRB.1=1;
	SBI  0x17,1
; 0000 0103 PORTB.0=1;
	SBI  0x18,0
; 0000 0104 PORTB.1=0;
	CBI  0x18,1
; 0000 0105 OCR0=0;
	LDI  R30,LOW(0)
	OUT  0x3C,R30
; 0000 0106 
; 0000 0107 while (1)
_0x31:
; 0000 0108       {
; 0000 0109       temp=read_adc(0)/2.05;
	LDI  R26,LOW(0)
	RCALL _read_adc
	CLR  R22
	CLR  R23
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x40033333
	CALL __DIVF21
	LDI  R26,LOW(_temp)
	LDI  R27,HIGH(_temp)
	CALL __CFD1
	ST   X+,R30
	ST   X,R31
; 0000 010A 
; 0000 010B       t4 = tin_high + t_highint;
	MOVW R30,R12
	ADD  R30,R8
	ADC  R31,R9
	STS  _t4,R30
	STS  _t4+1,R31
; 0000 010C       t3 = tin_high - t_highint;
	MOVW R30,R8
	SUB  R30,R12
	SBC  R31,R13
	STS  _t3,R30
	STS  _t3+1,R31
; 0000 010D       t2 = tin_low + t_lowint;
	CALL SUBOPT_0x1
	ADD  R30,R10
	ADC  R31,R11
	STS  _t2,R30
	STS  _t2+1,R31
; 0000 010E       t1 = tin_low - t_lowint;
	LDS  R26,_t_lowint
	LDS  R27,_t_lowint+1
	MOVW R30,R10
	SUB  R30,R26
	SBC  R31,R27
	STS  _t1,R30
	STS  _t1+1,R31
; 0000 010F 
; 0000 0110       if(temp>t4)
	CALL SUBOPT_0x2
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x34
; 0000 0111         {OCR0=200; sprintf(motor,"mode:high");}
	LDI  R30,LOW(200)
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,0
	CALL SUBOPT_0x4
; 0000 0112       if((temp<t4 && temp>t2) || (temp<t2 && temp>t1))
_0x34:
	CALL SUBOPT_0x2
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x36
	CALL SUBOPT_0x5
	CP   R30,R26
	CPC  R31,R27
	BRLT _0x38
_0x36:
	CALL SUBOPT_0x5
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x39
	CALL SUBOPT_0x6
	CP   R30,R26
	CPC  R31,R27
	BRLT _0x38
_0x39:
	RJMP _0x35
_0x38:
; 0000 0113         {OCR0=speed; sprintf(motor,"mode:normal");}
	LDS  R30,_speed
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,10
	CALL SUBOPT_0x4
; 0000 0114       if(temp<t1)
_0x35:
	CALL SUBOPT_0x6
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x3C
; 0000 0115         {OCR0=0; sprintf(motor,"mode:off");;}
	LDI  R30,LOW(0)
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,22
	CALL SUBOPT_0x4
; 0000 0116 
; 0000 0117       switch(state){
_0x3C:
	MOV  R30,R5
	LDI  R31,0
; 0000 0118 
; 0000 0119         case s0:
	SBIW R30,0
	BRNE _0x40
; 0000 011A             lcd_clear();
	CALL SUBOPT_0x7
; 0000 011B             lcd_gotoxy(0,0);
; 0000 011C             lcd_puts("/: Temp");
	__POINTW2MN _0x41,0
	CALL SUBOPT_0x8
; 0000 011D             lcd_gotoxy(0,1);
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
; 0000 011E             lcd_puts("*: Interval");
	__POINTW2MN _0x41,8
	CALL SUBOPT_0x8
; 0000 011F             lcd_gotoxy(0,2);
	LDI  R26,LOW(2)
	RCALL _lcd_gotoxy
; 0000 0120             sprintf(dis3,"Temp= %d",temp);
	LDI  R30,LOW(_dis3)
	LDI  R31,HIGH(_dis3)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,51
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_temp
	LDS  R31,_temp+1
	CALL SUBOPT_0x9
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0000 0121             lcd_puts(dis3);
	LDI  R26,LOW(_dis3)
	LDI  R27,HIGH(_dis3)
	CALL SUBOPT_0x8
; 0000 0122             lcd_gotoxy(0,3);
	LDI  R26,LOW(3)
	RCALL _lcd_gotoxy
; 0000 0123             lcd_puts(motor);
	LDI  R26,LOW(_motor)
	LDI  R27,HIGH(_motor)
	RJMP _0x60
; 0000 0124             delay_ms(100);
; 0000 0125         break;
; 0000 0126 
; 0000 0127         case s1:
_0x40:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x42
; 0000 0128             lcd_clear();
	CALL SUBOPT_0x7
; 0000 0129             lcd_gotoxy(0,0);
; 0000 012A             lcd_puts("+: High");
	__POINTW2MN _0x41,20
	CALL SUBOPT_0x8
; 0000 012B             lcd_gotoxy(0,1);
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
; 0000 012C             lcd_puts("-: Low");
	__POINTW2MN _0x41,28
	CALL SUBOPT_0x8
; 0000 012D             lcd_gotoxy(0,2);
	CALL SUBOPT_0xA
; 0000 012E             sprintf(dis1,"Temp: +%d -%d",tin_high,tin_low);
	MOVW R30,R10
	CALL SUBOPT_0x9
	CALL SUBOPT_0xB
; 0000 012F             lcd_puts(dis1);
; 0000 0130             lcd_gotoxy(0,3);
	LDI  R26,LOW(3)
	RCALL _lcd_gotoxy
; 0000 0131             lcd_puts("C: Back");
	__POINTW2MN _0x41,35
	RJMP _0x60
; 0000 0132             delay_ms(100);
; 0000 0133         break;
; 0000 0134 
; 0000 0135         case s2:
_0x42:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x43
; 0000 0136             lcd_clear();
	CALL SUBOPT_0x7
; 0000 0137             lcd_gotoxy(0,0);
; 0000 0138             lcd_puts("=: in high temp");
	__POINTW2MN _0x41,43
	CALL SUBOPT_0x8
; 0000 0139             lcd_gotoxy(0,1);
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
; 0000 013A             lcd_puts("-: Low");
	__POINTW2MN _0x41,59
	CALL SUBOPT_0x8
; 0000 013B             lcd_gotoxy(0,2);
	CALL SUBOPT_0xA
; 0000 013C             sprintf(dis1,"Temp: +%d -%d",tin_high,tin_low);
	MOVW R30,R10
	CALL SUBOPT_0x9
	CALL SUBOPT_0xB
; 0000 013D             lcd_puts(dis1);
; 0000 013E             lcd_gotoxy(0,3);
	LDI  R26,LOW(3)
	RCALL _lcd_gotoxy
; 0000 013F             lcd_puts("C: Back");
	__POINTW2MN _0x41,66
	RJMP _0x60
; 0000 0140             delay_ms(100);
; 0000 0141         break;
; 0000 0142 
; 0000 0143         case s3:
_0x43:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x44
; 0000 0144             lcd_clear();
	CALL SUBOPT_0x7
; 0000 0145             lcd_gotoxy(0,0);
; 0000 0146             lcd_puts("=: in low temp");
	__POINTW2MN _0x41,74
	CALL SUBOPT_0x8
; 0000 0147             lcd_gotoxy(0,1);
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
; 0000 0148             lcd_puts("+: high");
	__POINTW2MN _0x41,89
	CALL SUBOPT_0x8
; 0000 0149             lcd_gotoxy(0,2);
	CALL SUBOPT_0xA
; 0000 014A             sprintf(dis1,"Temp: +%d -%d",tin_high,tin_low);
	MOVW R30,R10
	CALL SUBOPT_0x9
	CALL SUBOPT_0xB
; 0000 014B             lcd_puts(dis1);
; 0000 014C             lcd_gotoxy(0,3);
	LDI  R26,LOW(3)
	RCALL _lcd_gotoxy
; 0000 014D             lcd_puts("C: Back");
	__POINTW2MN _0x41,97
	RJMP _0x60
; 0000 014E             delay_ms(100);
; 0000 014F         break;
; 0000 0150 
; 0000 0151         case s4:
_0x44:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x45
; 0000 0152             lcd_clear();
	CALL SUBOPT_0x7
; 0000 0153             lcd_gotoxy(0,0);
; 0000 0154             lcd_puts("+: upper interval");
	__POINTW2MN _0x41,105
	CALL SUBOPT_0x8
; 0000 0155             lcd_gotoxy(0,1);
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
; 0000 0156             lcd_puts("-: lower interval");
	__POINTW2MN _0x41,123
	CALL SUBOPT_0x8
; 0000 0157             lcd_gotoxy(0,2);
	CALL SUBOPT_0xC
; 0000 0158             sprintf(dis2,"interval: +%d -%d",t_highint,t_lowint);
	CALL SUBOPT_0xD
	CALL SUBOPT_0xE
; 0000 0159             lcd_puts(dis2);
; 0000 015A             lcd_gotoxy(0,3);
	LDI  R26,LOW(3)
	RCALL _lcd_gotoxy
; 0000 015B             lcd_puts("C: Back");
	__POINTW2MN _0x41,141
	RJMP _0x60
; 0000 015C             delay_ms(100);
; 0000 015D         break;
; 0000 015E 
; 0000 015F         case s5:
_0x45:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x46
; 0000 0160             lcd_clear();
	CALL SUBOPT_0x7
; 0000 0161             lcd_gotoxy(0,0);
; 0000 0162             lcd_puts("=: in high interval");
	__POINTW2MN _0x41,149
	CALL SUBOPT_0x8
; 0000 0163             lcd_gotoxy(0,1);
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
; 0000 0164             lcd_puts("-: low interval");
	__POINTW2MN _0x41,169
	CALL SUBOPT_0x8
; 0000 0165             lcd_gotoxy(0,2);
	CALL SUBOPT_0xC
; 0000 0166             sprintf(dis2,"interval: +%d -%d",t_highint,t_lowint);
	CALL SUBOPT_0xD
	CALL SUBOPT_0xE
; 0000 0167             lcd_puts(dis2);
; 0000 0168             lcd_gotoxy(0,3);
	LDI  R26,LOW(3)
	RCALL _lcd_gotoxy
; 0000 0169             lcd_puts("C: Back");
	__POINTW2MN _0x41,185
	RJMP _0x60
; 0000 016A             delay_ms(100);
; 0000 016B         break;
; 0000 016C 
; 0000 016D         case s6:
_0x46:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x3F
; 0000 016E             lcd_clear();
	CALL SUBOPT_0x7
; 0000 016F             lcd_gotoxy(0,0);
; 0000 0170             lcd_puts("=: save interval");
	__POINTW2MN _0x41,193
	CALL SUBOPT_0x8
; 0000 0171             lcd_gotoxy(0,1);
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
; 0000 0172             lcd_puts("+: high interval");
	__POINTW2MN _0x41,210
	CALL SUBOPT_0x8
; 0000 0173             lcd_gotoxy(0,2);
	CALL SUBOPT_0xC
; 0000 0174             sprintf(dis2,"interval: +%d -%d",t_highint,t_lowint);
	CALL SUBOPT_0xD
	CALL SUBOPT_0xE
; 0000 0175             lcd_puts(dis2);
; 0000 0176             lcd_gotoxy(0,3);
	LDI  R26,LOW(3)
	RCALL _lcd_gotoxy
; 0000 0177             lcd_puts("C: Back");
	__POINTW2MN _0x41,227
_0x60:
	RCALL _lcd_puts
; 0000 0178             delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 0179         break;
; 0000 017A         }
_0x3F:
; 0000 017B       }
	RJMP _0x31
; 0000 017C }
_0x48:
	RJMP _0x48
; .FEND

	.DSEG
_0x41:
	.BYTE 0xEB
;
;char keypad(void)
; 0000 017F {

	.CSEG
_keypad:
; .FSTART _keypad
; 0000 0180     int row=0,column=-1,position=0;
; 0000 0181 
; 0000 0182     while(1){
	CALL __SAVELOCR6
;	row -> R16,R17
;	column -> R18,R19
;	position -> R20,R21
	__GETWRN 16,17,0
	__GETWRN 18,19,-1
	__GETWRN 20,21,0
_0x49:
; 0000 0183     for (row=0;row<4;row++)
	__GETWRN 16,17,0
_0x4D:
	__CPWRN 16,17,4
	BRGE _0x4E
; 0000 0184         {
; 0000 0185         PORTC=shift[row];
	MOVW R30,R16
	SUBI R30,LOW(-_shift*2)
	SBCI R31,HIGH(-_shift*2)
	LPM  R0,Z
	OUT  0x15,R0
; 0000 0186         if(C0==0){column=0;}
	SBIC 0x13,4
	RJMP _0x4F
	__GETWRN 18,19,0
; 0000 0187         if(C1==0){column=1;}
_0x4F:
	SBIC 0x13,5
	RJMP _0x50
	__GETWRN 18,19,1
; 0000 0188         if(C2==0){column=2;}
_0x50:
	SBIC 0x13,6
	RJMP _0x51
	__GETWRN 18,19,2
; 0000 0189         if(C3==0){column=3;}
_0x51:
	SBIC 0x13,7
	RJMP _0x52
	__GETWRN 18,19,3
; 0000 018A         if(column != -1){
_0x52:
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CP   R30,R18
	CPC  R31,R19
	BREQ _0x53
; 0000 018B              position= row*4 + column;
	MOVW R30,R16
	CALL __LSLW2
	ADD  R30,R18
	ADC  R31,R19
	MOVW R20,R30
; 0000 018C              column=-1;
	__GETWRN 18,19,-1
; 0000 018D              while(C0==0){}
_0x54:
	SBIS 0x13,4
	RJMP _0x54
; 0000 018E              while(C1==0){}
_0x57:
	SBIS 0x13,5
	RJMP _0x57
; 0000 018F              while(C2==0){}
_0x5A:
	SBIS 0x13,6
	RJMP _0x5A
; 0000 0190              while(C3==0){}
_0x5D:
	SBIS 0x13,7
	RJMP _0x5D
; 0000 0191              PORTC=0xF0;
	LDI  R30,LOW(240)
	OUT  0x15,R30
; 0000 0192              delay_ms(50);
	LDI  R26,LOW(50)
	LDI  R27,0
	CALL _delay_ms
; 0000 0193              return layout[position];
	MOVW R30,R20
	SUBI R30,LOW(-_layout*2)
	SBCI R31,HIGH(-_layout*2)
	LPM  R30,Z
	RJMP _0x2080003
; 0000 0194              }
; 0000 0195             }
_0x53:
	__ADDWRN 16,17,1
	RJMP _0x4D
_0x4E:
; 0000 0196         }
	RJMP _0x49
; 0000 0197 }
_0x2080003:
	CALL __LOADLOCR6
	ADIW R28,6
	RET
; .FEND
;
;
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R26
	IN   R30,0x12
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x12,R30
	__DELAY_USB 2
	SBI  0x12,2
	__DELAY_USB 2
	CBI  0x12,2
	__DELAY_USB 2
	RJMP _0x2080002
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 17
	RJMP _0x2080002
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R4,Y+1
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0xF
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0xF
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	MOV  R4,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000005
	LDS  R30,__lcd_maxx
	CP   R4,R30
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000007
	RJMP _0x2080002
_0x2000007:
_0x2000004:
	INC  R4
	SBI  0x12,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x12,0
	RJMP _0x2080002
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000008:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000008
_0x200000A:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x11
	ORI  R30,LOW(0xF0)
	OUT  0x11,R30
	SBI  0x11,2
	SBI  0x11,0
	SBI  0x11,1
	CBI  0x12,2
	CBI  0x12,0
	CBI  0x12,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x10
	CALL SUBOPT_0x10
	CALL SUBOPT_0x10
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 33
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2080002:
	ADIW R28,1
	RET
; .FEND

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G102:
; .FSTART _put_buff_G102
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2040010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2040012
	__CPWRN 16,17,2
	BRLO _0x2040013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2040012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2040013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2040014
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x2040014:
	RJMP _0x2040015
_0x2040010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2040015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
; .FEND
__print_G102:
; .FSTART __print_G102
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2040016:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ADIW R30,1
	STD  Y+16,R30
	STD  Y+16+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R19,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2040018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x204001C
	CPI  R19,37
	BRNE _0x204001D
	LDI  R17,LOW(1)
	RJMP _0x204001E
_0x204001D:
	CALL SUBOPT_0x11
_0x204001E:
	RJMP _0x204001B
_0x204001C:
	CPI  R30,LOW(0x1)
	BRNE _0x204001F
	CPI  R19,37
	BRNE _0x2040020
	CALL SUBOPT_0x11
	RJMP _0x20400AD
_0x2040020:
	LDI  R17,LOW(2)
	LDI  R18,LOW(0)
	LDI  R16,LOW(0)
	CPI  R19,43
	BRNE _0x2040021
	LDI  R18,LOW(43)
	RJMP _0x204001B
_0x2040021:
	CPI  R19,32
	BRNE _0x2040022
	LDI  R18,LOW(32)
	RJMP _0x204001B
_0x2040022:
	RJMP _0x2040023
_0x204001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2040024
_0x2040023:
	CPI  R19,48
	BRNE _0x2040025
	ORI  R16,LOW(16)
	LDI  R17,LOW(5)
	RJMP _0x204001B
_0x2040025:
	RJMP _0x2040026
_0x2040024:
	CPI  R30,LOW(0x5)
	BREQ PC+2
	RJMP _0x204001B
_0x2040026:
	MOV  R30,R19
	CPI  R30,LOW(0x63)
	BRNE _0x204002B
	CALL SUBOPT_0x12
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	LDD  R26,Z+4
	ST   -Y,R26
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ICALL
	RJMP _0x204002C
_0x204002B:
	CPI  R30,LOW(0x73)
	BRNE _0x204002E
	CALL SUBOPT_0x12
	CALL SUBOPT_0x13
_0x204002F:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R30,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
	MOV  R19,R30
	CPI  R30,0
	BREQ _0x2040031
	CALL SUBOPT_0x11
	RJMP _0x204002F
_0x2040031:
	RJMP _0x204002C
_0x204002E:
	CPI  R30,LOW(0x70)
	BRNE _0x2040033
	CALL SUBOPT_0x12
	CALL SUBOPT_0x13
_0x2040034:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R19,R30
	CPI  R30,0
	BREQ _0x2040036
	CALL SUBOPT_0x11
	RJMP _0x2040034
_0x2040036:
	RJMP _0x204002C
_0x2040033:
	CPI  R30,LOW(0x64)
	BREQ _0x2040039
	CPI  R30,LOW(0x69)
	BRNE _0x204003A
_0x2040039:
	ORI  R16,LOW(1)
	RJMP _0x204003B
_0x204003A:
	CPI  R30,LOW(0x75)
	BRNE _0x204003C
_0x204003B:
	LDI  R30,LOW(_tbl10_G102*2)
	LDI  R31,HIGH(_tbl10_G102*2)
	RJMP _0x20400AE
_0x204003C:
	CPI  R30,LOW(0x58)
	BRNE _0x204003F
	ORI  R16,LOW(2)
	RJMP _0x2040040
_0x204003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2040052
_0x2040040:
	LDI  R30,LOW(_tbl16_G102*2)
	LDI  R31,HIGH(_tbl16_G102*2)
_0x20400AE:
	STD  Y+6,R30
	STD  Y+6+1,R31
	SBRS R16,0
	RJMP _0x2040042
	CALL SUBOPT_0x12
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	ADIW R26,4
	LD   R20,X+
	LD   R21,X
	TST  R21
	BRPL _0x2040043
	MOVW R30,R20
	CALL __ANEGW1
	MOVW R20,R30
	LDI  R18,LOW(45)
_0x2040043:
	CPI  R18,0
	BREQ _0x2040044
	ST   -Y,R18
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ICALL
_0x2040044:
	RJMP _0x2040045
_0x2040042:
	CALL SUBOPT_0x12
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	ADIW R26,4
	LD   R20,X+
	LD   R21,X
_0x2040045:
_0x2040047:
	LDI  R19,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x2040049:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	CP   R20,R30
	CPC  R21,R31
	BRLO _0x204004B
	SUBI R19,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	__SUBWRR 20,21,26,27
	RJMP _0x2040049
_0x204004B:
	SBRC R16,4
	RJMP _0x204004D
	CPI  R19,49
	BRSH _0x204004D
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x204004C
_0x204004D:
	ORI  R16,LOW(16)
	CPI  R19,58
	BRLO _0x204004F
	SBRS R16,1
	RJMP _0x2040050
	SUBI R19,-LOW(7)
	RJMP _0x2040051
_0x2040050:
	SUBI R19,-LOW(39)
_0x2040051:
_0x204004F:
	CALL SUBOPT_0x11
_0x204004C:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRSH _0x2040047
_0x2040052:
_0x204002C:
_0x20400AD:
	LDI  R17,LOW(0)
_0x204001B:
	RJMP _0x2040016
_0x2040018:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,18
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x14
	SBIW R30,0
	BRNE _0x2040053
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2080001
_0x2040053:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x14
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G102)
	LDI  R31,HIGH(_put_buff_G102)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G102
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x2080001:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND

	.CSEG

	.DSEG
_num:
	.BYTE 0x2
_motor:
	.BYTE 0x10
_dis1:
	.BYTE 0x10
_dis2:
	.BYTE 0x10
_dis3:
	.BYTE 0x10
_t_lowint:
	.BYTE 0x2
_speed:
	.BYTE 0x2
_temp:
	.BYTE 0x2
_t1:
	.BYTE 0x2
_t2:
	.BYTE 0x2
_t3:
	.BYTE 0x2
_t4:
	.BYTE 0x2
__base_y_G100:
	.BYTE 0x4
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:36 WORDS
SUBOPT_0x0:
	LDS  R30,_num
	LDI  R31,0
	SBIW R30,48
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	MOVW R26,R30
	__GETB1MN _num,1
	LDI  R31,0
	SBIW R30,48
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	LDS  R30,_t_lowint
	LDS  R31,_t_lowint+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	LDS  R30,_t4
	LDS  R31,_t4+1
	LDS  R26,_temp
	LDS  R27,_temp+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	OUT  0x3C,R30
	LDI  R30,LOW(_motor)
	LDI  R31,HIGH(_motor)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _sprintf
	ADIW R28,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	LDS  R30,_t2
	LDS  R31,_t2+1
	LDS  R26,_temp
	LDS  R27,_temp+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	LDS  R30,_t1
	LDS  R31,_t1+1
	LDS  R26,_temp
	LDS  R27,_temp+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x7:
	CALL _lcd_clear
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x8:
	CALL _lcd_puts
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x9:
	CALL __CWD1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0xA:
	LDI  R26,LOW(2)
	CALL _lcd_gotoxy
	LDI  R30,LOW(_dis1)
	LDI  R31,HIGH(_dis1)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,75
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R8
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xB:
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
	LDI  R26,LOW(_dis1)
	LDI  R27,HIGH(_dis1)
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0xC:
	LDI  R26,LOW(2)
	CALL _lcd_gotoxy
	LDI  R30,LOW(_dis2)
	LDI  R31,HIGH(_dis2)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,172
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R12
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	RCALL SUBOPT_0x1
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xE:
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
	LDI  R26,LOW(_dis2)
	LDI  R27,HIGH(_dis2)
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x10:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G100
	__DELAY_USB 33
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x11:
	ST   -Y,R19
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x12:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	SBIW R30,4
	STD  Y+14,R30
	STD  Y+14+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x13:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:

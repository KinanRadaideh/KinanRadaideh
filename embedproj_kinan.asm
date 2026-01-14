
_delay_us:

;embedproj_kinan.c,36 :: 		void delay_us(unsigned int t){
;embedproj_kinan.c,38 :: 		while(t--) for(i=0;i<2;i++);
L_delay_us0:
	MOVF       FARG_delay_us_t+0, 0
	MOVWF      R0+0
	MOVF       FARG_delay_us_t+1, 0
	MOVWF      R0+1
	MOVLW      1
	SUBWF      FARG_delay_us_t+0, 1
	BTFSS      STATUS+0, 0
	DECF       FARG_delay_us_t+1, 1
	MOVF       R0+0, 0
	IORWF      R0+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_delay_us1
	CLRF       R2+0
	CLRF       R2+1
L_delay_us2:
	MOVLW      0
	SUBWF      R2+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__delay_us61
	MOVLW      2
	SUBWF      R2+0, 0
L__delay_us61:
	BTFSC      STATUS+0, 0
	GOTO       L_delay_us3
	MOVF       R2+0, 0
	ADDLW      1
	MOVWF      R0+0
	MOVLW      0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      R2+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      R2+0
	MOVF       R0+1, 0
	MOVWF      R2+1
	GOTO       L_delay_us2
L_delay_us3:
	GOTO       L_delay_us0
L_delay_us1:
;embedproj_kinan.c,39 :: 		}
L_end_delay_us:
	RETURN
; end of _delay_us

_setServoAngle:

;embedproj_kinan.c,42 :: 		void setServoAngle(unsigned int angle){
;embedproj_kinan.c,43 :: 		if(angle > 180) angle = 180;
	MOVF       FARG_setServoAngle_angle+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__setServoAngle63
	MOVF       FARG_setServoAngle_angle+0, 0
	SUBLW      180
L__setServoAngle63:
	BTFSC      STATUS+0, 0
	GOTO       L_setServoAngle5
	MOVLW      180
	MOVWF      FARG_setServoAngle_angle+0
	CLRF       FARG_setServoAngle_angle+1
L_setServoAngle5:
;embedproj_kinan.c,44 :: 		servoPulse = 10 + (angle * 10) / 180;
	MOVF       FARG_setServoAngle_angle+0, 0
	MOVWF      R0+0
	MOVF       FARG_setServoAngle_angle+1, 0
	MOVWF      R0+1
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVLW      180
	MOVWF      R4+0
	CLRF       R4+1
	CALL       _Div_16X16_U+0
	MOVF       R0+0, 0
	ADDLW      10
	MOVWF      _servoPulse+0
	MOVLW      0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      R0+1, 0
	MOVWF      _servoPulse+1
;embedproj_kinan.c,45 :: 		}
L_end_setServoAngle:
	RETURN
; end of _setServoAngle

_ultrasonic_read:

;embedproj_kinan.c,48 :: 		unsigned int ultrasonic_read(unsigned char trig, unsigned char echo){
;embedproj_kinan.c,49 :: 		unsigned int count = 0, timeout = 60000;
	CLRF       ultrasonic_read_count_L0+0
	CLRF       ultrasonic_read_count_L0+1
	MOVLW      96
	MOVWF      ultrasonic_read_timeout_L0+0
	MOVLW      234
	MOVWF      ultrasonic_read_timeout_L0+1
;embedproj_kinan.c,51 :: 		PORTB &= ~trig;
	COMF       FARG_ultrasonic_read_trig+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	ANDWF      PORTB+0, 1
;embedproj_kinan.c,52 :: 		delay_us(2);
	NOP
	NOP
	NOP
	NOP
;embedproj_kinan.c,53 :: 		PORTB |= trig;
	MOVF       FARG_ultrasonic_read_trig+0, 0
	IORWF      PORTB+0, 1
;embedproj_kinan.c,54 :: 		delay_us(10);
	MOVLW      6
	MOVWF      R13+0
L_ultrasonic_read6:
	DECFSZ     R13+0, 1
	GOTO       L_ultrasonic_read6
	NOP
;embedproj_kinan.c,55 :: 		PORTB &= ~trig;
	COMF       FARG_ultrasonic_read_trig+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	ANDWF      PORTB+0, 1
;embedproj_kinan.c,57 :: 		while(!(PORTB & echo)) if(--timeout==0) return 1000;
L_ultrasonic_read7:
	MOVF       FARG_ultrasonic_read_echo+0, 0
	ANDWF      PORTB+0, 0
	MOVWF      R0+0
	BTFSS      STATUS+0, 2
	GOTO       L_ultrasonic_read8
	MOVLW      1
	SUBWF      ultrasonic_read_timeout_L0+0, 1
	BTFSS      STATUS+0, 0
	DECF       ultrasonic_read_timeout_L0+1, 1
	MOVLW      0
	XORWF      ultrasonic_read_timeout_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__ultrasonic_read65
	MOVLW      0
	XORWF      ultrasonic_read_timeout_L0+0, 0
L__ultrasonic_read65:
	BTFSS      STATUS+0, 2
	GOTO       L_ultrasonic_read9
	MOVLW      232
	MOVWF      R0+0
	MOVLW      3
	MOVWF      R0+1
	GOTO       L_end_ultrasonic_read
L_ultrasonic_read9:
	GOTO       L_ultrasonic_read7
L_ultrasonic_read8:
;embedproj_kinan.c,58 :: 		timeout = 60000;
	MOVLW      96
	MOVWF      ultrasonic_read_timeout_L0+0
	MOVLW      234
	MOVWF      ultrasonic_read_timeout_L0+1
;embedproj_kinan.c,59 :: 		while(PORTB & echo){
L_ultrasonic_read10:
	MOVF       FARG_ultrasonic_read_echo+0, 0
	ANDWF      PORTB+0, 0
	MOVWF      R0+0
	BTFSC      STATUS+0, 2
	GOTO       L_ultrasonic_read11
;embedproj_kinan.c,60 :: 		count++;
	INCF       ultrasonic_read_count_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       ultrasonic_read_count_L0+1, 1
;embedproj_kinan.c,61 :: 		if(--timeout==0) break;
	MOVLW      1
	SUBWF      ultrasonic_read_timeout_L0+0, 1
	BTFSS      STATUS+0, 0
	DECF       ultrasonic_read_timeout_L0+1, 1
	MOVLW      0
	XORWF      ultrasonic_read_timeout_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__ultrasonic_read66
	MOVLW      0
	XORWF      ultrasonic_read_timeout_L0+0, 0
L__ultrasonic_read66:
	BTFSS      STATUS+0, 2
	GOTO       L_ultrasonic_read12
	GOTO       L_ultrasonic_read11
L_ultrasonic_read12:
;embedproj_kinan.c,62 :: 		}
	GOTO       L_ultrasonic_read10
L_ultrasonic_read11:
;embedproj_kinan.c,63 :: 		return count;
	MOVF       ultrasonic_read_count_L0+0, 0
	MOVWF      R0+0
	MOVF       ultrasonic_read_count_L0+1, 0
	MOVWF      R0+1
;embedproj_kinan.c,64 :: 		}
L_end_ultrasonic_read:
	RETURN
; end of _ultrasonic_read

_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;embedproj_kinan.c,67 :: 		void interrupt(void){
;embedproj_kinan.c,68 :: 		if(INTCON & 0x04){
	BTFSS      INTCON+0, 2
	GOTO       L_interrupt13
;embedproj_kinan.c,69 :: 		TMR0 = 231;
	MOVLW      231
	MOVWF      TMR0+0
;embedproj_kinan.c,71 :: 		tickCounter++;
	INCF       _tickCounter+0, 1
	BTFSC      STATUS+0, 2
	INCF       _tickCounter+1, 1
;embedproj_kinan.c,72 :: 		if(tickCounter < servoPulse) PORTB |= 0x80;
	MOVF       _servoPulse+1, 0
	SUBWF      _tickCounter+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt69
	MOVF       _servoPulse+0, 0
	SUBWF      _tickCounter+0, 0
L__interrupt69:
	BTFSC      STATUS+0, 0
	GOTO       L_interrupt14
	BSF        PORTB+0, 7
	GOTO       L_interrupt15
L_interrupt14:
;embedproj_kinan.c,73 :: 		else PORTB &= 0x7F;
	MOVLW      127
	ANDWF      PORTB+0, 1
L_interrupt15:
;embedproj_kinan.c,75 :: 		if(tickCounter >= 200) tickCounter = 0;
	MOVLW      0
	SUBWF      _tickCounter+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt70
	MOVLW      200
	SUBWF      _tickCounter+0, 0
L__interrupt70:
	BTFSS      STATUS+0, 0
	GOTO       L_interrupt16
	CLRF       _tickCounter+0
	CLRF       _tickCounter+1
L_interrupt16:
;embedproj_kinan.c,76 :: 		if(delayTicks > 0) delayTicks--;
	MOVF       _delayTicks+3, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt71
	MOVF       _delayTicks+2, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt71
	MOVF       _delayTicks+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt71
	MOVF       _delayTicks+0, 0
	SUBLW      0
L__interrupt71:
	BTFSC      STATUS+0, 0
	GOTO       L_interrupt17
	MOVLW      1
	SUBWF      _delayTicks+0, 1
	BTFSS      STATUS+0, 0
	SUBWF      _delayTicks+1, 1
	BTFSS      STATUS+0, 0
	SUBWF      _delayTicks+2, 1
	BTFSS      STATUS+0, 0
	SUBWF      _delayTicks+3, 1
L_interrupt17:
;embedproj_kinan.c,77 :: 		INTCON &= 0xFB;
	MOVLW      251
	ANDWF      INTCON+0, 1
;embedproj_kinan.c,78 :: 		}
L_interrupt13:
;embedproj_kinan.c,79 :: 		}
L_end_interrupt:
L__interrupt68:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_delay_ms:

;embedproj_kinan.c,82 :: 		void delay_ms(unsigned int ms){
;embedproj_kinan.c,83 :: 		delayTicks = (unsigned long)ms * 10;
	MOVF       FARG_delay_ms_ms+0, 0
	MOVWF      R0+0
	MOVF       FARG_delay_ms_ms+1, 0
	MOVWF      R0+1
	CLRF       R0+2
	CLRF       R0+3
	MOVLW      10
	MOVWF      R4+0
	CLRF       R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Mul_32x32_U+0
	MOVF       R0+0, 0
	MOVWF      _delayTicks+0
	MOVF       R0+1, 0
	MOVWF      _delayTicks+1
	MOVF       R0+2, 0
	MOVWF      _delayTicks+2
	MOVF       R0+3, 0
	MOVWF      _delayTicks+3
;embedproj_kinan.c,84 :: 		while(delayTicks);
L_delay_ms18:
	MOVF       _delayTicks+0, 0
	IORWF      _delayTicks+1, 0
	IORWF      _delayTicks+2, 0
	IORWF      _delayTicks+3, 0
	BTFSC      STATUS+0, 2
	GOTO       L_delay_ms19
	GOTO       L_delay_ms18
L_delay_ms19:
;embedproj_kinan.c,85 :: 		}
L_end_delay_ms:
	RETURN
; end of _delay_ms

_m_F:

;embedproj_kinan.c,88 :: 		void m_F(int spd){
;embedproj_kinan.c,89 :: 		PORTC = (PORTC & 0b11010111) | 0b00010111;
	MOVLW      215
	ANDWF      PORTC+0, 0
	MOVWF      R0+0
	MOVLW      23
	IORWF      R0+0, 0
	MOVWF      PORTC+0
;embedproj_kinan.c,90 :: 		CCPR1L = spd; CCPR2L = spd;
	MOVF       FARG_m_F_spd+0, 0
	MOVWF      CCPR1L+0
	MOVF       FARG_m_F_spd+0, 0
	MOVWF      CCPR2L+0
;embedproj_kinan.c,91 :: 		}
L_end_m_F:
	RETURN
; end of _m_F

_m_B:

;embedproj_kinan.c,92 :: 		void m_B(int spd){
;embedproj_kinan.c,93 :: 		PORTC = (PORTC & 0b11001011) | 0b00001011;
	MOVLW      203
	ANDWF      PORTC+0, 0
	MOVWF      R0+0
	MOVLW      11
	IORWF      R0+0, 0
	MOVWF      PORTC+0
;embedproj_kinan.c,94 :: 		CCPR1L = spd; CCPR2L = spd;
	MOVF       FARG_m_B_spd+0, 0
	MOVWF      CCPR1L+0
	MOVF       FARG_m_B_spd+0, 0
	MOVWF      CCPR2L+0
;embedproj_kinan.c,95 :: 		}
L_end_m_B:
	RETURN
; end of _m_B

_m_R:

;embedproj_kinan.c,96 :: 		void m_R(int spd){
;embedproj_kinan.c,97 :: 		PORTC = (PORTC & 0b11010110) | 0b00010100;
	MOVLW      214
	ANDWF      PORTC+0, 0
	MOVWF      R0+0
	MOVLW      20
	IORWF      R0+0, 0
	MOVWF      PORTC+0
;embedproj_kinan.c,98 :: 		CCPR1L = spd; CCPR2L = 0;
	MOVF       FARG_m_R_spd+0, 0
	MOVWF      CCPR1L+0
	CLRF       CCPR2L+0
;embedproj_kinan.c,99 :: 		}
L_end_m_R:
	RETURN
; end of _m_R

_m_L:

;embedproj_kinan.c,100 :: 		void m_L(int spd){
;embedproj_kinan.c,101 :: 		PORTC = (PORTC & 0b11000111) | 0b00000011;
	MOVLW      199
	ANDWF      PORTC+0, 0
	MOVWF      R0+0
	MOVLW      3
	IORWF      R0+0, 0
	MOVWF      PORTC+0
;embedproj_kinan.c,102 :: 		CCPR1L = 0; CCPR2L = spd;
	CLRF       CCPR1L+0
	MOVF       FARG_m_L_spd+0, 0
	MOVWF      CCPR2L+0
;embedproj_kinan.c,103 :: 		}
L_end_m_L:
	RETURN
; end of _m_L

_s_m:

;embedproj_kinan.c,104 :: 		void s_m(){
;embedproj_kinan.c,105 :: 		PORTC &= 0b11000000;
	MOVLW      192
	ANDWF      PORTC+0, 1
;embedproj_kinan.c,106 :: 		CCPR1L = CCPR2L = 0;
	CLRF       CCPR2L+0
	MOVF       CCPR2L+0, 0
	MOVWF      CCPR1L+0
;embedproj_kinan.c,107 :: 		}
L_end_s_m:
	RETURN
; end of _s_m

_main:

;embedproj_kinan.c,110 :: 		void main(){
;embedproj_kinan.c,112 :: 		delay_ms(3000);
	MOVLW      31
	MOVWF      R11+0
	MOVLW      113
	MOVWF      R12+0
	MOVLW      30
	MOVWF      R13+0
L_main20:
	DECFSZ     R13+0, 1
	GOTO       L_main20
	DECFSZ     R12+0, 1
	GOTO       L_main20
	DECFSZ     R11+0, 1
	GOTO       L_main20
	NOP
;embedproj_kinan.c,114 :: 		TRISA = 0b00000001; // setting i/o & port values
	MOVLW      1
	MOVWF      TRISA+0
;embedproj_kinan.c,115 :: 		TRISB = 0b01000110;
	MOVLW      70
	MOVWF      TRISB+0
;embedproj_kinan.c,116 :: 		TRISC = 0b10000000;
	MOVLW      128
	MOVWF      TRISC+0
;embedproj_kinan.c,117 :: 		TRISD = 0b00110000;
	MOVLW      48
	MOVWF      TRISD+0
;embedproj_kinan.c,119 :: 		PORTA = PORTB = PORTC = PORTD = 0;
	CLRF       PORTD+0
	MOVF       PORTD+0, 0
	MOVWF      PORTC+0
	MOVF       PORTC+0, 0
	MOVWF      PORTB+0
	MOVF       PORTB+0, 0
	MOVWF      PORTA+0
;embedproj_kinan.c,121 :: 		OPTION_REG = 0b00000010;
	MOVLW      2
	MOVWF      OPTION_REG+0
;embedproj_kinan.c,122 :: 		TMR0 = 231;
	MOVLW      231
	MOVWF      TMR0+0
;embedproj_kinan.c,123 :: 		INTCON = 0xA0;
	MOVLW      160
	MOVWF      INTCON+0
;embedproj_kinan.c,125 :: 		ADCON0 = 0b01000001; // configuring adc
	MOVLW      65
	MOVWF      ADCON0+0
;embedproj_kinan.c,126 :: 		ADCON1 = 0b10000110;
	MOVLW      134
	MOVWF      ADCON1+0
;embedproj_kinan.c,128 :: 		T2CON = 0x07;
	MOVLW      7
	MOVWF      T2CON+0
;embedproj_kinan.c,129 :: 		PR2 = 250;
	MOVLW      250
	MOVWF      PR2+0
;embedproj_kinan.c,130 :: 		CCP1CON = CCP2CON = 0x0C;
	MOVLW      12
	MOVWF      CCP2CON+0
	MOVF       CCP2CON+0, 0
	MOVWF      CCP1CON+0
;embedproj_kinan.c,132 :: 		while(1){
L_main21:
;embedproj_kinan.c,134 :: 		if(state == STATE_LINE){
	MOVF       _state+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main23
;embedproj_kinan.c,136 :: 		if(!(PORTB & 0x04) && !(PORTB & 0x02))
	BTFSC      PORTB+0, 2
	GOTO       L_main26
	BTFSC      PORTB+0, 1
	GOTO       L_main26
L__main59:
;embedproj_kinan.c,137 :: 		m_F(SPEED);
	MOVF       _SPEED+0, 0
	MOVWF      FARG_m_F_spd+0
	MOVF       _SPEED+1, 0
	MOVWF      FARG_m_F_spd+1
	CALL       _m_F+0
	GOTO       L_main27
L_main26:
;embedproj_kinan.c,138 :: 		else if(!(PORTB & 0x04))
	BTFSC      PORTB+0, 2
	GOTO       L_main28
;embedproj_kinan.c,139 :: 		m_L(LEFT_SPEED);
	MOVF       _LEFT_SPEED+0, 0
	MOVWF      FARG_m_L_spd+0
	MOVF       _LEFT_SPEED+1, 0
	MOVWF      FARG_m_L_spd+1
	CALL       _m_L+0
	GOTO       L_main29
L_main28:
;embedproj_kinan.c,140 :: 		else if(!(PORTB & 0x02))
	BTFSC      PORTB+0, 1
	GOTO       L_main30
;embedproj_kinan.c,141 :: 		m_R(RIGHT_SPEED);
	MOVF       _RIGHT_SPEED+0, 0
	MOVWF      FARG_m_R_spd+0
	MOVF       _RIGHT_SPEED+1, 0
	MOVWF      FARG_m_R_spd+1
	CALL       _m_R+0
	GOTO       L_main31
L_main30:
;embedproj_kinan.c,143 :: 		s_m();
	CALL       _s_m+0
L_main31:
L_main29:
L_main27:
;embedproj_kinan.c,145 :: 		delay_us(20);
	MOVLW      13
	MOVWF      R13+0
L_main32:
	DECFSZ     R13+0, 1
	GOTO       L_main32
;embedproj_kinan.c,146 :: 		GO_DONE_bit = 1; // set & wait for adc conversion
	BSF        GO_DONE_bit+0, BitPos(GO_DONE_bit+0)
;embedproj_kinan.c,147 :: 		while(GO_DONE_bit);
L_main33:
	BTFSS      GO_DONE_bit+0, BitPos(GO_DONE_bit+0)
	GOTO       L_main34
	GOTO       L_main33
L_main34:
;embedproj_kinan.c,148 :: 		adc_value = ((unsigned int)ADRESH << 8) | ADRESL;
	MOVF       ADRESH+0, 0
	MOVWF      R3+0
	CLRF       R3+1
	MOVF       R3+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       ADRESL+0, 0
	IORWF      R0+0, 0
	MOVWF      R2+0
	MOVF       R0+1, 0
	MOVWF      R2+1
	MOVLW      0
	IORWF      R2+1, 1
	MOVF       R2+0, 0
	MOVWF      _adc_value+0
	MOVF       R2+1, 0
	MOVWF      _adc_value+1
;embedproj_kinan.c,150 :: 		if(adc_value > thresh){
	MOVF       R2+1, 0
	SUBWF      _thresh+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main79
	MOVF       R2+0, 0
	SUBWF      _thresh+0, 0
L__main79:
	BTFSC      STATUS+0, 0
	GOTO       L_main35
;embedproj_kinan.c,151 :: 		PORTD |= (1 << BUZZER_PIN);
	BSF        PORTD+0, 2
;embedproj_kinan.c,152 :: 		light_is_hi = 0; // set states
	CLRF       _light_is_hi+0
;embedproj_kinan.c,153 :: 		}
	GOTO       L_main36
L_main35:
;embedproj_kinan.c,155 :: 		PORTD &= ~(1 << BUZZER_PIN);
	BCF        PORTD+0, 2
;embedproj_kinan.c,157 :: 		if(light_is_hi == 0){
	MOVF       _light_is_hi+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main37
;embedproj_kinan.c,158 :: 		delay_ms(800);
	MOVLW      9
	MOVWF      R11+0
	MOVLW      30
	MOVWF      R12+0
	MOVLW      228
	MOVWF      R13+0
L_main38:
	DECFSZ     R13+0, 1
	GOTO       L_main38
	DECFSZ     R12+0, 1
	GOTO       L_main38
	DECFSZ     R11+0, 1
	GOTO       L_main38
	NOP
;embedproj_kinan.c,159 :: 		state = STATE_ULTRASONIC;
	MOVLW      1
	MOVWF      _state+0
;embedproj_kinan.c,160 :: 		light_is_hi = 1;
	MOVLW      1
	MOVWF      _light_is_hi+0
;embedproj_kinan.c,161 :: 		}
L_main37:
;embedproj_kinan.c,162 :: 		}
L_main36:
;embedproj_kinan.c,163 :: 		}
	GOTO       L_main39
L_main23:
;embedproj_kinan.c,165 :: 		else if(state == STATE_ULTRASONIC){
	MOVF       _state+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main40
;embedproj_kinan.c,167 :: 		distance = ultrasonic_read(US_TRIG, US_ECHO);
	MOVLW      32
	MOVWF      FARG_ultrasonic_read_trig+0
	MOVLW      64
	MOVWF      FARG_ultrasonic_read_echo+0
	CALL       _ultrasonic_read+0
	MOVF       R0+0, 0
	MOVWF      _distance+0
	MOVF       R0+1, 0
	MOVWF      _distance+1
;embedproj_kinan.c,169 :: 		if(distance >= obstacle_dist){
	MOVF       _obstacle_dist+1, 0
	SUBWF      R0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main80
	MOVF       _obstacle_dist+0, 0
	SUBWF      R0+0, 0
L__main80:
	BTFSS      STATUS+0, 0
	GOTO       L_main41
;embedproj_kinan.c,170 :: 		state = STATE_IR_AVOID;
	MOVLW      2
	MOVWF      _state+0
;embedproj_kinan.c,171 :: 		continue;
	GOTO       L_main21
;embedproj_kinan.c,172 :: 		}
L_main41:
;embedproj_kinan.c,174 :: 		m_B(SPEED);
	MOVF       _SPEED+0, 0
	MOVWF      FARG_m_B_spd+0
	MOVF       _SPEED+1, 0
	MOVWF      FARG_m_B_spd+1
	CALL       _m_B+0
;embedproj_kinan.c,175 :: 		delay_ms(300);
	MOVLW      4
	MOVWF      R11+0
	MOVLW      12
	MOVWF      R12+0
	MOVLW      51
	MOVWF      R13+0
L_main42:
	DECFSZ     R13+0, 1
	GOTO       L_main42
	DECFSZ     R12+0, 1
	GOTO       L_main42
	DECFSZ     R11+0, 1
	GOTO       L_main42
	NOP
	NOP
;embedproj_kinan.c,176 :: 		m_R(TURN_SPEED);
	MOVF       _TURN_SPEED+0, 0
	MOVWF      FARG_m_R_spd+0
	MOVF       _TURN_SPEED+1, 0
	MOVWF      FARG_m_R_spd+1
	CALL       _m_R+0
;embedproj_kinan.c,177 :: 		delay_ms(400);
	MOVLW      5
	MOVWF      R11+0
	MOVLW      15
	MOVWF      R12+0
	MOVLW      241
	MOVWF      R13+0
L_main43:
	DECFSZ     R13+0, 1
	GOTO       L_main43
	DECFSZ     R12+0, 1
	GOTO       L_main43
	DECFSZ     R11+0, 1
	GOTO       L_main43
;embedproj_kinan.c,178 :: 		s_m();
	CALL       _s_m+0
;embedproj_kinan.c,179 :: 		}
	GOTO       L_main44
L_main40:
;embedproj_kinan.c,181 :: 		else if(state == STATE_IR_AVOID){
	MOVF       _state+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_main45
;embedproj_kinan.c,183 :: 		if((PORTB & 0x06) == 0x06){
	MOVLW      6
	ANDWF      PORTB+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      6
	BTFSS      STATUS+0, 2
	GOTO       L_main46
;embedproj_kinan.c,184 :: 		state = STATE_FINAL;
	MOVLW      3
	MOVWF      _state+0
;embedproj_kinan.c,185 :: 		continue;
	GOTO       L_main21
;embedproj_kinan.c,186 :: 		}
L_main46:
;embedproj_kinan.c,188 :: 		if((PORTD & IR_RIGHT_RD5) == 0)
	MOVLW      32
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main47
;embedproj_kinan.c,189 :: 		m_L(TURN_SPEED);
	MOVF       _TURN_SPEED+0, 0
	MOVWF      FARG_m_L_spd+0
	MOVF       _TURN_SPEED+1, 0
	MOVWF      FARG_m_L_spd+1
	CALL       _m_L+0
	GOTO       L_main48
L_main47:
;embedproj_kinan.c,190 :: 		else if((PORTD & IR_LEFT_RD4) == 0)
	MOVLW      16
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main49
;embedproj_kinan.c,191 :: 		m_R(TURN_SPEED);
	MOVF       _TURN_SPEED+0, 0
	MOVWF      FARG_m_R_spd+0
	MOVF       _TURN_SPEED+1, 0
	MOVWF      FARG_m_R_spd+1
	CALL       _m_R+0
	GOTO       L_main50
L_main49:
;embedproj_kinan.c,193 :: 		m_F(SPEED);
	MOVF       _SPEED+0, 0
	MOVWF      FARG_m_F_spd+0
	MOVF       _SPEED+1, 0
	MOVWF      FARG_m_F_spd+1
	CALL       _m_F+0
L_main50:
L_main48:
;embedproj_kinan.c,194 :: 		}
	GOTO       L_main51
L_main45:
;embedproj_kinan.c,196 :: 		else if(state == STATE_FINAL){
	MOVF       _state+0, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L_main52
;embedproj_kinan.c,198 :: 		PORTD |= (1 << BUZZER_PIN);
	BSF        PORTD+0, 2
;embedproj_kinan.c,199 :: 		delay_ms(200);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      8
	MOVWF      R12+0
	MOVLW      119
	MOVWF      R13+0
L_main53:
	DECFSZ     R13+0, 1
	GOTO       L_main53
	DECFSZ     R12+0, 1
	GOTO       L_main53
	DECFSZ     R11+0, 1
	GOTO       L_main53
;embedproj_kinan.c,200 :: 		PORTD &= ~(1 << BUZZER_PIN);
	BCF        PORTD+0, 2
;embedproj_kinan.c,201 :: 		delay_ms(200);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      8
	MOVWF      R12+0
	MOVLW      119
	MOVWF      R13+0
L_main54:
	DECFSZ     R13+0, 1
	GOTO       L_main54
	DECFSZ     R12+0, 1
	GOTO       L_main54
	DECFSZ     R11+0, 1
	GOTO       L_main54
;embedproj_kinan.c,203 :: 		s_m();
	CALL       _s_m+0
;embedproj_kinan.c,204 :: 		delay_ms(500);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_main55:
	DECFSZ     R13+0, 1
	GOTO       L_main55
	DECFSZ     R12+0, 1
	GOTO       L_main55
	DECFSZ     R11+0, 1
	GOTO       L_main55
	NOP
	NOP
;embedproj_kinan.c,206 :: 		m_F(SPEED);
	MOVF       _SPEED+0, 0
	MOVWF      FARG_m_F_spd+0
	MOVF       _SPEED+1, 0
	MOVWF      FARG_m_F_spd+1
	CALL       _m_F+0
;embedproj_kinan.c,207 :: 		delay_ms(600);
	MOVLW      7
	MOVWF      R11+0
	MOVLW      23
	MOVWF      R12+0
	MOVLW      106
	MOVWF      R13+0
L_main56:
	DECFSZ     R13+0, 1
	GOTO       L_main56
	DECFSZ     R12+0, 1
	GOTO       L_main56
	DECFSZ     R11+0, 1
	GOTO       L_main56
	NOP
;embedproj_kinan.c,209 :: 		s_m();
	CALL       _s_m+0
;embedproj_kinan.c,210 :: 		setServoAngle(180);
	MOVLW      180
	MOVWF      FARG_setServoAngle_angle+0
	CLRF       FARG_setServoAngle_angle+1
	CALL       _setServoAngle+0
;embedproj_kinan.c,212 :: 		while(1);
L_main57:
	GOTO       L_main57
;embedproj_kinan.c,213 :: 		}
L_main52:
L_main51:
L_main44:
L_main39:
;embedproj_kinan.c,214 :: 		}
	GOTO       L_main21
;embedproj_kinan.c,215 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

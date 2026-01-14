// =================== STATES ===================
#define STATE_LINE        0
#define STATE_ULTRASONIC  1
#define STATE_IR_AVOID    2
#define STATE_FINAL       3 // these define the values for our states

unsigned char state = STATE_LINE; // by default, we are on lines

// =================== TUNABLE VALUES ===================
int SPEED = 80;
int RIGHT_SPEED = 80;
int LEFT_SPEED  = 80;
int TURN_SPEED  = 90;

unsigned int thresh = 480;
unsigned int obstacle_dist = 200;

// =================== GLOBALS ===================
unsigned int adc_value;
unsigned int distance;

unsigned int tickCounter = 0;
unsigned int servoPulse = 15;
unsigned long delayTicks = 0;

unsigned char light_is_hi = 1;

// ================= DEFINES =================
#define US_TRIG  0x20
#define US_ECHO  0x40
#define BUZZER_PIN 2
#define IR_LEFT_RD4  0x10
#define IR_RIGHT_RD5 0x20

// ================= SOFTWARE DELAY =================
void delay_us(unsigned int t){
    volatile unsigned int i;
    while(t--) for(i=0;i<2;i++);
}

// ================= SERVO =================
void setServoAngle(unsigned int angle){
    if(angle > 180) angle = 180;
    servoPulse = 10 + (angle * 10) / 180;
}

// ================= ULTRASONIC =================
unsigned int ultrasonic_read(unsigned char trig, unsigned char echo){
    unsigned int count = 0, timeout = 60000;

    PORTB &= ~trig;
    delay_us(2);
    PORTB |= trig;
    delay_us(10);
    PORTB &= ~trig;

    while(!(PORTB & echo)) if(--timeout==0) return 1000;
    timeout = 60000;
    while(PORTB & echo){
        count++;
        if(--timeout==0) break;
    }
    return count;
}

// =================== INTERRUPT ===================
void interrupt(void){
    if(INTCON & 0x04){
        TMR0 = 231;

        tickCounter++;
        if(tickCounter < servoPulse) PORTB |= 0x80;
        else PORTB &= 0x7F;

        if(tickCounter >= 200) tickCounter = 0;
        if(delayTicks > 0) delayTicks--;
        INTCON &= 0xFB;
    }
}

// =================== DELAYS ===================
void delay_ms(unsigned int ms){
    delayTicks = (unsigned long)ms * 10;
    while(delayTicks);
}

// =================== MOTOR CONTROL ===================
void m_F(int spd){
    PORTC = (PORTC & 0b11010111) | 0b00010111;
    CCPR1L = spd; CCPR2L = spd;
}
void m_B(int spd){
    PORTC = (PORTC & 0b11001011) | 0b00001011;
    CCPR1L = spd; CCPR2L = spd;
}
void m_R(int spd){
    PORTC = (PORTC & 0b11010110) | 0b00010100;
    CCPR1L = spd; CCPR2L = 0;
}
void m_L(int spd){
    PORTC = (PORTC & 0b11000111) | 0b00000011;
    CCPR1L = 0; CCPR2L = spd;
}
void s_m(){
    PORTC &= 0b11000000;
    CCPR1L = CCPR2L = 0;
}

// =================== MAIN ===================
void main(){

    delay_ms(3000);

    TRISA = 0b00000001; // setting i/o & port values
    TRISB = 0b01000110;
    TRISC = 0b10000000;
    TRISD = 0b00110000;

    PORTA = PORTB = PORTC = PORTD = 0;

    OPTION_REG = 0b00000010;
    TMR0 = 231;
    INTCON = 0xA0;

    ADCON0 = 0b01000001; // configuring adc
    ADCON1 = 0b10000110;

    T2CON = 0x07;
    PR2 = 250;
    CCP1CON = CCP2CON = 0x0C;

    while(1){

        if(state == STATE_LINE){

            if(!(PORTB & 0x04) && !(PORTB & 0x02))
                m_F(SPEED);
            else if(!(PORTB & 0x04))
                m_L(LEFT_SPEED);
            else if(!(PORTB & 0x02))
                m_R(RIGHT_SPEED);
            else
                s_m();

            delay_us(20);
            GO_DONE_bit = 1; // set & wait for adc conversion
            while(GO_DONE_bit);
            adc_value = ((unsigned int)ADRESH << 8) | ADRESL;

            if(adc_value > thresh){
                PORTD |= (1 << BUZZER_PIN);
                light_is_hi = 0; // set states
            }
            else{
                PORTD &= ~(1 << BUZZER_PIN);

                if(light_is_hi == 0){
                    delay_ms(800);
                    state = STATE_ULTRASONIC;
                    light_is_hi = 1;
                }
            }
        }

        else if(state == STATE_ULTRASONIC){

            distance = ultrasonic_read(US_TRIG, US_ECHO);

            if(distance >= obstacle_dist){
                state = STATE_IR_AVOID;
                continue;
            }

            m_B(SPEED);
            delay_ms(300);
            m_R(TURN_SPEED);
            delay_ms(400);
            s_m();
        }

        else if(state == STATE_IR_AVOID){

            if((PORTB & 0x06) == 0x06){
                state = STATE_FINAL;
                continue;
            }

            if((PORTD & IR_RIGHT_RD5) == 0)
                m_L(TURN_SPEED);
            else if((PORTD & IR_LEFT_RD4) == 0)
                m_R(TURN_SPEED);
            else
                m_F(SPEED);
        }

        else if(state == STATE_FINAL){

            PORTD |= (1 << BUZZER_PIN);
            delay_ms(200);
            PORTD &= ~(1 << BUZZER_PIN);
            delay_ms(200);

            s_m();
            delay_ms(500);

            m_F(SPEED);
            delay_ms(600);

            s_m();
            setServoAngle(180);

            while(1);
        }
    }
}
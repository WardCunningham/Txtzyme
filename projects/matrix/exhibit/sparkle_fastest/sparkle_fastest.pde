char sn[128];
const int nrnd=333;
byte rnd[nrnd];
void setup() {
  //Serial.begin();
  //delay(4000);
  for (int i; i<128; i++) {
    sn[i] = 96*sin(i*2*3.14159/128);
    //Serial.println((int)sn[i]);
  }
  for (int i; i<nrnd; i++) {
    rnd[i] = rn();
  }
}

int rn(void) {
  int r = random() & 0xFF;
  r += random() & 0xFF;
  r += random() & 0xFF;
  r += random() & 0xFF;
  return r >> 2;
  //return 128;
}

byte anode[] = {42, 15, 14, 39, 12, 40, 44, 45};
byte cathode[] = {38, 43, 10, 41, 17, 11, 16, 13};

char x=0, y=0;

void loop() {
  static unsigned long i1=0, i2=0;
  static unsigned int rindex=0;
  if (x >= 0 && x <= 7 && y >= 0 && y <= 7) {
    switch(x) {
      case 0: PORTF |= (1<<4); DDRF |= (1<<4); break; 
      case 1: PORTC |= (1<<5); DDRC |= (1<<5); break; 
      case 2: PORTC |= (1<<4); DDRC |= (1<<4); break; 
      case 3: PORTF |= (1<<1); DDRF |= (1<<1); break; 
      case 4: PORTC |= (1<<2); DDRC |= (1<<2); break; 
      case 5: PORTF |= (1<<2); DDRF |= (1<<2); break; 
      case 6: PORTF |= (1<<6); DDRF |= (1<<6); break; 
      case 7: PORTF |= (1<<7); DDRF |= (1<<7); break;
    }
    //digitalWrite(anode[x], HIGH);
    //pinMode(anode[x], OUTPUT);
    switch(y) {
      case 0: PORTF &= ~(1<<0); DDRF |= (1<<0); break; 
      case 1: PORTF &= ~(1<<5); DDRF |= (1<<5); break; 
      case 2: PORTC &= ~(1<<0); DDRC |= (1<<0); break; 
      case 3: PORTF &= ~(1<<3); DDRF |= (1<<3); break; 
      case 4: PORTC &= ~(1<<7); DDRC |= (1<<7); break; 
      case 5: PORTC &= ~(1<<1); DDRC |= (1<<1); break; 
      case 6: PORTC &= ~(1<<6); DDRC |= (1<<6); break; 
      case 7: PORTC &= ~(1<<3); DDRC |= (1<<3); break;
    }
    //digitalWrite(cathode[y], LOW);
    //pinMode(cathode[y], OUTPUT);
    delayMicroseconds(50);
    char xold = x;
    char yold = y;
    
    
    switch(xold) {
      case 0: PORTF &= ~(1<<4); DDRF &= ~(1<<4); break; 
      case 1: PORTC &= ~(1<<5); DDRC &= ~(1<<5); break; 
      case 2: PORTC &= ~(1<<4); DDRC &= ~(1<<4); break; 
      case 3: PORTF &= ~(1<<1); DDRF &= ~(1<<1); break; 
      case 4: PORTC &= ~(1<<2); DDRC &= ~(1<<2); break; 
      case 5: PORTF &= ~(1<<2); DDRF &= ~(1<<2); break; 
      case 6: PORTF &= ~(1<<6); DDRF &= ~(1<<6); break; 
      case 7: PORTF &= ~(1<<7); DDRF &= ~(1<<7); break;
    }
    //pinMode(anode[xold], INPUT);
    switch(yold) {
      case 0: PORTF &= ~(1<<0); DDRF &= ~(1<<0); break; 
      case 1: PORTF &= ~(1<<5); DDRF &= ~(1<<5); break; 
      case 2: PORTC &= ~(1<<0); DDRC &= ~(1<<0); break; 
      case 3: PORTF &= ~(1<<3); DDRF &= ~(1<<3); break; 
      case 4: PORTC &= ~(1<<7); DDRC &= ~(1<<7); break; 
      case 5: PORTC &= ~(1<<1); DDRC &= ~(1<<1); break; 
      case 6: PORTC &= ~(1<<6); DDRC &= ~(1<<6); break; 
      case 7: PORTC &= ~(1<<3); DDRC &= ~(1<<3); break;
    }
    //pinMode(cathode[yold], INPUT);
    
    x = (rnd[rindex] + sn[(i1>>24)&127]) >> 5;
    y = (rnd[rindex+1] + sn[((i2>>24)+32)&127]) >> 5;
  } else {
    x = (rnd[rindex] + sn[(i1>>24)&127]) >> 5;
    y = (rnd[rindex+1] + sn[((i2>>24)+32)&127]) >> 5;
  }
  i1 = i1 + (526335/2);
  i2 = i2 + (211913/2);
  rindex = rindex + 1;
  if (rindex >= nrnd - 2) rindex = 0;
  //delayMicroseconds(75);
}



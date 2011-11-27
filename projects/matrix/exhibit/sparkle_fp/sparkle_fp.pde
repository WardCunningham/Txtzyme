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
}

byte anode[] = {42, 15, 14, 39, 12, 40, 44, 45};
byte cathode[] = {38, 43, 10, 41, 17, 11, 16, 13};

char x=0, y=0;

void loop() {
  static unsigned long i1=0, i2=0;
  static unsigned int rindex=0;
  if (x >= 0 && x <= 7 && y >= 0 && y <= 7) {
    digitalWrite(anode[x], HIGH);
    pinMode(anode[x], OUTPUT);
    digitalWrite(cathode[y], LOW);
    pinMode(cathode[y], OUTPUT);
    //delayMicroseconds(50);
    char xold = x;
    char yold = y;
    x = (rnd[rindex] + sn[i1>>25]) >> 5;
    pinMode(anode[xold], INPUT);
    pinMode(cathode[yold], INPUT);
    y = (rnd[rindex+1] + sn[((i2>>25)+32)&127]) >> 5;
  } else {
    x = (rnd[rindex] + sn[i1>>25]) >> 5;
    y = (rnd[rindex+1] + sn[((i2>>25)+32)&127]) >> 5;
  }
  i1 = i1 + 526335;
  i2 = i2 + 211913;
  rindex = rindex + 1;
  if (rindex >= nrnd - 2) rindex = 0;
}



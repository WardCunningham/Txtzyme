void setup() {
    
}

float rn(void) {
  long r = random(0, 200000) + random(0, 200000) +
    random(0, 200000) + random(0, 200000);
  return r * 0.00001;
}

byte anode[] = {42, 15, 14, 39, 12, 40, 44, 45};
byte cathode[] = {38, 43, 10, 41, 17, 11, 16, 13};

void blink(char x, char y) {

}

char x=0, y=0;

void loop() {
  static float t=0;
  if (x >= 0 && x <= 7 && y >= 0 && y <= 7) {
    digitalWrite(anode[x], HIGH);
    pinMode(anode[x], OUTPUT);
    digitalWrite(cathode[y], LOW);
    pinMode(cathode[y], OUTPUT);
    delayMicroseconds(50);
    char xold = x;
    char yold = y;
    pinMode(anode[xold], INPUT);
    pinMode(cathode[yold], INPUT);
    x = rn() + 3.0 * sin(7.7 * t);
    y = rn() + 3.0 * cos(3.1 * t);
  } else {
    x = rn() + 3.0 * sin(7.7 * t);
    y = rn() + 3.0 * cos(3.1 * t);
  }
  t = t + 0.0002;
}

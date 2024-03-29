
unsigned int x = 0;
int d = 13;
const unsigned int bufsize = 1650; // 2048 is too large for Arduino Uno

void setup() {
  Serial.begin(9600);
  //txtEval("10d10T 1000m 2T 1000m 0T 0o\r\n"); // hint for a startup command
}

void loop() {
  char buf[bufsize];
  txtRead(buf, bufsize);  // wait for commands
  txtEval(buf);
}

void txtRead (char *p, unsigned int n) {
  unsigned int i = 0;
  while (i < (n-1)) {
    while (!Serial.available());  // loop while waiting for input
    char ch = Serial.read();
    if (ch == '\r' || ch == '\n') break;
    if (ch >= ' ' && ch <= '~') {
      *p++ = ch;
      i++;
    }
  }
  *p = 0;
}

void txtEval (char *buf) {
  unsigned int k = 0; 
  char *loop;
  char ch;
  while ((ch = *buf++)) {
    switch (ch) {
    case '0':
    case '1':
    case '2':
    case '3':
    case '4':
    case '5':
    case '6':
    case '7':
    case '8':
    case '9':
      x = ch - '0';
      while (*buf >= '0' && *buf <= '9') {
        x = x*10 + (*buf++ - '0');
      }
      break;
    case 'p':
      Serial.println(x);
      break;
    case 'd':
      d = x;
      break;
    case 'i':
      pinMode(d,INPUT);
    case 'r':
      x = digitalRead(d);
      break;
    case 'o':
      pinMode(d,OUTPUT);
      digitalWrite(d, x%2);
      break;
    case 'O': // write analog
      pinMode(d,OUTPUT);
      analogWrite(d,x);
      break;
// Teensy 3.1 and 3.0 specifc code
#if defined(__MK20DX256__)|| defined(__MK20DX128__)
    case 'F':  // See https://www.pjrc.com/teensy/td_pulse.html
      analogWriteFrequency(d,x);  
      break;
    case 'R':  // Teensy3 bits of resolution 2-16 default was 8
      analogWriteResolution(x);
      break;  
#endif
    case 'T':
      if (x ==0 ) 
        noTone(d);
      else  
        tone(d,x);
      break;
    case 'm':
      delay(x);
      break;
    case '{':
      k = x;
      loop = buf;
      while ((ch = *buf++) && ch != '}') {
      }
    case '}':
      if (k) {
        k--;
        buf = loop;
      }
      break;
    case 'k':
      x = k;
      break;
    case '_':
      while ((ch = *buf++) && ch != '_') {
        Serial.print(ch);
      }
      Serial.println();
      break;
    case 's':
      x = analogRead(x);
      break;
    }
  }
}









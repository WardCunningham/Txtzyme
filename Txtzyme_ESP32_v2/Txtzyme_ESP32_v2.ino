// Txtzyme_ESP32.ino
// based on https://github.com/WardCunningham/Txtzyme/edit/master/txtzyme.c
// and https://github.com/WardCunningham/Txtzyme/blob/master/Arduinozyme/Arduinozyme.ino
unsigned long x = 0;
uint32_t last = 0;
int d = 13;
const unsigned int bufsize = 2048;  // 2048 is too large for Arduino Uno

void setup() {
  Serial.begin(115200);
  //txtEval("10d10T 1000m 2T 1000m 0T 0o\r\n"); // hint for a startup command
}

char buff[bufsize];
char *p = buff;
int ibuf = 0;

void loop(void) {
  if (txtRead(buff, bufsize) == 1) {  // wait for commands
    txtEval(buff);
    p = buff;
    ibuf = 0;
    buff[ibuf] = 0;
  }
}

int txtRead(char *p, unsigned int n) {
  int retval = 0;
  if (ibuf < (n - 1)) {
    if (Serial.available()) {
      char ch = Serial.read();
      if (ch == '\r' || ch == '\n') {
        retval = 1;
      } else {
        if (ch >= ' ' && ch <= '~') {
          *(p + ibuf) = ch;
          *(p + ++ibuf) = 0;
        }
      }
    }
  }
  *(p + ibuf) = 0;
  return retval;
}

void txtEval(char *buf) {
  // Serial.println(buf);
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
          x = x * 10 + (*buf++ - '0');
        }
        break;
      case 'p':
        Serial.println(x);
        break;
      case 'd':
        d = x;
        break;
      case 'i':
        pinMode(d, INPUT);
      case 'r':
        x = digitalRead(d);
        break;
      case 'o':
        ledcDetachPin(d);
        pinMode(d, OUTPUT);
        digitalWrite(d, x % 2);
        break;
      case 'O':  // write analog
        pinMode(d, OUTPUT);
        analogWrite(d, x);
        break;
      case 'u':
        delayMicroseconds(x);
        break;
      case 'U':
        {
          uint32_t now;
          uint32_t delta = x;
          do {
            now = micros();
          } while (now - last < delta);
          last = now;
          break;
        }
        // Teensy specifc code
#if defined(__MK20DX256__) || defined(__MK20DX128__) || defined(CORE_TEENSY)
      case 'F':  // See https://www.pjrc.com/teensy/td_pulse.html
        analogWriteFrequency(d, x);
        break;
      case 'R':  // Teensy3 bits of resolution 2-16 default was 8
        analogWriteResolution(x);
        break;
#endif
      case 'v':
#define QUOTEME_(x) #x
#define QUOTEME(x) QUOTEME_(x)
        Serial.print(PSTR(QUOTEME(MCU)));
        Serial.println();
        break;
      case 'h':
        Serial.print(PSTR("Txtzyme [+bigbuf]\r\n0-9<num>\tenter number\r\n<num>p\t\tprint number\r\n<pin>i<num>\tinput\r\n<pin>d<num>o\toutput\r\n<num>m\t\tmsec delay\r\n<num>u\t\tusec delay\r\n<num>{}\t\trepeat\r\nk<num>\t\tloop count\r\n_<words>_\tprint words\r\n<num>s<num>\tanalog sample\r\nv\t\tprint version\r\nh\t\tprint help\r\n<pin>t<num>\tpulse width\r\n"));
        break;
      case 'T':
        if (x == 0)
          noTone(d);
        else
          tone(d, x);
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
        x = analogRead((int)x);
        break;
      case 't':
        {
          uint8_t pin = x;
          pinMode(pin, INPUT);  // direction = input
          uint8_t tstate = digitalRead(pin);
          uint16_t tcount = 0;
          uint32_t start = micros();
          while (++tcount) {
            if (digitalRead(pin) != tstate) break;
          }
          x = micros() - start;
          if (!tcount) break;
          while (++tcount) {
            if (digitalRead(pin) == tstate) break;
          }
          x = micros() - start;
        }
        break;
    }
  }
}


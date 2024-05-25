extern "C"{
  void init();
  void adc_loop();
  void servo();
  void myDelay();
}

ISR(INT0_vect){
  PORTB |= (1 << 0); // Set PORTB0 to high

}

void setup() {
  init();
}

void loop() {
  adc_loop();
  servo();
}



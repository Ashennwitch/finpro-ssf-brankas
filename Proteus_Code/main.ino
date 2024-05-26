extern "C"{
  void init();
  void adc_loop();
  void servo();
  void compare();
  void display();
}


ISR(INT0_vect){
  PORTB |= (1 << 0); // Set PORTB0 to high
}

ISR(INT1_vect){
  PORTD |= (1 << 7);
}


void setup() {
  init();
}

void loop() {
  adc_loop();
  compare();
  servo();
  display();
}



extern "C"
{
  void adc_loop();
  void init();
  void servo();
}
//----------------------------------------------------
const uint8_t btn_pin = 2;

void setup()
{
  init();
  // Set button pin to be input with pullup
  DDRD &= ~(1 << btn_pin); // Set btn_pin as input (clear the bit)
  PORTD |= (1 << btn_pin); // Enable pull-up resistor on btn_pin
  // Falling edge of INT0 generates interrupt
  EICRA |= (1 << ISC01);  // This sets ISC01 bit to 1 and ISC00 bit to 0
  EICRA &= ~(1 << ISC00); // Explicitly clear ISC00 bit

  // Enable interrupts for INT0
  EIMSK |= (1 << INT0);  // Use the correct macro and syntax

  // Enable global interrupts
  sei();  // Enable global interrupts
}
//----------------------------------------------------
void loop()
{
  adc_loop();
}

// Interrupt Service Routine (ISR) for INT0
ISR(INT0_vect) {
  servo();
}
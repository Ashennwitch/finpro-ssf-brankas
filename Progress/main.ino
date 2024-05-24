extern "C"{
  void init();
  void adc_loop();
  void servo();
}
void setup() {
  init();
}

void loop() {
  adc_loop();
  /* call if interrupt
  servo();
  */
}

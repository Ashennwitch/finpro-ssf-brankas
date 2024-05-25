extern "C" {
  void adc_loop();
  void init();
  void servo();
}

void setup() {
  init();
}

void loop() {
  adc_loop();
  servo();
}

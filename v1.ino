extern "C" { 
    void init_ADC(); 
    void read_ADC(); 
}

//--------------------------------------------------

void setup() {
    init_ADC();
}

//--------------------------------------------------

void loop() {
    read_ADC();
}
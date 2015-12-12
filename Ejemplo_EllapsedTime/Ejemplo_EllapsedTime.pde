int myPressedMillis = millis();

void draw() {
  background(10);
  int m = millis();
  text("millis: "+str(m), 10, 10);
  text("Pressed: "+str(myPressedMillis), 10, 40);
  int calculoTiempoEspera = millis() - myPressedMillis;
  text("Ellapsed: "+str(calculoTiempoEspera), 10, 60);
  
}

void mousePressed(){
  myPressedMillis = millis();
}

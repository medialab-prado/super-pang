int ancho = 768;
int alto = 628;
float escalar = 1;

Ball bola1;
Ball bola2;

void setup() {
  size(ancho, alto);
  bola1 = new Ball();
  bola2 = new Ball();
}

void draw() {
  bola1.update();
  bola2.update();
  bola1.edges();
  bola2.edges();
  bola1.display();
  bola2.display();
  
  
}



class Ball {
  PVector location;
  PVector velocity;
  PVector acceleration;

  float diam;
  float radius;
  float mass;

  Ball() {
    mass = random(0.2*escalar, 3.5*escalar);//Exmple for 5
    diam = mass*10;//50
    radius = diam/2;//25
    location = new PVector(random(width), random(10, 100));
    velocity = new PVector(random(2, 4), 1); // Direccion Inicial de las bolas
    velocity.mult(escalar);
  }
  //Pintar en pantalla
  void display() {
    fill(200, 100);
    ellipse(location.x, location.y, mass*10, mass*10);

    //line(mouseX, height, mouseX, mouseY);
  }
  void update() {
    location.add(velocity);
  }
  
  //Detección de los bordes de la pantalla
  void edges() {

    //Izquierda
    if (location.x < radius) {
      velocity.x *= -1;
      location.x = radius;
    }

    //Derecha
    if (location.x > width - radius) {
      velocity.x *= -1;
      location.x = width - radius;
    }

    //Arriba
    if (location.y < radius) {
      velocity.y *= -1;
      acceleration.mult(-1);
      location.y=radius;
    }  

    //Abajo
    if (location.y >= height-radius) {
      velocity.y *= -1;
      location.y=height-radius-10;
    }
  }
}


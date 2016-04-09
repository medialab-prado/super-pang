class Ball {
  PVector location;
  PVector velocity;
  PVector acceleration;


  float diam;
  float radius;
  float mass;

  boolean b2Small = false;

  ///////////////////////////////
  Boolean setDimensions(float _newDim) {

    b2Small = false;

    mass = _newDim;//Exmple for 5
    diam = mass*10;//50
    radius = diam/2;//25

    if (radius < minRadius) {
      b2Small = true;
    }

    return b2Small;
  }

  //Contructor
  Ball() {
    b2Small = setDimensions(2);//If its too small will not be created and added to the ArrayList
    location = new PVector(random(width), random(10, 100));
    velocity = new PVector(3, 1); // Direccion Inicial de las bolas
    acceleration = new PVector(0, accDificulty); // Vector Direccion de la aceleración

  }

  Ball(float lastSize, PVector lastLocation, PVector lastVelocity, PVector lastAcc) {

      println("New Ball with mass"+str(radius));
      location = lastLocation;

      velocity = lastVelocity;

      acceleration = lastAcc;

      //myInitMillis = millis();
      setDimensions(lastSize);
  }


  void update() {

    acceleration.add(gravityForce);

    velocity.add(acceleration);

    location.add(velocity);

//rest para no acumular
    acceleration.mult(0);
  }


  // colisión entre rayo y pelota
  /*void collisions(Ray myRayTemp) {
    if (dist(location.x, location.y, myRayTemp.rayLocation.x, myRayTemp.rayLocation.y) < radius || location.y > myRayTemp.rayLocation.y && dist(location.x, 0, myRayTemp.rayLocation.x, 0) < radius) destroyed = true;
  }*/

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
    /*if (location.y < radius) {
     velocity.y *= -1;
     location.y=radius;
     }
     */
    //Abajo
    if (location.y >= height-radius) {
      velocity.y *= -1;
      location.y=height-radius-1;
    }
  }

  //Pintar en pantalla
  void display() {
    stroke(0);
    fill(0, 255, 0);
    ellipse(location.x, location.y, mass*10, mass*10);
  }
}

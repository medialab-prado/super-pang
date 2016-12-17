class Ball {
  PVector location;
  PVector velocity;
  PVector acceleration;
  PVector InitAcceleration;

  float diam;
  float radius;
  float mass;

  Boolean b2Small = false;
  Boolean bStrokeBall = true;
  Boolean destroyed = false;

  color colorStrokeBall = color(104, 104, 134);
  color colorFillBall = color(255, 0, 0, 200);

  int myInitMillis = millis();
  int timeSpendInitAcc = 200;

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
    b2Small = setDimensions(random(minSizeBall, maxSizeBall));//If its too small will not be created and added to the ArrayList
    location = new PVector(random(widthWindow), random(10, 100));
    velocity = initVelocity.copy(); // Direccion Inicial de las bolas
    acceleration = new PVector(0, accDificulty); // Vector Direccion de la aceleración
    InitAcceleration =  new PVector(accDificulty, accDificulty);

    /*TODO {carles}
     Para hacer que bolas tengas diferentes direcciones crear diferentes clases de bolas.
     Cada clase que tenga un comportamiento diferente.
     Según el tamaño tenemos que la bola cambia de comportamiento.
     P.e Cuando el Tamaño disminuye la bola bota hasta una altura menor
     Necesitariamos definir unas alturas fijas para que tengamos claro donde.
     
     Init acc to down vector
     Hay que conseguir que la bola no se ralentice nunca.
     Si la posición de la bola llega a ser varias veces inferior al edge marcado, se ralentiza.
     */
  }

  Ball(float lastSize, PVector lastLocation, PVector lastVelocity, PVector lastAcc) {
    //Physic properties
    Boolean isSmaller = setDimensions(lastSize*0.5);

    InitAcceleration =  new PVector(lastAcc.x, lastAcc.y);

    if (isSmaller) {
      println("ERROR This should not be tried: Smaller please dont create a ball");
    } else {
      //println("New Ball with mass"+str(radius));

      location = lastLocation.copy();//{c}Fix reference issue arrayList get(ball).xxxx

      //Esto tambien actual como una copia
      velocity = new PVector(lastVelocity.x, lastVelocity.y);

      //Init acc to down vector
      acceleration = new PVector(0, accDificulty); // Vector Direccion de la acceleracion

      myInitMillis = millis();
    }
  }

  void update() {

    //Proceso de aplicacwidthWindowion de Fuerzas cada nuevo frame
    gravityForce.div(1);//inecesario pero si mirais Nature of Code, vereis que se usa cunado la masa es variable.

    //Una aceleration inicial diferente permite que al principio las bolas creen esta parabola 
    if (millis() - myInitMillis > timeSpendInitAcc) {
      acceleration.add(gravityForce);
    } else {
      acceleration.add(InitAcceleration);
    }

    velocity.add(acceleration);

    location.add(velocity);

    acceleration.mult(0);
  }


  // colisión entre rayo y pelota
  void collisions(Ray myRayTemp) {
    if (dist(location.x, location.y, myRayTemp.rayLocation.x, myRayTemp.rayLocation.y) < radius || location.y > myRayTemp.rayLocation.y && dist(location.x, 0, myRayTemp.rayLocation.x, 0) < radius) destroyed = true;
  }

  //Detección de los bordes de la pantalla
  void edges() {

    //Izquierda

    if (location.x < radius) {
      velocity.x *= -1;
      location.x = radius;
    }

    //Derecha
    if (location.x > widthWindow - radius) {
      velocity.x *= -1;
      location.x = widthWindow - radius;
    }

    //Arriba
    /*if (location.y < radius) {
     velocity.y *= -1;
     location.y=radius;
     }
     */
    //Abajo
    if (location.y >= heightWindow-radius) {
      velocity.y *= -1;
      location.y=heightWindow-radius-1;
    }
  }

  //Pintar en pantalla
  void display() {
    stroke(colorStrokeBall);
    fill(colorFillBall);
    strokeWeight(1);
    if (keyPressed == true) {
      if (key == 'c') {
        bStrokeBall = !bStrokeBall;
      }
    }
    
    if (bStrokeBall)noStroke();
    else strokeWeight(1);
    ellipse(location.x, location.y, mass*10, mass*10);
    strokeWeight(1);
  }
}
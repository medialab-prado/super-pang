class Ball {
  PVector location;
  PVector velocity;
  PVector acceleration;
  PVector InitAcceleration;

  float diam;
  float radius;
  float mass;

  Boolean b2Small = false;

  Boolean bUpLevel = false;
  int counterLevel = 0;

  Boolean destroyed = false;

  color colorStrokeBall = color(104, 104, 134);
  color colorFillBall = color(104, 164, 104);

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
    b2Small = setDimensions(random(minSizeBall, 2.5));//If its too small will not be created and added to the ArrayList
    location = new PVector(random(width), random(10, 100));
    velocity = new PVector(random(2, 4), 1); // Direccion Inicial de las bolas
    acceleration = new PVector(0, accDificulty); // Vector Direccion de la aceleración
    InitAcceleration =  new PVector(initCollisionGravityForce.x, initCollisionGravityForce.y);

    /*TODO
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

  Ball(float lastSize, PVector lastLocation, PVector lastVelocity, PVector lastAcc, int direction) {
    //Physic properties
    Boolean isSmaller = setDimensions(lastSize*0.5);

    InitAcceleration =  new PVector(lastAcc.x, lastAcc.y);

    if (isSmaller) {
      println("ERROR This should not be tried: Smaller please dont create a ball");
    } else {
      println("New Ball with mass"+str(radius));
      location = lastLocation;

      //T=D Crear que solo sean algunas grandes y algunas pequeñas, el resto valores medios (la mayoria )
      velocity = new PVector(lastVelocity.x, lastVelocity.y);
      velocity.mult(0);

      //Init acc to down vector
      acceleration = new PVector(0, accDificulty); // Vector Direccion de la acceleracion
      //acceleration = new PVector(direction, -0.1);

      myInitMillis = millis();
    }
  }

  void update() {
    //Set the acceleration in the right direction force
    //First apply the mass
    gravityForce.div(1);//mass = 1

    // acceleration = new PVector(0,accDificulty);

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
    if (myRayTemp.bRayActive) {
      float myDistCollision = dist(location.x, 0, myRayTemp.rayLocation.x, 0);
      if (myDistCollision< radius && myRayTemp.rayLocation.y < location.y && bBallsReadyCollision) {
        
        destroyed = true;
        println("colisiona myDistCollision="+str(myDistCollision));
      }
    }
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
    stroke(colorStrokeBall);
    fill(colorFillBall);
    ellipse(location.x, location.y, mass*10, mass*10);
  }
}
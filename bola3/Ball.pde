class Ball {
  PVector location;
  PVector velocity;
  PVector acceleration;

  float diam;
  float radius;
  float mass;
  
    Boolean b2Small = false;

  Boolean bUpLevel = false;
  int counterLevel = 0;

  Boolean destroyed = false;

  color colorStrokeBall = color(104, 104, 134);
  color colorFillBall = color(104, 164, 104);
 
  //
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
    /*TODO
     Para hacer que bolas tengas diferentes direcciones crear diferentes clases de bolas.
     Cada clase que tenga un comportamiento diferente.
     Según el tamany tenemos que la bola cambia de comportamiento. 
     P.e Cuando el Tamaño disminuye la bola bota hasta una altura menor
     Necesitariamos definir unas alturas fijas para que tengamos claro donde.
     
     Init acc to down vector
     Hay que conseguir que la bola no se ralentice nunca.
     Si la posición de la bola llega a ser varias veces inferior al edge marcado, se ralentiza.
     */
  }

  Ball(float lastSize, PVector lastLocation, int direction) {
    //Physic properties
    Boolean isSmaller = setDimensions(lastSize*0.5);

    if (isSmaller) {
      println("ERROR This should not be tried: Smaller please dont create a ball");
    } else {
      println("New Ball with mass"+str(radius));
      location = lastLocation;

      //T=D Crear que solo sean algunas grandes y algunas pequeñas, el resto valores medios (la mayoria )
      velocity = new PVector(direction*2, 1); // Dir X -2 ( derecha ) o 2 ( izquierda, DIR Y -1 ( abajo )

      //Init acc to down vector
      acceleration = new PVector(0, accDificulty); // Vector Direccion de la acceleracion
      acceleration.mult(0);
    }
  }

  void update() {
    //Set the acceleration in the right direction force
    //First apply the mass
    gravityForce.div(1);//mass = 1
    acceleration.add(gravityForce);
    // acceleration = new PVector(0,accDificulty);

    velocity.add(acceleration);
    location.add(velocity);

    /*?? Playing with Levels    
     if(millis() - myInitMillis > 3000){
     if(bUpLevel == false){
     accDificulty = accDificulty*2;
     acceleration = new PVector(0, accDificulty);
     
     bUpLevel = true; 
     myInitMillis = millis();
     
     println("Level Up", bUpLevel);
     counterLevel++;
     }
     }
     else{
     bUpLevel = false;
     }
     
     Reset the acceleration in case another one appplied other forces.
     */
    acceleration.mult(0);
  }

  void collisions() {
    float myDistCollision = dist(location.x, 0, mouseX, 0);
    if (myDistCollision< radius) {
      destroyed = true;
      println("colisiona myDistCollision="+str(myDistCollision));
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
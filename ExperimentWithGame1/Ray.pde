class Ray {
  //Rayo interaction
  // down
  float ballSize = 3;
  PVector rayBottom;
  PVector rayTop;
  PVector rayLocation;
  int initTimeRay;
  int rayTimeAnimation = 2000;
  
  boolean bRayActive;
  float rayTimeDif;//tiempo de vida del rayo
  float rayTimeDifMapped;

  void initRay() {

    rayBottom = new PVector(0, 0);
    rayBottom.y = heightWindow;

    rayTop = new PVector(0, 0);
    rayTop.y = 0;//ballSize/2;

    rayLocation = new PVector(0, heightWindow); // Se inicia abajo de la pantalla

    initTimeRay = millis();
    rayTimeDif = rayTimeAnimation;
  }

  //Contructor
  Ray() {
    initRay();
  }

  void resetRay() {
    initRay();
  }

  void throwRay() {
    // setear punto de inicio
  }

  void startShootRay() {
    bRayActive = true;
    initTimeRay = millis();

    rayBottom.x = mouseXJulian;
    rayTop.x = mouseXJulian;
    rayLocation.x = mouseXJulian;
  }

  void update() {

    if (keyPressed == true && bRayActive == false) {
      if (key == 's') {
        startShootRay();
      }
    }

    //Start to check collisions if ray is active
    if (bRayActive) {

      if (rayTimeDifMapped ==heightWindow) {
        rayTimeDif = 0;
      }

      rayTimeDif = millis() - initTimeRay;

      if (rayTimeDif > 2000) {
        bRayActive = false;
        rayTimeDif = 0;
      }

      //Animation Ray Y 
      rayTimeDifMapped = map(rayTimeDif, 0, rayTimeAnimation, heightWindow, 0);
      rayLocation.y = rayTimeDifMapped;
    }
  }

  void display() {
    fill(132, 82, 218);
    noStroke();

    if (bRayActive) {

      fill(0, 0, 255);
      ellipse(rayLocation.x, rayLocation.y, ballSize, ballSize);
      //ellipse(rayBottom.x, rayBottom.y, ballSize, ballSize);

      if (bRayActive == true) {
        stroke(0, 0, 255);
        line(rayBottom.x, rayBottom.y, rayLocation.x, rayLocation.y);
      }
    }
  }
}
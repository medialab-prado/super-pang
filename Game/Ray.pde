class Ray {
  //Rayo interaction
  // down
  float ballSize;
  PVector rayBottom;
  PVector rayTop;
  
  PVector rayLocation;
  int initTimeRay;
  int rayTimeAnimation;
  boolean bRayActive;
  float rayTimeDif;//tiempo de vida del rayo
  float rayTimeDifMapped;

  //Contructor
  Ray() {
    ballSize = 10; 

    rayBottom = new PVector(0, 0);
    rayBottom.y = height - ballSize/2;

    rayTop = new PVector(0, 0);
    rayTop.y = ballSize/2;

    rayLocation = new PVector(0, height); // Se inicia abajo de la pantalla

    rayTimeAnimation = 2000;
    initTimeRay = millis();
    rayTimeDif = rayTimeAnimation;
  }
  
  void resetRay(){
   
    ballSize = 10; 

    rayBottom = new PVector(0, 0);
    rayBottom.y = height - ballSize/2;

    rayTop = new PVector(0, 0);
    rayTop.y = ballSize/2;

    rayLocation = new PVector(0, height); // Se inicia abajo de la pantalla

    rayTimeAnimation = 2000;
    initTimeRay = millis();
    rayTimeDif = rayTimeAnimation;
  }

  void throwRay(){
   // setear punto de inicio
   
  }
  void update() {
    rayBottom.x = mouseX;
    rayTop.x = mouseX;


    if (mousePressed == true) {
      bRayActive = true;
      initTimeRay = millis();
    }

    //Start to check collisions if ray is active
    if (bRayActive) {

      if (rayTimeDifMapped == height) {
        rayTimeDif = 0;
      }

      rayTimeDif = millis() - initTimeRay;

      if (rayTimeDif > 2000) {
        bRayActive = false;
        rayTimeDif = 0;
      }

      /*if (millis() == 0) {
        rayLocation.y = height -height/ballSize;
      }*/

      rayTimeDifMapped = map(rayTimeDif, 0, rayTimeAnimation, height, 0);
      rayLocation.x = mouseX;
      rayLocation.y = rayTimeDifMapped;
    }
  }

  void display() {
    fill(132, 82, 218);
    noStroke();

    if (bRayActive) {

      ellipse(rayLocation.x, rayLocation.y, ballSize, ballSize);
      fill(255, 0, 0);
      ellipse(rayBottom.x, rayBottom.y, ballSize, ballSize);

      if (bRayActive == true) {
        stroke(255, 0, 0);
        line(rayBottom.x, rayBottom.y - ballSize/2, rayLocation.x, rayLocation.y);
      }
    }
  }
}
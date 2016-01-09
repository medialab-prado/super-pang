class Ray {
  //Rayo interaction
  float rayX1;
  float rayY1;
  float rayX2;
  float rayY2;
  int initTimeRay;
  int rayTimeAnimation;
  int ballSize;
  boolean isShoot;
  float rayTimeDif;
  float rayTimeDifMapped;

  //Contructor
  Ray() {
    ballSize = 10; 
    rayY1 = height - ballSize/2;
    rayY2 = ballSize/2;
    
    rayTimeAnimation = 2000;
    initTimeRay = millis();
    rayTimeDif = rayTimeAnimation;
  }

  void update() {
    rayX1 = mouseX;
    rayX2 = mouseX;
    if (isShoot == false) {
      
      if (mousePressed == true) {
        isShoot = true;
        initTimeRay = millis();
      }
    }
    
    if (rayTimeDifMapped == height){
      stroke(255);
    }

    rayTimeDif = millis() - initTimeRay;

    if (rayTimeDif > 2000) {
      isShoot = false;
      rayTimeDif = 2000;
    }

    rayTimeDifMapped = map(rayTimeDif, 0, rayTimeAnimation, height, 0);
  }

  void display() {
    fill(132, 82, 218);
    noStroke();
    ellipse(rayX1, height - ballSize/2, ballSize, ballSize);
    ellipse(rayX2, rayY2, ballSize, ballSize);
   
    if (isShoot == true) {
      stroke(255, 0, 0);
      line(rayX1, rayY1, rayX2, rayTimeDifMapped);
    }
  }
}


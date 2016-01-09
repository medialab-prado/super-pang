class Ray {
  //Rayo interaction
  float rayX1;
  float rayY1;
  float rayX2;
  float rayY2;
  int initTimeRay;
  int rayTimeAnimation;
  int ballSize;

  //Constructor
  Ray() {
  }

  void update() {
    ballSize = 10;    
    rayX1 = mouseX;
    rayY1 = ballSize/2;
    rayX2 = mouseX;
    rayY2 = height-ballSize/2;
    rayTimeAnimation = 2000;
    initTimeRay = millis();

    if (mousePressed == true) {
      line(rayX1, rayY1, rayX2, rayX1+1);
    }

    //calc collision
  }

  void display() {
    fill(0);
    noStroke();
  }
}
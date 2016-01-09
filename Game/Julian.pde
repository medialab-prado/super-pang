class Julian {
  int widthJulian = 20;
  int heightJulian = 15;
  int posXJulian;
  int posYJulian;


  void update() {
    posXJulian = mouseX;

    //calcular colision
    //if (myDistCollision< radius && bBallsReadyCollision) {
    //  destroyed = true;
    //}
  }

  void display() {
    fill(0, 255, 255);
    // rect(posXJulian, height - heightJulian, widthJulian, heightJulian);

    //Paint Player
    if (height - mouseY <= maxPlayerHeight && height - mouseY >= minPlayerHeight) {
      rect(mouseX - 5, mouseY, 10, height - mouseY);
      posXJulian = mouseX;
    } else if (height - mouseY >= maxPlayerHeight) {
      rect(mouseX - 5, height - maxPlayerHeight, 10, maxPlayerHeight);
      posXJulian = maxPlayerHeight;
    } else {
      rect(mouseX - 5, height - minPlayerHeight, 10, minPlayerHeight);
      posXJulian = minPlayerHeight;
    }

    posYJulian = mouseY - 5;
  }
}
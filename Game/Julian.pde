class Julian {
  PVector posJulian;
  PVector sizeJulian;

  void update() {
    posJulian = new PVector(mouseX, mouseY - 5);
    sizeJulian = new PVector(10, height - mouseY);

    //calcular colision
    //if (myDistCollision< radius && bBallsReadyCollision) {
    //  destroyed = true;
    //}
  }

  void display() {
    fill(0, 255, 255);
    // rect(posJulian.x, height - sizeJulian.x, sizeJulian.y, sizeJulian.x);

    //Paint Player
    if (height - mouseY <= maxPlayerHeight && height - mouseY >= minPlayerHeight) {
      posJulian.x = mouseX - 5;
      posJulian.y = mouseY;
      sizeJulian.y = height - mouseY;
      rect(posJulian.x, posJulian.y, sizeJulian.x, sizeJulian.y);
    } else if (height - mouseY >= maxPlayerHeight) {
      posJulian.x = mouseX - 5;
      posJulian.y = height - maxPlayerHeight;
      sizeJulian.y = maxPlayerHeight;
      rect(posJulian.x, posJulian.y, sizeJulian.x, sizeJulian.y);
    } else {
      posJulian.x = mouseX - 5;
      posJulian.y = height - minPlayerHeight;
      sizeJulian.y = minPlayerHeight;
      rect(posJulian.x, posJulian.y, sizeJulian.x, sizeJulian.y);
    }
  }
}
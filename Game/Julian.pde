class Julian {
  PVector loc;
  PVector dim;

  void update(ArrayList<Ball> ballsInput) {
    loc = new PVector(mouseX, mouseY - 5);
    dim = new PVector(10, height - mouseY);




    //update character dimensions
    if (height - mouseY <= maxPlayerHeight && height - mouseY >= minPlayerHeight) {
      loc.x = mouseX - 5;
      loc.y = mouseY;
      dim.y = height - mouseY;
    } else if (height - mouseY >= maxPlayerHeight) {
      loc.x = mouseX - 5;
      loc.y = height - maxPlayerHeight;
      dim.y = maxPlayerHeight;
    } else {
      loc.x = mouseX - 5;
      loc.y = height - minPlayerHeight;
      dim.y = minPlayerHeight;
    }

    //calcular colision con todas las bolas recibidas aqui
    for (Ball b : ballsInput) {
      Boolean collisionActual = false;
      collisionActual = isCollision(b.location);

      if (collisionActual == true) {
        println("COlLISIONNNNNNN!!!!!!!");
      }
    }
  }

  void display() {
    fill(0, 255, 255);
    // rect(loc.x, height - dim.x, dim.y, dim.x);

    //Paint Player
    rect(loc.x, loc.y, dim.x, dim.y);
    fill(255, 0, 0);
    ellipse(loc.x, loc.y, 5, 5);
    ellipse(loc.x + dim.x, loc.y, 5, 5);
  }

  Boolean isCollision (PVector PballLoc) {
    Boolean bCollision = false;
    if (PballLoc.x >= loc.x && PballLoc.x <= loc.x + dim.x) {
      if (PballLoc.y > loc.y) {
        //algo
        bCollision = true;
      }
    }
    return bCollision;
  }
}
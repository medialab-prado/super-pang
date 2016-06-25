class Julian {
  PVector loc;
  PVector dim;
  

  void update(ArrayList<Ball> ballsInput) {
    loc = new PVector(mouseXJulian, mouseYJulian - 5);
    dim = new PVector(10, heightWindow - mouseYJulian);




    //update character dimensions
    if (heightWindow - mouseYJulian <= maxPlayerHeight && heightWindow - mouseYJulian >= minPlayerHeight) {
      loc.x = mouseXJulian - 5;
      loc.y = mouseYJulian;
      dim.y = heightWindow - mouseYJulian;
    } else if (heightWindow - mouseYJulian >= maxPlayerHeight) {
      loc.x = mouseXJulian - 5;
      loc.y = heightWindow - maxPlayerHeight;
      dim.y = maxPlayerHeight;
    } else {
      loc.x = mouseXJulian - 5;
      loc.y =heightWindow - minPlayerHeight;
      dim.y = minPlayerHeight;
    }

    //calcular colision con todas las bolas recibidas aqui
    for (Ball b : ballsInput) {
      Boolean collisionActual = false;
      collisionActual = isCollidingCircleRectangle(b.location.x, b.location.y, b.radius, loc.x, loc.y, dim.x, dim.y);

      if (collisionActual == true) {
        println("COlLISIONNNNNNN!!!!!!!");
      }
    }
  }

  void display() {
    fill(255, 0, 255);
    

    //Paint Player
    rect(loc.x, loc.y, dim.x, dim.y);
    
    //ellipse(loc.x, loc.y, 5, 5);
    //ellipse(loc.x + dim.x, loc.y, 5, 5);
  }

  boolean isCollidingCircleRectangle(
    float circleX, 
    float circleY, 
    float radius, 
    float rectangleX, 
    float rectangleY, 
    float rectangleWidth, 
    float rectangleHeight)
  {
    float circleDistanceX = abs(circleX - rectangleX - rectangleWidth/2);
    float circleDistanceY = abs(circleY - rectangleY - rectangleHeight/2);

    if (circleDistanceX > (rectangleWidth/2 + radius)) { 
      return false;
    }
    if (circleDistanceY > (rectangleHeight/2 + radius)) { 
      return false;
    }

    if (circleDistanceX <= (rectangleWidth/2)) { 
      return true;
    } 
    if (circleDistanceY <= (rectangleHeight/2)) { 
      return true;
    }

    float cornerDistance_sq = pow(circleDistanceX - rectangleWidth/2, 2) +
      pow(circleDistanceY - rectangleHeight/2, 2);

    return (cornerDistance_sq <= pow(radius, 2));
  }
}
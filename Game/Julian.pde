class Julian {
  PVector loc = new PVector(0, 0);
  PVector dim = new PVector(0, 0);
  PVector locRaw = new PVector(0, 0);
  PVector dimRaW = new PVector(0, 0);
  boolean isShot, isKillingLive;
  float initMillistColision;
  float shotDuration;

  //------------------------------------------------
  void linearInterpolate_Current2Desired(PVector currentValue, PVector targetValue) {
    float targetDistance = abs(targetValue.x-currentValue.x);
    float factorDistanceTarget = map(targetDistance, 0, widthWindow, 0, 1);
    currentValue.x = currentValue.x + ( targetValue.x - currentValue.x ) * factorDistanceTarget;//0.5;
    //println("Factor Distance =" +str(factorDistanceTarget)    +"CurrentValue.x = "  +str(currentValue.x) + "targetValue.x = " + str(targetValue.x));
    currentValue.y = targetValue.y;//Y not relevant now
  }

  //------------------------------------------------
  void updatePositionAndDimensions() {
    locRaw = new PVector(mouseXJulian, mouseYJulian - 5);
    dimRaW = new PVector(10, heightWindow - mouseYJulian);
    isShot = false;

    linearInterpolate_Current2Desired(loc, locRaw);
    //linearInterpolateFromTo(locRaw, loc);
    dim = dimRaW;

    //update character dimensions
    if (heightWindow - mouseYJulian <= maxPlayerHeight && heightWindow - mouseYJulian >= minPlayerHeight) {
      //loc.x = mouseXJulian - 5;
      loc.y = mouseYJulian;
      dim.y = heightWindow - mouseYJulian;
      //println("1 dim.y = "+str(dim.y));
    } else if (heightWindow - mouseYJulian >= maxPlayerHeight) {
      //loc.x = mouseXJulian - 5;
      loc.y = heightWindow - maxPlayerHeight;
      dim.y = maxPlayerHeight;
      //println("2 dim.y = "+str(dim.y));
    } else {
      //loc.x = mouseXJulian - 5;
      loc.y =heightWindow - minPlayerHeight;
      dim.y = minPlayerHeight;
      //println("else dim.y = "+str(dim.y));
    }
  }

  //------------------------------------------------
  void update(ArrayList<Ball> ballsInput) {

    //update Character Position and Dimensions
    updatePositionAndDimensions();

    //calcular colision con todas las bolas recibidas aqui
    int countCollisions = 0;

    for (Ball b : ballsInput) {
      Boolean collisionActual = false;

      if (isKillingLive == false) {
        collisionActual = isCollidingCircleRectangle(b.location.x, b.location.y, b.radius, loc.x, loc.y, dim.x, dim.y);
        if (collisionActual == true) {
          countCollisions ++;
          initMillistColision = millis();
        }
      }
    }

    //Resumen Colisions
    if (countCollisions > 0) {
      //println("COlLISIONNNNNNN");
      lives = lives-1;
      isShot = true;

      //println("isShot = "+isShot);
      isKillingLive = true;
    }

    //update timer
    if (millis() - initMillistColision > 1000) {
      isKillingLive = false;
    }
    //println("isKillingLive = "+isKillingLive);
  }

  void display() {
    fill(255, 0, 255);

    if (isKillingLive == true)fill(random(0, 255), random(0, 255), random(0, 255));

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
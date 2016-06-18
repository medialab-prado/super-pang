// Example base from  //<>//
// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

class Mover {

  int id;
  PVector location;
  PVector velocity;
  PVector acceleration;
  PVector last_velocity;
  float mass;
  int radius;
  float maxHeightJumped = height;


  //TODO
  //Apply diferent Color to each ball 
  int redChannel = (int)random(10, 244);
  int greenChannel = (int)(255 - redChannel);
  int blueChannel = (int)random(10, 255);
  color colorBall = color(redChannel, greenChannel, blueChannel); 
  //And draw the upper jumped height in a line with this color
  boolean floorInteraction = false;

  Mover(float m, float x, float y, int _id) {
    id = _id;
    mass = m;
    location = new PVector(x, y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    //Apply dims
    radius = (int)mass*3;
    last_velocity = new PVector(0, 0);
  }

  void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);
    acceleration.add(f);
  }

  void update() {

    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);

    if (id == 0) {//test for only id 0

      if (velocity.y > 0 && last_velocity.y <= 0) { //Si la velocidad actual baja y la pasada subia o era cero
        maxHeightJumped = location.y - radius;
        println("id = " +str(id) + "New height detected"+str(millis())+ " velocity = " + str(velocity.y) + "last velocity = " + str(last_velocity.y));
      } else {
        println("ELSE " + "id = " +str(id) + "New height detected"+str(millis())+ " velocity = " + str(velocity.y) + "last velocity = " + str(last_velocity.y));
      }
    }
  }

  void display() {

    textSize(8);
    text("Vel.y= " + str(velocity.y) + " LastVel.y= " + str(velocity.y), location.x, location.y);

    //Salto de altura maxima consegida y actualizada despues de cada salto
    stroke(colorBall);
    line(0, maxHeightJumped, width, maxHeightJumped);

    //Paint ball
    stroke(0);
    strokeWeight(2);
    fill(colorBall);
    ellipse(location.x, location.y, radius*2, radius*2);

    //update last Velocity
    last_velocity = velocity;
  }

  void checkEdges() {

    if (location.x > width) {
      location.x = width;
      velocity.x *= -1;
    } else if (location.x < 0) {
      location.x = 0;
      velocity.x *= -1;
    }

    if (location.y > height-radius) {
      if (BslowVel) {
        velocity.y *= addedAcc;
        //BslowVel = false;
      } else velocity.y *= -1;
      location.y = height-radius-1; //Cuando la bola toca el suelo, recolocamos la bola para que siga en direccion contraria y no vuelva a entrar en este bucle
      floorInteraction = true;
    }
  }
}
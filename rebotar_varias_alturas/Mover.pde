// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

class Mover {

  PVector location;
  PVector velocity;
  PVector acceleration;
  float mass;
  int radius;
  
  //TODO
  //Apply diferent Color to each ball 
  //And draw the upper jumped height in a line with this color

  Mover(float m, float x, float y) {
    mass = m;
    location = new PVector(x, y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
   //Apply dims
    radius = (int)mass*3;
  }

  void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);
    acceleration.add(f);
  }

  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);
  }

  void display() {
    stroke(0);
    strokeWeight(2);
    fill(0, 127);
    ellipse(location.x, location.y, radius*2, radius*2);
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
      location.y = height-radius-1;
    }
  }
}
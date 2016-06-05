/*CodeDojo 2016 Rrocessing 
Matias, Camila, Carles */

//Learn how to interact with the accelerations and heights in floor collisions
//Check how to pause game to see some internal values.

// Example base from 
// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

Mover[] movers = new Mover[10];
float addedAcc = -0.75;
boolean BslowVel = false;

void setup() {
  size(383, 200);
  randomSeed(1);
  for (int i = 0; i < movers.length; i++) {
    movers[i] = new Mover(random(1, 4), random(1, width), random(50, height-100));
  }
}

void draw() {
  background(255);

  for (int i = 0; i < movers.length; i++) {

    PVector wind = new PVector(0.01, 0);
    PVector gravity = new PVector(0, 0.1*movers[i].mass);

    float c = 0.05;
    PVector friction = movers[i].velocity.get();
    friction.mult(-1); 
    friction.normalize();
    friction.mult(c);

    //movers[i].applyForce(friction);
    //movers[i].applyForce(wind);
    movers[i].applyForce(gravity);

    movers[i].update();
    movers[i].display();
    movers[i].checkEdges();

  }

  stroke(255, 10, 15); 
  line(0, mouseY, width, mouseY);

  fill(0, 102, 153);
  textSize(12);
  text("Mult Acc (" + str(addedAcc) + ") when floor contact done? " + str(BslowVel), 10, 10);
}

void keyPressed() {

  if (key == 'q') {//apply slow or fast acc
    BslowVel = !BslowVel;
  } 
  else if (key == 'w') {
    addedAcc = -1.15;
  }
  else if (key == 's') {
    addedAcc = -0.75;
  }

  print("Key pressed! = " + str(key));
}
//Vars for Balls
ArrayList<Ball> balls;
float accDificulty = 0.1; // en 0.3 disminuye, con el resto sigue igual, no disminuye
PVector deltaXVel =  new PVector(3, 0);
PVector deltaYVel =  new PVector(0, 1);
PVector gravityForce = new PVector(0, accDificulty);

PVector initVelocity = new PVector(2, 2);
PVector initInvertVelocity = new PVector(initVelocity.x*-1, initVelocity.y);

PVector initGravityForce = new PVector(0, -accDificulty*2);

int initialBalls = 1;
float minSizeBall = 2;
float maxSizeBall = 4;
float minRadius =  2;

//Balls var interaction
int lastShootedTime = millis();
int waitTimeBeforeShoot = 1000;
Boolean bBallsReadyCollision = false;

////Vars for Mouse Interaction
color colorMouseInteraction = color(255, 204, 0);
Boolean bmousePressed = false;

//Vars for Rays
Ray myRay;

////Vars for character
Julian miJulian;
int maxPlayerHeight = 30;
int minPlayerHeight = 10;

void setup() {
  size(192, 157);

  //ray vars
  myRay = new Ray();

  balls = new ArrayList<Ball>();  // Create an empty ArrayList
  for (int i = 0; i < initialBalls; i++) {
    balls.add(new Ball());
  }

  miJulian = new Julian();
}

void draw() {
  background(255);
  fill(127);

  //Calc once if Balls can be collided. This is used inside Ball class
  bBallsReadyCollision = isBallsReady2Collision();

  if (myRay.bRayActive) {
    //for (int i = balls.size()-1; i >= 0; i--) {
    for (int i = 0; i <  balls.size(); i++) {
      Ball ball1 = balls.get(i);
      if (ball1.destroyed == true) {
        Boolean bSmaller = checkSmaller(ball1.mass*0.3);
        if (!bSmaller) {

          Ball Ball2Left = new Ball(ball1.mass, ball1.location, initVelocity, initGravityForce);
          balls.add(Ball2Left);  // adding element with specific mass and dimensions

          Ball Ball2Right = new Ball(ball1.mass, ball1.location, initInvertVelocity, initGravityForce);//( inverted movement with Velocity)
          balls.add(Ball2Right);
        }

        //Elimina la bola
        lastShootedTime = millis();
        balls.remove(i);

        //Desactiva el Ray y resetear valores internos
        myRay.bRayActive = false;
        myRay.resetRay();
      }
    }
  }

  for (Ball b : balls) {
    b.update();
    b.edges();
    b.display();
    b.collisions(myRay);
  }

  myRay.display();
  myRay.update();


  miJulian.update(balls);
  miJulian.display();
}

void keyPressed() {
}

//////////////////////////////
void mousePressed() {
  bmousePressed = true;
}

//////////////////////////////
void mouseReleased() {
  bmousePressed = false;
}

////////////////////////////////////////////////
Boolean isBallsReady2Collision() {
  Boolean readyBalls = false;

  if ( (millis() - lastShootedTime) > waitTimeBeforeShoot) {
    readyBalls = true;
  }

  return readyBalls;
}

////////////////////////////////////////////////
Boolean checkSmaller(float _newDim) {
  Boolean b2Small = false;

  float mass = _newDim;//Exmple for 5
  float diam = mass*10;//50
  float radius = diam/2;//25

  if (radius < minRadius) {
    b2Small = true;
  }

  return b2Small;
}
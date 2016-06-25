//window vars
int widthWindow = 192;
int heightWindow = 157;

//Vars for Balls
ArrayList<Ball> balls;
float accDificulty = 0.1; // en 0.3 disminuye, con el resto sigue igual, no disminuye
PVector deltaXVel =  new PVector(3, 0);
PVector deltaYVel =  new PVector(0, 1);
PVector gravityForce = new PVector(0, accDificulty);
PVector initVelocity = new PVector(2, 2);
PVector initInvertVelocity = new PVector(initVelocity.x*-1, initVelocity.y);
PVector initGravityForce = new PVector(0, -accDificulty*2);

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
float mouseXJulian;
float mouseYJulian;


//Vars for Game
int initTime;
int currentTime;
int points;


///osc
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

float pangBlobX = 0;
float pangBlobY = 0;

///////////////////////
PImage BackGroundImg;
int initialBalls = 1;
float minSizeBall = 2;
float maxSizeBall = 4;
float minRadius =  2;


/////////////////////
int statusGame = 0; // 0 es readyToInit, 1 Playing, 2 GameOver

void setup() {

  fullScreen(); //size(192, 157); 

  //Game Vars
  statusGame = 0;

  //ray vars
  myRay = new Ray();

  balls = new ArrayList<Ball>();  // Create an empty ArrayList
  for (int i = 0; i < initialBalls; i++) {
    balls.add(new Ball());
  }

  miJulian = new Julian();

  //*****OSC
  oscP5 = new OscP5(this, 12345);
  myRemoteLocation = new NetAddress("127.0.0.1", 12345);

  BackGroundImg = loadImage ("fondo.jpg");
}

void resetGame() {

  //Game Vars
  statusGame = 0;

  for (int i = 0; i < initialBalls; i++) {
    balls.add(new Ball());
  }
}

void draw() {
  background(204);

  translate(40, 40);

  if (statusGame == 0) {
    drawReadyToPlay();
  } else if (statusGame == 1) {
    drawPlaying();

    if (balls.size() == 0) {
      statusGame = 2;
    }
  } else if (statusGame == 2) {
    drawGameOver();
  }

  //osc
  fill(255, 0, 0);
  ellipse(pangBlobX*widthWindow, pangBlobY*heightWindow, 10, 10);
  
  
  textAlign(CENTER);
  textSize(10);
  text ("time:"+currentTime, 140, 20);
  text ("points:"+points, 140, 30);
}

//----------------------------------------
void drawGameOver() {

  text("GAME OVER Press KEY to Start Again", 100, 100);

  updatePoints();
}

//----------------------------------------
void drawReadyToPlay() {
  text("Press P to Start Play", 100, 100);

  if (keyPressed == true) {
    statusGame = 1;
  }
}


//----------------------------------------
void drawPlaying() {

  updateTime();

  //Ideally this change for each new game
  //background(BackGroundImg); no works for full Screen
  image(BackGroundImg, 0, 0);
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

  /////
}

void mouseMoved() {

  mouseXJulian = mouseX;
  if (mouseXJulian > widthWindow) {
    mouseXJulian = widthWindow;
  }
  mouseYJulian = mouseY;
  if (mouseYJulian > heightWindow) {
    mouseYJulian = heightWindow;
  }
}

void keyPressed() {
  //if (key=='a'){
  bmousePressed = true;
  //}
}

void keyReleased() {
  //if (key=='a'){
  bmousePressed = false;
  //}
}

//////////////////////////////
void mousePressed() {
}

//////////////////////////////
void mouseReleased() {
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
  float radius = diam/2;//25heightWindow

  if (radius < minRadius) {
    b2Small = true;
  }

  return b2Small;
}
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());


  if (theOscMessage.checkAddrPattern("/PangBlob") == true) {
    if (theOscMessage.checkTypetag("ff")) {
      float OSCvalue0 = theOscMessage.get(0).floatValue();
      println(" values 0: "+OSCvalue0);
      pangBlobX = OSCvalue0;

      float OSCvalue1 = theOscMessage.get(1).floatValue();
      println(" values 1: "+OSCvalue1);
      pangBlobY = OSCvalue1;


      //add to our system
      mouseXJulian = (int)(pangBlobX*widthWindow);
      mouseYJulian = (int)(pangBlobY*heightWindow);

      return;
    }
  }
}

//-----------------------------------
void updateTime() {
  initTime = 180;
  currentTime = initTime - (millis()/1000);
}

//-----------------------------------
void updatePoints() {

  if (currentTime  > 0) {
    points = points + 3;
    currentTime--;
  }
  else{
    //HardCoded RESET
    if (keyPressed == true) {
      resetGame();
    }
  }
}
//window vars //<>//
int widthWindow = 192;
int heightWindow = 157;
float messageScreenX = (widthWindow)/2;
float messageScreenY = 60;

float pointsScreenX;
float pointsScreenY;
float timeScreenX;
float timeScreenY;

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

//Vars for Mouse Interaction
color colorMouseInteraction = color(255, 204, 0);
Boolean bmousePressed = false;
Boolean bManualControl = true;

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

void initMessagesPos() {
  //Messages postions reset
  timeScreenX = (widthWindow)/2;
  timeScreenY = 15;
  
  pointsScreenX = timeScreenX-9;
  pointsScreenY = timeScreenY+17;
}

void setup() {

  frameRate(20);
  fullScreen(); //size(192, 157); 

  //Init class vars
  myRay = new Ray();
  balls = new ArrayList<Ball>();  // Create an empty ArrayList
  miJulian = new Julian();
  
  //set the right values to start a game
  resetGame();

  //setup OSC
  oscP5 = new OscP5(this, 12345);
  myRemoteLocation = new NetAddress("127.0.0.1", 12345);

  //TODO{c} Set a random background in Reset
  BackGroundImg = loadImage ("fondo.jpg");
}

void resetGame() {

  //Game Vars
  statusGame = 0;

  for (int i = 0; i < initialBalls; i++) {
    balls.add(new Ball());
  }

  initMessagesPos();
}

void draw() {
  background(0);

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
  text (""+currentTime, timeScreenX, timeScreenY);
  if(statusGame == 2)text ("Points: "+points, pointsScreenX, pointsScreenY);
  
  translate(-40, -40);
  stroke(255);  
  drawFacadeContourInside();
}

//----------------------------------------
void drawGameOver() {

  text("GAME is OVER / Restart", messageScreenX, messageScreenY);

  updatePoints();
}

//----------------------------------------
void drawReadyToPlay() {
  text("Press Space or Shoot to Start", messageScreenX, messageScreenY);

  if (keyPressed == true) {
    if (key == ' ') {
      statusGame = 1;
    }
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
  
  if(key == 'm'){
    bManualControl = true;
  }
  if(key == 'M'){
     bManualControl = false;
  }
  
  if(key == ' '){
    myRay.bRayActive = true;
    myRay.startShootRay();
  }
}

void keyReleased() {
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
  //print(" addrpattern: "+theOscMessage.addrPattern());
  //println(" typetag: "+theOscMessage.typetag());


  if (theOscMessage.checkAddrPattern("/GameBlob") == true) {
    if (theOscMessage.checkTypetag("ffff")) {
      float OSCvalue0 = theOscMessage.get(0).floatValue(); // X position [0..1]
      //println(" values 0: "+OSCvalue0);
      

      float OSCvalue1 = theOscMessage.get(1).floatValue();  // Y position [0..1]
      //println(" values 1: "+OSCvalue1);
      pangBlobY = OSCvalue1;

      float OSCvalueUp = theOscMessage.get(2).floatValue();  // UP Force position [0..1]
      //println(" values Up: "+OSCvalueUp);
      if (OSCvalueUp > 0.15) {
        if (myRay.bRayActive == false) {
          myRay.bRayActive = true;
          myRay.initTimeRay = millis();
          println("SHOOOT detected ! OSCUPForce = "+OSCvalue1);
        }
      }

      /*
      float OSCvalueDown = theOscMessage.get(3).floatValue(); // DOWN Force position [0..1]
       println(" values 1: "+OSCvalue1);
       pangBlobY = OSCvalue1;
       */

      //add to our system if no Manual Control is active
      if(bManualControl == false){
        mouseXJulian = (int)(pangBlobX*widthWindow);
        mouseYJulian = (int)(pangBlobY*heightWindow);
      }
      
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
  } else {
    //HardCoded RESET
    if (keyPressed == true) {
      resetGame();
    }
  }
}

//-----------------------------------
void drawFacadeContourInside()
{

  //left line
  line(40,72,40,196);
  
  //bottom
  line(40,196,231,196);
  
  //right side
  line(231,72,231,196);
  
  // steps
  //flat left
  line(40,72,76,72);
  
  //vert
  line(76,72,76,56);
  
  // hor
  line(76,56,112,56);
  
  //vert
  line(112,56,112,40);
    
  //top
  line(112,40,159,40);
  
   //vert right side
  line(159,40,159,56);
  
  //hors
   line(160,56,195,56);
   
  //  vert
  line(195,56,195,72);
  
  //hor
  line(196,72,231,72);
}
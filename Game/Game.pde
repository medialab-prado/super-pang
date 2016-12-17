//window vars //<>//
Boolean bFullScreenActive = true;
int widthWindowExtra = 192+30;
int heightWindowExtra = 157 + 30;

int widthWindow = 192;
int heightWindow = 157;
float messageScreenX = (widthWindow)/2;
float messageScreenY = 90;

float pointsScreenX;
float pointsScreenY;
float timeScreenX;
float timeScreenY;

//Vars for Starts ( vidas )
ArrayList<Star> stars;
int numStars = 5;

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

//Vars for lives
int lives;
float livesScreenX;
float livesScreenY;
boolean livesText;

//Vars for text
PFont myFont;
float textSize;



///osc
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;
float last_OSCvalue0 = -1;//Vars to detect movement from Blobs
float last_OSCvalue1 = -1;
Boolean bOscActive = true;
float pangBlobX = 0;
float pangBlobY = 0;

///////////////////////
PImage BackGroundImg;
int initialBalls = 1;
float minSizeBall = 2;
float maxSizeBall = 4;
float minRadius =  2;






/////////////////////
int statusGame = 0; // 0 es readyToInit, 1 Playing, 2 GameOver 3 Won

void initMessagesPos() {
  //Messages postions reset
  timeScreenX = (widthWindow)/2;
  timeScreenY = 15;

  livesScreenX = (widthWindow)/2;
  livesScreenY = 30;

  pointsScreenX = timeScreenX-9;
  pointsScreenY = timeScreenY+17;
}

void setup() {

  frameRate(20);

  //if(bFullScreenActive)
  fullScreen(); //
   //size(300, 300); 
   
   textSize = 20;

  myFont = createFont("ARCADECLASSIC.TTF", textSize);

  //Init class vars
  myRay = new Ray();
  stars = new ArrayList<Star>();  // Create an empty ArrayList
  balls = new ArrayList<Ball>();  // Create an empty ArrayList
  miJulian = new Julian();

  //set the right values to start a game
  resetGame(0);

  //setup OSC
  oscP5 = new OscP5(this, 12345);
  myRemoteLocation = new NetAddress("127.0.0.1", 12345);

  //TODO{c} Set a random background in Reset
  BackGroundImg = loadImage ("fondo.jpg");

  //set number of lives
  lives = 5;
  livesText = true;
}

void resetGame(int level) {

  //Game Vars
  statusGame = level;
  points = 0;
  lives = 5;
  
  //reset lives
  stars.clear();
  //setup balls
  for (int i = 0; i < numStars; i++) {
    stars.add(new Star());
  }

  //reset balls
  balls.clear();
  //setup balls
  for (int i = 0; i < initialBalls; i++) {
    balls.add(new Ball());
  }

  initMessagesPos();

  // reset number of lives
}

void draw() {
  background(0); 
  
  
  
  translate(40, 40);

  if (statusGame == 0) {
    drawReadyToPlay();
  } else if (statusGame == 1) {
    drawPlaying();

    if (balls.size() == 0) {
      statusGame = 3;
      //points = 0;
    }
  } else if (statusGame == 2) {
    drawGameOver();
  }

  if (statusGame == 3) {
    drawWin();
  }

  if (lives == 0) {
    statusGame = 2;
  }


  //osc
  fill(255, 0, 0);
  ellipse(pangBlobX*widthWindow, pangBlobY*heightWindow, 10, 10);

  textFont(myFont);
  textAlign(CENTER);
  textSize(10);
  //text (""+currentTime, timeScreenX, timeScreenY);
  //if (statusGame == 2)text ("Points: "+points, pointsScreenX, pointsScreenY);
  if (statusGame == 3)text ("Points: "+points, pointsScreenX, pointsScreenY);
  //if (statusGame == 1)text("You have "+lives+" lives", livesScreenX, livesScreenY);


  translate(-40, -40);
  stroke(255);  
  drawFacadeContourInside();
}

//----------------------------------------
void drawGameOver() {

  textSize(20);
  text("GAME OVER", messageScreenX, messageScreenY);
  updatePoints();
  
}

//----------------------------------------
void drawWin() {

  text("WINNER", messageScreenX, messageScreenY);
  updatePoints();
  
}

//----------------------------------------
void drawReadyToPlay() {

  textSize = map(sin(millis()/200), -1, 1, 17, 20);
  //println("textSize = " +str(textSize)); 
  textSize(20);
  text("Salta", messageScreenX, messageScreenY - textSize);
    text("\npara  empezar", messageScreenX, messageScreenY);

  if (keyPressed == true) {
    if (key == ' ') {
      resetGame(1);
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
  
  //draw all objects
  int heightStars = 15;
  int xInitStars = 25;
  float gapStars = 11.5;//stars.get(0).rad1*2;
  for (int i = 0; i < numStars; i++) {
    Star myStar = stars.get(i);
    if(i<lives){
      //vidas activas
      fill(245, 240, 146);
      myStar.draw(false, (int)(xInitStars+gapStars*i), heightStars, 1);
    }else{
      fill(200);
      myStar.draw(false, (int)(xInitStars+gapStars*i), heightStars, 1);
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
  if (!bOscActive) {
    mouseXJulian = mouseX;
    if (mouseXJulian > widthWindow) {
      mouseXJulian = widthWindow;
    }
    mouseYJulian = mouseY;
    if (mouseYJulian > heightWindow) {
      mouseYJulian = heightWindow;
    }
  }
}

void keyPressed() {

  //Set reset methods

  if (key == ' ') {
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
  //println("### Yep!! Received an osc message and bOscActive " +str(bOscActive));
  //print(" addrpattern: "+theOscMessage.addrPattern());
  //println(" typetag: "+theOscMessage.typetag());


  if (theOscMessage.checkAddrPattern("/GameBlob") == true) {
    if (theOscMessage.checkTypetag("ffff")) {
      float OSCvalue0 = theOscMessage.get(0).floatValue(); // X position [0..1]
      //println(" values 0: "+OSCvalue0);
      pangBlobX = OSCvalue0;

      float OSCvalue1 = theOscMessage.get(1).floatValue();  // Y position [0..1]
      //println(" values 1: "+OSCvalue1);
      pangBlobY = OSCvalue1;//

      //println("### /GameBlob received and bOscActive"+str(bOscActive));

      //add to our system if no Manual Control is active
      if (bOscActive == true) {
        mouseXJulian = (int)(pangBlobX*widthWindow);
        mouseYJulian = (int)(pangBlobY*heightWindow);
      }
    }
  } else if (theOscMessage.checkAddrPattern("/GameBlob2") == true) {

    if (theOscMessage.checkTypetag("ffff")) {
      float OSCvalue0 = theOscMessage.get(0).floatValue(); // X position [0..1]
      float OSCvalue1 = theOscMessage.get(1).floatValue();  // Y position [0..1]
      //////////////////////////////////////////
      //Just init this
      Boolean bInitedOscVars = false;
      if (last_OSCvalue0 == -1) {
        last_OSCvalue0 = OSCvalue0;
      } else bInitedOscVars = true;
      if (last_OSCvalue1 == -1) {//Just init this
        last_OSCvalue1 = OSCvalue1;
      } else bInitedOscVars = true;

      ///////////////////////////////////////
      //float diffBlob0 = abs(last_OSCvalue0 - OSCvalue0);
      float diffBlobY = abs(last_OSCvalue0 - OSCvalue0);

      //println("### /GameBlob2 received and bOscActive"+str(bOscActive));
      //println("received data detected ! diffBlobY = "+diffBlobY);
      //println("bInitedOscVars = "+bInitedOscVars);
      //println("myRay.bRayActive = "+myRay.bRayActive);


      if (bInitedOscVars) {
        //save last values
        last_OSCvalue1 = OSCvalue1;
        last_OSCvalue0 = OSCvalue0;

        //Detect If Ray action
        if (diffBlobY > 0.05) {
          if (statusGame == 0 || statusGame == 2) { //If at init Screen or Game Over
            ready2Restart(3000);
          } else if (myRay.bRayActive == false) {
            myRay.bRayActive = true;
            myRay.startShootRay();
            //println("SHOOOT diffBlob1 = "+diffBlobY);
          }
        }
      }
    }
  }
}
//----------------------------
//void updateTimerReady2Start(){}
//----------------------------
void ready2Restart(int timer){
  
  resetGame(1);
  
 /*
  if(bReadyInit == true){

  }else {
    
  }
  
  if(millis() -  > timer)
  bReadyInit = true;
  */
}

//-----------------------------------
void updateTime() {
  initTime = 180;
  currentTime = initTime - (millis()/1000);
}

//-----------------------------------
void updatePoints() {
  //reseted points at one status before

  //Count points
  if (currentTime  > 0) {
    points = points + 3;
    currentTime--;


    if (statusGame == 2) {
      points = 0;
      currentTime = 0;
    }
  }

  //HardCoded RESET
  if (keyPressed == true) {
    resetGame(1);
  }
}


//-----------------------------------
void drawFacadeContourInside()
{

  //left line
  line(40, 72, 40, 196);

  //bottom
  line(40, 196, 231, 196);

  //right side
  line(231, 72, 231, 196);

  // steps
  //flat left
  line(40, 72, 76, 72);

  //vert
  line(76, 72, 76, 56);

  // hor
  line(76, 56, 112, 56);

  //vert
  line(112, 56, 112, 40);

  //top
  line(112, 40, 159, 40);

  //vert right side
  line(159, 40, 159, 56);

  //hors
  line(160, 56, 195, 56);

  //  vert
  line(195, 56, 195, 72);

  //hor
  line(196, 72, 231, 72);
}
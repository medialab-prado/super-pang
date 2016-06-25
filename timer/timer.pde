int initTime;
int currentTime;
int points;
boolean bPause;
void setup() {
  size(192, 157); 
  //frameRate(33);
}

void draw() {
  background(0);
  if (bPause == false){
    updateTime();
  }
  else{
    updatePoints();
  }

  if (key=='a') {
    bPause =true;
  }
  
  textAlign(CENTER);
  textSize(10);
  text ("time:"+currentTime, 140, 20);
  text ("points:"+points, 140, 30);
}

void updateTime() {
  initTime = 180;
  currentTime = initTime - (millis()/1000);  
}

void updatePoints() {
  points = points + 3;
  currentTime--;
  if (currentTime ==0){
   noLoop(); 
  }
}
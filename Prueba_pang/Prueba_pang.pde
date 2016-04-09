ArrayList<Ball> balls = new ArrayList();
float minSizeBall = 5;
float minRadius = 3;
float accDificulty = 0.1;
PVector gravityForce = new PVector(0, accDificulty);

void setup(){
  size(600, 600);
  balls.add(new Ball());
}

void draw() {
  
  if(mousePressed){
    print("hola"); //<>//
  }
  background(255);
  for(Ball b: balls){
    b.update(); //<>//
    b.edges();
    b.display();
  }
}

void keyReleased(){
  float mydim = balls.get(0).mass;
  PVector myLoc = balls.get(0).location;
  PVector myAcc = new PVector(0, accDificulty);//balls.get(0).acceleration;
  PVector myVel = new PVector(3, 1);//balls.get(0).velocity;

  //location = new PVector(random(width), random(10, 100));
  //velocity = new PVector(3, 1); // Direccion Inicial de las bolas
  //acceleration = new PVector(0, accDificulty); // Vector Direccion de la aceleración
  PVector newDirVel = new PVector(myVel.x, myVel.y);
  Ball b2 = new Ball(mydim, myLoc, newDirVel, myAcc);

  //for(int i = 0; i<balls.size(); i++){
  newDirVel = new PVector(myVel.x*-1, myVel.y);
  Ball b1 = new Ball(mydim, myLoc, newDirVel, myAcc);
  balls.add(b1); //<>//
  balls.add(b2);
  balls.remove(0);
  //}
}
int ancho = 192;
int alto = 157;
float escalar = 1;
ArrayList<Ball> balls;
float accDificulty = 0.2; // en 0.3 disminuye, con el resto sigue igual, no disminuye
PVector deltaXVel =  new PVector(1, 0);
PVector deltaYVel =  new PVector(0, 1);
PVector gravityForce = new PVector(0, accDificulty);
int initialBalls = 5;


void setup() {
  size(ancho, alto);

  balls = new ArrayList<Ball>();  // Create an empty ArrayList
  for (int initialBalls = 0; initialBalls < 6; initialBalls++) {
    balls.add(new Ball());
  }
}

void draw() {
  background(245);
  fill(127);


  //for (int i = balls.size()-1; i >= 0; i--) {
   for (int i = 0; i <  balls.size(); i++) {
    Ball ball1 = balls.get(i);
    if (ball1.destroyed == true) {
      // Items can be deleted with remove().
      balls.remove(i);
    }
  }

  for (Ball b : balls) {
    b.update();
    b.edges();
    b.display();
    b.collisions();
  }
}

void keyPressed() {
}


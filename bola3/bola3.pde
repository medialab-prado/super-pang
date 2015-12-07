int ancho = 192;
int alto = 157;


//Vars for Balls
ArrayList<Ball> balls;
float accDificulty = 0.2; // en 0.3 disminuye, con el resto sigue igual, no disminuye
PVector deltaXVel =  new PVector(1, 0);
PVector deltaYVel =  new PVector(0, 1);
PVector gravityForce = new PVector(0, accDificulty);
int initialBalls = 5;
float minSizeBall = 3;
float minRadius = 4;


//Vars for Interaction
color colorMouseInteraction = color(255, 204, 0);
int shootTimer = 0;
int waitShootTimer = 5000;
Boolean ready2Shoot;
Boolean bmousePressed = false;

void setup() {
  size(192, 157);

  balls = new ArrayList<Ball>();  // Create an empty ArrayList
  for (int initialBalls = 0; initialBalls < 6; initialBalls++) {
    balls.add(new Ball());
  }
}

void draw() {
  background(245);
  fill(127);

  if (bmousePressed) {
    //for (int i = balls.size()-1; i >= 0; i--) {
    for (int i = 0; i <  balls.size(); i++) {
      Ball ball1 = balls.get(i);
      if (ball1.destroyed == true) {
        Boolean bSmaller = checkSmaller(ball1.mass*0.5);
        if (!bSmaller) {

          Ball Ball2Left = new Ball(ball1.mass, ball1.location, -1);//Constructor con parametros
          Ball Ball2Right = new Ball(ball1.mass, ball1.location, +1);//Creando Bolas con Parametros específicos de la bola anterior que ibamos a eliminar

          balls.add(Ball2Right);  // adding element with specific mass and dimensions
          balls.add(Ball2Left);  // adding element with specific mass and dimensions
        }

        // Items can be deleted with remove().
        balls.remove(i);
      }
    }
  }

  for (Ball b : balls) {
    b.update();
    b.edges();
    b.display();
    if(bmousePressed)b.collisions();
  }

  //Paint Mouse Interaction
  stroke(colorMouseInteraction);
  line(mouseX, height, mouseX, mouseY);
  line(0, mouseY, width, mouseY);
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
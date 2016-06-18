import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Kinect kinect;

int distMax;
int[] valores;
PImage foto;

void setup() {
  size(640, 520);
  kinect = new Kinect(this);
  kinect.initDepth();

  distMax = 800;
  foto = createImage(kinect.width, kinect.height, RGB);
  valores = new int[kinect.width * kinect.height];
}

void draw() {
  background(0);
  foto.loadPixels();
  for (int x = 0; x < kinect.width; x++) {
    for (int y = 0; y < kinect.height; y++) {
      int indice = x + y * kinect.width;
      int valor = kinect.getRawDepth()[indice];
      if (valor < distMax) {
        valores[indice] = valor;
        foto.pixels[indice] = color(int(map(valor, 0, 2048, 255, 0)));
      } else {
        foto.pixels[indice] = color(0);
      }
    }
  }
  foto.updatePixels();
  image(foto, 0, 0);
}
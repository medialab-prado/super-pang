class Star {
  float factorRot = 1;
  float radius1 = 3;
  float radius2 = 7;
  int nCorners = 5;


  void drawStar(float x, float y, float radius1, float radius2, int npoints) {
    float angle = TWO_PI / npoints;
    float halfAngle = angle/2.0;
    beginShape();
    for (float a = 0; a < TWO_PI; a += angle) {
      float sx = x + cos(a) * radius2;
      float sy = y + sin(a) * radius2;
      vertex(sx, sy);
      sx = x + cos(a+halfAngle) * radius1;
      sy = y + sin(a+halfAngle) * radius1;
      vertex(sx, sy);
    }
    endShape(CLOSE);
  }


  void draw(boolean _bRot, int _x, int _y, float _scale) {

    if (_bRot) {
      pushMatrix();
      translate(_x, _y);
      rotate(frameCount / -100.0);
      drawStar(_x, _y, radius1, radius2, nCorners);
      popMatrix();
    } else {
      pushMatrix();
      translate(_x, _y);
      drawStar(_x, _y, radius1, radius2, nCorners);
      popMatrix();
    }
  }
}
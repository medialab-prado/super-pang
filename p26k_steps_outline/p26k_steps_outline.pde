// 26k Pixels Template
// Chris Sugrue. Feb 27, 2011
// Dibuja el contorno de la fachada (todas las lineas aparece en la fachada)

void setup()
{
  size(1024,768);
}

void draw()
{
  
  background(0,0,0);
  
  stroke(255);  
  drawFacadeContourInside();
}


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

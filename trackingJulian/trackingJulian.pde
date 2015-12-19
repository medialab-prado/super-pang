/*
* THis code only works in ProgramaLaPLaza
* http://programalaplaza.medialab-prado.es/sketch/edit/5675a21ed33b4b03d9b63d1f
*/ 
int num_people;
int max_width = 0;
int id_max_width = 0;
int blob0x;

Julian miJulian;

void setup() {
  size(192, 157); 
  background(0); 
  frameRate(25);
  tracking.connect(); 
  
  miJulian = new Julian();
}

void draw () {
  background(0);
  tracking.getBlobs(processBlobs);
  miJulian.update();
  miJulian.display();
}

//Do somthing with that blobs
function processBlobs(blobs){
  num_people = blobs.length;
 
 max_width = 0;
    for (int i = 0; i < num_people; i++ ) {
      //rect(blobs[i].x, blobs[i].y, blobs[i].w, blobs[i].h);
      //org[i].Update();
      //org[i].Display();
      
      fill(200);
      rect(blobs[i].x, blobs[i].y, 10, 10);
      
      fill(255);
      textSize(20);
      text("blob[" +str(i)+ "]", 10, 80+20*i); 
      
      fill(0, 255, 255);
      rect(blobs[0].x, blobs[0].y,10,10);
      
      //copiamos el blob que queremos
      blob0x =blobs[0].x;
    }
}
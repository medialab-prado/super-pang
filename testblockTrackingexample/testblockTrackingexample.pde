/*
* Start coding and have fun! 
* if you want you can use this header
* to explain your project!
* 
*/ 
int num_people;

void setup() {
  size(192, 157); 
  background(0); 
  frameRate(25);
  tracking.connect(); 
}

void draw () {
  background(0);
  tracking.getBlobs(processBlobs);
}

//Do somthing with that blobs
function processBlobs(blobs){
  num_people = blobs.length;
 
    for (int i = 0; i < num_people; i++ ) {
      //rect(blobs[i].x, blobs[i].y, blobs[i].w, blobs[i].h);
      //org[i].Update();
      //org[i].Display();
      
      fill(200);
      rect(blobs[i].x, blobs[i].y,10,10);
      
      fill(20);
      textSize(20);
      text("blob[" +str(i)+ "]", 10, 80+20*i); 
      
    }
}




import netP5.*;
import oscP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

void setup() {
  size(400, 400);
  oscP5 = new OscP5(this, 12345);
   myRemoteLocation = new NetAddress("127.0.0.1",12345);
}
void draw() {
  
  background(0);
  
  text("mouseX"+str((float)mouseX/(float)width), 100, 100);
  text("mouseY"+str((float)mouseY/(float)height), 100, 200);
  
  OscMessage myMessage = new OscMessage("/GameBlob");
  myMessage.add((float)mouseX/(float)width); /* add an int to the osc message */
  myMessage.add((float)mouseX/(float)width);
  myMessage.add((float)mouseX/(float)width);
  myMessage.add((float)mouseX/(float)width);
  /* send the message */
  oscP5.send(myMessage, myRemoteLocation); 

  OscMessage myMessage2 = new OscMessage("/GameBlob2");
  myMessage2.add((float)mouseY/(float)height);
  myMessage2.add((float)mouseY/(float)height);
  myMessage2.add((float)mouseY/(float)height);
  myMessage2.add((float)mouseY/(float)height);

  /* send the message */
  oscP5.send(myMessage2, myRemoteLocation);
}
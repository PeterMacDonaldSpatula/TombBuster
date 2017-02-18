class Flare extends LightSource {
  int timeStarted;
  final int DURATION = 3000;
  int alpha;
  
  
  Flare(float x, float y) {
    super(x, y);
    lightArc = 2*PI;
    numWedges = 500;
    range = 300;
    direction.x = 1;
    direction.y = 0;
    timeStarted = millis();
    alpha = 255;
  }
  
  void drawMe() {
    stroke(#FFF527);
    fill(#FFF527, alpha);
    //line(x, y, mouseX, mouseY);
    noStroke();
    for (int i=0; i<numWedges; i+=1) {
      drawWedge(checkDistance(x, y, rotateVector(direction, lightArc/numWedges*i)), lightArc/numWedges*i);
    }
  }
  
  void update(){
    alpha = 255-(255*(millis()-timeStarted)/DURATION);
    if (millis()-timeStarted > DURATION) {
      destroyed = true;
    }
  }
}
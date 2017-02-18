class Flashlight extends LightSource {
  
  PVector getDirection() {
    float distance = PVector.dist(new PVector(x, y), new PVector(beamtarget.x, beamtarget.y));
    return new PVector(abs((beamtarget.x-x)/distance), abs((beamtarget.y-y)/distance));
  }
  
  Flashlight(float x, float y) {
    super(x, y);
    direction = getDirection();
    numWedges = 50;
    lightArc = QUARTER_PI/2;
    range = sqrt(pow(width, 2)+pow(height, 2));
  }
  
  
  
  float getTargetAngle() {
    direction = getDirection();
    float angle;
    if ((beamtarget.x-x) * (beamtarget.y-y) < 0) {
      angle = atan(direction.x/direction.y);
    } else {
      angle = atan(direction.y/direction.x);
    }
    if (beamtarget.x-x <0 && beamtarget.y-y > 0) {
      angle += HALF_PI;
    } else if (beamtarget.x-x < 0 && beamtarget.y-y < 0) {
      angle += PI;
    } else if (beamtarget.x-x > 0 && beamtarget.y-y < 0) {
      angle += 3*PI/2;
    } else if (beamtarget.x-x ==0 && beamtarget.y-y > 0) {
      angle = HALF_PI;
    } else if (beamtarget.x-x ==0 && beamtarget.y-y < 0) {
      angle = 3*PI/2;
    } else if (beamtarget.x-x > 0 && beamtarget.y-y == 0) {
      angle = 0;
    } else if (beamtarget.x-x < 0 && beamtarget.y-y == 0) {
      angle = PI;
    }
    return angle;
  }
  
  PVector getCenterVector() {
    float distance = PVector.dist(new PVector(x, y), new PVector(beamtarget.x, beamtarget.y));
    return new PVector((beamtarget.x-x)/distance, (beamtarget.y-y)/distance);
  }
  
  
  
  void update(){}
  
  void drawMe() {
    stroke(#FFF527);
    fill(#FFF527);
    //line(x, y, mouseX, mouseY);
    noStroke();
    for (float i=0-numWedges/2; i<=numWedges/2; i+=1) {
      drawWedge(checkDistance(x, y, rotateVector(getCenterVector(), lightArc/numWedges*i)), getTargetAngle()+(lightArc/numWedges*i));
    }
  }
}
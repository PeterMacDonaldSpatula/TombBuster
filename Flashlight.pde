class Flashlight extends GameObject {
  
  PVector direction;
  int numWedges;
  float flashlightArc;
  
  PVector getDirection() {
    float distance = PVector.dist(new PVector(x, y), new PVector(mouseX, mouseY));
    return new PVector(abs((mouseX-x)/distance), abs((mouseY-y)/distance));
  }
  
  Flashlight(int x, int y) {
    super(x, y);
    direction = getDirection();
    numWedges = 20;
    flashlightArc = QUARTER_PI/2;
  }
  
  void drawWedge(float wedgeLength, float angle, float wedgeWidth) {
    arc(x, y, wedgeLength*2, wedgeLength*2, angle-(flashlightArc/numWedges), angle+(flashlightArc/numWedges));
  }
  
  float getMouseAngle() {
    direction = getDirection();
    float angle;
    if ((mouseX-x) * (mouseY-y) < 0) {
      angle = atan(direction.x/direction.y);
    } else {
      angle = atan(direction.y/direction.x);
    }
    if (mouseX-x <0 && mouseY-y > 0) {
      angle += HALF_PI;
    } else if (mouseX-x < 0 && mouseY-y < 0) {
      angle += PI;
    } else if (mouseX-x > 0 && mouseY-y < 0) {
      angle += 3*PI/2;
    } else if (mouseX-x ==0 && mouseY-y > 0) {
      angle = HALF_PI;
    } else if (mouseX-x ==0 && mouseY-y < 0) {
      angle = 3*PI/2;
    } else if (mouseX-x > 0 && mouseY-y == 0) {
      angle = 0;
    } else if (mouseX-x < 0 && mouseY-y == 0) {
      angle = PI;
    }
    return angle;
  }
  
  float checkDistance(float thisX, float thisY, float angle) {
    if (thisX < 0 || thisY < 0 || thisX > width || thisY > height) {
      return sqrt(pow(thisX-x, 2)+pow(thisY-y, 2));
    }
    for (int i = 0; i< objects.length; i+=1) {
      if (thisX > objects[i].x && thisX < objects[i].x+objects[i].collisionWidth && thisY > objects[i].y && thisY < objects[i].y+objects[i].collisionHeight) {
        objects[i].visible = true;
        if (objects[i].opaque == true) {
          return sqrt(pow(x-thisX, 2)+pow(y-thisY, 2));
        }
      }
    }
    
    float slope;
    float temp=angle;
    
    if ((thisX-x) * (thisY-y) < 0) {
      slope = 1/tan(temp);
    } else {
      slope = tan(temp);
    }
    rect(thisX, thisY, 1, 1);
    return checkDistance(thisX+1, thisY+slope, angle);
  }
  
  void drawMe() {
    stroke(#FFF527);
    fill(#FFF527);
    line(x, y, mouseX, mouseY);
    noStroke();
    for (float i=-numWedges/2; i<=numWedges/2; i+=1) {
      drawWedge(checkDistance(x, y, getMouseAngle()+(flashlightArc/numWedges*i)), getMouseAngle()+(flashlightArc/numWedges*i), 100);
    }
  }
}
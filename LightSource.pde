abstract class LightSource extends GameObject {
  PVector direction;
  int numWedges;
  float lightArc;
  float screensize;
  float range;
  
  PVector rotateVector(PVector vector, float angle) {
    PVector output = new PVector();
    output.x = vector.x*cos(angle)-vector.y*sin(angle);
    output.y = vector.x*sin(angle)+vector.y*cos(angle);
  
    return output;
  }
    
  float checkDistance(float thisX, float thisY, PVector vector) {
    if (thisX < -10 || thisY < -10 || thisX > width+10 || thisY > height+10) {
      return min(screensize, sqrt(pow(thisX-x, 2)+pow(thisY-y, 2)));
    }
    if (sqrt(pow(x-thisX, 2)+pow(y-thisY, 2)) > range) {
      return range;
    }
    for (int i = 0; i< objects.length; i+=1) {
      if (thisX > objects[i].x && thisX < objects[i].x+objects[i].collisionWidth && thisY > objects[i].y && thisY < objects[i].y+objects[i].collisionHeight) {
        objects[i].visible = true;
        if (objects[i].opaque == true) {
          return sqrt(pow(x-thisX, 2)+pow(y-thisY, 2));
        }
      }
    }
    //rect(thisX, thisY, 1, 1);
    return checkDistance(thisX+vector.x, thisY+vector.y, vector);
  }
  
  void drawWedge(float wedgeLength, float angle) {
    arc(x, y, wedgeLength*2, wedgeLength*2, angle-(lightArc/numWedges), angle+(lightArc/numWedges));
  }
  
  LightSource(float x, float y) {
    super(x, y);
    numWedges = 0;
    lightArc = 0;
    direction = new PVector(0, 0);
    range = 0;
    screensize = sqrt(pow(width, 2)+pow(height, 2));
  }
}
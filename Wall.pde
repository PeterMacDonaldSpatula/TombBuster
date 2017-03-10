/*
This class describes a wall. Not much more to say. 
*/

class Wall extends GameObject {
  
  int fillColor;//The color of the wall
  Wall(float x, float y, float collisionX, float collisionY) {
    super();
    this.x = x;
    this.y = y;
    this.collisionX = collisionX;
    this.collisionY = collisionY;
    opaque = true;
    collides = true;
    fillColor = #A05712;
  }
  
  void collide(GameObject other) {}
  
  void update() {}
  
  void render() {
    pushMatrix();
    translate(x, y);
    fill(fillColor);
    noStroke();
    rect(0, 0, collisionX, collisionY);
    popMatrix();
  }
}
abstract class GameObject {
  float x;
  float y;
  float collisionWidth;
  float collisionHeight;
  boolean visible;
  boolean opaque;
  boolean destroyed;
  
  abstract void drawMe();
  abstract void update();
  
  GameObject(float x, float y) {
    this.x = x;
    this.y = y;
    collisionWidth = 0;
    collisionHeight = 0;
    visible = false;
    opaque = false;
    destroyed = false;
  }
}
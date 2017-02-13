abstract class GameObject {
  int x;
  int y;
  int collisionWidth;
  int collisionHeight;
  boolean visible;
  boolean opaque;
  
  abstract void drawMe();
  
  GameObject(int x, int y) {
    this.x = x;
    this.y = y;
    collisionWidth = 0;
    collisionHeight = 0;
    visible = false;
    opaque = false;
  }
}
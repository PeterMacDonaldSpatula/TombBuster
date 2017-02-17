class Enemy extends GameObject {
  Enemy(int x, int y, int myWidth, int myHeight) {
    super(x, y);
    this.collisionWidth = myWidth;
    this.collisionHeight = myHeight;
  }
  
  void drawMe() {
    if (visible) {
      fill(#FF050E);
      rect(x, y, collisionWidth, collisionHeight); 
      visible = false;  
    }
    
  }
}
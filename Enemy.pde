class Enemy extends GameObject {
  Enemy(float x, float y, float myWidth, float myHeight) {
    super(x, y);
    this.collisionWidth = myWidth;
    this.collisionHeight = myHeight;
  }
  
  void update(){}
  
  void drawMe() {
    if (visible) {
      fill(#FF050E);
      rect(x, y, collisionWidth, collisionHeight); 
      visible = false;  
    }
    
  }
}
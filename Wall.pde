class Wall extends GameObject {
  int myColor;
  
  Wall(int x, int y, int w, int h, int c) {
    super(x, y);
    this.collisionHeight = h;
    this.collisionWidth = w;
    this.myColor = c;
    this.visible = true;
    this.opaque = true;
  }

    
  void drawMe() {
    fill(this.myColor);
    rect(this.x, this.y, this.collisionWidth, this.collisionHeight); 
  }
}
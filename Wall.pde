class Wall extends GameObject {
  int myColor;
  
  Wall(float x, float y, float w, float h, int c) {
    super(x, y);
    this.collisionHeight = h;
    this.collisionWidth = w;
    this.myColor = c;
    this.visible = true;
    this.opaque = true;
  }

  void update(){}
      
  void drawMe() {
    fill(this.myColor);
    rect(this.x, this.y, this.collisionWidth, this.collisionHeight); 
  }
}
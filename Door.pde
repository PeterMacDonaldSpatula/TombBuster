class Door extends GameObject {
  boolean open;
  
  Door(float x, float y, float collisionX, float collisionY) {
    super();
    this.x = x;
    this.y = y;
    this.collisionX = collisionX;
    this.collisionY = collisionY;
    open = false;
  }
  
  void collide(GameObject other) {
    
  }
  
  void update() {
    for (int i = 0; i < triggers.size(); i+=1) {
      if (triggers.get(i).name.equals("open")) {
        open = true;
      }
    }
  }
  
  void render() {
    if (open) {
      fill(#D81889);
      rect(x, y, collisionX, collisionY);
    }
    
  }
}
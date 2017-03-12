class Wall extends GameObject {
  
  int fillColor;
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
  
  void collide(GameObject other) {
    if (walls.contains(other)) {
      fillColor = #A01235;
    }
  }
  
  void update() {
    if (millis() > 10000) {
      removed = true;
    }
  }
  
  void render() {
    pushMatrix();
    translate(x, y);
    fill(fillColor);
    rect(0, 0, collisionX, collisionY);
    popMatrix();
  }
}
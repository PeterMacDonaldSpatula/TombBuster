class ButtonActivated extends TriggerSpace {
  boolean ready;
  int timeLastStepped;
  
  ButtonActivated(float x, float y, float collisionX, float collisionY, String name, ArrayList<GameObject> targets) {
    super(x, y, collisionX, collisionY, targets, "button"+name);
    collides = true;
    ready = false;
    timeLastStepped = 0;
  }
  
  ButtonActivated(float x, float y, float collisionX, float collisionY, String name, GameObject target) {
    super(x, y, collisionX, collisionY, target, "button" + name);
    collides = true;
    ready = false;
  }
  
  void collide (GameObject other) {
    if (players.contains(other)) {
      ready = true;
      timeLastStepped = millis();
    }
  }
  
  void update() {
    if (millis()-timeLastStepped > 50) {
      ready = false;
    }
  }
  
  void render() {
    fill(#1A18D8);
    rect(x, y, collisionX, collisionY);
  }
}
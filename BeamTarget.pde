/*
This class creates a target for a flashlight to orient itself towards. BeamTargets automatically chase the cursor at a maximum speed of BEAMSPEED.
*/
class BeamTarget extends LightTarget {
  float vx;
  float vy;
  final static float BEAMSPEED = 30;//The target's maximum speed
  
  BeamTarget() {//BeamTargets automatically spawn at the mouse location
    super(mouseX, mouseY);
    collisionX = 0;
    collisionY = 0;
    vx = 0;
    vy = 0;
    collides = false;
  }
  
  /*
  This function takes in a target's coordinates, and returns a velocity PVector for the BeamTarget to move towards it at BEAMSPEED.
  Returns a [0, 0] vector if it's closer than BEAMSPEED to the target
  This is used for figuring out how fast and where the BeamTarget should move to chase the mouse
  */
  PVector trajectoryToTarget(float targetX, float targetY) {
  float dx, dy, distance, ratio;
    
    dx = targetX-x;
    dy = targetY-y;
    distance = sqrt(pow(dx, 2) + pow(dy, 2));
    ratio = BEAMSPEED/distance;
    if (distance < BEAMSPEED) {
      ratio = 0;
    }
    
    PVector temp = new PVector();
    temp.x = ratio*dx;
    temp.y = ratio*dy;
    return temp;
  }
  
  void collide(GameObject other) {}
  
  void update() {//Generates its velocity vector, and then moves along it.
    PVector temp = trajectoryToTarget(mouseX + camera.pos.x, mouseY + camera.pos.y);
    vx = temp.x;
    vy = temp.y;
    x += vx;
    y += vy;
  }
  
  void render() {}
}
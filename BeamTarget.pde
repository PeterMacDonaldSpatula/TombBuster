class BeamTarget extends GameObject {
  float vx;
  float vy;
  final static float BEAMSPEED = 15;
  
  BeamTarget(float xIn, float yIn){
    super(xIn, yIn);
    vx = 0;
    vy = 0;
  }
  
  PVector setBeamTrajectory(float targetX, float targetY) {
  float dx, dy, distance, ratio;
    
    dx = targetX-x;
    dy = targetY-y;
    distance = sqrt(pow(dx, 2) + pow(dy, 2));
    ratio = BEAMSPEED/distance;
    if (distance < BEAMSPEED) {
      ratio = 0;
      x = mouseX;
      y = mouseY;
    }
    
    PVector temp = new PVector();
    temp.x = ratio*dx;
    temp.y = ratio*dy;
    return temp;
}
  
  void drawMe(){}
  void update(){
     PVector temp = setBeamTrajectory(mouseX, mouseY);
    
    if (abs(temp.x-mouseX) >BEAMSPEED && abs(temp.y-mouseY) > BEAMSPEED) {
      vx = temp.x;
      vy = temp.y;
      x += vx;
      y += vy;
    }
  }
}
/*
This class is a flashlight. Flashlights are LightSources which produce a narrow beam, directed at a target point which follows the mouse.
*/

class Flashlight extends LightSource {
  Flashlight(float x, float y) {//Spawns at the provided x and y location.
    super(new BeamTarget());
    addBeamTarget((BeamTarget)target);
    this.x = x;
    this.y = y;
    lightArc = QUARTER_PI/2;
    numWedges = 100;
    range = screensize;//Light will travel as far as the diagonal screen size
  }
  
  void collide(GameObject other){}
  
  void update() {}
}
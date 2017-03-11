/*
THis class is for tracers used in generating light rays. Essentially just a point of collision.
*/

class Tracer extends GameObject {
  Tracer(float x, float y) {
    super();
    this.x = x;
    this.y = y;
    removed = true;//Tracers automatically delete themselves each frame, to be generated again next frame
  }
  
  void collide(GameObject other) {}
  
  void update(){}
  
  void render(){}
}
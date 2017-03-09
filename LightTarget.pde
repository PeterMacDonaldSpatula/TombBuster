/*
 This abstract class defines a LightTarget, the target towards which light sources point. The base class contains very little information on its own; each type of behavior should be a separate subclass.  
*/

abstract class LightTarget extends GameObject {
  LightTarget(float x, float y) {
    super();
    this.x = x;
    this.y = y;
  }

}
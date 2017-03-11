/*
This class describes a type of TriggerSpace that activates when light has been shone on it for LIGHT_ACTIVATION_TIME seconds.
*/
class LightActivated extends TriggerSpace {
  int becameVisible;
  
  LightActivated(float x, float y, float collisionX, float collisionY, ArrayList<GameObject> targets) {
    super(x, y, collisionX, collisionY, targets, "light");
  }
  
  LightActivated(float x, float y, float collisionX, float collisionY, GameObject target) {
    super(x, y, collisionX, collisionY, target, "light");
  }
   
  void collide(GameObject other) {}
  
  void update() {
    if (!visible) { //If it's been in a light beam for more than LIGHT_ACTIVATION_TIME seconds, 
      becameVisible = 0;
      deactivate();
    } else {
      if (becameVisible == 0) {
        becameVisible = millis();
      } else if (millis()-becameVisible > LIGHT_ACTIVATION_TIME * 1000){
        activate();
      }
    }
    visible = false;
  }
}
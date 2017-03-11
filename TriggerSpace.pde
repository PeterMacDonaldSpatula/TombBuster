/*
This abstract class is a generic version of invisible tiles which trigger logic when collided with or otherwise interacted with.
Different types of tiles will be their own subclass (one might be activated by sustained light being shone on it, another might respond to touch, another to mouse click, etc)
*/
abstract class TriggerSpace extends GameObject {
  ArrayList<GameObject> targets; //Which objects get sent a trigger when the TriggerSpace activates
  String name;//The name of the trigger to be sent
  
  TriggerSpace(float x, float y, float collisionX, float collisionY, ArrayList<GameObject> targets, String name) {
    super();
    this.x = x;
    this.y = y;
    this.collisionX = collisionX;
    this.collisionY = collisionY;
    this.targets = targets;
    this.name = name;
  }
  
  TriggerSpace(float x, float y, float collisionX, float collisionY, GameObject target, String name) {
    super();
    this.x = x;
    this.y = y;
    this.collisionX = collisionX;
    this.collisionY = collisionY;
    targets = new ArrayList<GameObject>();
    targets.add(target);
    this.name = name;
  }
  
  /*
  This function is used when the TriggerSpace is activated. It sends a trigger with the appropriate name to each of the target objects.
  */
  void activate() {
    for (int i=0; i < targets.size(); i+=1) {
     targets.get(i).triggers.add(new Trigger(name));
    }
  }
  
  /*
  This function is used when the TriggerSpace is deactivated. It removes all triggers with the appropriate name from the target objects.
  */
  void deactivate() {
    for (int i=0; i < targets.size(); i+=1) {
      for (int j=targets.get(i).triggers.size()-1; j >= 0; j-=1) {
        if(targets.get(i).triggers.get(j).name.equals(name)) {
          targets.get(i).triggers.remove(j);
        }
      }
    }
  }
  
  void render() {}
}
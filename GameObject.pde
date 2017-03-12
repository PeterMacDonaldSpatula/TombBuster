/*
This abstract class is the template form which all game objects are created. If it displays on screen, collides, or runs game logic, it's a child class of GameObject
*/
abstract class GameObject {
  float x;//The object's x coordinate. If it doesn't matter where it is on screen, just set this to 0
  float y;//The object's y coordinate. If it doesn't matter where it is on screen, just set this to 0
  float collisionX;//The width of the object's collision box. If you don't care about its collision, set this to 0
  float collisionY;//The height of the object's collision box. If you don't care about tis collision, set this to 0
  boolean collides;//TRUE if the object has collision, FALSE if not
  boolean opaque;//TRUE if the object stops light, FALSE if it doesn't
  boolean visible;//TRUE if the object is in the flashlight beam right now, FALSE otherwise
  boolean beenSeen;//TRUE if the object has previously been seen, FALSE otherwise
  boolean fogVisible;//TRUE if the object is still visible when the flashlight beam moves away (e.g. walls)
  boolean removed;//Set this TRUE if you want the object to be removed at the next end of game loop
  boolean ui;//Set this TRUE if the object is part of the UI (e.g. should not be moved with the camera
  ArrayList<Trigger> triggers;//A list of all triggers that have been sent to this object3
  byte direction;
  float speed;
  
  GameObject() {
    x = 0;
    y = 0;
    collisionX = 0;
    collisionY = 0;
    collides = false;
    visible = false;
    opaque = false;
    beenSeen = false;
    fogVisible = false;
    removed = false;
    ui = false;
    direction = 0;
    speed = 0;
    triggers = new ArrayList<Trigger>();
  }
  
  //This function takes in another GameObject, and performs collision logic depending on what type the other object is.
  //That is, if this object is a wall, and the other object is an enemy, the wall will do whatever it does when an enemy hits it (i.e. nothing)
  //use the object lists to figure out which type of object it is
  abstract void collide(GameObject other);
  
  //This function runs the object's per-loop logic
  abstract void update();
  
  //This function draws the object to the screen
  abstract void render();
  
  //This function sends a trigger to another object.
  void sendTrigger(GameObject other, String name) {
    other.triggers.add(new Trigger(name));
  }
}
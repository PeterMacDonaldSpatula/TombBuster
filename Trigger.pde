/*
This class is used for GameObjects to send signals to one another. When one GameObject meets its conditions, it adds a Trigger object to another GameObject, which the other objects responds to in its update() function.
For example, if you want a door to open when you step on a tile, set an object on that tile that sends a Trigger to the door. In the update function of the door, write an if statement that opens the door if the trigger is present.
*/
class Trigger {
  String name;//The name of the trigger. Used to distinguish different Triggers from one another in the recipient object's logic
  int time;//The time the trigger is sent. Automatically set in the constructor
  
  Trigger(String name) {
    this.name = name;
    time = millis();
  }
}
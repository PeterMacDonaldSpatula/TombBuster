/*
Objects of this class represent one edge of the collision map. Each contains a pair of GameObjects, and a function which compares them. If they are in collision, it runs their collision code with the other.
*/
class Collider {
  GameObject object1;
  GameObject object2;
  
  Collider(GameObject object1, GameObject object2) {
    this.object1 = object1;
    this.object2 = object2;
  }
  
  //This function checks that the two objects's collision boxes overlap, and if it does, it runs each object's collision code relative to the other.
  void collide() {
    if (((object1.x >= object2.x && object1.x <= object2.x+object2.collisionX)||(object1.x + object1.collisionX >= object2.x && object1.x + object1.collisionX <= object2.x+object2.collisionX)) && ((object1.y >= object2.y && object1.y <= object2.y+object2.collisionY)||(object1.y + object1.collisionY >= object2.y && object1.y + object1.collisionY <= object2.y+object2.collisionY))) {
      object1.collide(object2);
      object2.collide(object1);
    } else if (((object2.x >= object1.x && object2.x <= object1.x+object1.collisionX)||(object2.x + object2.collisionX >= object1.x && object2.x + object2.collisionX <= object1.x+object1.collisionX)) && ((object2.y >= object1.y && object2.y <= object1.y+object1.collisionY)||(object2.y + object2.collisionY >= object1.y && object2.y + object2.collisionY <= object1.y+object1.collisionY))) {
      object1.collide(object2);
      object2.collide(object1);
    }
  }
}
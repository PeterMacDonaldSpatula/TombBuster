/*
This class represents a message which appears when the a trigger activates. The message is generated from a set of images and a set of ints corresponding to them
*/

class HiddenMessage extends GameObject {
  PImage[] images;
  float alpha;
  
  HiddenMessage(float x, float y, float collisionX, float collisionY, int[] input) {
    super();
    this.x = x;
    this.y = y;
    this.collisionX = collisionX;
    this.collisionY = collisionY;
    
    images = new PImage[input.length];
    for (int i = 0; i < images.length; i+=1) {
      images[i] = loadImage("message"+input[i]+".png");
    }
    alpha = 0;
  }
  
  void collide(GameObject other) {}
  
  void update() {
    boolean show = false;
    for (int i = 0; i<triggers.size(); i+=1) {
      if (triggers.get(i).name.equals("light")) {
        alpha = 128;
        show = true;
      }
    }
    if(!show) {
      alpha = 0;
    }
  }
  
  void render() {
    tint(255, alpha);
    imageMode(CENTER);
    for (int i=0; i<images.length; i+=1) {
      pushMatrix();
      translate(x+(25*i), y);
      image(images[i], 0, 0);
      popMatrix();
    }
  }
}
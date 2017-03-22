/*
This class represents a message which appears when the a trigger activates. The message is generated from a set of images and a set of ints corresponding to them
*/

class HiddenMessage extends GameObject {
  PImage[] images;
  float alpha;
  GameObject target;
  int numberReceived;
  int[] message;
  int[] guess;
  boolean complete;
  
  HiddenMessage(float x, float y, float collisionX, float collisionY, int[] input, GameObject target) {
    super();
    this.x = x;
    this.y = y;
    this.collisionX = collisionX;
    this.collisionY = collisionY;
    this.target = target;
    numberReceived = 0;
    complete = false;
    images = new PImage[input.length];
    message = input;
    for (int i = 0; i < images.length; i+=1) {
      images[i] = loadImage("message"+input[i]+".png");
    }
    this.guess = new int[input.length];
    alpha = 0;
  }
  
  void collide(GameObject other) {}
  
  void update() {
    boolean show = false;
    for (int i = 0; i<triggers.size(); i+=1) {
      if (triggers.get(i).name.equals("light") || triggers.get(i).name.equals("button")) {
        alpha = 128;
        show = true;
      }
      
      if (!complete) {
        for (int j = 0; j < 6; j+=1) {
          if (triggers.get(i).name.equals("button" + j)) {
            guess[numberReceived] = j;
            numberReceived += 1;
            triggers.remove(j);
          }
        }
      boolean correct = true;
      if (numberReceived == message.length) {
        for (int j = 0; i < message.length; i+=1) {
            if (message[j] != guess[j]) {
              correct = false;
            }
          }
          if (correct) {
            target.triggers.add(new Trigger("open"));
            complete = true;
          }
        } else {
          numberReceived = 0;
        }
      }
      if(!show) {
        alpha = 0;
      }
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
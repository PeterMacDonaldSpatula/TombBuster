class Animation{
  PImage[] sprites; //holds a bunch of sprites that will be cycled through to make an animation
  int index, frame, idleFrame, frameDelay; //keeps track of the index of the frames and the delay between each frame
  
  Animation(String setDir, String imageSetName, int numSprites, int frameDelay, int idleFrame){
    sprites = new PImage[numSprites];
    for(int i = 0; i < numSprites; i++){ //use the directory and the 
      sprites[i] = loadImage("res/"+setDir+"/"+imageSetName+i+".png");
    }
    this.frameDelay = frameDelay;
    index = 0;
    frame = 0;
    this.idleFrame = idleFrame;
  }
  
  void draw(float x, float y){
    imageMode(CENTER);
    image(sprites[index],x,y);
    frame++;
    
    if(frame == frameDelay){
      index++;
      frame = 0;
      if (index >= sprites.length){
        index = 0;
      }
    }
  }
  
  void idle(float x, float y){
    imageMode(CENTER);
    image(sprites[idleFrame],x,y);
  }
}
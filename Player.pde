//This is a Player. I think it's pretty self explanatory what the player is
//there will only ever be one player at any time

class Player extends GameObject {
  Animation upSprites, downSprites, leftSprites, rightSprites;
  final static byte FACING_UP = 1;
  final static byte FACING_DOWN = 2;
  final static byte FACING_LEFT = 3;
  final static byte FACING_RIGHT = 4;
  

  Player(){
    super();
  }

  Player(float x, float y) {
    super();
    this.x = x;
    this.y = y;
    speed = 3;
    direction = FACING_DOWN;
    upSprites = new Animation("player", "player_up", 9, 8, 3); //this will make it load all images in the format "res/player/player0.png", "res/player/player1.png" up until player4 (one less than 5) with a delay of 8 units between animation frames.
    downSprites = new Animation("player", "player_down", 9, 8, 3);
    leftSprites = new Animation("player", "player_left", 9, 8, 0);
    rightSprites = new Animation("player", "player_right", 9, 8, 0);
  }

  ////move the player's x
  //void xMove(int dir){
  //  if (x <= 0){x = width;}
  //  if (x > width){x = 0;}
  //  x = x + (dir * speed);
  //}

  ////move the player's y
  //void yMove(int dir){
  //  if (y <= 0){y = height;}
  //  if (y > height){y = 0;}
  //  y = y + (dir * speed);
  //}
  //the function that happens when the player dies
  void kill() {
  }

  void collide(GameObject g) {
  }

  void update() {
  }

  void render() {
    //check all the directions the mouse vector is facing and determine which direction we want to draw the character
    if(moveLeft){
      leftSprites.draw(x,y);
    }
    else if(moveRight){
      rightSprites.draw(x,y);
    }
    else if(moveUp){
      upSprites.draw(x,y);
    }
    else if (moveDown){
      downSprites.draw(x,y);
    }
    else{
      if (lastIn == FACING_UP){
        upSprites.idle(x,y);
      }
      else if (lastIn == FACING_DOWN){
        downSprites.idle(x,y);
      }
      else if (lastIn == FACING_LEFT){
        leftSprites.idle(x,y);
      }
      else if (lastIn == FACING_RIGHT){
        rightSprites.idle(x,y);
      }
    }
  }
}
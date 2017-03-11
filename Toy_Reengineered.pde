ArrayList<GameObject> objects; //List of all game objects in the game
Camera camera;
//OBJECT LISTS
//All types of object needs to have a list containing all objects of its type
//NO EXCEPTIONS. Even if there's only one of them.
//IMPORTANT NOTE: If you add a list, you have to add a removal line to cleanObjects() as well
ArrayList<GameObject> walls; //List of all Walls in the game
ArrayList<GameObject> enemies; //List of all Enemies in the game
ArrayList<GameObject> lightTargets;//List of all LightTargets in the game
ArrayList<GameObject> tracers;//List of all LightTracers in the game
ArrayList<GameObject> players; //list of all the Players in the scene (HINT: There's only 1)
ArrayList<LightSource> lightSources;//List of all lightSources in the game
ArrayList<Collider> colliders; //The collision map for the game

//CONSTANTS
final static float WINDOW_MARGIN = 100; //How far an object can be from the screen's edge before we stop caring about it
final static float COLLISION_REFRESH_INTERVAL = 1.0; //How long to wait between collision map generations. If the collision map hasn't been generated in this amount of time, the game loop should run it. 
                                                     //Smaller numbers = more generations, larger numbers = fewer. If you start getting collision glitches at the edges of the screen, try decreasing this value.
final static float TRACER_SPEED = 25; //How far light tracers travel with each check. Lower number = more precision but worse performance
final static int PLAYER_INDEX = 0;
final static int FLASHLIGHT_INDEX = 2;

//GLOBAL VARIABLES
int lastCollisionRefresh; //The runtime in milliseconds when generateCollisionMap() was last run.
int xOffset, yOffset; //These are used to keep track of the translation of the camera
boolean mapChanged; //Set to true when the collision map needs to be changed; set to false at the beginning of each loop iteration
boolean moveLeft, moveRight, moveUp, moveDown; //these are for the controls to allow for multiple directions to be processed at once.
int lastIn; //this recored the last input to get the right idle animation for the player

//OBJECT CREATORS
//These functions create objects and add them to the relevant lists, and flag that the game needs to rebuild the collision map
//Every type of object needs to have these, and they must be what's used to generate objects
void addWall(float x, float y, float collisionX, float collisionY) {//takes the coordinates and dimensions of the wall
  Wall temp = new Wall(x, y, collisionX, collisionY);
  objects.add(temp);
  walls.add(temp);
  mapChanged = true;
}

void addBeamTarget() {//BeamTargets always are spawned at mouse position, so no need for parameters
  BeamTarget temp = new BeamTarget();
  objects.add(temp);
  lightTargets.add(temp);
}

void addBeamTarget(BeamTarget temp) {
  objects.add(temp);
  lightTargets.add(temp);
}

void addTracer(float x, float y) {//Takes the tracer's x and y coordinates
  Tracer temp = new Tracer(x, y);
  objects.add(temp);
  tracers.add(temp);
}

void addTracer(Tracer temp) {
  objects.add(temp);
  tracers.add(temp);
}

void addPlayer(float x, float y) {//takes the Player's source's x and y coordinates
  Player temp = new Player(x, y);
  objects.add(temp);
}

void addFlashlight(float x, float y) {//takes the flashlight's source's x and y coordinates
  Flashlight temp = new Flashlight(x, y);
  objects.add(temp);
  lightSources.add(temp);
}

/*
This function checks all objects for the removed flag, and removes them from the lists if they're flagged. Run at the end of the game loop.
IF YOU ADD A LIST, YOU HAVE TO ADD A LINE TO THIS FUNCTION AS WELL
*/
void cleanObjects() {
  GameObject temp;
  for (int i = objects.size()-1; i >=0;i--) {
    if (objects.get(i).removed) {
      temp = objects.get(i);
      objects.remove(temp);
      walls.remove(temp);
      enemies.remove(temp);
      lightTargets.remove(temp);
      tracers.remove(temp);
      lightSources.remove(temp);
      mapChanged = true;
    }
  }
}


/*
This function generates the collision map. It should be run at the end of the game loop if an object was generated or destroyed earlier in the loop, or if it hasn't been run in COLLISION_REFRESH_INTERVAL seconds.
The collision map is stored in global variable colliders.
*/
void generateCollisionMap() {
  colliders = new ArrayList<Collider>();
  GameObject object1, object2;
   for (int i = 0; i < objects.size(); i++) {
     for (int j = i+1; j < objects.size(); j++) {
       object1 = objects.get(i);
       object2 = objects.get(j);
        //If both objects are within active distance, and both are set to collide, it creates a Collider with the two objects and adds it to the collision map 
        if (object1.collides && object2.collides && object1.x + object1.collisionX > -WINDOW_MARGIN && object1.x < width + WINDOW_MARGIN && object1.y+object1.collisionY > - WINDOW_MARGIN && object1.y <height+WINDOW_MARGIN && object2.x + object2.collisionX > -WINDOW_MARGIN && object2.x < width + WINDOW_MARGIN && object2.y+object2.collisionY > -WINDOW_MARGIN && object2.y<height+WINDOW_MARGIN) {
          colliders.add(new Collider(objects.get(i), objects.get(j)));
      }
   }
  }
  lastCollisionRefresh = millis();
}

void setup() {
  //initialize globals
  moveUp = false;
  moveDown = false;
  moveLeft = false;
  moveRight = false;
  lastIn = 2;
  //Set up the window
  size(1280, 1024);
  frameRate(300);
  //Set up all lists
  objects = new ArrayList<GameObject>();
  walls = new ArrayList<GameObject>();
  enemies = new ArrayList<GameObject>();
  lightTargets = new ArrayList<GameObject>();
  lightSources = new ArrayList<LightSource>();
  tracers = new ArrayList<GameObject>();
  players = new ArrayList<GameObject>();
  //Set up the objects that go in those lists
  
  camera = new Camera();
  
  addPlayer(width/2, height/2);
  addFlashlight(width/2, height/2);
  addWall(100, 100, 100, 100);
  addWall(400, 100, 100, 100);
  addWall(200, 300, 150, 150);
  addWall(300, 300, 150, 150);
  
  //Build the initial collision map (Do this last)
  generateCollisionMap();
  
  for(int i = 0; i < objects.size(); i++){
    print(objects.get(i)+ "  ");
  }
}

void draw(){
  background(#000000);
  mapChanged = false;//Reset this each loop so we don't create the map every time
  
  move();
  
  fill(255, 0, 0);
  rect(25, 25, 25, 25);
  
  //draw all the gameobjects in the push/popmatrix section so it moves with the camera
  pushMatrix();
  translate(-camera.pos.x, -camera.pos.y);
  camera.draw(objects.get(PLAYER_INDEX).x, objects.get(PLAYER_INDEX).y);  //draw at the player's position
  
  
  for (int i = 0; i<colliders.size(); i++) {//Check all Colliders for collisions
    colliders.get(i).collide();
  }
  for (int i=0; i < lightSources.size(); i++) {//Create light rays and draw them. We do this first because other objects may depend on it, and also so that opaque objects draw on top of the light beam
    lightSources.get(i).createRays();
    lightSources.get(i).render();
  }
  for (int i = 0; i < objects.size(); i++) {//Update all objects and then render all objects that aren't light sources
    objects.get(i).update();
    if (!lightSources.contains(objects.get(i))) {
      objects.get(i).render();
    }
  }
  objects.get(PLAYER_INDEX).render();
  popMatrix();
  
  //<HUD>
  
  //fps counter
  textSize(14);
  fill(255,255,255);
  text(floor(frameRate), 10, 20);
  
  //Inventory Display
  
  //</HUD>
  
  cleanObjects();//Remove any objects that have been flagged for removal
  for (int i=0; i < lightSources.size(); i++) {//Refresh light sources so the light rays can be generated anew next round
    lightSources.get(i).cleanRays();
  }
  if (mapChanged || millis()-lastCollisionRefresh >= 1000 * COLLISION_REFRESH_INTERVAL) {//If the map has changed by adding or removing elements, or if it's been too long since the last collision map rebuild, generate a new collision map
    generateCollisionMap();
  }
}

void keyPressed(){
  if(keyCode == 'W'){moveUp = true; lastIn = 1;}
  if(keyCode == 'S'){moveDown = true;lastIn = 2;}
  if(keyCode == 'A'){moveLeft = true;lastIn = 3;}
  if(keyCode == 'D'){moveRight = true;lastIn = 4;}
}
void keyReleased(){
  if(keyCode == 'W'){moveUp = false;}
  if(keyCode == 'S'){moveDown = false;}
  if(keyCode == 'A'){moveLeft = false;}
  if(keyCode == 'D'){moveRight = false;}
}
void move(){
  if(moveUp){
    objects.get(PLAYER_INDEX).y += (-1 * objects.get(PLAYER_INDEX).speed);
    objects.get(FLASHLIGHT_INDEX).y += (-1 * objects.get(PLAYER_INDEX).speed);
    camera.pos.y += (-1 * objects.get(PLAYER_INDEX).speed);
  }
  else if(moveDown){
    objects.get(PLAYER_INDEX).y += (1 * objects.get(PLAYER_INDEX).speed);
    objects.get(FLASHLIGHT_INDEX).y += (1 * objects.get(PLAYER_INDEX).speed);
    camera.pos.y += (1 * objects.get(PLAYER_INDEX).speed);
  }
  if(moveLeft){
    objects.get(PLAYER_INDEX).x += (-1 * objects.get(PLAYER_INDEX).speed);
    objects.get(FLASHLIGHT_INDEX).x += (-1 * objects.get(PLAYER_INDEX).speed);
    camera.pos.x += (-1 * objects.get(PLAYER_INDEX).speed);
  }
  else if (moveRight){
    objects.get(PLAYER_INDEX).x += (1 * objects.get(PLAYER_INDEX).speed);
    objects.get(FLASHLIGHT_INDEX).x += (1 * objects.get(PLAYER_INDEX).speed);
    camera.pos.x += (1 * objects.get(PLAYER_INDEX).speed);
  }
}
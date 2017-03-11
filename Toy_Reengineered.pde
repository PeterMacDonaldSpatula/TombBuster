ArrayList<GameObject> objects; //List of all game objects in the game

//OBJECT LISTS
//All types of object needs to have a list containing all objects of its type
//NO EXCEPTIONS. Even if there's only one of them.
//IMPORTANT NOTE: If you add a list, you have to add a removal line to cleanObjects() as well
ArrayList<GameObject> walls; //List of all Walls in the game
ArrayList<GameObject> enemies; //List of all Enemies in the game
ArrayList<GameObject> lightTargets;//List of all LightTargets in the game
ArrayList<GameObject> tracers;//List of all LightTracers in the game
ArrayList<GameObject> triggerspaces;//List of all trigger spaces in the game
ArrayList<GameObject> hiddenmessages;//List of all HiddenMessages in the game
ArrayList<GameObject> rooms;//List of all Rooms in the game
ArrayList<LightSource> lightSources;//List of all lightSources in the game
ArrayList<Collider> colliders; //The collision map for the game

//CONSTANTS
final static float WINDOW_MARGIN = 100; //How far an object can be from the screen's edge before we stop caring about it
final static float COLLISION_REFRESH_INTERVAL = 1.0; //How long to wait between collision map generations. If the collision map hasn't been generated in this amount of time, the game loop should run it. 
                                                     //Smaller numbers = more generations, larger numbers = fewer. If you start getting collision glitches at the edges of the screen, try decreasing this value.
final static float TRACER_SPEED = 10; //How far light tracers travel with each check. Lower number = more precision but worse performance
final static float TILE_SIZE = 30; //The size of all tiles
final static float LIGHT_ACTIVATION_TIME = 1.5; //How long light activation tiles take to kick in

//GLOBAL VARIABLES
int lastCollisionRefresh; //The runtime in milliseconds when generateCollisionMap() was last run.
boolean mapChanged; //Set to true when the collision map needs to be changed; set to false at the beginning of each loop iteration

//OBJECT CREATORS
//These functions create objects and add them to the relevant lists, and flag that the game needs to rebuild the collision map
//Every type of object needs to have these, and they must be what's used to generate objects
void addWall(float x, float y, float collisionX, float collisionY) {//takes the coordinates and dimensions of the wall
  Wall temp = new Wall(x, y, collisionX, collisionY);
  objects.add(temp);
  walls.add(temp);
  mapChanged = true;
}

void addWall(Wall temp) {//takes the coordinates and dimensions of the wall
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

void addFlashlight(float x, float y) {//takes the flashlight's source's x and y coordinates
  Flashlight temp = new Flashlight(x, y);
  objects.add(temp);
  lightSources.add(temp);
}

void addRoom(float x, float y, String name, String fileName) {
  Room temp = new Room (x, y, name, fileName);
  objects.add(temp);
  rooms.add(temp);
}

void addRoom(Room temp) {
  objects.add(temp);
  rooms.add(temp);
}

void addTriggerSpace(TriggerSpace temp) {
  objects.add(temp);
  triggerspaces.add(temp);
}

void addHiddenMessage(float x, float y, float collisionX, float collisionY, int[] input) {
  HiddenMessage temp = new HiddenMessage(x, y, collisionX, collisionY, input);
  objects.add(temp);
  hiddenmessages.add(temp);
}

void addHiddenMessage(HiddenMessage temp) {
  objects.add(temp);
  hiddenmessages.add(temp);
}

/*
This function checks all objects for the removed flag, and removes them from the lists if they're flagged. Run at the end of the game loop.
IF YOU ADD A LIST, YOU HAVE TO ADD A LINE TO THIS FUNCTION AS WELL
*/
void cleanObjects() {
  GameObject temp;
  for (int i = objects.size()-1; i >=0;i-=1) {
    if (objects.get(i).removed) {
      temp = objects.get(i);
      objects.remove(temp);
      walls.remove(temp);
      enemies.remove(temp);
      lightTargets.remove(temp);
      tracers.remove(temp);
      lightSources.remove(temp);
      rooms.remove(temp);
      triggerspaces.remove(temp);
      hiddenmessages.remove(temp);
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
   for (int i = 0; i < objects.size(); i+=1) {
     for (int j = i+1; j < objects.size(); j+=1) {
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
  //Set up the window
  size(600, 600);
  //Set up all lists
  objects = new ArrayList<GameObject>();
  walls = new ArrayList<GameObject>();
  enemies = new ArrayList<GameObject>();
  lightTargets = new ArrayList<GameObject>();
  lightSources = new ArrayList<LightSource>();
  rooms = new ArrayList<GameObject>();
  tracers = new ArrayList<GameObject>();
  triggerspaces = new ArrayList<GameObject>();
  hiddenmessages = new ArrayList<GameObject>();
  //Set up the objects that go in those lists
  
  
  addRoom(100, 100, "test", "testRoom.map");
  addFlashlight(300, 300);
  int[] message = {int(random(0, 6)), int(random(0, 6)), int(random(0, 6)), int(random(0, 6))};
  HiddenMessage temp = new HiddenMessage(400, 400, 50, 50, message);
  addHiddenMessage(temp);
  addTriggerSpace(new LightActivated(200, 400, 50, 50, temp));
  
  //Build the initial collision map (Do this last)
  generateCollisionMap();
  
}

void draw(){
  background(#000000);
  mapChanged = false;//Reset this each loop so we don't create the map every time
  for (int i = 0; i<colliders.size(); i+=1) {//Check all Colliders for collisions
    colliders.get(i).collide();
  }
  for (int i=0; i < lightSources.size(); i+=1) {//Create light rays and draw them. We do this first because other objects may depend on it, and also so that opaque objects draw on top of the light beam
    lightSources.get(i).createRays();
    lightSources.get(i).render();
  }
  for (int i = 0; i < objects.size(); i+=1) {//Update all objects and then render all objects that aren't light sources
    objects.get(i).update();
    if (!lightSources.contains(objects.get(i))) {
      objects.get(i).render();
    }
  }
  cleanObjects();//Remove any objects that have been flagged for removal
  for (int i=0; i < lightSources.size(); i+=1) {//Refresh light sources so the light rays can be generated anew next round
    lightSources.get(i).cleanRays();
  }
  if (mapChanged || millis()-lastCollisionRefresh >= 1000 * COLLISION_REFRESH_INTERVAL) {//If the map has changed by adding or removing elements, or if it's been too long since the last collision map rebuild, generate a new collision map
    generateCollisionMap();
  }
}
/*
This class describes one room of a map. The map is described in a text file, stored in the data folder. The Map file must be a text file, and contain only a series of characters
Each row of the file describes one row of the room, and each character describes one tile of size TILE_SIZE.
If two rooms are intersecting, it'll start kicking out error messages to the console. The intersection width of a room is the width of its largest row.
Rooms are NOT automatically surrounded by walls; you have to do that yourself. 
Right now, only contains generator for walls; if you have another type of tile to add, pick a character and add it to the constructor's loop.
Rooms also contain a list of all objects they generate, in case we want to run logic on that.
*/
class Room extends GameObject {
  String [] map; //The set of strings from which the room generates its objects
  String name; //The room's name, to help troubleshoot when two rooms are inside each other
  ArrayList<GameObject> contents; //All objects contained within the room
  
  Room(float x, float y, String name, String fileName) {
    this.x = x;
    this.y = y;
    this.name = name;
    contents = new ArrayList<GameObject>();
    map = loadStrings(fileName);//Get the map strings from the file
    int size = 0;
    for (int i=0; i < map.length; i+=1) {//Determine the length of the longest string
      if (map[i].length() > size) {
        size = map[i].length();
      }
    }
    collisionX = size * TILE_SIZE; //Horizontal size is the length of the longest string times the size of the tiles
    collisionY = map.length * TILE_SIZE; //Vertical size is the number of strings times the size of the tiles
    collides = true;//Rooms collide so that we can get an error if two are touching
    
    for (int i = 0; i < map.length; i+=1) {
      for (int j = 0; j < map[i].length(); j+=1) {//Generate the room objects from the strings
        if (map[i].charAt(j) == 'W') { // 'W' for walls
          Wall temp = new Wall(x+j*TILE_SIZE, y+i*TILE_SIZE, TILE_SIZE, TILE_SIZE);
          contents.add(temp);
          addWall(temp);
        }
      }
    }
  }
  
  void collide(GameObject other) {
    if (rooms.contains(other)) { //If two rooms are inside each other, that's no good, and it gives an error message to the console telling you which rooms are intersecting
      println("ROOM INTERSECTION ERROR! " + name);
    }
  }
  
  void update() {}
  
  void render() {}
}
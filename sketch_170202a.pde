GameObject[] objects;



void addObject(GameObject newObject) {
  if (objects == null) {
    objects = new GameObject[1];
    objects[0] = newObject;
  } else {
    GameObject[] temp = new GameObject[objects.length+1];
    for (int i=0; i< objects.length ; i+= 1) {
      temp[i] = objects[i];
    }
    temp[objects.length] = newObject;
    objects = temp;
  }
}

void removeObject(int index) {
  int j = 0;
  GameObject[] temp = new GameObject[objects.length-1];
  for (int i = 0; i < objects.length; i+=1) {
    if (i != index) {
      temp[j] = objects[i];
      j += 1;
    }
  }
  objects = temp;
}

int getObjectIndex(GameObject o) {
  for (int i=0; i< objects.length; i+= 1) {
    if (objects[i] == o) { return i;}
  }
  return -1;
}

void setup() {
  size(600, 600);

  addObject(new Flashlight(300, 500));
  addObject(new Wall(200, 200, 200, 100, #F0299D));
}

void draw() {
  background(#245BC6);
  fill(#FFF527);
  arc(100, 100, 100, 100, QUARTER_PI, HALF_PI);
  for (int i = 0; i < objects.length; i+=1) {
    objects[i].drawMe();
  }
}
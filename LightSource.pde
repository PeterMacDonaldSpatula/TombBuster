/*
This class is an abstract class representing any object which gives off light. LightSources behave somewhat differently than other in the main game loop.
All LightSources must have a LightTarget to orient towards (although in fully circular sources it won't matter)
The width of the light's arc (0-2*PI) is determined by the value of lightArc, while the value of numWedges determines how many individual rays are contained inside it(how granular the light is)
*/
abstract class LightSource extends GameObject {
  PVector direction; //vector describing the direction of the center of the beam
  int numWedges;//the number of wedges which make up the beam
  ArrayList<LightRay> rays;//A list of numWedges size, containing the individual LightRays which describe the light's shape
  float lightArc;//How wide the beam is
  float screensize;//The diagonal size of the screen
  float range;//THe maximum distance the light will travel
  LightTarget target;//The target which the light beam orients towards
  
  LightSource(LightTarget target) {
    super();
    this.target = target;
    numWedges = 0;
    lightArc = 0;
    direction = new PVector(0, 0);
    range = 0;
    screensize = sqrt(pow(width, 2)+pow(height, 2));
    rays = new ArrayList<LightRay>();
  }
  
  /*
  This function generates a series of rays, emerging from the LightSource's coordinates. Each ray is a series of tracers, which move forward until they hit something opaque. All non-opaque objects struck while en route have their visible and beenSeen flags set true.
  These rays are recreated every frame in order to keep a record of where the light actually is.
  */
  void createRays() {
    boolean dr = false;//If the down-right quadrant has had its map made, true 
    boolean dl = false;//If the down-left quadrant has had its map made, true 
    boolean ul = false;//If the up-left quadrant has had its map made, true 
    boolean ur = false;//If the up-right quadrant has had its map made, true 
    ArrayList<GameObject> downRight = new ArrayList<GameObject>();//Each quadrant has its own list of objects contained within it
    ArrayList<GameObject> downLeft = new ArrayList<GameObject>();//These are initialized now, but not filled unless needed
    ArrayList<GameObject> upLeft = new ArrayList<GameObject>();
    ArrayList<GameObject> upRight = new ArrayList<GameObject>();
    
    for (float i=0-numWedges/2; i<=numWedges/2; i+=1) {//For each wedge of the beam,
      PVector rayVector = rotateVector(getTargetVector(), lightArc/numWedges*i); //Generate a vector to describe its direction
      ArrayList<GameObject> collisionSet = new ArrayList<GameObject>();//We only initialize it here to get the compiler to shut up about how it might not have been initialized
      if (rayVector.x >= 0 && rayVector.y >= 0) {//If the ray's vector is pointing down and to the right...
        collisionSet = downRight; //We only check for collisions against objects in the down-right quadrant
        if (!dr) {//If we haven't generated that quadrant yet, we do
          dr = true;
          for (int j = 0; j < objects.size(); j+=1) {
            GameObject gameObject = objects.get(j);
            if(gameObject.x + gameObject.collisionX > x && gameObject.y + gameObject.collisionY > y) {
              collisionSet.add(gameObject);
            }
          }
        }//We then repeat the same process for the other three quadrants, if it wasn't in down-right
      } else if (rayVector.x <= 0 && rayVector.y >= 0) {
        collisionSet = downLeft;
        if (!dl) {
          dl = true;
          for (int j = 0; j < objects.size(); j+=1) {
            GameObject gameObject = objects.get(j);
            if(gameObject.x < x && gameObject.y + gameObject.collisionY > y) {
              collisionSet.add(gameObject);
            }
          }
        }
      } else if (rayVector.x <= 0 && rayVector.y <= 0) {
        collisionSet = upLeft;
        if (!ul) {
          ul = true;
          for (int j = 0; j < objects.size(); j+=1) {
            GameObject gameObject = objects.get(j);
            if(gameObject.x < x && gameObject.y < y) {
              collisionSet.add(gameObject);
            }
          }
        }
      } else if (rayVector.x >= 0 && rayVector.y <= 0) {
        collisionSet = upRight;
        if (!ur) {
          ur = true;
          for (int j = 0; j < objects.size(); j+=1) {
            GameObject gameObject = objects.get(j);
            if(gameObject.x + gameObject.collisionX > x && gameObject.y < y) {
              collisionSet.add(gameObject);
            }
          }
        }
      }
      rays.add(castRay(rayVector, collisionSet));//Now the we've picked out the quadrant and the objects the ray might collide with, we project the ray forward, and add it to the rays list
    }
  }
  
  /*
  This function generates and returns the vector between the LightSource and its target.
  */
  PVector getTargetVector() {
    PVector temp = new PVector();
    float distance = PVector.dist(new PVector(x, y), new PVector (target.x, target.y));
    
    temp.x = (target.x-x)/distance;
    temp.y = (target.y-y)/distance;
    return temp;
  }
  
  /*
    This function takes in a vector and a float representing an angle in radians, and returns a new vector which is the original vector rotated by the angle.
    Used to determine the angle of rays from the central beam vector.
  */
  PVector rotateVector(PVector vector, float angle) {
    PVector output = new PVector();
    output.x = vector.x*cos(angle)-vector.y*sin(angle);
    output.y = vector.x*sin(angle)+vector.y*cos(angle);
  
    return output;
  }
  
  /*
  This function takes in a vector, and a list of objects which the ray might collide with, and returns a LightRay using that information. From the LightSource's coordinates, it adds the vector and then creates a Tracer, and checks to see if it's colliding with anything.
  If it is, it sets the visible and beenSeen flags, and then checks if that thing is opaque. If it is, the ray stops there and it returns the light ray. Otherwise, it casts another tracer forward and then checks again.
  */
  LightRay castRay (PVector vector, ArrayList<GameObject> objects) {
    float terminalX = x; //the x coordinate of the final tracer
    float terminalY = y; //the y coordinate of the final tracer
    Tracer trace;
    LightRay temp = new LightRay(x, y, vector);
    boolean endFound = false;
    do {
      if (terminalX <= -WINDOW_MARGIN || terminalY <= -WINDOW_MARGIN || terminalX >= width+WINDOW_MARGIN || terminalY >= height+WINDOW_MARGIN || temp.length() >= range) {//if it's out of range or outside the visible area, stop searching
        endFound = true;
      } else { 
        GameObject object;
        trace = new Tracer(terminalX, terminalY); //Otherwise, create a new Tracer...
        temp.tracers.add(trace);
        addTracer(trace);
        for (int i=0; i<objects.size() ; i+=1) {//and check if it's inside an object
          object = objects.get(i);
          if (terminalX >= object.x && terminalX <= object.x + object.collisionX && terminalY >= object.y && terminalY <= object.y + object.collisionY) {//If it is, set the object's visible and beenSeen flags to true
            object.collide(temp.tracers.get(temp.tracers.size()-1));
            object.visible = true;
            object.beenSeen = true;
            if (object.opaque) {//If the object is opaque, stop searching
              endFound = true;
            }
          }
        }
        terminalX += vector.x * TRACER_SPEED;//keep looking until you hit the edge of range, edge of screen, or an opaque object
        terminalY += vector.y * TRACER_SPEED;
      }
    } while(!endFound);
    return temp;
  }
  
  /*
  Gets and returns the angle from the LightSource's coordinates to its target's coordinates. Not actually used for anything atm, but I kept it in case I needed it later
  */
  float getTargetAngle() {
    float angle;
    if ((target.x-x) * (target.y-y) < 0) {
      angle = atan(direction.x/direction.y);
    } else {
      angle = atan(direction.y/direction.x);
    }
    if (target.x-x <0 && target.y-y > 0) {
      angle += HALF_PI;
    } else if (target.x-x < 0 && target.y-y < 0) {
      angle += PI;
    } else if (target.x-x > 0 && target.y-y < 0) {
      angle += 3*PI/2;
    } else if (target.x-x ==0 && target.y-y > 0) {
      angle = HALF_PI;
    } else if (target.x-x ==0 && target.y-y < 0) {
      angle = 3*PI/2;
    } else if (target.x-x > 0 && target.y-y == 0) {
      angle = 0;
    } else if (target.x-x < 0 && target.y-y == 0) {
      angle = PI;
    }
    return angle;
  }
  
  /*
  This function takes in a light ray, and draws a wedge to the screen, as long as the ray, with the ray's line as its center. 
  */
  void drawWedge(LightRay ray) {
    Tracer lastTracer = ray.tracers.get(ray.tracers.size()-1);
    float wedgeLength = sqrt(pow(lastTracer.x-x, 2) + pow(lastTracer.y-y, 2));
    float angle = atan2(lastTracer.y-y, lastTracer.x-x);
    fill(#FCED38);
    arc(x, y, wedgeLength*2, wedgeLength*2, angle-(lightArc/numWedges), angle+(lightArc/numWedges));
  }
  
  void render() {
    for (int i = 0; i < rays.size(); i+=1) {//Draws all the wedges
      drawWedge(rays.get(i));
    }
  }
  
  void cleanRays() {//This just gets rid of the existing rays so new ones can replace them
    rays = new ArrayList<LightRay>();
  }
}
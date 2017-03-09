/*
This class is NOT a GameObject, and should not be treated as one. It is a container class to hold the tracers of one of the light source's rays, a vector describing the direction, and a function to determine how long it is.
It also holds the x and y coordinates of its origin point, for computational purposes.
This class should ONLY be used within LightSource.
*/
class LightRay {
  float x, y;
  ArrayList<Tracer> tracers;
  PVector vector;
  
  LightRay(float x, float y, PVector vector) {
    this.x = x;
    this.y = y;
    this.vector = vector;
    tracers = new ArrayList<Tracer>();
  }
  
  float length() {//Returns the distance from the ray's origin point to the last tracer contained within it
    if (tracers.size() == 0) {
      return 0;
    } else {
      Tracer temp = tracers.get(tracers.size()-1);
      return sqrt(pow(temp.x-x, 2) + pow(temp.y-y, 2));
    }
  }
}
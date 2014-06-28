// Declare an ArrayList of Vehicle objects
ArrayList<Vehicle> vehicles;

void setup()
{
  size(1000,600);
  background(0);
  vehicles = new ArrayList<Vehicle>();
  for (int i = 0; i < 20; i++)
  {
    vehicles.add(new Vehicle(random(width), random(height)));
  }
}

void draw()
{ 
  for (Vehicle v : vehicles)
  {
    v.separate(vehicles);//examine all the other vehicles in the process of calculating a separation force
    v.update();
    v.borders();
    v.display();
  }
  fill(255);
  text("Drag the mouse to generate new vehicles.", 10, height-16);
}

void mouseDragged()
{
  vehicles.add(new Vehicle(mouseX,mouseY));
}

class Vehicle
{
  PVector location;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;
  float maxspeed;
  
  Vehicle(float x, float y)
  {
    location = new PVector(x,y);
    r = 6;
    maxspeed = 3;
    maxforce = 0.2;
    acceleration = new PVector(0,0);
    velocity = new PVector(0,0);
  }
  
  void applyForce(PVector force)
  {
    acceleration.add(force);
  }
  
  void separate(ArrayList<Vehicle> vehicles)//look all of the vehicles and see if any are too close
  {
    float desiredSeparation = r*2;//specifies how close is too close
    PVector sum = new PVector();//start with an empty PVector
    int count = 0;
    for (Vehicle other: vehicles)
    {
      float d = PVector.dist(location, other.location);//what is the distance between me and another Vehicle?
      
      if ((d>0) && (d < desiredSeparation))
      {
        //calculate vector pointing away from meighbor
        PVector diff = PVector.sub(location, other.location);
        diff.normalize();
        diff.div(d); //Weight by distance
        sum.add(diff);
        count++; //keep track of how many
      }
    }
    if (count > 0) // We have to make sure we found at least one close vehicle.  We don’t want to bother doing anything
    // if nothing is too close (not to mention we can’t
    // divide by zero!)
    {
      sum.div(count);
      sum.normalize();
      sum.mult(maxspeed);
      PVector steer = PVector.sub(sum,velocity);
      steer.limit(maxforce);
      applyForce(steer);
    }
  }

// Method to update location
  void update() 
  {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    location.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }

  void display() 
  {
    fill(175);
    noStroke();
    pushMatrix();
    translate(location.x, location.y);
    ellipse(0, 0, r, r);
    popMatrix();
  }

  // Wraparound
  void borders() 
  {
    if (location.x < -r) location.x = width+r;
    if (location.y < -r) location.y = height+r;
    if (location.x > width+r) location.x = -r;
    if (location.y > height+r) location.y = -r;
  }
}

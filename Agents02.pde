// Declare an ArrayList of Vehicle objects
ArrayList<Node> nodes;
float b = 25;
float p = 0.5;
void setup()
{
  size(600,600);
  //background(255);
  nodes = new ArrayList<Node>();
  for (int i = 0; i < 20; i++)
  {
    nodes.add(new Node(random(width), random(height)));
  }
  for (Node n : nodes){
   n.pair = int(random(19));
   n.pairNo = random(0,1);
  }
    
  frameRate(30);
}

void draw()
{
  background(255);
  noStroke();
  fill(255, 255, 255, 50);
    rect(150,150,300, 300);
  
  for (Node n : nodes)
  {
    n.separate(nodes);//examine all the other nodes in the process of calculating a separation force
    n.update();
    //n.borders();
    n.display();
    n.boundaries();
    n.displayLine();
    //n.trail();
  }
//  fill(0);
//  text("Drag the mouse to generate new nodes.", 10, height-16);
}

//void mouseDragged()
//{
//  nodes.add(new Node(mouseX,mouseY));
//}

class Node
{
  PVector location;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;
  float maxspeed;
  int pair;
  float pairNo;
  
  Node(float x, float y)
  {
    location = new PVector(x,y);
    r = 6;
    maxspeed = 3;
    maxforce = 0.2;
    acceleration = new PVector(0,0);
    velocity = new PVector(0,0);
    velocity.mult(5);
  }
  
  void applyForce(PVector force)
  {
    acceleration.add(force);
  }
  
  void separate(ArrayList<Node> nodes)//look all of the nodes and see if any are too close
  {
  float desiredseparation = r+10;//specifies how close is too close
  PVector sum = new PVector();//start with an empty PVector
  int count = 0;
  for (Node other: nodes)
  {
    float d = PVector.dist(location, other.location);//what is the distance between me and another Node?
    
    if ((d>0) && (d < desiredseparation))
    {
      //calculate vector pointing away from neighbor
      PVector diff = PVector.sub(location, other.location);
      diff.normalize();
      diff.div(d); //Weight by distance
      sum.add(diff);
      count++; //keep track of how many
    }
  }
  if (count > 0) // We have to make sure we found at least one close node.  We don’t want to bother doing anything
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
  
    void boundaries()
  {
    PVector desired = null;
    
    if (location.x < b)
    {
      desired = new PVector(maxspeed, velocity.y);
    }
    else if (location.x > width - b)
    {
      desired = new PVector(-maxspeed, velocity.y);
    }
    
    if (location.y < b)
    {
      desired = new PVector(velocity.x, maxspeed);
    }
    else if (location.y > height - b)
    {
      desired = new PVector(velocity.x, -maxspeed);
    }
    
    if(desired !=null)
    {
      desired.normalize();
      desired.mult(maxspeed);
      PVector steer = PVector.sub(desired, velocity);
      steer.limit(maxforce);
      applyForce(steer);
    }
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
  
  void displayLine(){
    stroke(2);
    
    line(location.x, location.y, nodes.get(pair).location.x, nodes.get(pair).location.y);
    //println(location.x, location.y, nodes.get(pair).location.x, nodes.get(pair).location.y);
  }

  // Wraparound
//  void borders() 
//  {
//    if (location.x < -r) location.x = width+r;
//    if (location.y < -r) location.y = height+r;
//    if (location.x > width+r) location.x = -r;
//    if (location.y > height+r) location.y = -r;
//  }
}

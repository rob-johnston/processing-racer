public class MuscleCar implements Car {
  //current info
  public int health;
  public float speed;
  public float direction;
  public float xpos;
  public float ypos;
  public float acceleration;
  public boolean ability = false;

  //general info
  public String name;
  public color col;
  public float topSpeed;
  public float accelerationSpeed;
  public float handling;
  public int maxHealth;



  float drag = -.01; 

  public MuscleCar(float x, float y, float direction) {


    this.xpos=x;
    this.ypos=y;
    this.direction = direction;
    this.acceleration = 0;
    this.speed=0;


    //set up the stats that make it a muscle car
    name = "Muscle";
    col = color(0, 0, 227);
    topSpeed = 9;
    accelerationSpeed = 7;
    handling = 6;
    maxHealth = 6;
    this.health=maxHealth;
  }

  //each tick we apply physics to our car and update its position
  public void update() {
    //keep track of original values
    float oldX = this.xpos;
    float oldY = this.ypos;

    //if we are off the track apply some penalties
    if (!getTrack().onTrack(new PVector(xpos, ypos))) {
      if(speed>(topSpeed/4)){
        speed = speed - 0.1;
      }
    }

    if (speed>0) {
      speed = speed + drag;
    }
    if (speed<0) { 
      speed = speed - drag;
    }

    //act normal if on the track

    xpos = xpos + (speed * sin(radians(direction)));
    ypos = ypos + (speed * cos(radians(direction)));


    //check window bounds
    if (xpos < 0) {
      xpos = 1; 
      speed = speed-.5;
    } else if ( xpos > 1400) {
      xpos = 1399;
      speed = speed-.5;
      if(speed<0){
        speed =0;
      }
    }
    if (ypos < 0) {
      ypos = 1; 
      speed = speed-.5;
    } else if ( ypos > 800) {
      ypos = 799;
      speed = speed-.5;
      if(speed<0){
        speed =0;
      }
    }


    //have to check for collisions
    //have to check for collisions
    
    

    boolean crash = checkObstacles();
    if (crash) {
      health--;
      if (health <=0) {
        //explode();
      }
      xpos = xpos - (speed * sin(radians(direction)));
      ypos = ypos - (speed * cos(radians(direction)));
      boolean doublecheck = checkObstacles();
      if (doublecheck) {
        xpos = xpos - (speed/2 * sin(radians(direction)));
        ypos = ypos - (speed/2 * cos(radians(direction)));
      }
      if (speed>0)  
        speed = speed -.5;
      if (speed<0)
        speed = speed +.5;
    }
    ability=false;
    
    if(oldY<currentTrack.starty && ypos>currentTrack.starty 
    && xpos > currentTrack.startx-60 && xpos < currentTrack.startx+90){
       lapCount++; 
    }
   
    
  }

  public void accelerate() {
    //make the car go 
    //you accelerate faster at the start
    speed = speed +  (accelerationSpeed-acceleration)/100;

    if (speed<-1) {
      speed = -1;
    }
    if (speed>topSpeed/2) {
      speed=topSpeed/2;
    }
  }

  public void turnRight() {
    direction = direction - handling/ (4+(speed/3)) ;
    if (checkObstacles()) {
      direction = direction + handling/ (4+(speed/3));
    }
    //if ability is on lets to an awesome drift turn!
    if (ability) {
      speed = speed - .14;
      if (speed<0) {
        speed = speed +.14;
      }
      direction = direction - handling/ (4+(speed/3));

      xpos = xpos + (speed/2 * sin(radians(direction+90)));
      ypos = ypos + (speed/2 * cos(radians(direction+90)));
      if (checkObstacles()) {
        direction = direction + handling/ (4+(speed/3));

        xpos = xpos +(speed/2 * sin(radians(direction-90)));
        ypos = ypos + (speed/2 * cos(radians(direction-90)));
      } else {
        tyreMarks();
      }
    }
    ability=false;
  }


  public void turnLeft() {


    direction = direction + handling/ (4+(speed/3));
    if (checkObstacles()) {
      direction = direction - handling/ (4+(speed/3));
    }
    //if ability is on lets to an awesome drift turn!
    if (ability) {

      speed = speed - .14;
      if (speed<0) {
        speed = speed +.14;
      }
      direction = direction + handling/ (4+(speed/3));
      xpos = xpos + (speed/2 * sin(radians(direction-90)));
      ypos = ypos + (speed/2 * cos(radians(direction-90)));
      if (checkObstacles()) {
        direction = direction - handling/ (4+(speed/3));
        speed = speed - .1;
        if (speed<0) {
          speed = speed +.1;
        }
        xpos = xpos - (speed/2 * sin(radians(direction-90)));
        ypos = ypos - (speed/2 * cos(radians(direction-90)));
      } else {
        tyreMarks();
      }
    }
    ability=false;
  }

  public void tyreMarks() {
    float width = 15;
    float height = 25;
    //first corner
    //set square middle to origin        
    float corner1x = (xpos-width/2)-xpos;
    float corner1y = (ypos-height/2)-ypos;

    // now apply rotation
    float rotatedX = corner1x*cos(radians(360-direction)) - corner1y*sin(radians(360-direction));
    float rotatedY = corner1x*sin(radians(360-direction)) + corner1y*cos(radians(360-direction));
    // translate back
    float xx = rotatedX + (xpos);
    float yy = rotatedY + (ypos);  
     
    if(getTrack().onTrack(new PVector(xx,yy))){
      tyreMarks.add(new PVector(xx, yy));
    } else {
      mudMarks.add(new PVector(xx, yy)); 
    }
    

    //set square middle to origin        
    corner1x = (xpos+width/2)-xpos;
    corner1y = (ypos-height/2)-ypos;

    // now apply rotation
    rotatedX = corner1x*cos(radians(360-direction)) - corner1y*sin(radians(360-direction));
    rotatedY = corner1x*sin(radians(360-direction)) + corner1y*cos(radians(360-direction));
    // translate back
    xx = rotatedX + (xpos);
    yy = rotatedY + (ypos);  

    if(getTrack().onTrack(new PVector(xx,yy))){
      tyreMarks.add(new PVector(xx, yy));
    } else {
      mudMarks.add(new PVector(xx, yy)); 
    }

    if (tyreMarks.size()>300) {
      tyreMarks.remove(0);
      tyreMarks.remove(0);
    }
    if (mudMarks.size()>300) {
      mudMarks.remove(0);
      mudMarks.remove(0);
    }
  }



  public void brake() {
    //acceleration = acceleration - handling/10;
    speed = speed - handling/150;
    if (speed<-1) { 
      speed = -1;
    }
  }

  //determine the type of car and draw it
  //this is about to get complicated 
  public void draw() {
    //position for drawing
    fill(this.col);
    pushMatrix();
    translate(xpos, ypos);
    rotate(radians(360)-radians(direction));
    rectMode(CENTER);

    //now draw 

    //base rectangle for the color
    float width = 15;
    float height = 25;
    noStroke();
    rect(0, 0, width+2, height+2);

    strokeWeight(3);
    stroke(col);
    //bumbers
    curve(0-(width*2), 0, 0-width/2, 0-height/2, 0+width/2, 0-height/2, 0+(width*2), 0);
    curve(0-(width*2), -20, 0-width/2, 0+height/2, 0+width/2, 0+height/2, 0+(width*2), -20);
    
    //wing mirrors
    fill(col);
    stroke(col);
    rect(-width/2,5,5,1);
    rect(width/2,5,5,1);
    
    
    stroke(0);
    fill(0);
    rectMode(CENTER);
    //windshields
    rect(0,8,10,3);
    rect(0,-8,4,4);
    
    //windows
    rect(-6,0,0,8);
    rect(6,0,0,8);
    
    rectMode(CORNER);
    popMatrix();
    stroke(0);
    strokeWeight(1);
  }

  public boolean checkObstacles() {
    //here we want to check obstacles 
    float width = 15;
    float height = 25;
    Track t = getTrack();
    for (Barrier b : t.barriers) {
      if (b.contains(new PVector(xpos, ypos), width, height, direction)) {
        return true;
      }
    }
    return false;
  }

//getters and setters...
  public void ability() {
    ability=true;
  }
  public void abilityOff() {
    ability = false;
  }
  public float getxpos() {
    return xpos;
  }
  public float getypos() {
    return ypos;
  }
  public void setxpos(float x) {
    xpos=x;
  }
  public void setypos(float y) {
    ypos=y;
  }
  public float getAcceleration() { 
    return accelerationSpeed;
  }
  public float getTopSpeed() { 
    return topSpeed;
  }
  public float getHandling() {
    return handling;
  }
  public int getHealth() { 
    return this.maxHealth;
  }
  public String name() { 
    return name;
  }
  public color getColor() {
    return col;
  }
}
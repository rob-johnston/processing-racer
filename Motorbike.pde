public class Motorbike implements Car {
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
  public int lap=0;
  
  float drag = -.01;   
  
   public Motorbike(float x, float y, float direction){
    this.xpos=x;
    this.ypos=y;
    this.direction = direction;
    this.acceleration = 0;
    this.speed=0;
    
    name = "motorbike";
              col = color(227,227,0);
              topSpeed = 7;
              accelerationSpeed = 9;
              handling = 7;
              maxHealth = 2;
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
      speed = 0;
      
    } else if ( xpos > 1400) {
      xpos = 1399;
      speed = 0;
      if(speed<0){
        speed =0;
      }
    }
    if (ypos < 0) {
      ypos = 1; 
      speed = 0;
    } else if ( ypos > 800) {
      ypos = 799;
      speed = 0;
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
       lap++; 
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
      speed = speed - .08;
      if (speed<0) {
        speed = speed +.08;
      }
      direction = direction - handling/ (4+(speed));

      xpos = xpos + (speed/4 * sin(radians(direction+90)));
      ypos = ypos + (speed/4 * cos(radians(direction+90)));
      if (checkObstacles()) {
        direction = direction + handling/ (4+(speed));

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
    //if ability is on lets to an awesome drift turn! - for the mototrbike we should adjust this to be a lean turn. motorbikes dont drift
    if (ability) {

      speed = speed - .08;
      if (speed<0) {
        speed = speed +.08;
      }
      direction = direction + handling/ (4+(speed));
      xpos = xpos + (speed/4 * sin(radians(direction-90)));
      ypos = ypos + (speed/4 * cos(radians(direction-90)));
      if (checkObstacles()) {
        direction = direction - handling/ (4+(speed));
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

//this is slightly different from the other cars since the bike only has 2 wheels
  public void tyreMarks() {
    float width = 15;
    float height = 25;
    //first corner
    //set square middle to origin        
    float corner1x = xpos-xpos;
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
    

   
  }



  public void brake() {
    //acceleration = acceleration - handling/10;
    speed = speed - handling/150;
    if (speed<-1) { 
      speed = -1;
    }
  }

  //draw the car/vehicle
  public void draw() {
    //position for drawing
    fill(this.col);
    pushMatrix();
    translate(xpos, ypos);
    rotate(radians(360)-radians(direction));
    rectMode(CENTER);

    //now draw 

    //base rectangle for the color
    float width = 8;
    float height = 20;
    noStroke();
    rect(0, 0, width+2, height+2);
    
    //wing mirrors
    rect(width/2,5,7,2);
    rect(0-width/2,5,7,2);
    fill(255,0,0);
    //helmet
    ellipse(0,2,7,8);
    //body
    fill(0);
    rect(0,-5,5,-7);
    
    //front and tyre
    //angled front
    stroke(this.col);
    strokeWeight(2);
    line(-width/2,height/2,0,height/2+2);
    line(width/2,height/2,0,height/2+2);
    //tyre
    stroke(0);
    fill(0);
    strokeWeight(2);
    line(0,height/2+2,0,height/2+4);
    
    
    
   //////
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
  public int getLapCount(){
     return lap; 
  }
}
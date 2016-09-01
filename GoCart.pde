
public class GoCart implements Car {
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
  
  public GoCart(float x, float y, float direction){
    this.xpos=x;
    this.ypos=y;
    this.direction = direction;
    this.acceleration = 0;
    this.speed=0;
    
     name = "gocart";
              col =  color(227,0,227);
              topSpeed = 7;
              accelerationSpeed = 6;
              handling = 9;
              maxHealth = 4;
              
              this.health=maxHealth;
    
  }
  
   //each tick we apply physics to our car and update its position
  public void update(){
      
      speed = speed + drag;
      if(speed<0) { speed = 0; }
      
      xpos = xpos + (speed * sin(radians(direction)));
      ypos = ypos + (speed * cos(radians(direction)));
      
      //check window bounds
      if(xpos < 0){
         xpos = 0; 
         speed = speed-.5;
      } else if( xpos > 1400) {
          xpos = 1400;
          speed = speed-.5;
      }
      if(ypos < 0){
         ypos = 0; 
         speed = speed-.5;
      } else if( ypos > 800) {
          ypos = 800;
          speed = speed-.5;
      }
        
      
      //have to check for collisions
     boolean crash = checkObstacles();
     if(crash) {
        health--;
        if(health <=0){
           //explode(); 
        }
        xpos = xpos - (speed * sin(radians(direction)));
        ypos = ypos - (speed * cos(radians(direction)));
        speed = speed -.5;
     }
  }
  
  public void accelerate(){
   //make the car go 
   speed = speed +  (accelerationSpeed-acceleration)/100;
   if(speed<0) {
        speed = 0; 
      }
      if(speed>topSpeed/2){
         speed=topSpeed/2; 
      }
  }
  
  public void turnRight(){
      direction = direction - handling/ (4+(speed/3)) ;
      if(ability){
         direction = direction - handling/ (4+(speed/3));
         speed = speed - .1;
         xpos = xpos + (speed/2 * sin(radians(direction+90)));
         ypos = ypos + (speed/2 * cos(radians(direction+90)));
      }
      ability=false;
  }
  
  public void turnLeft(){
    direction = direction + handling/ (4+(speed/3));
    if(ability){
         direction = direction + handling/ (4+(speed/3));
         speed = speed - .1;
         xpos = xpos + (speed/2 * sin(radians(direction-90)));
         ypos = ypos + (speed/2 * cos(radians(direction-90)));
      }
      ability=false;
  }
  
  public void brake(){
   //acceleration = acceleration - handling/10;
    speed = speed - handling/150;
    if(speed<0) { speed = 0; }
  }
  
  //determine the type of car and draw it
  public void draw(){
    fill(this.col);
    pushMatrix();
    translate(xpos,ypos);
    rotate(radians(360)-radians(direction));
    rectMode(CENTER);
    rect(0,0,15,25);
    popMatrix();
  }
  
  public boolean checkObstacles(){
     //here we want to check obstacles 
     Track t = getTrack();
     for(Barrier b : t.barriers){
        if(b.contains(new PVector(xpos,ypos))){
            return true;
        }
     }
    return false;
  }
  
  public void ability(){
    ability = true;
  }
  public void abilityOff(){
     ability = false; 
  }
public float getxpos(){
   return xpos;
  }
public float getypos(){
    return ypos;
}
public void setxpos(float x){  xpos=x; }
public void setypos(float y){ ypos=y; }
public float getAcceleration(){ return accelerationSpeed;}
public float getTopSpeed() { return topSpeed;}
public float getHandling(){return handling; }
public int getHealth(){ return this.maxHealth; }
public String name(){ return name; }
public color getColor(){return col;}
}
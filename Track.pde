/* represents a racing track in the game, consists of a collection of curve points to represent the tarmack and a collection of obstacles */

public class Track {
  
  PVector[] controlPoints;
  Barrier[] barriers;
  
  //a track needs a start/finish
  float startx = 55;
  float starty = 180;
  
  
  
  public Track(){
    
    // if we want a sick track we have to hard code - no real way around it for such a small assignment
    controlPoints = new PVector[18];
    controlPoints[0] = new PVector(100,100);
    controlPoints[1] = new PVector(100,700);
    controlPoints[2] = new PVector(300,700);
    controlPoints[3] = new PVector(400,600);
    controlPoints[4] = new PVector(450,600);
    controlPoints[5] = new PVector(700,600);
    controlPoints[6] = new PVector(800,500);
    controlPoints[7] = new PVector(900,600);
    controlPoints[8] = new PVector(1200,550);
    controlPoints[9] = new PVector(1100,200);
    controlPoints[10] = new PVector(1000,100);
    
    controlPoints[11] = new PVector(800,300);
    controlPoints[12] = new PVector(700,200);
    controlPoints[13] = new PVector(630,50);
    controlPoints[14] = new PVector(550,200);
    controlPoints[15] = new PVector(500,250);
    controlPoints[16] = new PVector(300,250);
    controlPoints[17] = new PVector(200,100);
    
    
    //now our barriers
    barriers = new Barrier[7];
    barriers[0] = new Barrier(150,150,30,500);
    barriers[1] = new Barrier(180,500,440,30);
    barriers[2] = new Barrier(1000,500,150,30);
    barriers[3] = new Barrier(640,400,380,30);
    barriers[4] = new Barrier(1000,160,30,400);
    barriers[5] = new Barrier(610,180,30,350);
    barriers[6] = new Barrier(1000,1000,30,100);
  }
  
  
  //draws the track on screen
  public void draw(){
  
  //first do the track
  noFill();
  strokeWeight(90);
  stroke(100);
  
  
for(int i = 0; i< controlPoints.length ; i++){
   //for each line get the four points it needs then use those to draw
   int start = i;
   int second = start+1; 
   if(second>=controlPoints.length) { second=0; }
   int third = second+1;
   if(third>=controlPoints.length){ third = 0; }
   int fourth = third+1;
   if(fourth>=controlPoints.length) { fourth = 0; }
   curve(controlPoints[start].x,controlPoints[start].y,controlPoints[second].x,controlPoints[second].y,
   controlPoints[third].x, controlPoints[third].y,controlPoints[fourth].x,controlPoints[fourth].y);
   }
   
   //now draw any barriers
   for(int i = 0; i< barriers.length ; i++){
     barriers[i].draw();
     
   }
   
   stroke(255);
   //now the finish line
   for(int i=0; i< 9; i++){
       if(i%2==1){
         stroke(255);
          fill(255);
       } else {
         stroke(0);
         fill(0);
       }
       rect((startx-10)+(i*10), starty,10,10);
   }
   
  
  }
    
   public boolean onTrack(PVector p){
       
     for(int i = 0; i< controlPoints.length ; i++){
         //for each line get the four points it needs then use those to draw
         
         int start = i;
         int second = start+1; 
         if(second>=controlPoints.length) { second=0; }
         int third = second+1;
         if(third>=controlPoints.length){ third = 0; }
         int fourth = third+1;
         if(fourth>=controlPoints.length) { fourth = 0; }
         for(float j = 0.0 ; j< 1 ; j+=.05){
           float centerx =curvePoint(controlPoints[start].x,controlPoints[second].x,controlPoints[third].x, controlPoints[fourth].x,j);
           float centery =curvePoint(controlPoints[start].y,controlPoints[second].y,controlPoints[third].y,controlPoints[fourth].y,j);
          
           if(  pow(p.x-centerx,2) + pow(p.y - centery,2) < pow(45,2) ){
             
             return true;            }
         }   
     }    
     return false;
 }
  
  
  
  
}

 class Barrier {
      float x;
      float y;
      float w;
      float h;
    
    public Barrier( float x, float y, float w, float h){
         this.x = x;
         this.y = y;
         this.w = w;
         this.h = h;
     }
     
     void draw (){
       rectMode(CORNER);
       strokeWeight(2);
       
       //fill(255,127,27);
       //rect(x,y,w,h);
       fill(0);
       if(this.w>this.h){
          for(float i=this.x; i<this.x+this.w; i+=50){
             fill(255); rect(i,this.y,25,25);
             fill(255,0,0); rect(i+25,this.y,25,25);
          }
       } else {
         for(float i=this.y; i<this.y+this.h; i+=50){
             fill(255); rect(this.x,i,25,25);
             fill(255,0,0); rect(this.x,i+25,25,25);
          }
       }
         
       
       
     }
     
     
     
     //takes a pvector and sees if its within this barrier, ie a crash
     boolean contains(PVector p){
         if(p.x>x && p.x<x+w && p.y>y && p.y< y+h){
            return true; 
         }
         return false;
     }
     //ambitious little method here that will check all four corners of a rectangle (our car) 
     //to see if that point is contained within the obstacle to detect a collision
     boolean contains(PVector p, float width, float height, float direction){
        
           //first corner
           //set square middle to origin        
           float corner1x = (p.x+width/2)-p.x;
           float corner1y = (p.y+height/2)-p.y;
            
            // now apply rotation
            float rotatedX = corner1x*cos(radians(360-direction)) - corner1y*sin(radians(360-direction));
            float rotatedY = corner1x*sin(radians(360-direction)) + corner1y*cos(radians(360-direction));
            // translate back
            float xx = rotatedX + (p.x);
            float yy = rotatedY + (p.y);
             
             if(xx>x && xx< x+w && yy>y && yy<y+h){
                 return true;
             }
             
             //second corner
              //set square middle to origin        
            corner1x = (p.x-width/2)-p.x;
            corner1y = (p.y-height/2)-p.y;
            
            // now apply rotation
             rotatedX = corner1x*cos(radians(360-direction)) - corner1y*sin(radians(360-direction));
             rotatedY = corner1x*sin(radians(360-direction)) + corner1y*cos(radians(360-direction));
            // translate back
             xx = rotatedX + (p.x);
             yy = rotatedY + (p.y);
             
             if(xx>x && xx< x+w && yy>y && yy<y+h){
                 return true;
             }
            
            //third
             //set square middle to origin        
            corner1x = (p.x-width/2)-p.x;
            corner1y = (p.y+height/2)-p.y;
            
            // now apply rotation
             rotatedX = corner1x*cos(radians(360-direction)) - corner1y*sin(radians(360-direction));
             rotatedY = corner1x*sin(radians(360-direction)) + corner1y*cos(radians(360-direction));
            // translate back
             xx = rotatedX + (p.x);
             yy = rotatedY + (p.y);
             
             if(xx>x && xx< x+w && yy>y && yy<y+h){
                 return true;
             }
             
             //fourth
              //set square middle to origin        
            corner1x = (p.x+width/2)-p.x;
            corner1y = (p.y-height/2)-p.y;
            
            // now apply rotation
             rotatedX = corner1x*cos(radians(360-direction)) - corner1y*sin(radians(360-direction));
             rotatedY = corner1x*sin(radians(360-direction)) + corner1y*cos(radians(360-direction));
            // translate back
             xx = rotatedX + (p.x);
             yy = rotatedY + (p.y);
             
             if(xx>x && xx< x+w && yy>y && yy<y+h){
                 return true;
             }
         return false;
     }

    
     
    
    
  }
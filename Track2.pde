/* represents a racing track in the game, consists of a collection of curve points to represent the tarmack and a collection of obstacles */

public class Track2 extends Track {
  
  PVector[] controlPoints;
  Barrier[] barriers;
  
  //a track needs a start/finish
  float startx = -40;
  float starty = 150;
  
  
  
  public Track2(){
    super();
    
    // if we want a sick track we have to hard code - no real way around it for such a small assignment
    controlPoints = new PVector[25];
controlPoints[0]=new PVector(65.0,580.0);
controlPoints[1]=new PVector(67.0,440.0);
controlPoints[2]=new PVector(66.0,288.0);
controlPoints[3]=new PVector(77.0,51.0);
controlPoints[4]=new PVector(297.0,124.0);
controlPoints[5]=new PVector(654.0,52.0);
controlPoints[6]=new PVector(731.0,168.0);
controlPoints[7]=new PVector(1085.0,127.0);
controlPoints[8]=new PVector(1307.0,52.0);
controlPoints[9]=new PVector(1315.0,343.0);
controlPoints[10]=new PVector(1236.0,517.0);
controlPoints[11]=new PVector(1352.0,695.0);
controlPoints[12]=new PVector(1008.0,657.0);
controlPoints[13]=new PVector(1119.0,322.0);
controlPoints[14]=new PVector(803.0,299.0);
controlPoints[15]=new PVector(834.0,697.0);
controlPoints[16]=new PVector(611.0,693.0);
controlPoints[17]=new PVector(622.0,278.0);
controlPoints[18]=new PVector(394.0,246.0);
controlPoints[19]=new PVector(229.0,273.0);
controlPoints[20]=new PVector(249.0,543.0);
controlPoints[21]=new PVector(433.0,584.0);
controlPoints[22]=new PVector(398.0,729.0);
controlPoints[23]=new PVector(203.0,731.0);
controlPoints[24]=new PVector(83.0,726.0);

    super.barriers = new Barrier[1];
    super.barriers[0] = new Barrier(1,2,3,4);
    
   
  }
  
  
  //draws the track on screen
  public void draw(){
  
  //first do the track
  noFill();
  strokeWeight(70);
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
 //  for(int i = 0; i< barriers.length ; i++){
   //  barriers[i].draw();
     
  // }
   strokeWeight(2);
   stroke(255);
   
   //now the finish line
   for(int i=0; i< 7; i++){
       if(i%2==1){
         stroke(255);
          fill(255);
       } else {
         stroke(0);
         fill(0);
       }
       rect((startx+65)+(i*10), starty,10,10);
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
          
           if(  pow(p.x-centerx,2) + pow(p.y - centery,2) < pow(37,2) ){
             
             return true;            }
         }   
     }    
     return false;
 }
  
  @Override
  public String toString(){
   return "track2";
  }
  
}

    
     
    
    
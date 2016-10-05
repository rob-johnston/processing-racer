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
          for(float i=this.x; i<this.x+this.w; i+=40){
             fill(255); rect(i,this.y,20,25);
             fill(255,0,0); rect(i+20,this.y,20,25);
          }
       } else {
         for(float i=this.y; i<this.y+this.h; i+=40){
             fill(255); rect(this.x,i,25,20);
             fill(255,0,0); rect(this.x,i+20,25,20);
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
             
             //going to check middle of sides as well
             
             //fifth
             //fourth
              //set square middle to origin        
            corner1x = (p.x+width/2)-p.x;
            corner1y = p.y-p.y;
            
            // now apply rotation
             rotatedX = corner1x*cos(radians(360-direction)) - corner1y*sin(radians(360-direction));
             rotatedY = corner1x*sin(radians(360-direction)) + corner1y*cos(radians(360-direction));
            // translate back
             xx = rotatedX + (p.x);
             yy = rotatedY + (p.y);
             
             if(xx>x && xx< x+w && yy>y && yy<y+h){
                 return true;
             }
             
             //sixth
            
              //set square middle to origin        
            corner1x = (p.x-width/2)-p.x;
            corner1y = p.y-p.y;
            
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
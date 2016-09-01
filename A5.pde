/* A 2D racing game implemented with Processing for CGRA151 at VUW */
import java.util.Date;

//0 = in menu, 1 = in game
private int gameStatus = 0;
//the players car
public Car player;
public Car[] cars;
//may be able to chose different tracks in future
public Track currentTrack = new Track();

public ArrayList<PVector> tyreMarks = new ArrayList<PVector>();

//dealing with multiple simultanious keys being held down is annoying
//so keep track of them here
ArrayList<String> heldKeys = new ArrayList<String>();
long time = System.currentTimeMillis();


void setup(){
    size(1400,800);
    showStartMenu();
  
}



void draw () {
  //dont do anything if we are in menu
  if (gameStatus == 0){
     return ;
  }
  //otherwise we are in game and this is our main game loop
  
  //logic stuff?
  //check keys
  checkInput();
  
  
  //drawing stuff
  //do the background
  background(0,127,0);
  //now the track
  currentTrack.draw();
  drawTyreMarks();
  currentTrack.onTrack(new PVector(player.getxpos(),player.getypos()));
  
  //now the cars - draw and update
  for(int i = 0; i < cars.length ; i ++){
    cars[i].update();
    cars[i].draw();
   }  
   long newtime = System.currentTimeMillis();
   text((newtime-time)/1000,1200,100);
   
  
  
  
  
  
}

void drawTyreMarks(){
 
  stroke(40);
  fill(40);
  noStroke();
  //draw the tyres
  if(tyreMarks.size()>200){
      stroke(90);
      fill(90);
     strokeWeight(1);
     for(int i = 0; i < tyreMarks.size()-200;i++){
      ellipse(tyreMarks.get(i).x,tyreMarks.get(i).y,2.5,2.5);
     }
     stroke(40);
    fill(40);
    strokeWeight(1);
     for(int i = tyreMarks.size()-200; i < tyreMarks.size();i++){
      ellipse(tyreMarks.get(i).x,tyreMarks.get(i).y,2.5,2.5);
     }
  }
  else {
    for(int i = 0; i < tyreMarks.size();i++){
      ellipse(tyreMarks.get(i).x,tyreMarks.get(i).y,2.5,2.5);
    }
  }
  
  //this array fills up fast so remove when over, say 300 points
  
}

/*shows the start menu - for car select */
void showStartMenu(){
  this.gameStatus = 0;
  background(255);
  fill(0);
  textSize(25);
  text("Select your car", 20,20);
  //give us some example cars to work with
  cars = new Car[4];
  //make the cars, also draw them and their stats
  for(int i = 1; i< 5 ; i++){
    switch(i){
     case 1: cars[i-1] = new MuscleCar(150*i,100,0); 
              break;
     case 2: cars[i-1] = new Truck(150*i,100,0); 
              break;    
     case 3: cars[i-1] = new GoCart(150*i,100,0); 
              break;
     case 4: cars[i-1] = new Motorbike(150*i,100,0); 
              break;         
    }
    cars[i-1].draw(); 
    rectMode(CORNER);
    textSize(20);
     //name
     text(cars[i-1].name(), (150*i)-30, 150);
    textSize(15);
     //accel
     
     text("Accelleration", (150*i)-50, 190);
     fill(0);
     rect((150*i)-50, 210, 100,20);
     fill(cars[i-1].getColor());
     rect((150*i)-50, 210, cars[i-1].getAcceleration()*10,20); 
    
     //top speed
    
     text("Top Speed", (150*i)-50, 260);
     fill(0);
     rect((150*i)-50, 270, 100,20);
     fill(cars[i-1].getColor());
     rect((150*i)-50, 270, cars[i-1].getTopSpeed()*10,20); 
     
     //handling
     
     text("Handling", (150*i)-50, 320);
     fill(0);
     rect((150*i)-50, 330, 100,20);
     fill(cars[i-1].getColor());
     rect((150*i)-50, 330, cars[i-1].getHandling()*10,20); 
     
      //health
     
     text("Health", (150*i)-50, 370);
     fill(0);
     rect((150*i)-50, 380, 100,20);
     fill(cars[i-1].getColor());
     rect((150*i)-50, 380, cars[i-1].getHealth()*10,20); 
     
  }
 
  
  
 
}

void mouseClicked(){
  //deal with menu choices
  if(gameStatus==0){
    if(mouseX > 130 && mouseX < 180){
       player = cars[0];
       readyGame();
    } else if (mouseX >280 && mouseX < 320){
       player = cars[1];
       readyGame();
    }else if (mouseX >430 && mouseX < 470){
       player = cars[2];
       readyGame();
    } else if (mouseX >580 && mouseX < 620){
        player = cars[3];
       readyGame();
    }
    
  } else {
      //otherwise we are in game and check for restart button   
  }  
}

//called when we start a game
void readyGame(){
  //get cars into position
  for(int i =0; i< cars.length; i++){
     cars[i].setxpos(currentTrack.startx + i*20); 
     cars[i].setypos(currentTrack.starty);
    time = System.currentTimeMillis();
  }
  
  gameStatus = 1;
    
  
}

void keyPressed(){
   if(key == CODED){
     if(keyCode == UP) {
         if(!heldKeys.contains("UP")){
           heldKeys.add("UP");
         }
     }
     if(keyCode == LEFT){
       if(!heldKeys.contains("LEFT")){
          heldKeys.add("LEFT");
       }
     }
     if(keyCode == RIGHT){
       if(!heldKeys.contains("RIGHT")){
          heldKeys.add("RIGHT"); 
       }
     }
     if(keyCode == DOWN){
       if(!heldKeys.contains("DOWN")){
         heldKeys.add("DOWN");
       }     
     }
     
   }
   if(key=='w'){
     if(!heldKeys.contains("w")){
       heldKeys.add("w");
     }
   }
}

void keyReleased(){
   if(key == CODED){
     if(keyCode == UP) {
         heldKeys.remove("UP");
     }
     if(keyCode == LEFT){
        heldKeys.remove("LEFT");
     }
     if(keyCode == RIGHT){
        heldKeys.remove("RIGHT"); 
     }
     if(keyCode == DOWN){
       heldKeys.remove("DOWN");
     }
   }
   if(key=='w'){
      heldKeys.remove("w"); 
      player.abilityOff();
   }
}


void checkInput(){
    if(heldKeys.contains("w")){
        player.ability();
    }
    for(String s : heldKeys){ 
      if(s=="UP"){
         player.accelerate();  
      } else if (s=="LEFT"){
         player.turnLeft(); 
      } else if (s=="RIGHT"){
         player.turnRight(); 
      }else if (s=="DOWN"){
         player.brake(); 
      } 
    }
}

public Track getTrack(){
    return currentTrack;
}


  
/* A 2D racing game implemented with Processing for CGRA151 at VUW */




//0 = in menu, 1 = in game
private int gameStatus = 0;
//the players car
public Car player;
//player 2's car
public Car player2;

public Car[] cars;
//may be able to chose different tracks in future
public Track currentTrack = new Track2();

public ArrayList<PVector> tyreMarks = new ArrayList<PVector>();
public ArrayList<PVector> mudMarks = new ArrayList<PVector>();

//dealing with multiple simultanious keys being held down is annoying
//so keep track of them here
ArrayList<String> heldKeys = new ArrayList<String>();

//lap time keeping
long time = System.currentTimeMillis();
int lapCount = 0;
long finalTime=0;




void setup(){
    size(1400,800);
    showStartMenu();
  
}


/*our main game and draw loop. Probably not idea to have all the physics tied in here with the rendering. But this is processing and not a game engine.
*/
void draw () {
  //dont do anything if we are in menu
  if (gameStatus == 0 || gameStatus ==3){
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
   player.update();
   player.draw();
   if(player2!=null){
    player2.update();
    player2.draw();
   }
    
  //now display the time
  
  long currentTime = System.currentTimeMillis();
  int secs;
  int mins;
  int hundredths;
  
  
  if(finalTime==0){
      secs = (int) ((currentTime-time) / 1000) % 60 ;
      mins = (int) ((currentTime-time) / (1000*60) % 60);
      hundredths   = (int) (currentTime-time) / (10) %100;
      fill(255);
      text(mins + ":"+secs+":"+hundredths,1200,100);
  }
    //and display the lap count
    text("P1 Laps completed: "+ player.getLapCount() + "/3", 1170,50);
    if(player2!=null){
        text("P2 Laps completed: "+ player2.getLapCount() + "/3", 1170,100);
    }
    
    
    //restart button in bottom right corner
    text("Menu",1325,775);
  
    // now deal with end of game display
     if(player.getLapCount()>=3){
       if(finalTime==0){
          finalTime= currentTime-time; 
       }
       
       if(finalTime!=0){
         secs = (int) ((finalTime) / 1000) % 60 ;
         mins = (int) ((finalTime) / (1000*60) % 60);
         hundredths   = (int) (finalTime) / (10) %100;
         fill(255);
         textSize(20);
         text("Final time: "+ mins + ":"+secs+":"+hundredths,700,400);
         text("Race Over",730,350);
       } 
       
     }
     
}
/* draws the tyre slide marks on screen*/
void drawTyreMarks(){
  
  println(tyreMarks.size());
 
  stroke(40);
  fill(40);
  
  //draw the tyres
  if(tyreMarks.size()>200){
      stroke(90);
      fill(90);
     strokeWeight(1);
     for(int i = 0; i < tyreMarks.size()-200;i++){
      ellipse(tyreMarks.get(i).x,tyreMarks.get(i).y,3,3);
     }
     stroke(40);
    fill(40);
    strokeWeight(1);
     for(int i = tyreMarks.size()-200; i < tyreMarks.size();i++){
      ellipse(tyreMarks.get(i).x,tyreMarks.get(i).y,3,3);
     }
  }
  else {
    stroke(40);
    for(int i = 0; i < tyreMarks.size();i++){
      ellipse(tyreMarks.get(i).x,tyreMarks.get(i).y,3,3);
    }
  }
  
  //repeat for mud marks
  if(mudMarks.size()>200){
      stroke(160,82,45);
      fill(160,82,45);
     strokeWeight(1);
     for(int i = 0; i < mudMarks.size()-200;i++){
      ellipse(mudMarks.get(i).x,mudMarks.get(i).y,3,3);
     }
     
    fill(160,82,45);
    strokeWeight(1);
     for(int i = mudMarks.size()-200; i < mudMarks.size();i++){
      ellipse(mudMarks.get(i).x,mudMarks.get(i).y,3,3);
     }
  }
  else {
    stroke(160,82,45);
    fill(160,82,45);
    for(int i = 0; i < mudMarks.size();i++){
      ellipse(mudMarks.get(i).x,mudMarks.get(i).y,3,3);
    }
  }
  
  
  
}

/*shows the start menu - for car and track select */
void showStartMenu(){
  this.lapCount=0;
  if(gameStatus!=0 && gameStatus!=3){
      this.gameStatus = 0;
  }
  background(255);
  fill(0);
  textSize(25);
   stroke(0);
  text("Select your car", 20,20);
  //give us some example cars to work with
  cars = new Car[4];
  //make the cars, also draw them and their stats
  for(int i = 1; i< cars.length+1 ; i++){
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
    fill(0);
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
  
  
  //now show the toggle track selection
  textSize(17);
  fill(0);
  text("Click to toggle track selection", 400,500);
  textSize(25);
  if(currentTrack.toString().equals("track")){
     text("Current:  Easy Track",400,550);
  } else {
     text("Current:  Advanced Track", 400,550); 
  }
 
 //now show if one or two player mode
 textSize(17);
  text("Click to toggle 1 or 2 player mode", 400,650);
  textSize(25);
  if(gameStatus==0){
   text("Current = 1 player - Click car choice to begin", 400,700);
  } else if(gameStatus==3) {
     if(player==null) { 
         text("Current = 2 player - Choose player 1",400,700);
     } else {
         text("Current = 2 player - Choose player 2 to begin",400,700); 
     }
    
  }
  
 
}
/*used to detect menu choices and for the menu button when in game*/
void mouseClicked(){
  //player mode switching
  if( mouseX>400 & mouseX<700 && mouseY>620 && mouseY<750){
         if(gameStatus==0){
            println("Entering 2 player mode");
            gameStatus=3;
            player=null; player2 =null;
         } else if (gameStatus==3){
           println("exiting 2 player mode");
          gameStatus=0; 
          player=null; player2=null;
         }
         showStartMenu();
    }
  //track selection switching
  if(mouseX > 400 && mouseX < 700 && mouseY> 450 && mouseY < 560){
        //toggle which track to use
        if(currentTrack.toString().equals("track")) {
           currentTrack = new Track2(); 
        } else {
           currentTrack = new Track(); 
        }
        //menu doesnt draw as part of the draw loop so we have to implicityly call to show the updated menu
        showStartMenu();
    } 
  
 
  //deal with menu choices
  if(gameStatus==0){
    if(mouseX > 130 && mouseX < 180 && mouseY<400){
       player = cars[0];
       readyGame();
    } else if (mouseX >280 && mouseX < 320 && mouseY<400){
       player = cars[1];
       readyGame();
    }else if (mouseX >430 && mouseX < 470 && mouseY<400){
       player = cars[2];
       readyGame();
    } else if (mouseX >580 && mouseX < 620 && mouseY<400){
        player = cars[3];
       readyGame();
    } 
    
  } else if (gameStatus==3){
        
    //two player mode selected
    if(player==null){
        if(mouseX > 130 && mouseX < 180 && mouseY<400){
         player = cars[0];
         showStartMenu();
      } else if (mouseX >280 && mouseX < 320 && mouseY<400){
         player = cars[1];
         showStartMenu();
      }else if (mouseX >430 && mouseX < 470 && mouseY<400){
         player = cars[2];
         showStartMenu();
      } else if (mouseX >580 && mouseX < 620 && mouseY<400){
          player = cars[3];
          showStartMenu();
      }  
      
    } else {
        if(mouseX > 130 && mouseX < 180 && mouseY<400){
         player2= new MuscleCar(100,100,0);
         readyGame();
      } else if (mouseX >280 && mouseX < 320 && mouseY<400){
         player2 = new Truck(100,100,0);
         readyGame();
      }else if (mouseX >430 && mouseX < 470 && mouseY<400){
         player2 = new GoCart(100,100,0);
         readyGame();
      } else if (mouseX >580 && mouseX < 620 && mouseY<400){
          player2 = new Motorbike(100,100,0);
          readyGame();
      }  
     
    }
  } else {
      //otherwise we are in game and check for restart/menu button   
      if(mouseX>1320 && mouseX <1400 && mouseY >750 && mouseY<800){
        readyGame();
        showStartMenu();
      }
  }  
}

//called when we start a game - gets everything ready
void readyGame(){
  //get car into position
  player.setxpos(currentTrack.startx +20); 
  player.setypos(currentTrack.starty);
  
  if(player2!=null){
    player2.setxpos(currentTrack.startx -20); 
    player2.setypos(currentTrack.starty);
  }
 
  //set up time and lap counting variables
  time = System.currentTimeMillis();
  lapCount = 0;
  finalTime=0;
  
  
  //make sure tyres arrays are clean
  tyreMarks.clear();
  mudMarks.clear();
  
  //chame games status to in game
  gameStatus = 1;
    
  
}
/*used to help deal with keyboard input for movement and slide turning*/
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
   if(key=='m'){
     if(!heldKeys.contains("m")){
       heldKeys.add("m");
     }
   }
   if(player2!=null){
         if(key == 'w'){
             if(!heldKeys.contains("w")){
               heldKeys.add("w");
             }
         }
           if(key=='a'){
              if(!heldKeys.contains("a")){
               heldKeys.add("a");
             }
           }
           if(key=='s'){
              if(!heldKeys.contains("s")){
               heldKeys.add("s");
             } 
           }
           if(key == 'd'){
             if(!heldKeys.contains("d")){
               heldKeys.add("d");
             }
           }
           
          if(key=='v'){
            if(!heldKeys.contains("v")){
               heldKeys.add("v"); 
              player2.ability();
            }
         }
   }
        
   
}

/*checks for released keys for movement and slide turning*/
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
   if(key=='m'){
      heldKeys.remove("m"); 
      player.abilityOff();
   }
   
 if(player2!=null){
   if(key == 'w'){
         heldKeys.remove("w");
   }
     if(key=='a'){
        heldKeys.remove("a");
     }
     if(key=='d'){
        heldKeys.remove("d"); 
     }
     if(key == 's'){
       heldKeys.remove("s");
     }
     if(key=='v'){
      heldKeys.remove("v"); 
      player2.abilityOff();
   }
 }
   
   
 }
   


/*this method checks for keyboard input and executes the apropriate action*/
void checkInput(){
    if(heldKeys.contains("m")){
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
    
    //if player 2 is there deal with their input too. 
    if(player2!=null){
      if(heldKeys.contains("v")){
         player2.ability(); 
       }
       for(String s: heldKeys){
         if(s=="w"){
             player2.accelerate(); 
          } else if(s=="a"){
             player2.turnLeft(); 
          } else if(s=="s"){
             player2.brake(); 
          } else if(s=="d"){
             player2.turnRight(); 
          }  
       }
    } 
}

public Track getTrack(){
    return currentTrack;
}




  
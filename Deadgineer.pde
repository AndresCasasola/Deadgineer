/*
*
*  Authors:
*  - Andres Casasola Dominguez
*  - Fernando Navarrete Mohedano
*
*  Game available in: https://github.com/AndresCasasola/Deadgineer
*
*/

import processing.serial.*;
import ddf.minim.*;  // Library Minim

/*****  Global Variables  *****/

PImage bg, explosion, winner, loser;
Player player1,player2;
ArrayList <Shot> shotsPlayer1, shotsPlayer2;
//int num_shots_1, num_shots_2;
int time1, time2;
Serial port;
int value, pointsp1, pointsp2, fin;
Marker marker;
int[] shotsToRemove1;
int[] shotsToRemove2;
Minim soundengine;
AudioSample PlayerHitSound;
boolean start, selected1, selected2;
PImage[] ImagePlayers;
int numImagePlayers;

/*****  Setup Function  *****/

void setup () {
  size(800,480);
  imageMode(CENTER);
  bg = loadImage("DEAD_bg.png");
  explosion = loadImage("explosion.png");
  winner = loadImage("trophy.png");
  loser = loadImage("Everyone.png");
  shotsPlayer1 = new ArrayList<Shot>();
  shotsPlayer2 = new ArrayList<Shot>();
  String portName = "/dev/ttyACM0";
  port = new Serial(this, portName, 9600);
  pointsp1=pointsp2=0;
  marker = new Marker(pointsp1, pointsp2);
  shotsToRemove1 = new int[5];
  shotsToRemove2 = new int[5];
  for(int i=0; i<5; i++){
      shotsToRemove1[i] = 0;
      shotsToRemove2[i] = 0;
  }
  fin=0;
  soundengine = new Minim(this);
  PlayerHitSound = soundengine.loadSample("sounds/HitSound.mp3", 1024);
  start = false;
  numImagePlayers = 6;
  ImagePlayers = new PImage[numImagePlayers];
  LoadImagePlayers();
  selected1=selected2=false;
  
}

/*****  Draw Function  *****/

void draw () {
  
  if(start==false){
    // Load Startscreen background
    PImage start_bg = loadImage("Deadgineer_Start2.png");
    background(start_bg);
    // Show players
    int x;
    int y = 320;
    int xOffset =500;
    for(int i=0; i<2; i++){    // files
      x = 60;
      for(int j=0; j<3; j++){  // columns
        image(ImagePlayers[3*i+j],x,y,65,90);                  // Draw player 1 images
        image(ImagePlayers[3*i+j],x+xOffset,y,65,90);          // Draw player 2 images
        x += 80;
      }
      y += 100;
    }
    
    // TODO:
    // Select players
    // Start game (start = true)
  
  }else{
    background(bg);
    marker.load_numbers();
    if(fin==0){
        player1.drawPlayer();
        player2.drawPlayer();
        player1.movePlayer();
        player2.movePlayer();
        
        for(int i = 0; i < shotsPlayer1.size(); i++){
          int xpos = shotsPlayer1.get(i).getX();
          int ypos = shotsPlayer1.get(i).getY();
          if(xpos < 800+50){
            shotsPlayer1.get(i).drawShot();
            shotsPlayer1.get(i).moveShot();
          }else{
            shotsPlayer1.remove(i);
          }
          if(collision(xpos, ypos, player2.getX(), player2.getY(), 40, 40, 20, 60)){
               shotsToRemove1[i] = 1;
               pointsp1++;
               PlayerHitSound.trigger();
               if(pointsp1<10) marker.set_v1(pointsp1);
          }
        }
        
        for(int i=0; i < shotsPlayer2.size(); i++){
          int xpos2 = shotsPlayer2.get(i).getX();
          int ypos2 = shotsPlayer2.get(i).getY();
          if(xpos2 > -50){
            shotsPlayer2.get(i).drawShot();
            shotsPlayer2.get(i).moveShot();
          }else{
            shotsPlayer2.remove(i);
          }
          for(int j=0; j<shotsPlayer1.size(); j++){
            int xpos1 = shotsPlayer1.get(j).getX();
            int ypos1 = shotsPlayer1.get(j).getY();
            if(collision(xpos1, ypos1, xpos2, ypos2, 40, 40, 20, 20)){
               shotsToRemove2[i] = 1;
               shotsToRemove1[j] = 1;
            }
          }
          if(collision(xpos2, ypos2, player1.getX(), player1.getY(), 40, 40, 20, 60)){
               shotsToRemove2[i] = 1;
               pointsp2++;
               PlayerHitSound.trigger();
               if(pointsp2<10) marker.set_v2(pointsp2);
          }
        }
        
        for(int i=4; i>=0; i--){
          if(shotsToRemove1[i] == 1){
            //image(explosion, 400,400, 20, 20);
            shotsPlayer1.remove(i);
            shotsToRemove1[i] = 0;
          }
          if(shotsToRemove2[i] == 1){
            //image(explosion, 400,400, 20, 20);
            shotsPlayer2.remove(i);
            shotsToRemove2[i] = 0;
            //delay(1000);
          }
          
        }
        
        if (pointsp1==10){
          fin=1;  
        }else if(pointsp2 == 10){
          fin=2;
        }
    }else {
      if(fin==1){
        image(winner, 200, height/2, 150, 150);
        image(loser, width-190, height/2, 265, 110);
      }
      if(fin==2){
        image(winner, width-200, height/2, 150, 150);
        image(loser, 200, height/2, 265, 110);
      }
    }
      
    if (port.available() > 0){
      value = port.read();
      println(value);
    if(value == 1 && shotsPlayer1.size() < 5 && ((millis() - time1) > 500) ){
      shotsPlayer1.add(new Shot(player1.getX()+55, player1.getY(), 1));
      time1 = millis();
    }
    if(value == 2 && shotsPlayer2.size() < 5 && ((millis() - time2) > 500) ){
      shotsPlayer2.add(new Shot(player2.getX()-55, player2.getY(), -1));
      time2 = millis();
    }
    }
  }
}

/*****  Auxiliar Functions  *****/

void mousePressed(MouseEvent event){
    if(start==true){
    /*if(event.getButton()==39 && shotsPlayer1.size() < 5 && ((millis() - time1) > 500) ){
      shotsPlayer1.add(new Shot(player1.getX()+55, player1.getY(), 1));
      time1 = millis();
    }
    if(event.getButton()==37 && shotsPlayer2.size() < 5 && ((millis() - time2) > 500) ){
      shotsPlayer2.add(new Shot(player2.getX()-55, player2.getY(), -1));
      time2 = millis();
    }*/  
  }else {
    if(event.getButton()==37 && selected1==false){
      if ((mouseY>275)&&(mouseY<365)){
        if ((mouseX>30)&&(mouseX<90)){
          player1 = new Player(50, height/2,1, "players/player0.png");
          selected1=true;
        }else if((mouseX>110)&&(mouseX<170)){ 
          player1 = new Player(50, height/2,1, "players/player1.png");  
          selected1=true;
        }else if((mouseX>190)&&(mouseX<250)){ 
          player1 = new Player(50, height/2,1, "players/player2.png");  
          selected1=true;
        }
      }else if((mouseY>375)&&(mouseY<465)){
        if ((mouseX>30)&&(mouseX<90)){ 
          player1 = new Player(50,height/2,1, "players/player3.png");  
          selected1=true;
        }else if((mouseX>110)&&(mouseX<170)){ 
          player1 = new Player(50,height/2,1, "players/player4.png");  
          selected1=true;
        }else if((mouseX>190)&&(mouseX<250)){ 
          player1 = new Player(50,height/2,1, "players/player5.png");  
          selected1=true;
        }
      }
    }
    if(event.getButton()==37  && selected2==false){
      if ((mouseY>275)&&(mouseY<365)){
        if ((mouseX>530)&&(mouseX<590)){ 
          player2 = new Player(width-50, height/2,-1, "players/player0.png");  
          selected2=true;
        }else if((mouseX>610)&&(mouseX<670)){
          player2 = new Player(width-50, height/2,-1, "players/player1.png");  
          selected2=true;
        }else if((mouseX>690)&&(mouseX<750)){ 
          player2 = new Player(width-50, height/2,-1, "players/player2.png");  
          selected2=true;
        }
      }else if((mouseY>375)&&(mouseY<465)){
        if ((mouseX>530)&&(mouseX<590)){ 
          player2 = new Player(width-50,height/2,-1, "players/player3.png");  
          selected2=true;
        }else if((mouseX>610)&&(mouseX<670)){ 
          player2 = new Player(width-50,height/2,-1, "players/player4.png");  
          selected2=true;
        }else if((mouseX>690)&&(mouseX<750)){ 
          player2 = new Player(width-50,height/2,-1, "players/player5.png");  
          selected2=true;
        }
      }
    }
    if(event.getButton()==37 && selected1==true && selected2==true){
      if((mouseY>328)&&(mouseY<380)){
        if ((mouseX>330)&&(mouseX<470)){ 
          start=true;
        }
      }

    }
  }
}

boolean collision(int p1x, int p1y, int p2x, int p2y, int p1w, int p2w, int p1h, int p2h){
  if(p1x+p1w>=p2x && p1x<=p2x+p2w && p1y+p1h>=p2y && p1y<=p2y+p2h){
    return true;
  }else{
    return false;
  }
}

void LoadImagePlayers(){
  for(int i=0; i<numImagePlayers; i++){
    String name = "data/players/player" + i + ".png";
    ImagePlayers[i] = loadImage(name);
  }
}


import processing.serial.*;
import ddf.minim.*;  // Library Minim

/*****  Global Variables  *****/

PImage bg,explosion,winner,loser;
Player player1,player2;
ArrayList <Shot> shotsPlayer1, shotsPlayer2;
//int num_shots_1, num_shots_2;
int time1, time2;
Serial port;
int value,pointsp1,pointsp2,fin;
Marker marker;
int[] shotsToRemove1;
int[] shotsToRemove2;
Minim soundengine;
AudioSample PlayerHitSound;

/*****  Setup Function  *****/

void setup () {
  size(800,480);
  imageMode(CENTER);
  bg = loadImage("DEAD_bg.png");
  explosion = loadImage("explosion.png");
  winner = loadImage("trophy.png");
  loser = loadImage("loser.png");
  player1 = new Player(50, height/2,1);
  player2 = new Player(width-50,height/2,-1);
  shotsPlayer1 = new ArrayList<Shot>();
  shotsPlayer2 = new ArrayList<Shot>();
  String portName = "/dev/ttyACM0";
  //port = new Serial(this, portName, 9600);
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
  PlayerHitSound = soundengine.loadSample("HitSound.mp3", 1024);
}

/*****  Draw Function  *****/

void draw () {
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
      
      println(shotsToRemove1);
      println(shotsToRemove2);
      
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
      image(winner, 100, height/2, 100, 100);
      image(loser, width-100, height/2, 100, 100);
    }
    if(fin==2){
      image(winner, width-150, height/2, 200, 200);
      image(loser, 150, height/2, 250, 200);
    }
  }
    
  /*if (port.available() > 0){
    value = port.read();
    println("Value: " + value);
  }*/

}

/*****  Auxiliar Functions  *****/

void mousePressed(MouseEvent event){
  if(event.getButton()==39 && shotsPlayer1.size() < 5 && ((millis() - time1) > 500) ){
    shotsPlayer1.add(new Shot(player1.getX()+55, player1.getY(), 1));
    time1 = millis();
  }
    if(event.getButton()==37 && shotsPlayer2.size() < 5 && ((millis() - time2) > 500) ){
    shotsPlayer2.add(new Shot(player2.getX()-55, player2.getY(), -1));
    time2 = millis();
  }  
}

boolean collision(int p1x, int p1y, int p2x, int p2y, int p1w, int p2w, int p1h, int p2h){
  if(p1x+p1w>=p2x && p1x<=p2x+p2w && p1y+p1h>=p2y && p1y<=p2y+p2h){
    return true;
  }else{
    return false;
  }
}

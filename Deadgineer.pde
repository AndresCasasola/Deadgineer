
import processing.serial.*;

/*****  Global Variables  *****/

PImage bg;
Player player1,player2;
ArrayList <Shot> shotsPlayer1, shotsPlayer2;
//int num_shots_1, num_shots_2;
int time1, time2;
Serial port;
int value;
Marker marker;
int[] shotsToRemove1;
int[] shotsToRemove2;

/*****  Setup Function  *****/

void setup () {
  size(800,480);
  imageMode(CENTER);
  bg = loadImage("DEAD_bg.png");
  player1 = new Player(50, height/2,1);
  player2 = new Player(width-50,height/2,-1);
  shotsPlayer1 = new ArrayList<Shot>();
  shotsPlayer2 = new ArrayList<Shot>();
  String portName = "/dev/ttyACM0";
  //port = new Serial(this, portName, 9600);
  marker = new Marker(0, 0);
  shotsToRemove1 = new int[5];
  shotsToRemove2 = new int[5];
  for(int i=0; i<5; i++){
      shotsToRemove1[i] = 0;
      shotsToRemove2[i] = 0;
  }
}

/*****  Draw Function  *****/

void draw () {
  background(bg);
  marker.load_numbers();
  player1.drawPlayer();
  player2.drawPlayer();
  player1.movePlayer();
  player2.movePlayer();
  
  for(int i = 0; i < shotsPlayer1.size(); i++){
    int xpos = shotsPlayer1.get(i).getX();
    if(xpos < 800+50){
      shotsPlayer1.get(i).drawShot();
      shotsPlayer1.get(i).moveShot();
    }else{
      shotsPlayer1.remove(i);
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
      if(collision(xpos1, ypos1, xpos2, ypos2, 40, 50, 40, 50)){
         shotsToRemove2[i] = 1;
         shotsToRemove1[j] = 1;
      }
    }
  }
  
  println(shotsToRemove1);
  println(shotsToRemove2);
  
  for(int i=4; i>=0; i--){
    if(shotsToRemove1[i] == 1){
      shotsPlayer1.remove(i);
      shotsToRemove1[i] = 0;
    }
    if(shotsToRemove2[i] == 1){
      shotsPlayer2.remove(i);
      shotsToRemove2[i] = 0;
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
    if(event.getButton()==37 && shotsPlayer1.size() < 5 && ((millis() - time2) > 500) ){
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

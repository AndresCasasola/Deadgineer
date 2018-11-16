
PImage bg;
Player player1,player2;
ArrayList<Shot> shotsPlayer1, shotsPlayer2;
//int num_shots_1, num_shots_2;
int time1, time2;

void setup () {
  size(800,480);
  imageMode(CENTER);
  bg = loadImage("Air-Hockey.png");
  player1 = new Player(50, height/2,1);
  player2 = new Player(width-50,height/2,-1);
  shotsPlayer1 = new ArrayList<Shot>();
  shotsPlayer2 = new ArrayList<Shot>();

}

void draw () {
  background(bg);
  player1.drawPlayer();
  player2.drawPlayer();
  player1.movePlayer();
  player2.movePlayer();
  
  for(int i = 0; i < shotsPlayer1.size(); i++){
    shotsPlayer1.get(i).drawShot();
    shotsPlayer1.get(i).moveShot(); 
  }
  for(int i = 0; i < shotsPlayer2.size(); i++){
    shotsPlayer2.get(i).drawShot();
    shotsPlayer2.get(i).moveShot();
  }

}

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

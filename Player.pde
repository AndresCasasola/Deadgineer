
class Player {
  int x, y;
  PImage playerImage;
  int dir;

  Player(int x_x, int y_y, int dir_dir) {
    x=x_x;
    y=y_y;
    playerImage=loadImage("trump.png");
    dir = dir_dir;
  }

  void drawPlayer() {
    image(playerImage,x,y,75,100);
  }

  void movePlayer() {
    if (y>(height-75)){
      dir = -1;
    }
    if (y<75){
      dir = 1;
    }
    y = y+dir;
  }
  
  int getX(){
    return x;
  }
  
  int getY(){
    return y;
  }
}

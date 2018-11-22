class Shot {
  int x, y;
  PImage shotImage;
  int dir;

  Shot(int x_x, int y_y, int dir_dir) {
    x=x_x;
    y=y_y;
    if(dir_dir==1){
      shotImage=loadImage("shot1.png");
    }else{
      shotImage=loadImage("shot2.png");
    }
    dir= dir_dir;
  }

  void drawShot() {
    image(shotImage,x,y,40,55);
  }

  void moveShot() {
    x += (dir*2);
}

  int getX(){
    return x;
  }
  
  int getY(){
    return y;
  }


}

class Shot {
  int x, y;
  PImage shotImage;
  int dir;

  Shot(int x_x, int y_y, int dir_dir) {
    x=x_x;
    y=y_y;
    if(dir_dir==1){
      shotImage=loadImage("rockets/shot1.png");
    }else{
      shotImage=loadImage("rockets/shot2.png");
    }
    dir= dir_dir;
  }

  void drawShot() {
    image(shotImage,x,y,40,55);  // 40, 55
  }

  void moveShot() {
    x += (dir*3);
}

  int getX(){
    return x;
  }
  
  int getY(){
    return y;
  }


}

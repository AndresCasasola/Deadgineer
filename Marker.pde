
class Marker {
  int v1, v2;
  PImage p1Image, p2Image;
  PImage[] numbers = new PImage[10];
  
  Marker(int new_v1, int new_v2){
    v1 = new_v1;
    v2 = new_v2;
    String name;
    for(int i=0; i<10; i++){
       name = "numbers/" + i + ".png";
       numbers[i] = loadImage(name);
    }
  }
  
  void set_v1(int new_v1){
    v1 = new_v1;
  }
  
  void set_v2(int new_v2){
    v2 = new_v2;
  }
  
  void load_numbers(){
    image(numbers[v1], width/2-30, 35, 25, 40);
    image(numbers[v2], width/2+20, 35, 25, 40);
  }
  
  
}

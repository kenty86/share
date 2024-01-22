PFont ebm;
PImage img1, img2, img3, img4, img5;
boolean is_menu_showed;
boolean is_game_played;
int score;
int position;
boolean is_game_over;
int MAX = 32;
int xmin, xmax, ymin, ymax;
Invader[] Invaders = new Invader[MAX];
Fort[] Forts = new Fort[4];


class Invader {
  boolean is_alive;
  int xpos, ypos;
  int Var;

  Invader(int x, int y){
    this.is_alive = true;
    this.xpos = x;
    this.ypos = y;
    this.Var = (int)random(3);
  }
}

class Fort {
  boolean is_broken;

  Fort(){
    this.is_broken = false;
  }
}

class Player {
  boolean is_alive;
  int remaining;
  
}



void setup() {
  size(600, 800);
  background(0);
  ebm = createFont("mg01_bmp8.ttf", 64);
  img1 = loadImage("img_200720_si_char_02.png");
  img2 = loadImage("img_200720_si_char_03.png");
  img3 = loadImage("img_200720_si_char_04.png");
  img4 = loadImage("fort.png");
  img5 = loadImage("player.png");
  is_menu_showed = true;
  is_game_played = false;
  init_data();

}

void draw() {
  background(0);
  if (is_menu_showed) show_menu();
  else if (is_game_played) play_game();
}

void show_menu() {
  textSize(40);
  textFont(ebm);
  textAlign(CENTER);
  fill(0xff, 0xff, 0x00);
  text("SPACE INVADER", width/2, height/3 + 10);

  textSize(25);
  fill(0xff);
  text("PRESS ENTER TO START", width/2, 2*height/3);
}
void init_data() {
  score = 0;
  position = width/2;
  for(int i=0; i<MAX; i++){
    Invaders[i] = new Invader(60*(i%8), 60*(i/8%4));
  }
  for(int i=0; i<4; i++){
    Forts[i] = new Fort();
  }
}

void show_data(){
  fill(0xff);
  textAlign(CORNER);
  text("SCORE:" + score, 20, 50);
}

void play_game() {
  show_data();
  draw_invaders(0,0);
  draw_forts();
  draw_player();
}

void draw_invaders(int x, int y){
  for(int i=0; i<MAX; i++){
    if(Invaders[i].is_alive == true){
      if(Invaders[i].Var == 0){
        image(img1, Invaders[i].xpos + x, Invaders[i].ypos + y);
      }
      else if(Invaders[i].Var == 1){
        image(img2, Invaders[i].xpos + x, Invaders[i].ypos + y);
      }
      else if(Invaders[i].Var == 2){
        image(img3, Invaders[i].xpos + x, Invaders[i].ypos + y);
      }
    }
  }
}

void draw_forts(){
  for(int i=0; i<4; i++){
    image(img4, 70 + 140*i, 600);
  }
}

void draw_player(){
  image(img5, position, 670);
}

void keyPressed() {
  if (keyCode == ENTER || keyCode == RETURN) {
    is_menu_showed = false;
    is_game_played = true;
  }
  if (keyCode == LEFT) {
    if(position - 10 > 50) position -= 10;
  }
  if (keyCode == RIGHT) {
    if(position + 10 < 550)  position += 10;
  }
}
PFont ebm;
boolean is_menu_showed;
boolean is_game_played;
int score;
int position;
boolean is_game_over;
int MAX = 32;
int xmin, xmax, ymin, ymax;
Invader[] Invaders = new Invader[MAX];
PImage img1, img2, img3;

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



void setup() {
  size(600, 800);
  background(0);
  ebm = createFont("mg01_bmp8.ttf", 64);
  img1 = loadImage("img_200720_si_char_02.png");
  img2 = loadImage("img_200720_si_char_03.png");
  img3 = loadImage("img_200720_si_char_04.png");
  is_menu_showed = true;
  is_game_played = false;

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
  for(int i=0; i<MAX; i++){
    Invaders[i] = new Invader(30 + 60*(i%8), 300 + 60*(i%4));
  }
}

void show_data(){
  fill(0xff);
  text("SCORE:" + score, 20, 20);
}

void play_game() {
  show_data();
  draw_invaders(0,0);
}

void draw_invaders(int x, int y){
  for(int i=0; i<MAX; i++){
    if(Invaders[i].is_alive == true){
      if(Invaders[i].Var == 1){
        image(img1, Invaders[i].xpos + x, Invaders[i].ypos + y);
      }
      else if(Invaders[i].Var == 2){
        image(img2, Invaders[i].xpos + x, Invaders[i].ypos + y);
      }
      else if(Invaders[i].Var == 3){
        image(img3, Invaders[i].xpos + x, Invaders[i].ypos + y);
      }

    }
  }
}

void keyPressed() {
  if (keyCode == ENTER || keyCode == RETURN) {
    is_menu_showed = false;
    is_game_played = true;
  }
  if (keyCode == LEFT) position -= 3;
  if (keyCode == RIGHT) position += 3;
}
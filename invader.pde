PFont ebm;
boolean is_menu_showed;
boolean is_game_played;
int score;
int position;
Invader[] Invaders = new Invader[32];

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

class Player{
  boolean is_alive;
  int position;

  Player(){
    this.is_alive = true;
    this.position = width/2;

  }

}



void setup() {
  size(600, 800);
  background(0);
  ebm = createFont("mg01_bmp8.ttf", 64);
  is_menu_showed = true;
  is_game_played = false;
}

void draw() {
  background(0);
  if (is_menu_showed) show_menu();
  else if (is_game_played) playgame();
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
}

void playgame() {
  text("aaaaaaaa",50,50);
}

void keyPressed() {
  if (keyCode == ENTER || keyCode == RETURN) {
    is_menu_showed = false;
    is_game_played = true;
  }
  if (keyCode == LEFT) position -= 3;
  if (keyCode == RIGHT) position += 3;
}
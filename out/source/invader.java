/* autogenerated by Processing revision 1293 on 2024-01-12 */
import processing.core.*;
import processing.data.*;
import processing.event.*;
import processing.opengl.*;

import java.util.HashMap;
import java.util.ArrayList;
import java.io.File;
import java.io.BufferedReader;
import java.io.PrintWriter;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.IOException;

PFont ebm;
boolean is_menu_showed;
boolean is_game_played;
int score;
invader invaders[] = new invader();

class invader{
    boolean is_alive;
    int var;

    void draw_invader(){
        if()
        {


        }

    }
}



void setup() {
    size(600,800);
    background(0);
    ebm = createFont("mg01_bmp8.ttf",64);
    is_menu_showed = true;
    is_game_played = false;
    
}

void draw(){
    background(0);
    if(is_menu_showed) show_menu();
    else if(is_game_played) playgame();
}

void show_menu(){
    textSize(40);
    textFont(ebm);
    textAlign(CENTER);
    fill(0xff,0xff,0x00);
    text("SPACE INVADER",width/2,height/3 + 10);
    
    textSize(25);
    fill(0xff);
    text("PRESS ENTER TO START", width/2, 2*height/3);
}
void init_data(){
    score = 0;
}

void playgame(){

}

void keyPressed(){
    if(keyCode == ENTER || keyCode == RETURN) {
        is_menu_showed = false;
        is_game_played = true;
    }
}

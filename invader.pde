/* グローバル変数 */
PFont ebm; // フォント
PImage img1, img2, img3, img4, img5; // 画像たち
boolean is_menu_showed; //　メニューが表示されているかどうか
boolean is_game_played; //　プレイが始まったかどうか
int score; // スコア
boolean direction_is_right = true; // モブが移動する方向
boolean pre_direction_is_right = true; // 一つ前のフレームにおいてモブがどっち向きだったか
boolean is_game_over; // ゲームオーバーかどうか
int MAX = 32; //モブの数
mob[] mobs = new mob[MAX]; // モブの配列
Fort[] Forts = new Fort[4]; // 守るための壁の配列
Player player = new Player(); // レーザー発射するやつ
enemy_laser[] elaser = new enemy_laser[30]; // モブが発射してくるレーザー光線の配列
friend_laser[] flaser = new friend_laser[30]; // 自分が発射するレーザー光線の配列
int index_f=0, index_e=0; //レーザー光線の配列の今どこですよを記憶する
int clock=0; // モブが早く動きすぎないようにするためのカウンタ的な

/* クラスの定義 */
class mob { // モブクラス
	boolean is_alive;
	int xpos, ypos;
	int Var;

	mob(int x, int y){
		this.is_alive = true;
		this.xpos = x;
		this.ypos = y;
		this.Var = (int)random(3);
	}

	void draw_mobs(){
		if(this.is_alive == true){
			if(this.Var == 0){
				image(img1, this.xpos, this.ypos);
			}
			else if(this.Var == 1){
				image(img2, this.xpos, this.ypos);
			}
			else if(this.Var == 2){
				image(img3, this.xpos, this.ypos);
			}
		}
	}

	void check_dir(){
		if(this.is_alive == true){
			if(this.xpos + 5 > width - 50) {
				direction_is_right = false; 
			}
			else if (this.xpos - 5 < 50) {
				direction_is_right = true;
			}
		}

		if(this.is_alive == true){
			if(this.ypos > player.ypos) is_game_over = true;
		}
	}

	void update_pos(){
		if(clock%50 == 0){
			if (direction_is_right == true) this.xpos += 5;
			else this.xpos -= 5;
		}
	}

	void go_down(){
		if(pre_direction_is_right != direction_is_right){
			this.ypos += 30;
		}
		
	}
}

class enemy_laser{
	int xpos, ypos;
	boolean is_invisible;

	enemy_laser(int x, int y) {
		this.xpos = x;
		this.ypos = y;
		is_invisible = false;
	}

	void draw_elaser(){
		if(this.is_invisible == false) {
			strokeWeight(5);
			stroke(0xff,0x00,0x00);
			line(this.xpos, this.ypos, this.xpos, this.ypos + 10);
			this.ypos += 5;
			if(this.ypos > height) this.is_invisible = true;
		}
	}

	void collision_detect(){
		for(int i=0; i<4; i++){
			if(abs(Forts[i].xpos - this.xpos) <= 40 && Forts[i].ypos - this.ypos == 10) {
				if(Forts[i].is_broken == false && this.is_invisible == false){
					this.is_invisible = true;
					Forts[i].HP -= 1;
					break;
				}
			}
		}
		if(abs(this.xpos - player.xpos) <= 40 && player.ypos - this.ypos == 10){
				is_game_over = true;
			}
		}


}

class Fort {
	boolean is_broken;
	int HP;
	int xpos, ypos;

	Fort(int x, int y){
		this.is_broken = false;
		HP = 3;
		this.xpos = x;
		this.ypos = y;
	}

	void draw_forts(int i){
		if(this.is_broken == false){
			image(img4, this.xpos, this.ypos);
			textSize(20);
			fill(0xff);
			text(this.HP,this.xpos,this.ypos);
		}
		
	}

	void check_HP(){
		if(this.HP <= 0) this.is_broken = true;
	}
}


class Player {
	boolean is_alive;
	int remaining;
	int xpos, ypos;

	Player(){
		is_alive = true;
		remaining = 3;
		xpos = width/2;
		ypos = 670;
	}
	void check_mouse(){
		this.xpos = mouseX;
	}
	void draw_player(){
		image(img5, this.xpos, this.ypos);
	}
}

class friend_laser {
	int xpos, ypos;
	boolean is_invisible;

	friend_laser(int x, int y) {
		this.xpos = x;
		this.ypos = y;
		this.is_invisible = false;
	}

	void draw_flaser(){
		if(this.is_invisible == false) {
			strokeWeight(3);
			stroke(0,255,0);
			line(this.xpos, this.ypos, this.xpos, this.ypos - 10);
		}
		this.ypos -= 5;
		if(this.ypos < 0) this.is_invisible = true;
	}

	void collision_detect(){
	  	for(int i=0; i<MAX; i++){
	    	if(abs(mobs[i].xpos - this.xpos) <= 20 && this.ypos - mobs[i].ypos == 0) {
				if(mobs[i].is_alive == true && this.is_invisible == false){
					this.is_invisible = true;
					mobs[i].is_alive = false;
					score += (mobs[i].Var + 1) * 10;
					break;
				}
			}
	  	}
		for(int i=0; i<4; i++){
			if(abs(Forts[i].xpos - this.xpos) <= 40 && this.ypos - Forts[i].ypos - 10 == 0){
				if(Forts[i].is_broken == false){
					this.is_invisible = true;
				}
			}
		}
	}
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
	imageMode(CENTER);
	init_data();
}

void draw() {
	background(0);
	if (is_menu_showed) show_menu();
	else if (is_game_played) play_game();
}

void show_menu() {
	textSize(35);
	textFont(ebm);
	textAlign(CENTER);
	fill(0xff, 0xff, 0x00);
	text("SPACE INVADER", width/2, height/3);

	textSize(25);
	fill(0xff);
	text("PRESS ENTER TO START", width/2, height/2);

	text("Use Mouse to Control Player",width/2, height/2 + 50);
	text("Click to Shoot Laser Beam", width/2, height/2 + 100);
	text("GOOD LUCK!", width/2, height/2 + 150);
}
void init_data() {
	score = 0;
	for(int i=0; i<MAX; i++){
		mobs[i] = new mob(50 + 60*(i%8), 120 + 60*(i/8%4));
	}
	for(int i=0; i<4; i++){
		Forts[i] = new Fort(90 + 140*i, 600);
	}
	for(int i=0; i<30; i++){
		flaser[i] = new friend_laser(0,0);
		elaser[i] = new enemy_laser(0,0);
	}

}

void show_data(){
	fill(0xff);
	textAlign(CORNER);
	textSize(30);
	text("SCORE:" + score, 20, 50);
}

void play_game() {
	if(is_game_over == false){
		show_data();
		player.check_mouse();
		player.draw_player();
		for(int i=0; i<4; i++){
			Forts[i].check_HP();
			Forts[i].draw_forts(i);
		}
		
		for(int i=0; i<MAX; i++){
			mobs[i].draw_mobs();
			mobs[i].check_dir();
		}
		for(int i=0; i<MAX; i++){
			mobs[i].update_pos();
			mobs[i].go_down();
		}
		for(int i=0; i<30; i++){
			flaser[i].collision_detect();
			flaser[i].draw_flaser();
			elaser[i].collision_detect();
			elaser[i].draw_elaser();
		}
		if(clock%200==0){
			int temp = (int)random(30);
			elaser[index_e] = new enemy_laser(mobs[temp].xpos, mobs[temp].ypos);
			if(index_e < 29) index_e++;
			else index_e = 0;
		}
		clock++;
		pre_direction_is_right = direction_is_right;
	}
	
	else if(is_game_over == true){
		fill(0xff,0x00,0x00);
		textSize(60);
		textAlign(CENTER);
		text("GAME IS OVER", width/2, height/3);
		textSize(40);
		fill(0xff);
		text("SCORE:" + score, width/2, height/2);
		text("Press R to Restart", width/2, height * 2/3);
	}
}

void keyPressed() {
	if (keyCode == ENTER || keyCode == RETURN) {
		is_menu_showed = false;
		is_game_played = true;
	}
	if (key == 'r'){
		init_data();
		is_game_over = false;
	}
}

void mousePressed(){
	flaser[index_f] = new friend_laser(player.xpos, player.ypos - 10);
	if(index_f < 29) index_f++;
	else index_f = 0;
}
/*
学籍番号:	2022531047
氏　　名:	中山　涼太
アプリ名:	スペースインベーダー
使い方　:	基本操作はマウスのみで可能
 */

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
int temp = 0;

/* クラスの定義 */
class mob { // モブクラス
	boolean is_alive; // モブの状態
	int xpos, ypos; // モブの位置
	int Var; // モブの種類

	mob(int x, int y){ // コンストラクタ
		this.is_alive = true;
		this.xpos = x;
		this.ypos = y;
		this.Var = (int)random(3); //乱数で適当に種類を決める
	}

	void draw_mobs(){ //モブを描く（画像）
		if(this.is_alive == true){ //モブが生きているならば
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

	void check_dir(){ // モブがUターンするタイミングを決める
		if(this.is_alive == true){ //生きているモブに対して
			if(this.xpos + 5 > width - 50) { //右の方まで来たら
				direction_is_right = false;  //左向きにする
			}
			else if (this.xpos - 5 < 50) { //左の方まで来たら
				direction_is_right = true; //右向きにする
			}
		}

		if(this.is_alive == true){ //生きているモブが
			if(this.ypos > player.ypos) is_game_over = true; //プレイヤーの陣地に入ってきたらゲームオーバー
		}
	}

	void update_pos(){ //モブの位置を更新
		if(clock%50 == 0){ //
			if (direction_is_right == true) this.xpos += 5; //5px右に
			else this.xpos -= 5; //5px左に
		}
	}

	void go_down(){ //モブが迫ってくる
		if(pre_direction_is_right != direction_is_right){ //進行方向が変わったタイミングで
			this.ypos += 30;  //下に30px移動
		}
		
	}
}

class enemy_laser{ //敵のレーザーのクラス
	int xpos, ypos; //レーザーの位置
	boolean is_invisible; //表示するかどうか

	enemy_laser(int x, int y) { //コンストラクタ
		this.xpos = x;
		this.ypos = y;
		is_invisible = false;
	}

	void draw_elaser(){ //e(nemy)laserを動かす
		if(this.is_invisible == false) { //レーザーが生きてるならば
			strokeWeight(5); //太さは5px
			stroke(0xff,0x00,0x00); //色は赤
			line(this.xpos, this.ypos, this.xpos, this.ypos + 10); //線を描く
			this.ypos += 5; //動かすために縦に5px動かす
			if(this.ypos > height) this.is_invisible = true; //画面外では表示しない
		}
	}

	void collision_detect(){ //当たり判定を判定するfunc
		for(int i=0; i<4; i++){ //砦に当たった際に砦のHPを減らす
			if(abs(Forts[i].xpos - this.xpos) <= 40 && Forts[i].ypos - this.ypos == 10) { 
				if(Forts[i].is_broken == false && this.is_invisible == false){
					this.is_invisible = true;
					Forts[i].HP -= 1;
					break;
				}
			}
		}
		if(abs(this.xpos - player.xpos) <= 40 && player.ypos - this.ypos == 10){ //自陣に侵入してきたらゲームオーバーにする
				is_game_over = true;
			}
		}
	}

class Fort { //砦のクラス
	boolean is_broken; //壊れているか
	int HP; //ヒットポイント
	int xpos, ypos; //位置

	Fort(int x, int y){ //コンストラクタ
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
			text(this.HP,this.xpos,this.ypos); //HPは数字で表示することにした
		}
		
	}

	void check_HP(){ //HPが0になったら非表示にする
		if(this.HP <= 0) this.is_broken = true;
	}
}


class Player { //プレイヤーが操作するオブジェクトのクラス
	int xpos, ypos;

	Player(){
		xpos = width/2;
		ypos = 670;
	}
	void check_mouse(){ //マウスの位置を使用
		this.xpos = mouseX;
	}
	void draw_player(){ 
		image(img5, this.xpos, this.ypos);
	}
}

class friend_laser { //自分のレーザービ〜ムのクラス
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
	ebm = createFont("mg01_bmp8.ttf", 64); //使用するフォント（ゲームっぽく）
	img1 = loadImage("img_200720_si_char_02.png"); //モブ１
	img2 = loadImage("img_200720_si_char_03.png"); //モブ２
	img3 = loadImage("img_200720_si_char_04.png"); //モブ３
	img4 = loadImage("fort.png"); //砦(自分は砦だと思っている)
	img5 = loadImage("player.png"); //操作する砲台（？）
	is_menu_showed = true; //メニュー画面を表示させておく
	is_game_played = false; //ゲームは始まっていない
	imageMode(CENTER);
	init_data(); //ゲームを始める準備
}

void draw() {
	background(0);
	if (is_menu_showed) show_menu();
	else if (is_game_played) play_game();
}

void show_menu() { //メニュー画面の詳細
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

void init_data() { //イニシャライズ
	score = 0; //スコアは0
	for(int i=0; i<MAX; i++){
		mobs[i] = new mob(50 + 60*(i%8), 120 + 60*(i/8%4)); //モブの位置を決定
	}
	for(int i=0; i<4; i++){
		Forts[i] = new Fort(90 + 140*i, 600); //砦の位置を決定
	}
	for(int i=0; i<30; i++){
		flaser[i] = new friend_laser(0,0); //レーザー配列をぬるぽがで内容に初期化
		elaser[i] = new enemy_laser(0,0);
	}

}

void show_data(){ //スコアを表示させるだけの機能
	fill(0xff);
	textAlign(CORNER);
	textSize(30);
	text("SCORE:" + score, 20, 50);
}

void play_game() {
	if(is_game_over == false){ //ゲームオーバーじゃない時
		show_data(); //スコアを表示
		player.check_mouse(); //マウスの位置を取得
		player.draw_player(); //プレイヤーを表示
		for(int i=0; i<4; i++){ //砦関係
			Forts[i].check_HP();
			Forts[i].draw_forts(i);
		}
		for(int i=0; i<MAX; i++){ //モブ関係1
			mobs[i].draw_mobs();
			mobs[i].check_dir();
		}
		for(int i=0; i<MAX; i++){ //モブ関係2
			mobs[i].update_pos();
			mobs[i].go_down();
		}
		for(int i=0; i<30; i++){ //レーザー関係
			flaser[i].collision_detect();
			flaser[i].draw_flaser();
			elaser[i].collision_detect();
			elaser[i].draw_elaser();
		}
		if(clock%100==0){
			temp = (int)random(30);
			elaser[index_e] = new enemy_laser(mobs[temp].xpos, mobs[temp].ypos);
			if(index_e < 29) index_e++;
			else index_e = 0;
		}
		clock++;
		pre_direction_is_right = direction_is_right;
	}
	else if(is_game_over == true){ //ゲームオーバー時の画面表示
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
	if (key == 'r' && is_game_over){
		init_data();
		is_game_over = false;
	}
}

void mousePressed(){
	flaser[index_f] = new friend_laser(player.xpos, player.ypos - 10);
	if(index_f < 29) index_f++;
	else index_f = 0;
}
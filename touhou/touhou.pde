//グローバル変数
int NumOfBullet = 0 , NumOfRect = 0 , NumOfCParts = 0 , NumOfBullet2 = 0 , NumOfbomb = 0 ,
NumOfsinb = 0,NumOfcosb = 0 , NumOfgear = 0 , NumOfgearb = 0;
//NumOfBullet:弾の数 NumOfRect : 敵の攻撃弾の数。//NumOfCparts : 敵の円状攻撃弾の数。
int picture = 0;
float A = 50,fire = 10,T = 360, biase = 0;//sin関数における値。A:振幅,fire:一周期においての弾の発射数,T:周期,biase:バイアス
int usebullet = 0; //着目する弾
int frameCount = 0; //フレーム数値
int x_count = 0 , enemy_count = 0; //xが押されている間のフレーム数,敵に触れているフレーム時間
int Game_width = 512;
int phase = 0; //フェーズ管理
boolean z_push = false , x_push = false; //Z判定
boolean game_play = true; //ゲームプレイ
boolean Enter_pushed = false;
boolean ckey = false ,ekey = false;//終了判定時に使うキータイプ
boolean gear_push = true;
//--------------------------------
//クラス宣言
Player player; //プレイヤーを宣言
Enemy enemy; //敵を宣言
ArrayList<Enemy> gear; //歯車形の敵
ArrayList<Weapon> bullets; //弾の動的配列を定義
ArrayList<Weapon> bullet2; //弾の動的配列を定義
ArrayList<Weapon> bomb; //ボムを定義
ArrayList<Weapon> Rect_attack; //敵弾の動的配列を定義 
ArrayList<Weapon> Cparts; //敵弾の動的配列を定義
ArrayList<Weapon> sinb; //Sin状に敵弾を並べる。
ArrayList<Weapon> cosb; //Cos状に敵弾を並べる。
ArrayList<Weapon> gear_bullet;//ギアが発射する弾丸
//--------------------------------
PImage shiratuyu;
PImage shiratuyu_head;
PImage murasame;
PImage murasame_head;
//最初の動作。
void setup() {
    size(800, 800);
    rectMode(CENTER);
    ellipseMode(CENTER);
    colorMode(HSB,400);
    //ファイル読み込み
    shiratuyu = loadImage("shiratuyu_dot.png");
    murasame = loadImage("murasame.png");
    shiratuyu_head = loadImage("shiratuyu.head.png");
    murasame_head = loadImage("murasame_head.png");
    //クラス定義
    player = new Player(Game_width / 2,height / 3,false,false,false,false,5,350,350,70,70); //playerの初期化。
    //Player(x初期値,y初期値,上キー,下キー,右キー,左キー,プレイヤースピード,HP,Max_HP,XP,Max_XP)
    enemy = new Enemy(Game_width / 2,height / 4,50,50,16000,16000,true);
    //Enemy(x初期値,y初期値,xサイズ,yサイズHP,Max_HP,ボスかどうか)
    gear = new ArrayList<Enemy>();
    bullets = new ArrayList<Weapon>(); //味方の弾を定義
    bullet2 = new ArrayList<Weapon>(); //味方の弾(二個目)を定義
    bomb = new ArrayList<Weapon>(); //ボムを定義。
    Rect_attack = new ArrayList<Weapon>(); //敵の玉を定義
    Cparts = new ArrayList<Weapon>(); //敵の弾を定義
    sinb = new ArrayList<Weapon>(); //Sin弾を定義。
    cosb = new ArrayList<Weapon>(); //cos弾を定義。
    gear_bullet = new ArrayList<Weapon>(); //ギアの発射弾を定義。
}
//繰り返し処理。
void draw() {
    background(0); //画面の初期化
    if (phase == 0) {
        color(255);
        textSize(60);
        text("Press C" , width / 2 - 80, height / 2);
        if (ckey) {
            phase = 1;
        }
    }
    if (game_play && phase > 0) {
        status();
        judge_phase(); //フェーズ管理
        player.display(); //プレイヤー表示
        player.movement(); //プレイヤーを動かす。 
        enemy.display(); //敵を表示
        enemy.enemy_move(); //敵の動き
        enemy.HP_gauge(); //敵のHP
        if (z_push) {
            if ((player.speed == 5 && frameCount % 5 == 0) || (player.speed == 2 && frameCount % 2 == 0)) {
                bullets.add(new Weapon(player.x - 10,player.y - 22,20,10,0,0,0));//弾の生成
                bullet2.add(new Weapon(player.x + 10,player.y - 22,20,10,0,0,0));//弾の生成
                NumOfBullet++;
                NumOfBullet2++;
            }
        }
        if (x_push) {
            if (player.XP >= 10 && x_count == 1) {
                NumOfbomb = 8;
                for (int i = 0; i < NumOfbomb; i++) {
                    bomb.add(new Weapon(random(100,400),random(100,700),20,30,10,0,0));
                }
                player.XP -= bomb.get(0).XP;
            }
            x_count++;
        }
        else{
            x_count = 0;
        }
        if (phase == 1 && frameCount % 10 == 0) {
            Rect_attack.add(new Weapon(random(500),random(200),10,15,0,0,0));
            NumOfRect++;
        }
        if (phase == 2 && frameCount % 10 == 0) {
            for (int i = 0; i < 30; i++) {
                Cparts.add(new Weapon(enemy.x,enemy.y,3,5,0,(12 * i) + NumOfCParts / 30,(12 * i) + NumOfCParts / 30));
                NumOfCParts++;
            }
        }
        if (phase == 3 && frameCount % 60 == 0) {
            for (int i = 0; i < 2; i++) {
                for (int j = 0; j < T / fire; j++) {
                    if (T * i + (T / fire) * j < Game_width) {
                        sinb.add(new Weapon(T * i + (T / fire) * j , A * sin(radians(36 * j)),0.02,5,0,90,90));
                        NumOfsinb++;
                    }
                    if (T * i + (T / fire) * j < Game_width) {
                        cosb.add(new Weapon(T * i + (T / fire) * j , height - A * cos(radians(36 * j)),0.02,5,0,90, -90));
                        NumOfcosb++;
                    }
                }
            }
        }
        if (phase == 4) {
            if (gear_push) {
                NumOfgear = 8;
                for (int i = 0; i < NumOfgear; i++) {
                    gear.add(new Enemy(enemy.x,enemy.y,50,50,5000,5000,false));
                }
                gear_push = false;
            }
            if (frameCount % 10 == 0) {
                float dx,dy;
                for (int i = 0; i < NumOfgear - 1; i++) {
                    dx = player.x - gear.get(i).x;
                    dy = player.y - gear.get(i).y;
                    gear_bullet.add(new Weapon(gear.get(i).x,gear.get(i).y,10,5,0,degrees(atan2(dy,dx)),degrees(atan2(dy,dx))));
                    NumOfgearb++;
                }
                dx = player.x - enemy.x;
                dy = player.y - enemy.y;
                gear_bullet.add(new Weapon(enemy.x,enemy.y,15,5,0,degrees(atan2(dy,dx)),degrees(atan2(dy,dx))));
                NumOfgearb++;
            }
        }
        //Weapon(初期x座標,初期y座標,弾速,攻撃力,消費XP,x進行方向,y進行方向)
        control_bullet();
        control_rect();
        control_cparts();
        control_bomb();
        control_tetra();
        control_gear();
        frameCount++;
    }
    judge();
    if (!game_play) {
        continue_judge();
    }
}
// キー押下時
void keyPressed() {
    //プレイヤーの動作
    if (key == CODED) {
        if (keyCode == UP) {
            player.is_up = true;
        }
        if (keyCode == DOWN) {
            player.is_down = true;
        }
        if (keyCode == RIGHT) {
            player.is_right = true;
        }
        if (keyCode == LEFT) {
            player.is_left = true;
        }
        if (keyCode == SHIFT) {
            player.speed = 2;
        }
    }
    if (key == 'z' || key == 'Z') {
        z_push = true;
    }
    if (key == 'c' || key == 'C') {
        ckey = true;
    }
    if (key == 'e' || key == 'E') {
        ekey = true;
    }
    if (key == 'x' || key == 'X') {
        x_push = true;
    }
}

// キーを離したとき
void keyReleased() {
    //プレイヤーの動作
    if (key == CODED) {
        if (keyCode == UP) {
            player.is_up = false;
        }
        if (keyCode == DOWN) {
            player.is_down = false;
        }
        if (keyCode == RIGHT) {
            player.is_right = false;
        }
        if (keyCode == LEFT) {
            player.is_left = false;
        }
        if (keyCode == SHIFT) {
            player.speed = 5;
        }
    }
    if (key == 'z' || key == 'Z') {
        z_push = false;
    }
    if (key == 'c' || key == 'C') {
        ckey = false;
    }
    if (key == 'e' || key == 'E') {
        ekey = false;
    }
    if (key == 'x' || key == 'X') {
        x_push = false;
    }
}
class Player{
    //フィールドの宣言
    //プレイヤー表示
    //プレイヤーの座標。
    float x;
    float y;
    //十字キーが押されているかの判定
    boolean is_up;
    boolean is_down;
    boolean is_right;
    boolean is_left;
    //---------------
    boolean movable = true;
    float speed; //プレイヤーの移動スピードを定義。
    float HP;
    float Max_HP;
    float XP;
    float Max_XP;
    //コンストラクタを宣言
    Player(float position_x,float position_y,boolean up,boolean down,boolean right,boolean left,float speed_arg , float health , float Max_HP,float XP, float Max_XP) {
        x = position_x;
        y = position_y;
        is_up = up;
        is_down = down;
        is_right = right;
        is_left = left;
        speed = speed_arg;
        HP = health;
        this.Max_HP = Max_HP;
        this.XP = XP;
        this.Max_XP = Max_XP;
    }
    // Playerクラス内で使用する関数
    void display() {
        noStroke();
        image(shiratuyu,x - 50,y - 55);
    }
    // プレイヤーを動かす。
    void movement() {
        if (y > 0 && is_up) {
            y -= speed;
            //-----敵に当たった時-----//
            if (dist(x,y,enemy.x,enemy.y) < 40) {
                y += speed;
                player.HP -= 1;
            }
        }
        if (y <= height && is_down) {
            y += speed;
            //----敵に当たった時-----//
            if (dist(x,y,enemy.x,enemy.y) < 40) {
                y -= speed;
                player.HP -= 1;
            }
        }
        if (x <= Game_width && is_right) {
            x += speed;
            //-----敵に当たった時-----//
            if (dist(x,y,enemy.x,enemy.y) < 40) {
                x -= speed;
                player.HP -= 1;
            }
        }
        if (x >= 0 && is_left) {
            x -= speed;
            //-----敵に当たった時-----//
            if (dist(x,y,enemy.x,enemy.y) < 40) {
                x += speed;
                player.HP -= 1;
            }
        }
    }
}
// 弾のクラスを宣言
class Weapon{
    //フィールドの宣言
    float x;
    float y;
    float speed;
    float atk;
    float XP;
    float vecX;
    float vecY;
    float r = 0; //r : 半径
    float biase = 0;
    //Weaponクラスのコンストラクタ
    Weapon(float xpos ,float ypos,float sped, float attack,float XP,float vecX,float vecY) {
        x = xpos;
        y = ypos;
        speed = sped;
        atk = attack;
        this.XP = XP;
        this.vecX = cos(radians(vecX));
        this.vecY = sin(radians(vecY));
    }
    // 使用関数宣言
    // 球を動かす
    void movebullet() {
        fill(0,0,400);
        noStroke();
        y -= speed;
        ellipse(x,y,10,10);
    }
    //四角形を落とす
    void rect_fall() {
        noStroke();
        fill(x,y,400);
        y += speed;
        rect(x,y,50,50);
    }
    //円状に弾を発射する
    void cbullet() {
        noStroke();
        fill(0,0,400);
        r += speed / 30;
        x += r * vecX;
        y += r * vecY;
        rect(x,y,10,10);
    }
    void bomb() {
        r += speed / NumOfbomb;
        strokeWeight(2);
        noFill();
        stroke(x,y,400);
        ellipse(x, y, r, r);
    }
    void tetrab() {
        x += biase * vecX;
        y += biase * vecY;
        noStroke();
        fill(0,0,400);
        rect(x,y,10,10);
        biase += speed;
    }
}
//自機弾の制御
void control_bullet() {
    for (int i = 0; i < NumOfBullet - 1; i++) {
        bullets.get(i).movebullet();
        if (bullets.get(i).y < 0) {
            bullets.remove(i);
            NumOfBullet--;
        }
        if ((bullets.get(i).x < enemy.x + 30 && bullets.get(i).x > enemy.x - 30) && (bullets.get(i).y > enemy.y - 30 && bullets.get(i).y < enemy.y + 30)) {
            enemy.HP -= bullets.get(i).atk;
            bullets.remove(i);
            NumOfBullet--;
        }
    }
    for (int i = 0; i < NumOfBullet2 - 1; i++) {
        bullet2.get(i).movebullet();
        if (bullet2.get(i).y < 0) {
            bullet2.remove(i);
            NumOfBullet2--;
        }
        if ((bullet2.get(i).x < enemy.x + 30 && bullet2.get(i).x > enemy.x - 30) && (bullet2.get(i).y > enemy.y - 30 && bullet2.get(i).y < enemy.y + 30)) {
            enemy.HP -= bullet2.get(i).atk;
            bullet2.remove(i);
            NumOfBullet2--;
        }
    }
}
//ボムの制御
void control_bomb() {
    float distance = 500;
    if (NumOfbomb > 0) {
        for (int i = 0; i < NumOfbomb - 1; i++) {
            bomb.get(i).bomb();
            if (bomb.get(i).r > 200) {
                bomb.remove(i);
                NumOfbomb--;
            }
            distance = dist(bomb.get(i).x,bomb.get(i).y,enemy.x,enemy.y); //敵とボムの距離
            if (distance < bomb.get(i).r) {
                enemy.HP -= bomb.get(i).atk;
            }
            //ボムと四角形の間の距離を計算し処理
            if (phase == 1 && NumOfRect > 0) {
                for (int j = 0; j < NumOfRect; j++) {
                    distance = dist(bomb.get(i).x,bomb.get(i).y,Rect_attack.get(j).x,Rect_attack.get(j).y); //ボムと四角形の間の距離。
                    if (distance < bomb.get(i).r + 25) {
                        Rect_attack.remove(j);
                        NumOfRect--;
                    }
                }
            }
            else if (phase == 2 && NumOfCParts > 0) {
                for (int j = 0; j < NumOfCParts; j++) {
                    distance = dist(bomb.get(i).x,bomb.get(i).y,Cparts.get(j).x,Cparts.get(j).y);
                    if (distance < bomb.get(i).r + 5) {
                        Cparts.remove(j);
                        NumOfCParts--;
                    }
                }
            }
            else if (phase == 3) {
                if (NumOfsinb > 0) {
                    for (int j = 0; j < NumOfsinb; j++) {
                        distance = dist(bomb.get(i).x,bomb.get(i).y,sinb.get(j).x,sinb.get(j).y);
                        if (distance < bomb.get(i).r + 5) {
                            sinb.remove(j);
                            NumOfsinb--;
                        }
                    }
                }
                if (NumOfcosb > 0) {
                    for (int j = 0; j < NumOfcosb; j++) {
                        distance = dist(bomb.get(i).x,bomb.get(i).y,cosb.get(j).x,cosb.get(j).y);
                        if (distance < bomb.get(i).r) {
                            cosb.remove(j);
                            NumOfcosb--;
                        }
                    }
                }
            }
            else if (phase == 4) {
                if (NumOfgearb > 0) {
                    for (int j = 0; j < NumOfgearb; j++) {
                        distance = dist(bomb.get(i).x,bomb.get(i).y,gear_bullet.get(j).x,gear_bullet.get(j).y);
                        if (distance < bomb.get(i).r) {
                            gear_bullet.remove(j);
                            NumOfgearb--;
                        }
                    }
                }
                if (NumOfgear > 0) {
                    for (int j = 0; j < NumOfgear; j++) {
                        distance = dist(bomb.get(i).x,bomb.get(i).y,gear.get(j).x,gear.get(j).y);
                        if (distance < bomb.get(i).r) {
                            gear.get(j).HP -= bomb.get(i).atk;
                        }
                    }
                }
            }
        }
    }
}
// 敵弾の制御
// 四角形弾の制御
void control_rect() {
    for (int i = 0; i < NumOfRect - 1; i++) {
        Rect_attack.get(i).rect_fall(); //四角形を落とす。
        if (NumOfRect > 1) {
            if (Rect_attack.get(i).y> height || Rect_attack.get(i).x > Game_width) {
                Rect_attack.remove(i);
                NumOfRect--;
            }
            if ((Rect_attack.get(i).x < player.x + 25 && Rect_attack.get(i).x > player.x - 25) && (Rect_attack.get(i).y < player.y + 25 && Rect_attack.get(i).y > player.y - 25)) {
                player.HP -= Rect_attack.get(i).atk;
                Rect_attack.remove(i);
                NumOfRect--;
            }
        }
    }
}
//円状弾の制御
void control_cparts() {
    if (NumOfCParts > 0) {
        for (int i = 0; i < NumOfCParts - 1; i++) {
            Cparts.get(i).cbullet(); //円形弾幕の操作。
            if (Cparts.get(i).y > height || Cparts.get(i).x > Game_width) {
                Cparts.remove(i);
                NumOfCParts--;
            }
            if ((Cparts.get(i).x < player.x + 10 && Cparts.get(i).x > player.x - 10) && (Cparts.get(i).y < player.y + 10 && Cparts.get(i).y > player.y - 10)) {
                player.HP -= Cparts.get(i).atk;
                Cparts.remove(i);
                NumOfCParts--;
            }
        }
    }
}
//sin弾の制御
void control_tetra() {
    if (NumOfsinb > 0) {
        for (int i = 0; i < NumOfsinb - 1; i++) {
            sinb.get(i).tetrab();
            if (sinb.get(i).y > height) {
                sinb.remove(i);
                NumOfsinb--;
            }
            if ((sinb.get(i).x >= player.x - 10 && sinb.get(i).x <= player.x + 10) && (sinb.get(i).y >= player.y - 10 && sinb.get(i).y <= player.y + 10)) {
                player.HP -= sinb.get(i).atk;
                sinb.remove(i);
                NumOfsinb--;
            }
        }
    }
    if (NumOfcosb > 0) {
        for (int i = 0; i < NumOfcosb - 1; i++) {
            cosb.get(i).tetrab();
            if (cosb.get(i).y < 0) {
                cosb.remove(i);
                NumOfcosb--;
            }
            if ((cosb.get(i).x >= player.x - 10 && cosb.get(i).x <= player.x + 10) && (cosb.get(i).y >= player.y - 10 && cosb.get(i).y <= player.y + 10)) {
                player.HP -= cosb.get(i).atk;
                cosb.remove(i);
                NumOfcosb--;
            }
        }
    }
}
// 敵機のクラス
class Enemy{
    //フィールドの宣言
    float x;
    float y;
    float xsize;
    float ysize;
    float xmove = Game_width / 2;
    float ymove = height / 4;
    float HP;
    float Max_HP;
    boolean is_boss;
    Enemy(float x, float y, float xsize, float ysize,
    float HP,float Max_HP, boolean is_boss) {
        this.x = x;
        this.y = y;
        this.xsize = xsize;
        this.ysize = ysize;
        this.HP = HP;
        this.Max_HP = Max_HP;
        this.is_boss = is_boss;
    }
    void display() {
        noStroke();
        image(murasame, x - 50, y - 45);
    }
    void enemy_move() {
        if (phase ==  1 && frameCount % 1000 == 0) {
            xmove = random(512);
            ymove = random(200);
        }
        else if (phase == 2 && frameCount % 500 == 0) {
            xmove = random(512);
            ymove = random(200);
        }
        else if (phase == 3 && frameCount % 200 == 0) {
            xmove = random(512);
            ymove = random(200);
        }
        else if (phase == 4 && frameCount % 300 == 0) {
            if (is_boss == false) {
                xmove = random(512);
                ymove = random(height);
            }
            if (is_boss == true && frameCount % 600 == 0) {
                xmove = random(512);
                ymove = random(400);
            }
        }
        if (!(x > xmove - 10 && x < xmove + 10)) {
            if (x < xmove) {
                x += 5;
            }
            else if (x > xmove) {
                x -= 5;
            }
        }
        if (!(y > ymove - 10 && y < ymove + 10)) {
            if (y < ymove) {
                y += 5;
            }
            else if (y > ymove) {
                y -= 5;
            }
        }
    }
    void HP_gauge() {
        if (is_boss) {
            stroke(255);
            strokeWeight(3);
            line(0, 3, HP * (Game_width / Max_HP), 3);
        }
    }
    void gear() {
        noStroke();
        fill(400,400,400);
        ellipse(x,y,50,50);
        for (int i = 0; i < NumOfgear; i++) {
            pushMatrix();
            fill(0);
            translate(x,y);
            rotate(radians(5 * frameCount));
            rect(0,0,10,10);
            translate(30 * cos(radians((360 * i / 8))),30 * sin(radians(360 * i / 8)));
            rotate(radians(360 * i / 8));
            noStroke();
            fill(400,400,400);
            rect( -1, -1,10,10);
            popMatrix();
        }
        
    }
}
//ギア（歯車）の制御。
void control_gear() {
    for (int i = 0; i < NumOfgear - 1; i++) {
        gear.get(i).gear();
        gear.get(i).enemy_move();
        for (int j = 0; j < NumOfBullet - 1; j++) {
            if (dist(bullets.get(j).x,bullets.get(j).y,gear.get(i).x,gear.get(i).y) < 30) {
                gear.get(i).HP -= bullets.get(j).atk;
                bullets.remove(j);
                NumOfBullet--;
            }
        }
        for (int j = 0; j < NumOfBullet2 - 1; j++) {
            if (dist(bullet2.get(j).x,bullet2.get(j).y,gear.get(i).x,gear.get(i).y) < 30) {
                gear.get(i).HP -= bullet2.get(j).atk;
                bullet2.remove(j);
                NumOfBullet2--;
            }
        }
        if (gear.get(i).HP < 0) {
            gear.remove(i);
            NumOfgear--;
        }
    }
    for (int i = 0; i < NumOfgearb - 1; i++) {
        gear_bullet.get(i).cbullet();
        if ((gear_bullet.get(i).x < player.x + 25 && gear_bullet.get(i).x > player.x - 25) && (gear_bullet.get(i).y <player.y + 25 && gear_bullet.get(i).y > player.y - 25)) {
            player.HP -= gear_bullet.get(i).atk;
            gear_bullet.remove(i);
            NumOfgearb--;
        }
        if (gear_bullet.get(i).y > height || gear_bullet.get(i).y < 0 || gear_bullet.get(i).x > Game_width) {
            gear_bullet.remove(i);
            NumOfgearb--;
        }
    }
}
//ゲーム状況を表示
void status() {
    strokeWeight(3);
    stroke(0,0,400);
    fill(0,0,400);
    line(Game_width + 2,0,Game_width + 2,height);
    textSize(60);
    text("YOU",Game_width + 60, height * 3 / 4); 
    text("Enemy",Game_width + 60,height / 4);
    image(shiratuyu_head, width - 120, height * 3 / 4 - 40 ,40,40);
    textSize(40);
    text("HP:" + player.HP + " / " + player.Max_HP, Game_width + 30 , height * 3 / 4 + 60);
    text("XP:" + player.XP + "/" + player.Max_XP, Game_width + 30 , height * 3 / 4 + 100);
    textSize(30);
    text("HP:" + enemy.HP + "/" + enemy.Max_HP , Game_width + 30, height / 4 + 60);
    text("phase : " + phase , Game_width + 30, height / 4 + 90);
    image(murasame_head, width - 50 , height / 4 - 30,40,40);
}
//勝敗の判定
void judge() {
    textSize(60);
    fill(0,0,400);
    if (enemy.HP <= 0) {
        text("YOU WIN!!",Game_width / 2, height / 2 - 50);
        game_play = false;
    }
    else if (player.HP <= 0) {
        text("GAME OVER",Game_width / 2, height / 2 - 50);
        game_play = false;
    }
}
//継続判定
void continue_judge() {
    if (game_play == false) {
        textSize(30);
        text("C:Continue",width / 2 - 65, height / 2);
        text("E:Exit",width / 2 - 65, height / 2 + 30);
        if (keyPressed) {
            if (ckey) {
                //初期化して再開
                game_play = true;
                player.x = Game_width / 2;
                player.y = height - 100;
                enemy.x = Game_width / 2;
                enemy.y = height / 4;
                player.HP = player.Max_HP;
                player.XP = player.Max_XP;
                enemy.HP = enemy.Max_HP;
                if (NumOfBullet > 0) {
                    for (int i = NumOfBullet - 1; i >= 0; i--) {
                        bullets.remove(i);
                    }
                }
                if (NumOfBullet2 > 0) {
                    for (int i = NumOfBullet2 - 1; i >= 0; i--) {
                        bullet2.remove(i);
                    }
                }
                if (NumOfRect > 0) {
                    for (int i = NumOfRect - 1; i >= 0; i--) {
                        Rect_attack.remove(i);
                    }
                }
                if (NumOfCParts > 0) {
                    for (int i = NumOfCParts - 1; i >= 0; i--) {
                        Cparts.remove(i);
                    }
                }
                if (NumOfsinb > 0) {
                    for (int i = NumOfsinb - 1; i >= 0; i--) {
                        sinb.remove(i);
                    }
                }
                if (NumOfcosb > 0) {
                    for (int i = NumOfcosb - 1; i >= 0; i--) {
                        cosb.remove(i);
                    }
                }
                if(NumOfgear > 0){
                    for(int i = NumOfgear - 1; i >= 0; i--){
                        gear.remove(i);
                    }
                }
                if(NumOfgearb > 0){
                    for(int i = NumOfgearb - 1; i >= 0; i--){
                        gear_bullet.remove(i);
                    }
                }
                NumOfBullet = 0;
                NumOfBullet2 = 0;
                NumOfRect = 0;
                NumOfCParts = 0;
                NumOfsinb = 0;
                NumOfcosb = 0;
                NumOfbomb = 0;
                NumOfgear = 0;
                NumOfgearb = 0;
                gear_push = true;
                usebullet = 0;
                frameCount = 0;
                phase = 1;
            }
            if (ekey) {
                exit();
            }
        }
    }
}
void judge_phase() {
    if (phase != 0) {
        if (enemy.HP > enemy.Max_HP * 11 / 13) {
            phase = 1;
        }
        else if (enemy.HP > enemy.Max_HP * 7 / 13) {
            phase = 2;
        }
        else if (enemy.HP > enemy.Max_HP * 3 / 13) {
            phase = 3;
        }
        else if (enemy.HP <= enemy.Max_HP * 3 / 13) {
            phase = 4;
        }
    }
}
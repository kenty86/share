#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <ctype.h>
/* 画像の構造体 */
typedef struct{
    int width;
    int height;
    float **r;
    float **g;
    float **b;
}ColorImage;
/* 1ワード読み込む関数 */
void getword(FILE *fp, char *word);
/* PPMフォーマットの画像を読み込む関数 */
void loadPPM(char* filename, ColorImage *ci);
/* 出力画像の変数を生成する関数*/
void createImage(ColorImage *ci);
/* 画像変数のメモリを開放する関数*/
void freeImage(ColorImage *ci);
/* 画像をPPMフォーマットで書き出す関数 */
void savePPM(char* filename, ColorImage *ci);

/* クリッピング */
void clipping(ColorImage *cimage);
/* 量子化 */
void quantize(ColorImage *outimage, const ColorImage *inimage);
/* ２値化 */
void blackwhite(ColorImage *outimage, const ColorImage *inimage);
/* 縮小2（平均値） */
void scale_down_Mean(ColorImage *outimage, const ColorImage *inimage);
/* 縮小1（ダウンサンプリング） */
void scale_down_DS(ColorImage *outimage, const ColorImage *inimage);
/* 拡大3（線形補間） */
void scale_up_IP(ColorImage *outimage, const ColorImage *inimage);

int main(void)
{
	// 変数宣言
	char *outputfile={"output.ppm"};
	char *inputfile={"zoneplate256.ppm"};

	ColorImage inimage, outimage;
	int pros = 0;
	float scaleH, scaleW;
	int xpos, ypos;

	/* 0:拡大1（アップサンプリング）, 1:拡大2（最近傍法）, 2:拡大3（線形補間）, 
	   3:縮小1（ダウンサンプリング）, 4:縮小2（平均値）  , 5:トリミング      */
	printf("\n0:量子化, \n1:二値化, \n2:ダウンサンプリング, \n3:平均値を用いた縮小, \n4:線形補完\nprocess =");
	scanf("%d",&pros);

	// ここから処理
	loadPPM(inputfile, &inimage);
	
	if(pros==0) { 
        // 量子化
        outimage.width = inimage.width;
		outimage.height = inimage.height;
        createImage(&outimage);
		quantize(&outimage,&inimage);
	}
	else if(pros==1) { 
        // ２値化
        outimage.width = inimage.width;
		outimage.height = inimage.height;
        createImage(&outimage);
		blackwhite(&outimage,&inimage);
	}
	else if(pros==2) {
		/* ダウンサンプリング */
		scaleH=1.0/4; scaleW=1.0/4;
		outimage.width = scaleW*(inimage.width);
		outimage.height = scaleH*(inimage.height);	
		createImage(&outimage);
		scale_down_DS(&outimage, &inimage);
	}
	else if(pros==3) {
		/*平均値による縮小*/
		scaleH=1.0/4; scaleW=1.0/4;
		outimage.width = scaleW*(inimage.width);
		outimage.height = scaleH*(inimage.height);
		createImage(&outimage);
		scale_down_Mean(&outimage, &inimage);
	}
	else if(pros==4) {
		/* 線形補間*/
		scaleH=2; scaleW=2;
		outimage.width = scaleW*(inimage.width);
		outimage.height = scaleH*(inimage.height);
		createImage(&outimage);
		scale_up_IP(&outimage, &inimage);
	}
	savePPM(outputfile, &outimage);
	freeImage(&inimage);
	freeImage(&outimage);
	return 0;
}

/*量子化*/
void quantize(ColorImage *outimage, const ColorImage *inimage)
{
 	int i,j,k;
	int bit_shift;
	printf("何ビットに量子化しますか？\n>>>");
	scanf("%d",&bit_shift); // 量子化ビット
	for(i = 0;i < inimage -> height; i++){
		for(j = 0; j < inimage -> width; j++){
			//量子化処理
			outimage -> r[i][j] = (255/(pow(2,bit_shift)-1))*round(inimage -> r[i][j] /(255/(pow(2,bit_shift))-1));
			outimage -> g[i][j] = (255/(pow(2,bit_shift)-1))*round(inimage -> g[i][j] /(255/(pow(2,bit_shift)-1)));
			outimage -> b[i][j] = (255/(pow(2,bit_shift)-1))*round(inimage -> b[i][j] /(255/(pow(2,bit_shift)-1)));
		}
	}
}

/*２値化*/
void blackwhite(ColorImage *outimage, const ColorImage *inimage)
{
	int i,j,thresh,average;//thresh:闘値 average:RGB平均値
	printf("闘値を入力\n");
	scanf("%d",&thresh);
	for(i = 0; i < inimage -> height ; i++){
		for(j = 0; j < inimage -> width; j++){
			average = (inimage -> r[i][j] + inimage -> g[i][j] + inimage -> b[i][j]) / 3;
			if(average > thresh){
				//二値化処理
				outimage -> r[i][j] = 255;
				outimage -> g[i][j] = 255;
				outimage -> b[i][j] = 255;
			}
			else{
				outimage -> r[i][j] = 0;
				outimage -> g[i][j] = 0;
				outimage -> b[i][j] = 0;
			}
		}
	}
}

/* 縮小1（ダウンサンプリング） */
void scale_down_DS(ColorImage *outimage, const ColorImage *inimage)
{
    int i,j;
	int wide,high;//wide : 横の拡大率 high : 縦の拡大率
	printf("縦の縮小率を入力\n>>>");
	scanf("%d",&high);
	printf("横の縮小率を入力\n>>>");
	scanf("%d",&wide);
	//演算
	for(i=0;i < outimage -> width; i++){//一行ずらす
		for(j=0;j < outimage -> height; j++){//一列ずらす
			outimage -> r[i][j] = inimage -> r[(int)(i*wide)][(int)(j*high)];//位置の入れ替え、赤
			outimage -> g[i][j] = inimage -> g[(int)(i*wide)][(int)(j*high)];//位置の入れ替え、緑
			outimage -> b[i][j] = inimage -> b[(int)(i*wide)][(int)(j*high)];//位置の入れ替え、青
		}
	}
}

/* 縮小2（平均値） */
void scale_down_Mean(ColorImage *outimage, const ColorImage *inimage)
{
    int i,j,k,l;//i : 横の画素値　j:縦の画素値 k:横の平均を取る画素の座標 l:縦の平均を取る画素の座標
	int wide,high;//wide : 横の縮小率 high : 縦の縮小率
	int sumr,sumg,sumb;// sum: 画素地の合計
	float red=0,green = 0,blue=0; //画素値を一時的に格納
	//倍率入力
	printf("縦の縮小倍率を入力\n>>>");
	scanf("%d",&high);
	printf("横の縮小倍率を入力\n>>>");
	scanf("%d",&wide);
	//演算
	for(i=0;i < outimage -> width; i++){//一行ずらす
		for(j = 0;j < outimage -> height; j++){//一列ずらす
			sumr = 0;sumg = 0 ; sumb = 0;//sum値の初期化
			for(k = 0;k < wide;k++){
				for(l = 0;l < high; l++){
					if(!(i*wide+k >= inimage -> width || j*high+l >= inimage -> height)){
						sumr = sumr + (inimage -> r[i*wide+k][j*high+l]); //r値の合計を変数sumrに格納
						sumg = sumg + (inimage -> g[i*wide+k][j*high+l]); //g値の合計を変数sumgに格納
						sumb = sumb + (inimage -> b[i*wide+k][j*high+l]);//b値の合計を変数sumbに格納
					}
				}
			}
			red = sumr / (wide * high); //平均を取り、変数sumrに格納
			green = sumg / (wide * high); //平均を取り、変数sumgに格納
			blue = sumb / (wide * high); //平均を取り、変数sumbに格納
			//変更を反映。
			outimage -> r[i][j] = red;
			outimage -> g[i][j] = green;
			outimage -> b[i][j] = blue;
		}
	}
}

/* 拡大3（線形補間） */
void scale_up_IP(ColorImage *outimage, const ColorImage *inimage)
{
	int i,j;
	int wide,high;//wide : 横の拡大率　high : 縦の拡大率
	float sep_top_r,sep_top_g,sep_top_b; //sep_top : 上の内分点の画素値
	float sep_bot_r,sep_bot_g,sep_bot_b; //sep_bot:下の内分点の画素値
	float alpha,beta; //alpha : i/wideの小数値　beta:j/highの小数値
	int i_childa,j_childa; //i_childa : i/wide  j_childa : j/high
	//倍率読み込み
	printf("縦の拡大率を入力\n>>>");
	scanf("%d",&high);
	printf("横の拡大率を入力\n>>>");
	scanf("%d",&wide);
	//演算
	for(i=0;i < outimage -> width - wide; i++){//一行ずらす
		for(j=0;j < outimage -> height -high; j++){//一列ずらす
			i_childa = i/wide;
			j_childa = j/high;
			//i/wide、j/wideが整数値であるとき
			if(i%wide == 0 && j%high == 0){
				outimage -> r[i][j] = inimage -> r[(int)i_childa][(int)j_childa];
				outimage -> g[i][j] = inimage -> g[(int)i_childa][(int)j_childa];
				outimage -> b[i][j] = inimage -> b[(int)i_childa][(int)j_childa];
			}
			//i/wide,j/wideが整数値でないとき
			else{
				//補完座標
				i_childa = floor(i_childa);
				beta = i/wide - i_childa;
				j_childa = floor(j_childa);
				alpha = j/high - j_childa;
				//上の内分点
				sep_top_r = (1-alpha)*inimage->r[(int)i_childa][(int)j_childa] + alpha* inimage -> r[(int)i_childa][(int)(j_childa+1)];
				sep_top_g = (1-alpha)*inimage->g[(int)i_childa][(int)j_childa] + alpha* inimage -> g[(int)i_childa][(int)(j_childa+1)];
				sep_top_b = (1-alpha)*inimage->b[(int)i_childa][(int)j_childa] + alpha* inimage -> b[(int)i_childa][(int)(j_childa+1)];
				//下の内分点
				sep_bot_r = (1-alpha)*inimage->r[(int)(i_childa+1)][(int)j_childa] + alpha* inimage -> r[(int)(i_childa+1)][(int)(j_childa+1)];
				sep_bot_r = (1-alpha)*inimage->r[(int)(i_childa+1)][(int)j_childa] + alpha* inimage -> r[(int)(i_childa+1)][(int)(j_childa+1)];
				sep_bot_r = (1-alpha)*inimage->r[(int)(i_childa+1)][(int)j_childa] + alpha* inimage -> r[(int)(i_childa+1)][(int)(j_childa+1)];
				//補完演算
				outimage -> r[i][j] = (1-beta)*sep_top_r + beta * sep_bot_r;
				outimage -> g[i][j] = (1-beta)*sep_top_g + beta * sep_bot_g;
				outimage -> b[i][j] = (1-beta)*sep_top_b + beta * sep_bot_b;
			}
		}
	}
}

/* ここから下は修正する必要はありません */

void clipping(ColorImage *cimage)
{
  int i,j;
  
	/* ここに画素値を0～255に制限するプログラムを挿入する */
	for(i=0;i<cimage->height;i++){
		for(j=0;j<cimage->width;j++){
            if(cimage->r[i][j] > 255.0f) cimage->r[i][j]=255.0f;
            if(cimage->g[i][j] > 255.0f) cimage->g[i][j]=255.0f;
            if(cimage->b[i][j] > 255.0f) cimage->b[i][j]=255.0f;
            if(cimage->r[i][j] < 0.0f) cimage->r[i][j]=0.0f;
            if(cimage->g[i][j] < 0.0f) cimage->g[i][j]=0.0f;
            if(cimage->b[i][j] < 0.0f) cimage->b[i][j]=0.0f;
		}
	}
}

void createImage(ColorImage *ci)
{
	int i,j;

	ci->r=(float **)malloc(ci->height*sizeof(float *));
	ci->g=(float **)malloc(ci->height*sizeof(float *));
	ci->b=(float **)malloc(ci->height*sizeof(float *));
	if(ci->r==NULL||ci->g==NULL||ci->b==NULL) {
		printf("Error in malloc");
		exit(0);
	}	

	for(i=0;i<ci->height;i++){
		ci->r[i]=(float *)malloc(ci->width*sizeof(float));
		ci->g[i]=(float *)malloc(ci->width*sizeof(float));
		ci->b[i]=(float *)malloc(ci->width*sizeof(float));
		if(ci->r[i]==NULL||ci->g==NULL||ci->b==NULL) {
			printf("Error in malloc");
			exit(0);
		}	
	}		

	for(i=0;i<ci->height;i++){
		for(j=0;j<ci->width;j++){
			ci->r[i][j]=0;
			ci->g[i][j]=0;
			ci->b[i][j]=0;
		}
	}
}

void savePPM(char* filename, ColorImage *ci)
{
	/* save file in PGM P3 format */
	int i, j;
	FILE *out;

	/* ファイルをオープン */
	out=fopen(filename, "w");

	/* ファイルが存在しなければエラー */
	if (out==NULL){
		printf("Cannot open file\n");
		exit(0);
	}

	/* ファイルのヘッダ情報を書き出す */
	fprintf(out, "P3\n%d %d\n255\n", ci->width, ci->height);

    /* [0, 255]に画素値をクリッピング */
	clipping(ci);

	/* 画素値を書き出す */
	for(i=0;i<ci->height;i++){
		for(j=0;j<ci->width;j++){
			fprintf(out, "%d ", (int)ci->r[i][j]);
			fprintf(out, "%d ", (int)ci->g[i][j]);
			fprintf(out, "%d ", (int)ci->b[i][j]);
		}
	}

	fclose(out);
}

void loadPPM(char* filename, ColorImage *ci)
{
	char word[1000];
	int i,j;
	FILE *in;

	in=fopen(filename, "rb");

	if(in==NULL){
		printf("Cannot open file\n");
		exit(0);
	}

	getword(in, word);

	getword(in, word);
	sscanf(word,"%d",&(ci->width));
	getword(in, word);
	sscanf(word,"%d",&(ci->height));
	getword(in, word);

	ci->r=(float **)malloc(ci->height*sizeof(float *));
	ci->g=(float **)malloc(ci->height*sizeof(float *));
	ci->b=(float **)malloc(ci->height*sizeof(float *));
	if(ci->r==NULL||ci->g==NULL||ci->b==NULL) {
		printf("Error in malloc");
		exit(0);
	}	
	
	for(i=0;i<ci->height;i++){
		ci->r[i]=(float *)malloc(ci->width*sizeof(float));
		ci->g[i]=(float *)malloc(ci->width*sizeof(float));
		ci->b[i]=(float *)malloc(ci->width*sizeof(float));
		if(ci->r[i]==NULL||ci->g==NULL||ci->b==NULL) {
			printf("Error in malloc");
			exit(0);
		}	
	}		
	
	/*discard one CR*/
	fgetc(in);

	for(i=0;i<ci->height;i++){
		for(j=0;j<ci->width;j++){
			int tmpr, tmpg, tmpb;
			fscanf(in, "%s", word); sscanf(word,"%d",&(tmpr));
			fscanf(in, "%s", word); sscanf(word,"%d",&(tmpg));
			fscanf(in, "%s", word); sscanf(word,"%d",&(tmpb));

			ci->r[i][j]=(float)tmpr;
			ci->g[i][j]=(float)tmpg;
			ci->b[i][j]=(float)tmpb;
		}
	}

	fclose(in);
}

void getword(FILE *fp, char *word)
{ 
	fscanf(fp, "%s", word);

	/*	while(word[0]=='#'){
		fscanf(fp, "%s", word);
		}*/
	if(word[0]=='#'){
		while(word[0]!=10){
			word[0]=(int)fgetc(fp);
		}
		fscanf(fp, "%s", word);
	}
}

void freeImage(ColorImage *ci)
{
	int i;

	for(i=0;i<ci->height;i++)
	{
		free(ci->r[i]);
		free(ci->g[i]);
		free(ci->b[i]);
	}
	free(ci->r);
	free(ci->g);
	free(ci->b);
}
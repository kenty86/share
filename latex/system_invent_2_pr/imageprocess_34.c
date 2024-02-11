/*
	2023年度第7回のプログラム
	imageprocess_4_ans.c
*/

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <ctype.h>

/* カラー画像の構造体 */
typedef struct{
    int width;
    int height;
    float **r;
    float **g;
    float **b;
}ColorImage;


/* １ワード読み込む関数 */
void getword(FILE* fp, char* word);
/* PPMフォーマットの画像を読み込む関数 */
void loadPPM(char* filename, ColorImage* ci);
/* 画像をPPMフォーマットで書き出す関数 */
void savePPM(char* filename, ColorImage* ci);
/* 出力画像の変数を生成する関数*/
void createColorImage(ColorImage* ci); // 濃淡画像用
/* 画像の領域を開放する関数 */
void freeColorImage(ColorImage* ci); // 濃淡画像用
/* クリッピング */
void clipping(ColorImage *cimage);

/* ガウシアンフィルタ　*/
void gaussian_filter(ColorImage *outimage, ColorImage *inimage, float sigma, int win_size);
/* ラプラシアンフィルタによる鮮鋭化 */
void laplacian_sharpening(ColorImage *outimage, ColorImage *inimage, float k);

int main(int argc, const char * argv[]) {
    /* 変数宣言 */
    ColorImage cinimage, coutimage;
    char *inputfile, *outputfile;
    int win_size = 5; // フィルタサイズ
    /* 課題4.1 win_size変更用
    printf("win_size=\n",win_size);
    scanf("%d",&win_size);
    */
    int pros = 0;
    /*	0:ガウシアンフィルタ,
        1:ラプラシアンフィルタによる鮮鋭化
	*/
	printf("\n0:ガウシアンフィルタ");
	printf("\n1:ラプラシアンフィルタによる鮮鋭化");
    printf("\npros = ");
    scanf("%d", &pros);
    
    printf("\nFilter window : %d x %d\n", win_size, win_size);

    if (pros == 0) { 
    /* ガウシアンフィルタ */
      inputfile = "lena256.ppm";
      outputfile = "out_gauss.ppm";
      float sigma = 10.0f; // ガウス分布の標準偏差
      /*課題4.2　sigma変更
      printf("sigmaを入力>>");
      scanf("%f",&sigma);
      */
      printf("Sigma for spatial  %0.1f\n ", sigma);
      /* PPMファイルを読み込む*/
      loadPPM(inputfile, &cinimage);
      /* 結果画像を格納するメモリを確保　*/
      coutimage.width = cinimage.width;
      coutimage.height = cinimage.height;
      createColorImage(&coutimage);

      /* ガウシアンフィルタによるフィルタリング*/
      gaussian_filter(&coutimage, &cinimage, sigma, win_size);

      /* 結果画像をPPMファイルとして出力 */
      savePPM(outputfile, &coutimage);
      /* 結果画像用のメモリを解放 */
      freeColorImage(&coutimage);
    } 
     else if (pros == 1) {
    /* ラプラシアンフィルタによる鮮鋭化 */
        inputfile = "Boats.ppm"; // "lena256.ppm";
        outputfile = "out_Lapsharpen.ppm";
        float k = 0.5f; // 鮮鋭化パラメータ
        scanf("%f",&k);
        printf("sharpning scale k : %0.1f\n", k);
        /* PPMファイルを読み込む */
        loadPPM(inputfile, &cinimage);
        /* 結果画像を格納するメモリを確保 */
        coutimage.width = cinimage.width;
        coutimage.height = cinimage.height;
        createColorImage(&coutimage);

        /* ラプラシアンフィルタによる鮮鋭化処理 */
        laplacian_sharpening(&coutimage, &cinimage, k);

        /* 結果画像をPPMファイルとして出力 */
        savePPM(outputfile, &coutimage);
        /* 結果画像用のメモリを解放 */
        freeColorImage(&coutimage);
    } 
    return 0;
}

void gaussian_filter(ColorImage *outimage, ColorImage *inimage, float sigma, int win_size) {
    /* 入力カラー画像inimageに対してガウシアンに基づく平滑化フィルタを計算し，出力用outimageに格納する．*/
    /* 必要であれば、変数宣言を適宜追加すること */
    /* ここにプログラムを挿入する */
    int i, j, k, l, L = (win_size - 1) / 2;
    float sumR = 0.0f, sumG = 0.0f, sumB = 0.0f;
    float InR,InG,InB; //それぞれ、入力画像の画素値。InR:赤 InG:緑 InB:青
    float w1 = 0.0f, sumW = 0.0f;
    for (i=0; i<outimage->height; i++) {
        for (j=0; j<outimage->width; j++) {
            sumR = 0.0f; sumG = 0.0f; sumB = 0.0f; sumW = 0.0f;//sumの初期化
            for (k=-L; k<=L; k++) {
                for (l=-L; l<=L; l++) {
                    /* 画像端では、画像の領域外にアクセスしないようにする */
                    if(i+k >= inimage -> width || j+l >= inimage -> height || i+k <= 0 || j+l <= 0){
                        //0埋め
                        InR = 0,InG = 0,InB = 0;
                    }
                    else{
                    //画素値の代替変数に画素値を代入。
                        InR = inimage -> r[i+k][j+l];
                        InG = inimage -> g[i+k][j+l];
                        InB = inimage -> b[i+k][j+l];
                    }
                    /* 重みを計算する */
                    // w1 = ????;
                    w1 = exp(-((pow(k,2)+pow(l,2))/(2*pow(sigma,2))));
                    /* フィルタの係数の乗算 */
                    sumR += InR*w1;
                    sumG += InG*w1;
                    sumB += InB*w1;
                    sumW += w1;
                }
            }
        /* outimage[i][j]にフィルタの出力を格納する */
        outimage -> r[i][j] = sumR/sumW;
        outimage -> g[i][j] = sumG/sumW;
        outimage -> b[i][j] = sumB/sumW; 
        }

    }
}

void laplacian_sharpening(ColorImage *outimage, ColorImage *inimage, float K) {
    /* 入力カラー画像inimageに対してラプラシアンフィルタによる鮮鋭化結果を計算し，出力用outimageに格納する．*/
    /* ここにプログラムを挿入する */
    int i,j,k,l,L = 1; //参照範囲:winsize^2
    float sumR = 0.0f ,sumG = 0.0f ,sumB = 0.0f; //分母定義
    float InR,InG,InB; //inimageの画素地の代替変数
    int alap[3][3] = {{0,1,0},{1,-4,1},{0,1,0}}; //水平垂直方向のラプラシアンフィルタ
    for (i=0; i < outimage->height; i++) {
        for (j=0; j < outimage->width; j++) {
            sumR = 0.0f,sumG = 0.0f; sumB = 0.0f;
            for (k = -L; k <= L; k++)
            {
                for (l = -L; l <= L; l++)
                {
                    //segmentation fault対策
                    if(i+k >= inimage -> width || j+l >= inimage -> height || i+k <= 0 || j+l <= 0){
                        //0埋め
                        InR = 0,InG = 0,InB = 0;
                    }
                    else{
                        //画素値の代替変数に画素値を代入。
                        InR = inimage -> r[i+k][j+l];
                        InG = inimage -> g[i+k][j+l];
                        InB = inimage -> b[i+k][j+l];
                    }
                    //合計演算
                    sumR += alap[k+1][l+1] * InR;
                    sumG += alap[k+1][l+1] * InG;
                    sumB += alap[k+1][l+1] * InB;
                }
            }
            //画像演算 K:定数。
            outimage -> r[i][j] = inimage -> r[i][j] - K * sumR;
            outimage -> g[i][j] = inimage -> g[i][j] - K * sumG;
            outimage -> b[i][j] = inimage -> b[i][j] - K * sumB;
        }
    }
}
/* ここから下は修正する必要はありません */

void clipping(ColorImage *cimage)
{
  int i,j;
  
	/* ここに画素値を0～255に制限するプログラムを挿入する */
	for (i=0; i<cimage->height; i++) {
		for (j=0; j<cimage->width; j++) {
            if (cimage->r[i][j] > 255.0f) cimage->r[i][j] = 255.0f;
            if (cimage->g[i][j] > 255.0f) cimage->g[i][j] = 255.0f;
            if (cimage->b[i][j] > 255.0f) cimage->b[i][j] = 255.0f;
            if (cimage->r[i][j] < 0.0f) cimage->r[i][j] = 0.0f;
            if (cimage->g[i][j] < 0.0f) cimage->g[i][j] = 0.0f;
            if (cimage->b[i][j] < 0.0f) cimage->b[i][j] = 0.0f;
		}
	}
}

void loadPPM(char* filename, ColorImage* ci)
{
    char word[1000];
    int i, j;
    FILE* in;

    in = fopen(filename, "rb");

    if (in == NULL) {
        printf("Cannot open file\n");
        exit(0);
    }

    getword(in, word);

    getword(in, word);
    sscanf(word, "%d", &(ci->width));
    getword(in, word);
    sscanf(word, "%d", &(ci->height));
    getword(in, word);

    ci->r = (float**)malloc(ci->height * sizeof(float*));
    ci->g = (float**)malloc(ci->height * sizeof(float*));
    ci->b = (float**)malloc(ci->height * sizeof(float*));
    if (ci->r == NULL || ci->g == NULL || ci->b == NULL) {
        printf("Error in malloc");
        exit(0);
    }

    for (i = 0; i < ci->height; i++) {
        ci->r[i] = (float*)malloc(ci->width * sizeof(float));
        ci->g[i] = (float*)malloc(ci->width * sizeof(float));
        ci->b[i] = (float*)malloc(ci->width * sizeof(float));
        if (ci->r[i] == NULL || ci->g == NULL || ci->b == NULL) {
            printf("Error in malloc");
            exit(0);
        }
    }

    /*discard one CR*/
    fgetc(in);

    for (i = 0; i < ci->height; i++) {
        for (j = 0; j < ci->width; j++) {
            int tmpr, tmpg, tmpb;
            fscanf(in, "%s", word); sscanf(word, "%d", &(tmpr));
            fscanf(in, "%s", word); sscanf(word, "%d", &(tmpg));
            fscanf(in, "%s", word); sscanf(word, "%d", &(tmpb));

            ci->r[i][j] = (float)tmpr;
            ci->g[i][j] = (float)tmpg;
            ci->b[i][j] = (float)tmpb;
        }
    }

    fclose(in);
}

void savePPM(char* filename, ColorImage* ci)
{
    /* save file in PGM P3 format */
    int i, j;
    FILE* out;

    /* ファイルをオープン */
    out = fopen(filename, "w");

    /* ファイルが存在しなければエラー */
    if (out == NULL) {
        printf("Cannot open file\n");
        exit(0);
    }

    /* ファイルのヘッダ情報を書き出す */
    fprintf(out, "P3\n%d %d\n255\n", ci->width, ci->height);

    /* [0, 255]に画素値をクリッピング */
	clipping(ci);

    for (i = 0; i < ci->height; i++) {
        for (j = 0; j < ci->width; j++) {
            fprintf(out, "%d ", (int)ci->r[i][j]);
            fprintf(out, "%d ", (int)ci->g[i][j]);
            fprintf(out, "%d ", (int)ci->b[i][j]);
        }
    }

    fclose(out);
}

void getword(FILE* fp, char* word)
{
    fscanf(fp, "%s", word);

    if (word[0] == '#') {
        while (word[0] != 10) {
            word[0] = (int)fgetc(fp);
        }
        fscanf(fp, "%s", word);
    }
}

void createColorImage(ColorImage* ci)
{
    int i, j;

    ci->r = (float**)malloc(ci->height * sizeof(float*));
    ci->g = (float**)malloc(ci->height * sizeof(float*));
    ci->b = (float**)malloc(ci->height * sizeof(float*));
    if (ci->r == NULL || ci->g == NULL || ci->b == NULL) {
        printf("Error in malloc");
        exit(0);
    }

    for (i = 0; i < ci->height; i++) {
        ci->r[i] = (float*)malloc(ci->width * sizeof(float));
        ci->g[i] = (float*)malloc(ci->width * sizeof(float));
        ci->b[i] = (float*)malloc(ci->width * sizeof(float));
        if (ci->r[i] == NULL || ci->g[i] == NULL || ci->b[i] == NULL) {
            printf("Error in malloc");
            exit(0);
        }
    }

    for (i = 0; i < ci->height; i++) {
        for (j = 0; j < ci->width; j++) {
            ci->r[i][j] = 0;
            ci->g[i][j] = 0;
            ci->b[i][j] = 0;
        }
    }
}


void freeColorImage(ColorImage* ci)
{
    int i;

    for (i = 0; i < ci->height; i++)
    {
        free(ci->r[i]);
        free(ci->g[i]);
        free(ci->b[i]);
    }
    free(ci->r);
    free(ci->g);
    free(ci->b);
}

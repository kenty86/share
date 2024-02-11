#include <stdio.h>
#include <stdlib.h>
#define ASIZE 6  /* �z��T�C�Y*/
#define INFTY 1000

int T[ASIZE], D[ASIZE];
int w[ASIZE][ASIZE];

struct edge{         /*  ��(u,v)�Ƃ��̏d�� */
  int u;
  int v;	
  int weight;
};


/*  �d�ݕt���O���t�̗אڃ��X�g�@*/

struct element {
  int vertex;
  int weight;
  struct element *next;
};

struct element *newl()     /* �������[��ɃZ���̗̈���m�ہ@*/
{
  return((struct element *) malloc(sizeof(struct element)));
}

struct element *create()   /* �󃊃X�g�𐶐� */
{
  struct element *p;

  p = newl();
  p->next = NULL;
  return(p);    
}

void append(struct element *l, int v, int w) /* ���X�g�̍Ō���ɒ��_v�Əd��w��}���@*/
{
  struct element *p;

  if (l->next != NULL) 
    append(l->next, v, w);
  else {
    p = newl();
    p->vertex = v;
    p->weight = w;
    p->next = NULL;
    l->next = p;
  }
}

void printlist(struct element *l)    /* ���X�g�̃f�[�^���������*/
{
  if(l->next != NULL){
    printf(" (v%d,%d)", l->next->vertex, l->next->weight);
    printlist(l->next);
  }
}


void createadjlist(struct element *a[], int n) /* �אڃ��X�g�̐��� */
{
  int i;

  for (i = 1;i <= n; i++)
    a[i] = create();
}


void printadjlist(struct element *a[], int n)  /* �אڃ��X�g�̈�� */
{
  int i;

  for (i = 1; i <= n; i++){
    printf("a[v%d",i);
    printf("] = "); 
    printlist(a[i]); 
    printf("\n");
  }
}


int makegraph(struct element *a[]) /* �אڃ��X�g�̍쐬 */
{
  createadjlist(a, 5);
  append(a[1], 2, 4);
  append(a[1], 5, 3);
  append(a[2], 3, 2);
  append(a[3], 4, 3);
  append(a[5], 3, 2);
  append(a[5], 4, 7);
  return 5;
}

void makeweightarray(struct element *a[], int n)
{
  int i,j;
  struct element *l;

  for (i = 1; i <= n; i++)
    for (j = 1; j <= n; j++)
      w[i][j]= INFTY;
  for (i = 1; i <= n; i++)
    for (l = a[i]->next; l != NULL; l = l->next){
      j =l->vertex;
      w[i][j] = l->weight;
    }
}

int findmin(int T[], int n)
{
  int i, min;

  min = 0;
  D[min] = INFTY;
  for ( i = 2; i <= n; i++)
    if (T[i] == 1 && D[min] > D[i])
      min = i;
  return min;
}

int min(int a, int b)
{
  if (a < b)
    return a;
  else
    return b;
}

void dijkstra(struct element *a[], int n, int s)
{
  int i, u, v, sizeofT;
  struct element *l;

  for (i = 1; i <= n; i++){
    T[i] = 1;
    D[i] = INFTY;
  }
  T[s] = 0;
  D[s] = 0;
  for (l = a[s]->next; l != NULL; l = l->next)
    D[l->vertex] = l->weight;
  sizeofT = n-1;
  while (sizeofT > 0){
    for (v = 1; v <= n; v++) 
      if (T[v] == 1)
	printf("v[%d], ", v);
      else
	printf("      ");
    for (v = 2; v <= n; v++) 
      printf("D[%d]=%d, ", v, D[v]);
    printf("\n");
    u = findmin(T, n); /*T�̒��_��D[v]�̒l���ŏ��ƂȂ���̂�u�Ƃ���*/
    T[u] = 0;          /* T=T-{u} */
    sizeofT--;
    for (v = 1; v <= n; v++)
      if (T[v] == 1)
	D[v] = min(D[v], D[u]+w[u][v]);
  }
}

int main()
{
  int i, n; 
  struct element *a[ASIZE];

  n= makegraph(a);
  printf("adjlist\n");
  printadjlist(a, n);
  printf("\n");
  makeweightarray(a, n);
  dijkstra(a, n, 1);
  for (i = 1; i <= n; i++)
    printf("D[v%d] = %d \n", i, D[i]);
}
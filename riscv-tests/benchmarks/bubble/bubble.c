/* stanford baby benchmark suite from john hennessy --
 *
 *
 * FOR CS152, this has been modified to only execute Bubblesort, and to use a
 * smaller input size to run in a few dozen thousand cycles, intead of 10-20M.

There are copies all around; the MIPS performance brief has up-to-date
numbers for a bunch of machines. BUT, these wouldn't be my first
choice. SPEC, the industry benchmark collection group, will probably
specify a new set of benchmarks shortly and release then right after
that. I imagine they will include espresso, gcc, and other large, but
public domain programs, for real things.

here's bench.c
	John Hennessy
*/


/*  This is a suite of benchmarks that are relatively short, both in program
    size and execution time.  It requires no input, and prints the execution
    time for each program, using the system- dependent routine Getclock,
    below, to find out the current CPU time.  It does a rudimentary check to
    make sure each program gets the right output.  These programs were
    gathered by John Hennessy and modified by Peter Nye. 

4.2 VERSION   */


#include "util.h" // riscv

//#include <sys/types.h>
//#include <sys/times.h>

#define  nil		 0
#define	 false		 0
#define  true		 1
#define  bubblebase 	 1.61
#define  dnfbase 	 3.5
#define  permbase 	 1.75
#define  queensbase 	 1.83
#define  towersbase 	 2.39
#define  quickbase 	 1.92
#define  intmmbase 	 1.46
#define  treebase 	  2.5
#define  mmbase 	 0.0
#define  fpmmbase 	 2.92
#define  puzzlebase 	 0.5
#define  fftbase 	 0.0
#define  fpfftbase 	 4.44
    /* Towers */
#define maxcells 	 18

    /* Intmm, Mm */
#define rowsize 	 40

    /* Puzzle */
#define size	 	 511
#define classmax 	 3
#define typemax 	 12
#define d 		 8

    /* Bubble, Quick */
#define sortelements 	 2000
#define srtelements 	 100
//#define sortelements 	 5000 // this takes 1.7M cycles, 1.7CPI
//#define srtelements 	 500

    /* fft */
#define fftsize 	 256 
#define fftsize2 	 129  
/*
type */
    /* Perm */
#define    permrange 10

   /* tree */
struct node {
	struct node *left,*right;
	int val;
    };

    /* Towers */ /*
    discsizrange = 1..maxcells; */
#define    stackrange	3
/*    cellcursor = 0..maxcells; */
struct    element {
	    int discsize;
	    int next;
	};
/*    emsgtype = packed array[1..15] of char;
*/
    /* Intmm, Mm */ /*
    index = 1 .. rowsize;
    intmatrix = array [index,index] of integer;
    realmatrix = array [index,index] of real;
*/
    /* Puzzle */ /*
    piececlass = 0..classmax;
    piecetype = 0..typemax;
    position = 0..size;
*/
    /* Bubble, Quick */ /*
    listsize = 0..sortelements;
    sortarray = array [listsize] of integer;
*/
    /* FFT */
struct    complex { float rp, ip; } ;
/*
    carray = array [1..fftsize] of complex ;
    c2array = array [1..fftsize2] of complex ;
*/

float value;
float    fixed,floated;

    /* global */
int    timer;
int    xtimes[11];
int    seed;

    /* Perm */
int    permarray[permrange+1];
int    pctr;

    /* tree */
struct node *tree;

    /* Towers */
int    stack[stackrange+1];
struct element    cellspace[maxcells+1];
int    freelist,
       movesdone;

    /* Intmm, Mm */
int ima[rowsize+1][rowsize+1], imb[rowsize+1][rowsize+1], imr[rowsize+1][rowsize+1];
float rma[rowsize+1][rowsize+1], rmb[rowsize+1][rowsize+1], rmr[rowsize+1][rowsize+1];

    /* Puzzle */
int	piececount[classmax+1],
	class[typemax+1],
	piecemax[typemax+1],
	puzzl[size+1],
	p[typemax+1][size+1],
	n,
	kount;

    /* Bubble, Quick */
int    sortlist[sortelements+1],
    biggest, littlest,
    top;

    /* FFT */
struct complex    z[fftsize+1], w[fftsize+1],
    e[fftsize2+1];
float    zr, zi;

/* global procedures */

int Getclock ()
    {
//    struct tms rusage;
//    times (&rusage);
//    return (rusage.tms_utime*50/3);
#if (!HOST_DEBUG && SET_STATS && USE_SUPERVISOR_MODE)
      return rdcycle();
#else
      return 0;
#endif
    };

Initrand ()
    {
    seed = 74755;
    };

int Rand ()
    {
    seed = (seed * 1309 + 13849) & 65535;
    return( seed );
    };




 

    /* Sorts an array using bubblesort */

bInitarr()
{
  int i, temp;
  Initrand();
  biggest = 0; littlest = 0;
  for ( i = 1; i <= srtelements; i++ )
  {
    temp = Rand();
    sortlist[i] = temp - (temp/100000)*100000 - 50000;
    if ( sortlist[i] > biggest ) biggest = sortlist[i];
    else if ( sortlist[i] < littlest ) littlest = sortlist[i];
  };
};

Bubble()
{
  int i, j;
  bInitarr();
  top=srtelements;

  while ( top>1 ) {

    i=1;
    while ( i<top ) {

      if ( sortlist[i] > sortlist[i+1] ) {
        j = sortlist[i];
        sortlist[i] = sortlist[i+1];
        sortlist[i+1] = j;
      };
      i=i+1;
    };

    top=top-1;
  };
  //if ( (sortlist[1] != littlest) || (sortlist[srtelements] != biggest) )
    //	printf ( "Error3 in Bubble.\n");
};

main()
{
int i;
fixed = 0.0;	floated = 0.0;
/* rewrite (output); */
setStats(1);
////printf("    Perm"); timer = Getclock(); Perm();   xtimes[1] = Getclock()-timer;
//fixed = fixed + permbase*xtimes[1];
//floated = floated + permbase*xtimes[1];
////printf("  Towers"); timer = Getclock(); Towers(); xtimes[2] = Getclock()-timer;
//fixed = fixed + towersbase*xtimes[2];
//floated = floated + towersbase*xtimes[2];
////printf("  Queens"); timer = Getclock(); Queens(); xtimes[3] = Getclock()-timer;
//fixed = fixed + queensbase*xtimes[3];
//floated = floated + queensbase*xtimes[3];
////printf("   Intmm"); timer = Getclock(); Intmm();  xtimes[4] = Getclock()-timer;
//fixed = fixed + intmmbase*xtimes[4];
//floated = floated + intmmbase*xtimes[4];
////printf("      Mm"); timer = Getclock(); Mm();     xtimes[5] = Getclock()-timer;
//fixed = fixed + mmbase*xtimes[5];
//floated = floated + fpmmbase*xtimes[5];
////printf("  Puzzle"); timer = Getclock(); Puzzle(); xtimes[6] = Getclock()-timer;
//fixed = fixed + puzzlebase*xtimes[6];
//floated = floated + puzzlebase*xtimes[6];
////printf("   Quick"); timer = Getclock(); Quick();  xtimes[7] = Getclock()-timer;
//fixed = fixed + quickbase*xtimes[7];
//floated = floated + quickbase*xtimes[7];

////printf("  Bubble"); 
//timer = Getclock(); 
Bubble(); 
//xtimes[8] = Getclock()-timer;
//fixed = fixed + bubblebase*xtimes[8];
//floated = floated + bubblebase*xtimes[8];

////printf("    Tree"); timer = Getclock(); Trees(); xtimes[9] = Getclock()-timer;
//fixed = fixed + treebase*xtimes[9];
//floated = floated + treebase*xtimes[9];
////printf("     FFT"); timer = Getclock(); Oscar(); xtimes[10] = Getclock()-timer;
//fixed = fixed + fftbase*xtimes[10];
//floated = floated + fpfftbase*xtimes[10];

////printf("\n");
setStats(0);
////printf("\n");
////for ( i = 1; i <= 10; i++ ) printf("%8d", xtimes[i]);
////printf("\n");
//    /* compute composites */
////    printf("\n");
////    printf("Nonfloating point composite is %10.0f\n",fixed/10.0);
////    printf("\n");
////    printf("Floating point composite is %10.0f\n",floated/10.0);

}



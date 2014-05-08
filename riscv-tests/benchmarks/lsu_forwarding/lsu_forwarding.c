//**************************************************************************
// Load/Store Unit Torture Benchmark (Forwarding)
//--------------------------------------------------------------------------
//
// CS152 Students should add their own benchmark code in here.
// Use as many lines of code as you need (but run for at least 20k cycles).
// Try to maximize store data forwarding.


//  util.h is found in riscv-bmarks/common/
#include "util.h"

//--------------------------------------------------------------------------
// Input/Reference Data

// If you need to statically include a dataset, include it here.  Look at vvadd
// for an example.

//--------------------------------------------------------------------------
// Helper functions

int verify_test( int n, int test[], int correct[] )
{
   // You should probably write your own verify function.
   // Don't trust BOOM to not be buggy!
  return 1;
}

#if HOST_DEBUG 
void printArray( char name[], int n, int arr[] )
{
  int i;
  printf( " %10s :", name );
  for ( i = 0; i < n; i++ )
    printf( " %3d ", arr[i] );
  printf( "\n" );
}
#endif

   
//--------------------------------------------------------------------------
// the main computations
//
// Call functions, run highly nested loops, write inline assembly... go crazy.
// Just be sure to look at the objdumps to make sure the compiler is not
// undoing your work.

__attribute__ ((noinline)) void benchmark()
{
   // maximize store-data forwarding
}
 
//--------------------------------------------------------------------------
// Main

int main( int argc, char* argv[] )
{
  // BENCHMARK #1:  Try to maximize store-data forwarding.

  setStats(1);
  benchmark();
  setStats(0);

  // Check the results
 

  return 0; // You'll probably want to call your verify function here.
            // Return 0 for success, anything else for failure.
}

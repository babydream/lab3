//**************************************************************************
// Parameter Introspect: discover a parameter of BOOM via a microbenchmark
//--------------------------------------------------------------------------
//
// CS152 Students should add their own benchmark code in here.


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
  return 0;
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
__attribute__ ((noinline)) void benchmark()
{
   
}
    
//--------------------------------------------------------------------------
// Main

int main( int argc, char* argv[] )
{
  setStats(1);
  benchmark();
  setStats(0);

  // Check the results
 
  return 0; // You'll probably want to call your verify function here.
            // Return 0 for success, anything else for failure.
}

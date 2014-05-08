//************************************************************
// CS152 Lab 3: Tracer class for analyzing BOOM
//************************************************************
// TA      : Christopher Celio
// Date    : 2012 Spring
// Student :  


#include <stdint.h>
#include <stdio.h>
#include "emulator.h" 
#include "Top.h" 
       
class Tracer_t {

   public:
      Tracer_t(Top_t* _tile, FILE* log);
      void start();
      void tick();
      void monitor_issue_window(Top_t *tile);
      void stop();
      void print();

   private:
      Top_t*     tile;      // Device under test
      int        paused;    // is stat collection paused?
        
      struct 
      {
         uint64_t cycles;
         uint64_t cycle_counter;
         uint64_t inst_count;
         
         uint64_t brpred_mispred_count; //number of unsuccessful predictions
                  
         uint64_t nop_count;
         uint64_t bubble_count;
         uint64_t ldst_count;
         uint64_t arith_count;
         uint64_t br_count;  
         uint64_t jmp_count;  
         uint64_t misc_count;  


         /* XXX Step 1: ADD MORE COUNTS HERE */
         uint64_t load_count;
         uint64_t store_count;

         uint64_t lsu_order_fail_count; // pipeline flushes due to load-store ordering fail
         uint64_t lsu_ld_put_to_sleep; // load matched store and put to sleep
         uint64_t lsu_ld_forwarded;    // load forwarded from an older store 
         uint64_t lsu_misc;    // load forwarded from an older store 
         uint64_t ic_miss;     // instruction cache miss
         uint64_t dc_miss;     // data cache miss
         uint64_t dc_secondary_miss; // data cache secondary miss
         // etc. 
      
      } trace_data;


      FILE*      logfile;
};


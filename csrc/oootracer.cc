#include "oootracer.h"


// emulator.cpp passes in a pointer to the Instruction Register 
// found in the simulated processor.
//Tracer_t::Tracer_t(dat_t<32>* _inst_ptr, dat_t<1>* _stats_reg, FILE* log)
Tracer_t::Tracer_t(Top_t *_tile, FILE* log)
{
   tile = _tile;
   logfile  = log;
   paused   = 1;
}

// Initializes and turns the tracer on. 
void Tracer_t::start()
{
   paused = 0;
   trace_data.cycles                = tile->Top_BoomTile_core_dpath__my_cycle.lo_word();
   trace_data.inst_count            = tile->Top_BoomTile_core_dpath__my_instret.lo_word();
   trace_data.brpred_mispred_count  = tile->Top_BoomTile_core_dpath__my_mispred.lo_word();  
   trace_data.br_count              = tile->Top_BoomTile_core_dpath__my_branches.lo_word();  
                  
   trace_data.nop_count   = 0;
   trace_data.bubble_count= 0;
   trace_data.ldst_count  = 0;
   trace_data.arith_count = 0;
   trace_data.br_count    = tile->Top_BoomTile_core_dpath__my_branches.lo_word();  
   trace_data.jmp_count   = 0;  
   trace_data.misc_count  = 0;  
   trace_data.load_count  = tile->Top_BoomTile_core_dpath__my_lds.lo_word();
   trace_data.store_count = tile->Top_BoomTile_core_dpath__my_sts.lo_word();
   trace_data.lsu_order_fail_count = tile->Top_BoomTile_core_dpath__my_ld_order_fail.lo_word();
   trace_data.lsu_ld_put_to_sleep  = tile->Top_BoomTile_core_dpath__my_ld_sleep.lo_word();
   trace_data.lsu_ld_forwarded     = tile->Top_BoomTile_core_dpath__my_ld_forward.lo_word();
   trace_data.lsu_misc          = 0;
   trace_data.ic_miss = tile->Top_BoomTile_core_dpath__my_ic_miss.lo_word();
   trace_data.dc_miss = tile->Top_BoomTile_core_dpath__my_dc_miss.lo_word();
   trace_data.dc_secondary_miss = 0;

   /* XXX Step 2: INITIALIZE YOUR COUNTERS HERE */
}


// pull bits from a bit-array
// getBits(inst, 6,0) returns inst[6:0]
int getBits(uint32_t data_bits, int hi_bit, int lo_bit)
{
   int sz = hi_bit - lo_bit + 1;
   int offset  = lo_bit;
   int sz_mask = 0xFFFFFFFF >> (32-sz);
   return ((data_bits >> offset) & sz_mask);
}


void Tracer_t::tick()
{
  if(!paused && tile->Top__io_debug_0_track_cycle.lo_word())
  {
    monitor_issue_window(tile);
  }

}
 
// LAB 3, Question 2.4 and 2.5
void Tracer_t::monitor_issue_window(Top_t *tile)
{
   // Instructions:
   //
   // 0. I'm passing in the entire "tile" object. You can access any of its
   //    elements (i.e., you can read any register or wire in the Chisel design!).
   //
   // 1. Grep through ./generated-src/Top.h to find the C++ names to Chisel signals
   //
   // 2. The templated dat_t<> types need to be converted to the uint64_t type:
   //    call ".lo_word()" to get the lowest 64bits from the signal.
   //
   // 3. ???
   //
   // 4 Profit!
   //
   // Note: There are FOUR issue slots to monitor.
   //
   //
   // To give you a head-start, here are the eight most interesting signals for
   // Question 2.4: The chisel code for these signals can be found in
   // dpath.scala, in the IntegerIssueSlot component.
   //
   // dat_t<1> Top_BoomTile_core_dpath_issue_unit_IntegerIssueSlot_0__slot_valid;
   // dat_t<1> Top_BoomTile_core_dpath_issue_unit_IntegerIssueSlot_1__slot_valid;
   // dat_t<1> Top_BoomTile_core_dpath_issue_unit_IntegerIssueSlot_2__slot_valid;
   // dat_t<1> Top_BoomTile_core_dpath_issue_unit_IntegerIssueSlot_3__slot_valid;
   // ...
   // dat_t<1> Top_io_debug_0_issue_slot_request_0;
   // dat_t<1> Top_io_debug_0_issue_slot_request_1;
   // dat_t<1> Top_io_debug_0_issue_slot_request_2;
   // dat_t<1> Top_io_debug_0_issue_slot_request_3;
   // ...
   
   uint64_t num_ready_to_issue = 0;

/******
 *
   // an example of reading the valid bit of IntegerIssueSlot number n
   fprintf(logfile, "CYC %llu:\n",
     tile->Top_BoomTile_core_dpath__my_cycle.lo_word());
  
   #define MONITOR_ISSUE_SLOT(n) \
   if (tile->Top_BoomTile_core_dpath_issue_unit_IntegerIssueSlot_##n##__slot_valid.lo_word()) \
   {	\
      fprintf(logfile, "\tIntegerIssueSlot" #n " is PC 0x%lx  %s\n",\
	      tile->Top_BoomTile_core_dpath_issue_unit_IntegerIssueSlot_##n##__slotUop_pc.lo_word(), \
        tile->Top__io_debug_0_issue_slot_request_##n.lo_word() ? " -- REQ -- " : "XX"); \
      \
   }

     MONITOR_ISSUE_SLOT(0)
     MONITOR_ISSUE_SLOT(1)
     MONITOR_ISSUE_SLOT(2)
     MONITOR_ISSUE_SLOT(3)
     // ...
     fprintf(logfile, "\n");
*****/ 

   /* XXX Step 3. WRITE YOUR CODE HERE*/
      

   // insert code that increments "num_ready_to_issue" 

   // insert code that increments your counters

}

                                   
void Tracer_t::stop()
{
  trace_data.cycles = tile->Top_BoomTile_core_dpath__my_cycle.lo_word() -  trace_data.cycles; 
  trace_data.inst_count           = tile->Top_BoomTile_core_dpath__my_instret.lo_word() - trace_data.inst_count;
  trace_data.br_count             = tile->Top_BoomTile_core_dpath__my_branches.lo_word() - trace_data.br_count;
  trace_data.load_count           = tile->Top_BoomTile_core_dpath__my_lds.lo_word() - trace_data.load_count;
  trace_data.brpred_mispred_count = tile->Top_BoomTile_core_dpath__my_mispred.lo_word() - trace_data.brpred_mispred_count;
  trace_data.store_count          = tile->Top_BoomTile_core_dpath__my_sts.lo_word() - trace_data.store_count;
  trace_data.lsu_ld_forwarded     = tile->Top_BoomTile_core_dpath__my_ld_forward.lo_word() - trace_data.lsu_ld_forwarded;
  trace_data.lsu_order_fail_count = tile->Top_BoomTile_core_dpath__my_ld_order_fail.lo_word() -  trace_data.lsu_order_fail_count;
  trace_data.lsu_ld_put_to_sleep  = tile->Top_BoomTile_core_dpath__my_ld_sleep.lo_word() -  trace_data.lsu_ld_put_to_sleep;
  trace_data.ic_miss             = tile->Top_BoomTile_core_dpath__my_ic_miss.lo_word() - trace_data.ic_miss;
  trace_data.dc_miss             = tile->Top_BoomTile_core_dpath__my_dc_miss.lo_word() - trace_data.dc_miss;
  paused = 1;
}

void Tracer_t::print()
{
  fprintf(logfile, "\n");
  fprintf(logfile, "#----------- Tracer Data -----------\n");

  if (trace_data.cycles == 0)
    fprintf(logfile, "\n#     No stats collected: co-processor register cr10 was never set by the software.\n\n");
  else
    fprintf(logfile, "#\n");

   fprintf(logfile, "#      CPI   : %2.3g\n",  ((double) trace_data.cycles) / ((double) trace_data.inst_count));
   fprintf(logfile, "#      IPC   : %2.3g\n",  ((double) trace_data.inst_count) / ((double) trace_data.cycles));
   fprintf(logfile, "#      Instructions : %lu\n",  trace_data.inst_count);
   fprintf(logfile, "#\n");
   fprintf(logfile, "#      BrPred Accur: %2.3g %%\n",  100.0 * ((double) (trace_data.br_count - trace_data.brpred_mispred_count)) / trace_data.br_count);
   fprintf(logfile, "#      Mispredicts : %lu\n",  trace_data.brpred_mispred_count);
   fprintf(logfile, "#      Predictions : %lu\n",  trace_data.br_count);
   fprintf(logfile, "#\n");

/* 
   fprintf(logfile, "#      Bubbles     : %2.3g %%\n",  100.0 * ((double) trace_data.bubble_count)/ trace_data.inst_count);
   fprintf(logfile, "#      Nop instr   : %2.3g %%\n",  100.0 * ((double) trace_data.nop_count  ) / trace_data.inst_count);
   fprintf(logfile, "#      Arith instr : %2.3g %%\n",  100.0 * ((double) trace_data.arith_count) / trace_data.inst_count);
   fprintf(logfile, "#      Ld/St instr : %2.3g %%\n",  100.0 * ((double) trace_data.ldst_count ) / trace_data.inst_count);
   fprintf(logfile, "#      branch instr: %2.3g %%\n",  100.0 * ((double) trace_data.br_count   ) / trace_data.inst_count);
   fprintf(logfile, "#      jump   instr: %2.3g %%\n",  100.0 * ((double) trace_data.jmp_count  ) / trace_data.inst_count);
   fprintf(logfile, "#      misc instr  : %2.3g %%\n",  100.0 * ((double) trace_data.misc_count ) / trace_data.inst_count);
  */

   fprintf(logfile, "#\n#\n");
   fprintf(logfile, "#        - Loads            : %lu\n", trace_data.load_count);
   fprintf(logfile, "#           - order-fail    : %lu   (%2.3g %%)\n",  trace_data.lsu_order_fail_count
                                          , 100.0 * ((double) trace_data.lsu_order_fail_count) / trace_data.load_count);
   fprintf(logfile, "#            - forwarded   : %lu   (%2.3g %%)\n",  trace_data.lsu_ld_forwarded
                                          , 100.0 * ((double) trace_data.lsu_ld_forwarded) / trace_data.load_count);
   fprintf(logfile, "#            - put-to-sleep: %lu   (%2.3g %%)\n",  trace_data.lsu_ld_put_to_sleep
                                          , 100.0 * ((double) trace_data.lsu_ld_put_to_sleep) / trace_data.load_count);

   fprintf(logfile, "#        - Stores           : %lu\n", trace_data.store_count);
   fprintf(logfile, "#        - IC Misses        : %lu (%2.3g %%)\n", trace_data.ic_miss, 100.0 * ((double) trace_data.ic_miss / (trace_data.inst_count)));
   fprintf(logfile, "#        - DC Misses        : %lu (%2.3g %%)\n", trace_data.dc_miss, 100.0 * ((double) trace_data.dc_miss) / (trace_data.load_count + trace_data.store_count));
   uint64_t primary_misses = trace_data.dc_miss - trace_data.dc_secondary_miss;

   /* XXX Step 4. PRINT YOUR COUNTERS HERE */
   
   
   fprintf(logfile, "#-----------------------------------\n");
   fprintf(logfile, "\n");


}

package DRAMModel

import Chisel._
import scala.math._
import uncore._

object MemModelConstants{
  val NUM_BANKS = 8
  val NUM_ROWS = 16384
  val NUM_COLS = 512
  val DATABUS_WIDTH = 64
  val ROW_WIDTH = 512
  val BURST_LENGTH = ROW_WIDTH/DATABUS_WIDTH
  val DRAM_BANK_ADDR_WIDTH = log2Up(NUM_BANKS)
  val DRAM_ROW_ADDR_WIDTH = log2Up(NUM_ROWS)
  val DRAM_COL_ADDR_WIDTH = log2Up(NUM_COLS)

  val TIMING_COUNTER_WIDTH = 8
  val tCL = 4
  Predef.assert(tCL > 0)
  val tWL = 3
  Predef.assert(tWL > 0)
  val NUM_CMDS = 5
  val activate_cmd :: read_cmd :: write_cmd :: precharge_cmd :: other_cmd :: Nil=Enum(UInt(), NUM_CMDS)
  val CMD_WIDTH = log2Up(NUM_CMDS)
}

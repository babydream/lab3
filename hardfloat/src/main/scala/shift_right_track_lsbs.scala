package hardfloat

import Chisel._
import Node._;

import scala.collection.mutable.ArrayBuffer;

class shift_right_track_lsbs_io(DATA_WIDTH: Int, SHIFT_BITS: Int) extends Bundle {
  val do_shift = Bool(INPUT)
  val in       = UInt(INPUT, DATA_WIDTH)
  val in_lsb   = UInt(INPUT, 1)
  val out      = UInt(OUTPUT, DATA_WIDTH)
  val out_lsb  = UInt(OUTPUT, 1)
}

class shift_right_track_lsbs(DATA_WIDTH: Int = 64, SHIFT_BITS: Int = 6) extends Module {
  override val io = new shift_right_track_lsbs_io(DATA_WIDTH, SHIFT_BITS);

  io.out := Mux(io.do_shift,
        Cat(Fill(SHIFT_BITS, UInt(0, 1)), io.in(DATA_WIDTH-1, SHIFT_BITS)),
        io.in);

  io.out_lsb := Mux(io.do_shift,
        io.in_lsb.toBool || (io.in(SHIFT_BITS-1, 0) != UInt(0, SHIFT_BITS)),
        io.in_lsb);
}

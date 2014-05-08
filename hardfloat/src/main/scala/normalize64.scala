package hardfloat

import Chisel._
import Node._;

import normalize64._;
import scala.collection.mutable.ArrayBuffer;

class normalize64_io(width: Int, num_bits: Int) extends normalize_io {
  override val in       = UInt(INPUT, width);
  override val distance = UInt(OUTPUT, num_bits);
  override val out      = UInt(OUTPUT, width);
}

object normalize64 {
  //def apply() = { val c = new normalize64(); withComp(c, i => c.init()); c }
  def fold(buf: ArrayBuffer[UInt], fun: (UInt, UInt) => UInt) = {
    var res = buf(0);
    for (i <- 1 until buf.length)
      res = fun(res, buf(i))
    res
  }
}

class normalize64(width: Int = 64, num_bits: Int = 6) extends Module {
  override val io = new normalize64_io(width, num_bits);

  var distances = ArrayBuffer[Bool]()
  var norms     = ArrayBuffer[UInt]()
  var shift_bits = width;

  norms += io.in;

  for (i <- 0 until num_bits) {
    shift_bits >>= 1; // Divide by 2
    distances += norms.last(width - 1, width - shift_bits) === UInt(0, shift_bits);
    norms     += Mux(distances.last.toBool, norms.last << UInt(shift_bits), norms.last);
  }

  io.out      := norms.last(width-1,0);

  io.distance := fold(distances.map(x => x.toBits), Cat(_, _));
  
}

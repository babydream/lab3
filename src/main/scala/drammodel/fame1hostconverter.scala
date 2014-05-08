package referencechip

import Chisel._
import Node._
import uncore._

class HostPacket(htif_width: Int) extends Bundle
{
  val data = Bits(width = htif_width)
  override def clone: this.type = { new HostPacket(htif_width).asInstanceOf[this.type]}
}


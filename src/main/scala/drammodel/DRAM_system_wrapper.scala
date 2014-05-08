package DRAMModel

import Chisel._
import Node._
import DRAMModel.MemModelConstants._
import uncore._

class DRAMSystemWrapper()(implicit conf: MemoryControllerConfiguration) extends Module {
  implicit val mif = conf.mif
  val io = new Bundle{
    val mem = new MemIO
    val memResp = new FameDecoupledIO(new MemResp())
    val memReqCmd = new FameDecoupledIO(new MemReqCmd()).flip()
    val memReqData = new FameDecoupledIO(new MemData()).flip()
    val errors = new DRAMModelErrorIO()
    val params = new DRAMModelParameterIO()
    //debug
    //val ctrlFSMReadData = Vec.fill(conf.deviceWidth){Bits(width = conf.mif.dataBits)}.asOutput
    //val memControllerReadDataIn = Vec.fill(conf.deviceWidth){new MemData}.asOutput
    //val memControllerReadDataConcat = Bits().asOutput
  }
  //mem model and mem controller declarations
  val DRAMModel = Module(new DRAMTimingModel())
  val memController = Module(new MemController())
  //val memController = new RekallWrapper()
  
  
  val fireTgtClk = Bool()
  
  DRAMModel.io.errors <> io.errors
  DRAMModel.io.params <> io.params 
  DRAMModel.io.ctrlFSM.fireTgtCycle := fireTgtClk
  DRAMModel.io.memController <> memController.io.DRAMModel
  memController.io.fireTgtCycle := fireTgtClk
  memController.io.params <> io.params
  memController.io.mem_cmd_queue.valid := io.memReqCmd.target.valid
  memController.io.mem_cmd_queue.bits := io.memReqCmd.target.bits
  io.memReqCmd.target.ready := memController.io.mem_cmd_queue.ready && fireTgtClk
  memController.io.mem_data_queue.valid := io.memReqData.target.valid
  memController.io.mem_data_queue.bits := io.memReqData.target.bits
  io.memReqData.target.ready := memController.io.mem_data_queue.ready && fireTgtClk
  io.memResp.target.valid := memController.io.mem_resp_queue.valid && fireTgtClk
  io.memResp.target.bits.tag := memController.io.mem_resp_queue.bits.tag
  io.memResp.target.bits.data := memController.io.mem_resp_queue.bits.data
  memController.io.mem_resp_queue.ready := io.memResp.target.ready
  
  //requester side Fame1 IO
  val executeTgtCycle = Bool(); executeTgtCycle := fireTgtClk
  io.memReqCmd.host_ready := Bool(false)
	io.memReqData.host_ready := Bool(false)
	io.memResp.host_valid := Bool(false)
  when(executeTgtCycle){
		io.memReqCmd.host_ready := Bool(true)
		io.memReqData.host_ready := Bool(true)
		io.memResp.host_valid := Bool(true)
	}
	
	//backing mem side IO
	io.mem.req_cmd.valid := Bool(false)
	io.mem.req_cmd.bits.rw := Bool(false)
	io.mem.req_cmd.bits.tag := Bits(0)
	io.mem.req_cmd.bits.addr := UInt(0)
	io.mem.req_data.valid := Bool(false)
	io.mem.req_data.bits.data := UInt(0)
	io.mem.resp.ready := Bool(false)
	
	//read data regs
	val readDataRegs = Vec.fill(3){Reg(new MemData)}
  val readTagReg = Reg(Bits())
  readTagReg := io.mem.resp.bits.tag.toBits
	//ctrl_fsm
  val idle :: send_read_cmd :: wait_for_read_data0 :: wait_for_read_data1 :: wait_for_read_data2 :: wait_for_read_data3 :: send_write_cmd :: send_write_data0 :: send_write_data1 :: send_write_data2 :: send_write_data3 :: executeTgtCycle1 :: executeTgtCycle2 :: Nil = Enum(UInt(), 13)
  
  val current_state = Reg(init = idle)
  val next_state = UInt(); next_state := current_state
  current_state := next_state
  
  fireTgtClk := Bool(false)
  executeTgtCycle := Bool(false)
  DRAMModel.io.ctrlFSM.readData.valid := Bool(false)
  for(i <- 0 until 3){
    DRAMModel.io.ctrlFSM.readData.data(i) := readDataRegs(i).data
  }
  DRAMModel.io.ctrlFSM.readData.data(3) := io.mem.resp.bits.data
  //io.ctrlFSMReadData := DRAMModel.io.ctrlFSM.readData.data
  //io.memControllerReadDataIn := memController.io.debug_out
  //io.memControllerReadDataConcat := memController.io.debug_readData
  when(current_state === idle){
    fireTgtClk := io.memReqCmd.host_valid && io.memReqData.host_valid && io.memResp.host_ready
    executeTgtCycle := Bool(true)
    next_state := executeTgtCycle1
    when(DRAMModel.io.ctrlFSM.doWrite){
      fireTgtClk := Bool(false)
      next_state := send_write_cmd
    }.elsewhen(DRAMModel.io.ctrlFSM.doRead){
      fireTgtClk := Bool(false)
      next_state := send_read_cmd
    }
  }.elsewhen(current_state === send_read_cmd){
    when(io.mem.req_cmd.ready){
      io.mem.req_cmd.valid := Bool(true)
      io.mem.req_cmd.bits.rw := Bool(false)
      io.mem.req_cmd.bits.addr := DRAMModel.io.ctrlFSM.readAddr
      next_state := wait_for_read_data0
    }
  }.elsewhen(current_state === wait_for_read_data0){
    when(io.mem.resp.valid){
      io.mem.resp.ready := Bool(true)
      readDataRegs(0).data := io.mem.resp.bits.data
      next_state := wait_for_read_data1
    }
  }.elsewhen(current_state === wait_for_read_data1){
    when(io.mem.resp.valid){
      io.mem.resp.ready := Bool(true)
      readDataRegs(1).data := io.mem.resp.bits.data
      next_state := wait_for_read_data2
    }
  }.elsewhen(current_state === wait_for_read_data2){
    when(io.mem.resp.valid){
      io.mem.resp.ready := Bool(true)
      readDataRegs(2).data := io.mem.resp.bits.data
      next_state := wait_for_read_data3
    }
  }.elsewhen(current_state === wait_for_read_data3){
    when(io.mem.resp.valid && io.memReqCmd.host_valid && io.memReqData.host_valid && io.memResp.host_ready){
      io.mem.resp.ready := Bool(true)
      fireTgtClk := io.memReqCmd.host_valid && io.memReqData.host_valid && io.memResp.host_ready
      executeTgtCycle := Bool(true)
      DRAMModel.io.ctrlFSM.readData.valid := Bool(true)
      next_state := executeTgtCycle1
    }
  }.elsewhen(current_state === send_write_cmd){
    when(io.mem.req_cmd.ready){
      io.mem.req_cmd.valid := Bool(true)
      io.mem.req_cmd.bits.rw := Bool(true)
      io.mem.req_cmd.bits.addr := DRAMModel.io.ctrlFSM.writeAddr
			next_state := send_write_data0
		}
  }.elsewhen(current_state === send_write_data0){
    when(io.mem.req_data.ready){
      io.mem.req_data.valid := Bool(true)
      io.mem.req_data.bits.data := DRAMModel.io.ctrlFSM.writeData(0)
			next_state := send_write_data1
		}
  }.elsewhen(current_state === send_write_data1){
    when(io.mem.req_data.ready){
      io.mem.req_data.valid := Bool(true)
      io.mem.req_data.bits.data := DRAMModel.io.ctrlFSM.writeData(1)
			next_state := send_write_data2
		}
  }.elsewhen(current_state === send_write_data2){
    when(io.mem.req_data.ready){
      io.mem.req_data.valid := Bool(true)
      io.mem.req_data.bits.data := DRAMModel.io.ctrlFSM.writeData(2)
			next_state := send_write_data3
		}
  }.elsewhen(current_state === send_write_data3){
    when(DRAMModel.io.ctrlFSM.doRead){
      when(io.mem.req_data.ready){
        io.mem.req_data.valid := Bool(true)
        io.mem.req_data.bits.data := DRAMModel.io.ctrlFSM.writeData(3)
        next_state := send_read_cmd
      }
    }.otherwise{
      when(io.mem.req_data.ready && io.memReqCmd.host_valid && io.memReqData.host_valid && io.memResp.host_ready){
        io.mem.req_data.valid := Bool(true)
        io.mem.req_data.bits.data := DRAMModel.io.ctrlFSM.writeData(3)
        executeTgtCycle := Bool(true)
        fireTgtClk := io.memReqCmd.host_valid && io.memReqData.host_valid && io.memResp.host_ready
        next_state := executeTgtCycle1
      }
    }
  }.elsewhen(current_state === executeTgtCycle1){
    executeTgtCycle := Bool(true)
    next_state := executeTgtCycle2
  }.elsewhen(current_state === executeTgtCycle2){ 
    executeTgtCycle := Bool(true)
    next_state := idle
  }
}

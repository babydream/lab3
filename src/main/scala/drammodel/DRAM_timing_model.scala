package DRAMModel

import Chisel._;
import Node._;
import DRAMModel.MemModelConstants._
import uncore._

class DRAMModelToCtrlFSMIO()(implicit conf: MemoryControllerConfiguration) extends Bundle {
  val readAddr = UInt(OUTPUT)
  val writeAddr = UInt(OUTPUT)
  val doRead = Bool(OUTPUT)
  val doWrite = Bool(OUTPUT)
  val writeData = Vec.fill(conf.deviceWidth){Bits(width = conf.mif.dataBits)}.asOutput
  val readData = new Bundle {
    val valid = Bool().asInput
    val data = Vec.fill(conf.deviceWidth){Bits(width = conf.mif.dataBits)}.asInput
  }
  val fireTgtCycle = Bool(INPUT)
}

class DRAMModelToMemControllerIO() extends Bundle {
  val cmdBus = new DDRCommandBus().asInput
  val writeDataBus = new DDRDataBus().asInput
  val readDataBus = new DDRDataBus().asOutput
}

class DDRCommandBus extends Bundle {
  val valid = Bool()
  val cmd = UInt(width = CMD_WIDTH)
  val bankAddr = UInt(width = DRAM_BANK_ADDR_WIDTH)
  val rowAddr = UInt(width = DRAM_ROW_ADDR_WIDTH)
  val colAddr = UInt(width = DRAM_COL_ADDR_WIDTH)
}

class DDRDataBus() extends Bundle {
  val valid = Bool()
  val data = Bits(width = DATABUS_WIDTH)
}

class DRAMModelParameterIO extends BankParameterIO {
  val tRRD = UInt(INPUT, width = TIMING_COUNTER_WIDTH)
}

class DRAMModelErrorIO extends BankErrorIO {
  val tRRD_violation = Bool(OUTPUT)
  val tWL_violation = Bool(OUTPUT)
}

class DRAMTimingModel()(implicit conf: MemoryControllerConfiguration) extends Module {
  val io = new Bundle {
    val ctrlFSM = new DRAMModelToCtrlFSMIO()
    val memController = new DRAMModelToMemControllerIO()
    val params = new DRAMModelParameterIO()
    val errors = new DRAMModelErrorIO()
  }
  val banks = Array.fill(NUM_BANKS){Module(new DRAMBank())}
  var tRRD_violation = Bool(false)
  var invalidCmd = Bool(false) 
  var tRAS_violation = Bool(false) 
  var tRCD_violation = Bool(false) 
  var tRP_violation = Bool(false) 
  var tCCD_violation = Bool(false) 
  var tRTP_violation = Bool(false) 
  var tWTR_violation = Bool(false) 
  var tWR_violation = Bool(false) 
  
  for(i <- 0 until NUM_BANKS){
    banks(i).io.params <> io.params
    invalidCmd = invalidCmd || banks(i).io.errors.invalidCmd
    tRAS_violation = tRAS_violation || banks(i).io.errors.tRAS_violation  
    tRCD_violation = tRCD_violation || banks(i).io.errors.tRCD_violation
    tRP_violation = tRP_violation || banks(i).io.errors.tRP_violation  
    tCCD_violation = tCCD_violation || banks(i).io.errors.tCCD_violation 
    tRTP_violation = tRTP_violation || banks(i).io.errors.tRTP_violation 
    tWTR_violation = tWTR_violation || banks(i).io.errors.tWTR_violation 
    tWR_violation = tWR_violation || banks(i).io.errors.tWR_violation 
    banks(i).io.fireTgtCycle := io.ctrlFSM.fireTgtCycle
    banks(i).io.cmds.valid := io.memController.cmdBus.bankAddr === UInt(i) && io.memController.cmdBus.valid
    banks(i).io.cmds.activate := io.memController.cmdBus.cmd === activate_cmd
    banks(i).io.cmds.read := io.memController.cmdBus.cmd === read_cmd
    banks(i).io.cmds.write := io.memController.cmdBus.cmd === write_cmd
    banks(i).io.cmds.precharge := io.memController.cmdBus.cmd === precharge_cmd
    banks(i).io.cmds.bankAddr := UInt(i)
    banks(i).io.cmds.rowAddr := io.memController.cmdBus.rowAddr
    banks(i).io.cmds.colAddr := io.memController.cmdBus.colAddr
  }
  io.errors.invalidCmd := invalidCmd
  io.errors.tRAS_violation := tRAS_violation
  io.errors.tRCD_violation := tRCD_violation
  io.errors.tRP_violation := tRP_violation
  io.errors.tCCD_violation := tCCD_violation
  io.errors.tRTP_violation := tRTP_violation
  io.errors.tWTR_violation := tWTR_violation
  io.errors.tWR_violation := tWR_violation
  
  
  //select appropriate row addr to use based on bank selected
  val rowAddr = UInt()
  rowAddr := banks(0).io.ctrl.rowAddr
  for(i <- 0 until NUM_BANKS){
    when(io.memController.cmdBus.bankAddr === UInt(i)){
      rowAddr := banks(i).io.ctrl.rowAddr
    }
  }
  
  //read delay chain
  io.ctrlFSM.doRead := io.memController.cmdBus.cmd === read_cmd & io.memController.cmdBus.valid
  if(conf.addrOffsetWidth > 0){
    io.ctrlFSM.readAddr := Cat(io.memController.cmdBus.bankAddr, rowAddr, io.memController.cmdBus.colAddr, UInt(0, width = conf.addrOffsetWidth))
  } else {
    io.ctrlFSM.readAddr := Cat(io.memController.cmdBus.bankAddr, rowAddr, io.memController.cmdBus.colAddr)
  }
  val readDataShiftRegs = Vec.fill(tCL + BURST_LENGTH - 1){Reg(init = Bits(0, width = DATABUS_WIDTH))}
  val readDataValidShiftRegs = Vec.fill(tCL + BURST_LENGTH - 1){Reg(init = Bool(false))}
  when(io.ctrlFSM.fireTgtCycle){
    readDataValidShiftRegs(0) := Bool(false)
    for(i <- 1 until tCL + BURST_LENGTH - 1){
      readDataShiftRegs(i) := readDataShiftRegs(i - 1)
      readDataValidShiftRegs(i) := readDataValidShiftRegs(i - 1)
    }
    var readData = io.ctrlFSM.readData.data(0)
    for(i <- 1 until conf.deviceWidth){
      readData = Cat(io.ctrlFSM.readData.data(i), readData)
    }
    for(i <- 0 until BURST_LENGTH){
      when(io.ctrlFSM.readData.valid){
        readDataShiftRegs(i) := readData((i+1)*DATABUS_WIDTH - 1, i*DATABUS_WIDTH)
        readDataValidShiftRegs(i) := Bool(true)
      }
    }
  }
  io.memController.readDataBus.valid := readDataValidShiftRegs(tCL + BURST_LENGTH - 2)
  
  io.memController.readDataBus.data := readDataShiftRegs(tCL + BURST_LENGTH - 2)
  //writeData delay chain
  if(BURST_LENGTH - 1 > 0){
    val writeDataShiftRegs = Vec.fill(BURST_LENGTH - 1){Reg(init = Bits(0))}
    var writeData = io.memController.writeDataBus.data
    for(i <- 0 until BURST_LENGTH - 1){
      writeData = Cat(writeDataShiftRegs(i), writeData)
    }
    for(i <- 0 until conf.deviceWidth){
      io.ctrlFSM.writeData(i) := writeData((i+1)*conf.mif.dataBits - 1, i*conf.mif.dataBits)
    }
    when(io.ctrlFSM.fireTgtCycle){
      writeDataShiftRegs(0) := io.memController.writeDataBus.data
      for(i <- 1 until BURST_LENGTH - 1){
        writeDataShiftRegs(i) := writeDataShiftRegs(i - 1)
      }
    }
  } else {
    for(i <- 0 until conf.deviceWidth){
      io.ctrlFSM.writeData(i) := io.memController.writeDataBus.data((i+1)*conf.mif.dataBits - 1, i*conf.mif.dataBits)
    }
  }
  //doWrite and writeAddr delay chain
  val expectReceiveWriteData = Bool()
  if(tWL + BURST_LENGTH - 1 > 0){
    val doWriteShiftRegs = Vec.fill(tWL + BURST_LENGTH - 1){Reg(init = Bool(false))}
    val writeAddrShiftRegs = Vec.fill(tWL + BURST_LENGTH - 1){Reg(init = UInt(0))}
    io.ctrlFSM.doWrite := doWriteShiftRegs(tWL + BURST_LENGTH - 1 - 1)
    io.ctrlFSM.writeAddr := writeAddrShiftRegs(tWL + BURST_LENGTH - 1 - 1)
    when(io.ctrlFSM.fireTgtCycle){
      doWriteShiftRegs(0) := io.memController.cmdBus.cmd === write_cmd & io.memController.cmdBus.valid
      if(conf.addrOffsetWidth > 0){
        writeAddrShiftRegs(0) := Cat(io.memController.cmdBus.bankAddr, rowAddr, io.memController.cmdBus.colAddr, UInt(0, width = conf.addrOffsetWidth))
      } else {
        writeAddrShiftRegs(0) := Cat(io.memController.cmdBus.bankAddr, rowAddr, io.memController.cmdBus.colAddr)
      }
      for(i <- 1 until tWL + BURST_LENGTH - 1){
        doWriteShiftRegs(i) := doWriteShiftRegs(i - 1)
        writeAddrShiftRegs(i) := writeAddrShiftRegs(i - 1)
      }
    }
    expectReceiveWriteData := doWriteShiftRegs(tWL - 1)
  } else {//this case is not possible right now since we force tWL >= 1 and BURST_LENGTH >= 1, but we might add support in the future
    io.ctrlFSM.doWrite := io.memController.cmdBus.cmd === write_cmd & io.memController.cmdBus.valid
    if(conf.addrOffsetWidth > 0){
      io.ctrlFSM.writeAddr := Cat(io.memController.cmdBus.bankAddr, rowAddr, io.memController.cmdBus.colAddr, UInt(0, width = conf.addrOffsetWidth))
    } else {
      io.ctrlFSM.writeAddr := Cat(io.memController.cmdBus.bankAddr, rowAddr, io.memController.cmdBus.colAddr)
    }
    expectReceiveWriteData := io.memController.cmdBus.cmd === write_cmd & io.memController.cmdBus.valid
  }
  
  val tWL_violation = Reg(init = Bool(false))
  when(io.ctrlFSM.fireTgtCycle){
    tWL_violation := (expectReceiveWriteData & ~io.memController.writeDataBus.valid) | tWL_violation
  }
  io.errors.tWL_violation := tWL_violation
}

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles


@cocotb.test()
async def test_vtisa_cpu(dut):
    dut._log.info("start")
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # reset
    dut._log.info("reset")
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 1)

    dut.ui_in.value = 0xd0

    # reset
    dut._log.info("reset")
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 1)

    rom = [0xd0, 0xd1, 0xd2, 0xd3]
    ram = [0, 0, 0, 0, 0, 17, 0, 0, 0]

    await read(dut, rom, 0)
    await read(dut, ram, 5)
    await read(dut, rom, 1)
    await read(dut, ram, 5)
    await read(dut, rom, 2)


async def read(dut, mem, rom_addr):
    addr = int(dut.uo_out.value)
    assert addr == rom_addr
    dut.ui_in.value = mem[rom_addr]
    await ClockCycles(dut.clk, 1)

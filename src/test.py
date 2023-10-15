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

    assert int(dut.uo_out.value) == 0
    await ClockCycles(dut.clk, 1)
    assert int(dut.uo_out.value) == 1
    await ClockCycles(dut.clk, 1)
    assert int(dut.uo_out.value) == 2
    await ClockCycles(dut.clk, 1)
    assert int(dut.uo_out.value) == 3

    # reset
    dut._log.info("reset")
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 1)

    assert int(dut.uo_out.value) == 0

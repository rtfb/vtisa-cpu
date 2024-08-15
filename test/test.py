# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


ROM = [0xd0, 0xd1, 0xd2, 0xd3]
RAM = [0xb1, 0xb2, 0xb3, 0xb4, 0xb5, 17, 0xb6, 0xb7, 0xb8]


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    dut._log.info("Test project behavior")

    mem = must_rom(dut)
    await read(dut, mem, 0)

    # mem = must_ram(dut)
    # await read(dut, mem, 0)

    mem = must_ram(dut)
    await read(dut, mem, 5)

    mem = must_rom(dut)
    await read(dut, mem, 1)

    mem = must_ram(dut)
    await read(dut, mem, 5)

    mem = must_rom(dut)
    await read(dut, mem, 2)

    mem = must_ram(dut)
    await read(dut, mem, 5)


def must_rom(dut):
    flags = int(dut.uio_out.value)
    assert flags == 0
    return ROM


def must_ram(dut):
    flags = int(dut.uio_out.value)
    # assert flags == 1
    return RAM


async def read(dut, mem, want_addr):
    """CPU has exposed address in uo_out. Read it, and set ui_in to whatever we
    have in memory for that address.
    """
    addr = int(dut.uo_out.value)
    # assert addr == want_addr
    dut.ui_in.value = mem[addr]
    await ClockCycles(dut.clk, 1)

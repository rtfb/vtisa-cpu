# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


# ROM = [0x0f, 0xd1, 0xd2, 0xd3]
# ROM = [0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f]
ROM = [
    0x09,  # LI 1
    0x13,  # LD r3 - load memory to r3, from address stored at acc
    0x89,  # INC 1 - acc+=1
    0x89,  # INC 1 - acc+=1
    0x89,  # INC 1 - acc+=1
    0x89,  # INC 1 - acc+=1
    0x53,  # SETACC r3 - set acc to contents of r3
    0x0d,  # LI 5
    0x40,  # GETACC r0 - set r0 to contents of acc
    0,
    0,
    0,
    0,
    0,
    0,
]
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

    # Wait one more cycle to get out of reset
    await ClockCycles(dut.clk, 1)

    for i in range(len(ROM)):
        mem = get_mem(dut)
        print(i, hex(mem[i]))
        await read(dut, mem, i)
    await ClockCycles(dut.clk, 1)
    await ClockCycles(dut.clk, 1)
    await ClockCycles(dut.clk, 1)


def must_rom(dut):
    flags = int(dut.uio_out.value)
    assert flags == 0
    return ROM


def must_ram(dut):
    flags = int(dut.uio_out.value)
    assert flags == 1
    return RAM


def get_mem(dut):
    flags = int(dut.uio_out.value)
    if (flags&1) == 1:
        return RAM
    return ROM


async def read(dut, mem, want_addr):
    """CPU has exposed address in uo_out. Read it, and set ui_in to whatever we
    have in memory for that address.
    """
    addr = int(dut.uo_out.value)
    dut.ui_in.value = mem[addr]
    await ClockCycles(dut.clk, 1)

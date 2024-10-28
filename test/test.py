import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 ns (100 MHz)
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    # Reset signals
    dut._log.info("Reset")
    dut.ce_n.value = 1  # Disable chip by default
    dut.lr_n.value = 1  # No write by default
    dut.mar.value = 0   # Default address
    dut.data_in.value = 0
    await ClockCycles(dut.clk, 5)

    # Write to RAM
    dut._log.info("Write data to RAM")
    dut.lr_n.value = 0     # Enable write (active-low)
    dut.mar.value = 4      # Address 4
    dut.data_in.value = 100 # Write 100 to address 4
    await ClockCycles(dut.clk, 1)
    dut.lr_n.value = 1     # Disable write

    # Read from RAM
    dut._log.info("Read data from RAM")
    dut.ce_n.value = 0     # Enable chip (active-low)
    dut.mar.value = 4      # Address 4
    await ClockCycles(dut.clk, 1)

    # Verify the data read
    assert dut.data_out.value == 100, f"Expected 100, got {dut.data_out.value}"

    # Write and read another value
    dut._log.info("Write and read data from another address")
    dut.lr_n.value = 0     # Enable write (active-low)
    dut.mar.value = 2      # Address 2
    dut.data_in.value = 50  # Write 50 to address 2
    await ClockCycles(dut.clk, 1)
    dut.lr_n.value = 1     # Disable write

    # Read from address 2
    dut.mar.value = 2      # Address 2
    await ClockCycles(dut.clk, 1)

    # Verify the data read
    assert dut.data_out.value == 50, f"Expected 50, got {dut.data_out.value}"

    dut._log.info("Test completed successfully")

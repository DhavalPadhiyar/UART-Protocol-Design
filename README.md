# UART Protocol Design in Verilog

## Overview
This repository contains **basic UART protocol design** implemented in **Verilog HDL**  
and verified in **Xilinx Vivado**. The project demonstrates **baud rate generation, data transmission, and reception** at the RTL level.

## Platform & Tools
- **HDL:** Verilog  
- **EDA Tool:** Xilinx Vivado  
- **Simulation:** Vivado Simulator  
- **Target:** FPGA / RTL Simulation  

## Modules Included

### Baud Rate Generator
- Generates timing ticks for UART communication  
- Configurable for different baud rates  

### UART Transmitter (TX)
- Sends 8-bit parallel data serially  
- Includes **start bit** and **stop bit**  
- `tx_busy` signal indicates ongoing transmission  

### UART Receiver (RX)
- Receives 8-bit serial data  
- Detects **start bit**  
- Outputs `rx_data` and `rx_done` flag  

> Note: Features like oversampling, parity, and error detection are **not included**.  
> **Estimated Working Percentage:** ~80%  

## Author
**Dhaval Padhiyar**  
Verilog | Digital Design | UART Communication

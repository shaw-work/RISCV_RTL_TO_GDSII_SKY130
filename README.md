# 5-Stage Pipelined RISC-V Processor ASIC Implementation

## Overview

This project implements a 5-stage pipelined RISC-V processor in Verilog HDL and demonstrates a complete RTL-to-GDSII ASIC implementation using OpenLane 2 and the Sky130 Open PDK.

## Features

* 5-stage pipeline (IF, ID, EX, MEM, WB)
* Data hazard detection
* Forwarding unit
* Pipeline registers
* ALU control logic
* Register file
* Instruction memory

## ASIC Flow

The complete ASIC implementation flow was executed using:

* OpenLane 2.3.10
* OpenROAD
* Sky130 Open PDK
* Magic
* Netgen
* KLayout

Flow stages:

1. RTL Design
2. Linting
3. Logic Synthesis
4. Floorplanning
5. Placement
6. Clock Tree Synthesis
7. Routing
8. DRC Verification
9. LVS Verification
10. GDSII Generation

## Final Results

* Standard Cells: 105
* Core Area: 1471.41 µm²
* Die Area: 3034.89 µm²
* Utilization: 50.85%
* Total Power: 121.66 µW
* DRC Violations: 0
* LVS Errors: 0
* Setup Violations: 0
* Hold Violations: 0

## Generated Outputs

* GDSII Layout
* DEF
* LEF
* Gate-Level Netlist
* SPICE Netlist
* Timing Reports
* Power Reports

## Tools Used

Verilog HDL, OpenLane, OpenROAD, Sky130 PDK, Magic, Netgen, KLayout, Docker, WSL Ubuntu.

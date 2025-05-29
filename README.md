# RISC-V-pipeline-architecture

32-bit 5-stage pipelined RISC-V processor implementing RV32I instructions **excluding branches and jumps**. Designed for educational purposes and modular extension.

## Features
- **5-stage pipeline**: IF, ID, EX, MEM, WB
- **Supported instructions**:
  - **R-type**: ADD, SUB, OR, AND, SLT
    
 ![image](https://github.com/user-attachments/assets/ac569592-64b1-42c7-a536-032420bfe636)

  - **I-type**: LW, SW
    
![image](https://github.com/user-attachments/assets/0e2332e0-b4a5-4219-a7f3-b5cb9a92599f)
- **Hazard handling**:
  - **Forwarding unit** for EX/MEM and MEM/WB stages
- **Separate instruction/data memories**
- **Verilog implementation** with testbench support

## Pipeline Stages
### 1. Instruction Fetch (IF)
- PC increments by 4 each cycle [2]
- Instruction memory interface
- IF/ID pipeline register

### 2. Instruction Decode (ID)
- Register file access (2 read ports, 1 write port)
- Immediate generation
- Hazard detection unit [4]

### 3. Execute (EX)
- ALU operations
- Address calculation for memory access
- EX/MEM pipeline register

### 4. Memory Access (MEM)
- Data memory interface (read/write)
- MEM/WB pipeline register

### 5. Write Back (WB)
- Result selection (ALU vs memory)
- Register file writeback

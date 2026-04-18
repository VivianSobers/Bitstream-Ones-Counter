# Bitstream Ones Counter

A hardware implementation of a **bitstream ones counter** — loads a 15-bit input, serially shifts it out, and counts the number of `1` bits using a ripple counter. Designed in Verilog HDL with a Logisim circuit schematic and a self-checking testbench.

---

## Circuit Schematic

![Logisim Circuit](Logisim%20Circuit.png)

---

## How It Works

1. A **15-bit parallel load shift register** accepts the input data
2. On each clock cycle, one bit is shifted out serially (`sout`)
3. Every time a `1` bit is shifted out, the **4-bit ripple counter** increments
4. After all 15 bits are shifted, the counter holds the **total number of 1s** in the input

```
data[14:0] ──► [ Shift Register ] ──sout──► en ──► [ Ripple Counter ] ──► count[3:0]
                    ▲                               ▲
                  load/shift                       clk/rst
```

---

## Modules

### `tff` — T Flip-Flop
The fundamental building block. Toggles output `q` on the rising clock edge when `t = 1`. Synchronous active-high reset.

### `shift_reg` — 15-bit Shift Register
| Signal | Direction | Description |
|--------|-----------|-------------|
| `clk` | Input | Clock |
| `rst` | Input | Reset (clears register) |
| `load` | Input | Parallel load enable |
| `data[14:0]` | Input | 15-bit input data |
| `shift` | Input | Shift enable |
| `sout` | Output | Serial output (LSB first) |

### `counter` — 4-bit Ripple Counter
Built from 4 T flip-flops in ripple configuration. Increments when enable `en` is high. Counts up to 15 — sufficient for a 15-bit input.

### `project` — Top-level Module
Connects the shift register and counter. The counter enable is driven by `shift & sout`, so it only increments when actively shifting out a `1`.

---

## Simulation

### Requirements
- [Icarus Verilog](https://bleyer.org/icarus/) — for simulation
- [GTKWave](https://gtkwave.sourceforge.net/) — for waveform viewing
- [Logisim Evolution](https://github.com/logisim-evolution/logisim-evolution) — to open the `.circ` schematic

### Run the testbench

```bash
iverilog -o sim tb_project.v project.v
vvp sim
```

### View waveforms

```bash
gtkwave project.vcd
```

### Test case

The testbench loads `101011101011101` (15 bits) and shifts it out over 15 clock cycles.

```
Input:  101011101011101
             ↓
Expected count: 10  (ten 1s in the bitstream)
```

Sample monitor output:
```
Time=12  | shift=0 | sout=0 | count=0000
Time=22  | shift=1 | sout=1 | count=0001
Time=32  | shift=1 | sout=0 | count=0001
Time=42  | shift=1 | sout=1 | count=0010
...
```

---



## Built With

- Verilog HDL
- [Icarus Verilog](https://bleyer.org/icarus/)
- [GTKWave](https://gtkwave.sourceforge.net/)
- [Logisim Evolution](https://github.com/logisim-evolution/logisim-evolution)

---

## Author

**Vivian Sobers E** — [github.com/VivianSobers](https://github.com/VivianSobers)

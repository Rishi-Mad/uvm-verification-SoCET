# Shift Register
Simple shift register with serial-to-parallel and parallel-to-serial functionality.

## Sample Waveform
![Shift register sample waveform, described below](./shift_register_wave.png)

The waveform shows the shift register configured with `NUM_BITS = 4` and `SHIFT_MSB = 0` (LSB-first). After reset, `shift_enable` goes high and `serial_in` shifts in a sequence of bits over several cycles, with `parallel_out` progressing through 0000, 0001, 0011, and 0110 as new bits arrive at the LSB. `parallel_load` is then asserted with `parallel_in` set
to 1111, which overrides shifting and loads the parallel value directly.
After the load, shifting resumes and `parallel_out` becomes 1110 as a 0 shifts in.

## I/O
| Port Name | Direction | Type | Description |
|:---------:|:---------:|:----:|:-----------|
| `CLK` | `input` | `logic` | Clock |
| `nRST` | `input` | `logic` | Active-low asynchronous reset |
| `shift_enable` | `input` | `logic` | Enable shifting in direction of `SHIFT_MSB` parameter |
| `serial_in` | `input` | `logic` | Serial input |
| `parallel_load` | `input` | `logic` | Loads parallel data into shift register |
| `parallel_in` | `input` | `logic [NBITS-1 : 0]` | Parallel input data |
| `serial_out` | `output` | `logic` | Serial out |
| `parallel_out` | `output` | `logic [NBITS-1 : 0]` | Parallel value of shift register |

## Function
This implements a shift register capable of serial-to-parallel and parallel-to-serial conversion in addition to simple shifting. When the `shift_enable` signal is high, the shift register will shift by 1 position each cycle in the direction indicated by `SHIFT_MSB`. `shift_out` is driven by the opposite of the `SHIFT_MSB` flag; that is, if `SHIFT_MSB = 0`, `serial_out` will be the MSB of the register.

If `parallel_load` is high, the value of `parallel_in` is loaded into the shift register. This overrides `shift_enable`, and the register will *not* shift during this cycle.

The shift register will reset to the value indicated by `RESET_VAL`. 

## Parameters
| Parameter     | Type | Description | Default Value | Valid Range |
|:---------------:|:------:|:-------------|:---------------:|:-------------:|
| `NUM_BITS` | `int` | Number of bits in the shift register | 4 | >= 2 |
| `SHIFT_MSB` | `bit` | Determines shifting direction. `SHIFT_MSB = 1` indicates that the value shifts in/out MSB-first, `SHIFT_MSB = 0` indicates LSB first. | 1 (MSB) | 0 (LSB), 1 (MSB) |
| `RESET_VAL` | `bit` | Fill value of bits in shift register upon asynchronous reset | `1'b1` | 0, 1|
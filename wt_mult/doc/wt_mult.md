# Wallace Tree Multiplier
Parameterizable Wallace tree multiplier.

## I/O
| Port Name | Direction | Type | Description |
|:---------:|:---------:|:----:|:-----------|
| `CLK` | `input` | `logic` | Clock |
| `nRST` | `input` | `logic` | Active-low asynchronous reset |
| `ready` | `input` | `logic` | Indicates that `a` and `b` should begin multiplication |
| `a` | `input` | `logic [WIDTH-1:0]` | Multiplier input |
| `b` | `input` | `logic [WIDTH-1:0]` | Multiplicand input |
| `done` | `output` | `logic` | Indicates that a previous multiplication has finished |
| `out` | `output` | `logic [2*WIDTH-1:0]` | Result of a previous multiplication |

## Function
This Wallace tree multiplier is fully pipelined and consists of 3 stages. The
first stage generates `WIDTH^2` partial products by multiplying every bit of
`a` by every bit of `b`. The second stage consists of ~`lg(WIDTH)` stages of half
adders and full adders to reduce a grid of `WIDTH*2 x WIDTH` number of inputs
into a `2 x WIDTH` number of inputs. The final stage reduces the final two rows
of the grid into the product using a carry-propagate adder.

More information on the partial product generation scheme can be found in
`partial_prod.py`, and more information about the reduction tree scheme can be
found in `reduction_tree.py`.

## Performance

Cycle delays with no stage merging for common bit widths are shown below.

| Width     | Delay (Cycles) |
|:---------:|:-----:|
| 4         | 5     |
| 8         | 7     |
| 16        | 9     |
| 32        | 11    |
| 64        | 13    |

## Parameters
| Parameter     | Type | Description | Default Value | Valid Range |
|:---------------:|:------:|:-------------|:---------------:|:-------------:|
| `WIDTH` | `int` | Width of the `a` and `b` inputs. Output will be `2*WIDTH` bits wide | 32 | >= 1 |
| `MERGE_PROD_GEN_REDUCE_STAGES` | `logic` | Determines whether there is a FF layer between the first and second stages. Setting to '1' will merge the product generation stage with the succeeding reduction stage | 0 | 0,1 |
| `STAGE_DEPTH` | `int` | Determines how many layers should be combined before adding a FF layer | 1 | 0..`reduce_depth(WIDTH)` |
| `MERGE_REDUCE_FINAL_STAGES` | `logic` | Determines whether there is a FF layer between the final reduction layer and the third stage | 0 | 0,1 |

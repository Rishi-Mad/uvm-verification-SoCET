Library of modules that are common use: 
Synchronizer
Parameters:
"High" or "Low" reset value (SYNC_HIGH and SYNC_LOW from 337)
Stages? (2 or 3)

Shift Register
Features:
Parallel load and read
Serial input and output
Parameters:
Length (in bits)
Order (MSB-First vs. LSB-First) (TODO: Should this be a parameter, or an input? i.e. controlled by a signal)

FIFO Buffer
Features:
Parameters:
Width (# of bits per data element)
Depth (# of data elements to fit in FIFO)

Counter
Features:
Synchronous "clear"
Overflow flag
Overflow value
Up/Down counting?
Parameters:
Bits

APB Slave Interface

AHB Slave Interface



SV_FILES := src/socetlib_apb_completer.sv
PACKAGE_FILES := package/apb_pkg.sv
HEADER_FILES := ../interfaces ./inc
TB_FILES := tb/register_sim.sv tb/tb_socetlib_apb_completer.sv

XCELIUM_HEADER := $(patsubst %, -incdir %, $(HEADER_FILES))
VERILATOR_HEADER := $(patsubst %, -y %, $(HEADER_FILES))

XCELIUM_ARGS := -access +rwc -timescale '1ns/10ps'

define USAGE
@echo "------------------------------------------------"
@echo " Build Targets:"
@echo " 	verilate: Invoke verilator on input files"
@echo "		clean: Remove verilator output
@echo "------------------------------------------------"
endef


.PHONY: default clean

default:
	$(USAGE)

verilate:
	verilator -cc --report-unoptflat --trace-fst --trace-structs --top-module

xcelium:
	xrun $(XCELIUM_ARGS) $(XCELIUM_HEADER) $(SV_FILES) $(TB_FILES)

gui:
	xrun $(XCELIUM_ARGS) -gui -input restore.tcl $(XCELIUM_HEADER) $(SV_FILES) $(TB_FILES)

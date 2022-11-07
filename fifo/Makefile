TOP = tb_uvm_fifo.sv
TB = tb/
RTL = src/socetlib_fifo.sv

build:
	vlog +incdir+src+tb \
	+acc \
	+cover \
	-L $$QUESTA_HOME/uvm-1.2 $(FIFO) tb/$(TOP) \
	-logfile tb_compile.log \
	-printinfilenames=file_search.log

run:
	vsim -c tb_uvm_fifo -L \
	$$QUESTA_HOME/uvm-1.2 \
	-voptargs=+acc \
	-coverage \
	+UVM_TESTNAME="test" \
	+UVM_VERBOSITY=UVM_LOW \
	-do "do wave.do" -do "run -all" &

run_gui:
	vsim -i tb_uvm_fifo -L \
	$$QUESTA_HOME/uvm-1.2 \
	-voptargs=+acc \
	-coverage \
	+UVM_TESTNAME="test" \
	+UVM_VERBOSITY=UVM_LOW \
	-do "do wave.do" -do "run -all" &

clean:
	rm -rf work
	rm -rf mitll90_Dec2019_all
	rm -rf covhtmlreport
	rm *.log
	rm transcript
	rm *.wlf
	rm *.vstf

.phony: build, run, run_gui, clean

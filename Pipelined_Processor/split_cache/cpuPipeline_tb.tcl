proc AddWaves {} {
#TODO
	;#Add waves we're interested in to the Wave window
    add wave -position end sim:/cpuPipeline_tb/pipeline/clk
	add wave -position end sim:/cpuPipeline_tb/pipeline/address
	add wave -position end sim:/cpuPipeline_tb/pipeline/instruction
	add wave -position end sim:/cpuPipeline_tb/pipeline/ALUOp
	add wave -position end sim:/cpuPipeline_tb/pipeline/IFIDaddress
	add wave -position end sim:/cpuPipeline_tb/pipeline/IFIDinstruction
	add wave -position end sim:/cpuPipeline_tb/pipeline/rs
	add wave -position end sim:/cpuPipeline_tb/pipeline/rt
	add wave -position end sim:/cpuPipeline_tb/pipeline/rd
	add wave -position end sim:/cpuPipeline_tb/pipeline/ra
	add wave -position end sim:/cpuPipeline_tb/pipeline/rb
	add wave -position end sim:/cpuPipeline_tb/pipeline/immediate_out
	add wave -position end sim:/cpuPipeline_tb/pipeline/IDEXAluOp
	add wave -position end sim:/cpuPipeline_tb/pipeline/IDEXra
	add wave -position end sim:/cpuPipeline_tb/pipeline/IDEXrb
	add wave -position end sim:/cpuPipeline_tb/pipeline/IDEXrd
	add wave -position end sim:/cpuPipeline_tb/pipeline/IDEXimmediate
	add wave -position end sim:/cpuPipeline_tb/pipeline/operator/input_a
	add wave -position end sim:/cpuPipeline_tb/pipeline/operator/input_b
	add wave -position end sim:/cpuPipeline_tb/pipeline/operator/out_alu
	add wave -position end sim:/cpuPipeline_tb/pipeline/EXMEMaluOutput
	add wave -position end sim:/cpuPipeline_tb/pipeline/EXMEMrd
	add wave -position end sim:/cpuPipeline_tb/pipeline/EXMEMregisterOutput
	add wave -position end sim:/cpuPipeline_tb/pipeline/MEMWBaluOutput
	add wave -position end sim:/cpuPipeline_tb/pipeline/MEMWBmemOutput
	add wave -position end sim:/cpuPipeline_tb/pipeline/WBrd
	add wave -position end sim:/cpuPipeline_tb/pipeline/rd_data
	add wave -position end sim:/cpuPipeline_tb/pipeline/write_enable
	add wave -position end sim:/cpuPipeline_tb/pipeline/RegisterFile/register_store

}

vlib work

;# Compile components if any
vcom alu.vhd
vcom adder.vhd
vcom controller.vhd
vcom cpuPipeline.vhd
vcom cpuPipeline_tb.vhd
vcom instructionFetchStage.vhd
vcom instructionMemory.vhd
vcom mem.vhd
vcom memory.vhd
vcom mux.vhd
vcom PC.vhd
vcom register_file.vhd
vcom signextender.vhd
vcom wb.vhd
vcom zero.vhd
vcom arbiter.vhd
vcom newMemory.vhd
vcom cache.vhd

;# Start simulation
vsim cpuPipeline_tb

;# Generate a clock with 1ns period
force -deposit clk 0 0 ns, 1 0.5 ns -repeat 1 ns

;# Add the waves
AddWaves

;# Run for 390000 ns
run 390000ns

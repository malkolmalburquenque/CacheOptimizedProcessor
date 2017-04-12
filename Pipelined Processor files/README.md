ECSE425 COMPUTER ARCHITECTURE
GROUP 7 

https://github.com/malkolmalburquenque/CacheOptimizedProcessor 

THIS ZIP CONTAINS:
1- The split cache optimized processor with all files required to run it.
2- The unified cache optimized processor with all files required to run it.
3- The unoptimized processor with all files to required to run it.
4- Assembler 
5- Testbenches used for optimization 

PROBLEMS WITH PD4:
- The pipelined processor can handle structural hazard but not data hazard.
- Some instructions such as mult/div/beq sometimes didn't work properly. 

FIXED FROM PD4:
-All instructions should work now by fixing the cpuPipeline.vhd and ALU.vhd. 

OPTIMIZATION ON PIPELINE PROCESSOR: 
	-Detached data memory and instruction memory from the PD4 pipelined processor 
	-Added arbiter.vhd and cache.vhd for both unified and split cache optimization to provide lower memory access delay.
	-Modified instruction and data memories to be a single memory
	-Modified the memory delay  from 1 ns to 20ns. 
	-The cache takes 3 clock cycles to perform instruction fetch or load/store.
	-Arbiter is asynchronous.
	
	Unified Cache Optimization:
	-Connected the arbiter to receive both the instruction fetch and the store/load from the CPU
	-Connected the arbiter to the unified cache where the cache accesses the memory when the cache misses.
	
	Split Cache Optimization: 
	-Connected two caches to receive the instruction fetch and the store/load from the CPU
	-Connected the two caches to the arbiter to access the memory when cache misses
	
Both cache optimizations should be working to run any test.

To operate the processor if not using the testbenches: 
-Place program.txt file in the same folder as the processor to test.
	-Program.txt needs to add 3 stall instructions at the beginning since the processor skips 2 instructions before running.
	-Data hazards not implemented, to get correct operation you need to put 3 stall instructions in between every two instructions that would cause data hazard in the program.txt
-Run the cpuPipeline_tb.tcl
	-This provides the necessary waves to showcase the operation.
	-It will write to the register.txt and memory.txt 
	-The .tcl file will write into register.txt and memory.txt the values of the registers and memory
		-for the unified cache after 210 000 ns, split cache after 390 000 ns and unoptimized after 360 000ns.
	
To run testbenches:
-Create the machine code using the Assembler. 
-Place the program.txt in the same folder as the processor to test.
-Run the cpuPipeline_tb.tcl 
	-This provides the necessary waves to showcase the operation
	-The .tcl file will write into register.txt and memory.txt the values of the registers and memory
		-for the unified cache after 210 000 ns, split cache after 390 000 ns and unoptimized after 360 000ns.


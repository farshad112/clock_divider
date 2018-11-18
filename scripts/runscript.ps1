# Remove all previous simulation file
if(Test-Path "..\sim\work"){
    Remove-Item -Path '..\sim\work' -Recurse
}

# Create work directory
vlib work
# Map work directory
vmap work work
# Compile
vlog -f ..\sim\sv_tb_filelist.f

# Simulate in gui mode
vsim clk_div_tb -gui -do "add wave -position insertpoint sim:/clk_div_tb/*; run -all;"
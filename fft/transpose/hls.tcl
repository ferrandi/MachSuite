open_project fft_transpose_syn

set_top fft1D_512

add_files fft.c -cflags "-I../../common"
add_files input.data
add_files check.data
add_files -tb local_support.c -cflags "-I../../common"
add_files -tb ../../common/support.c
add_files -tb ../../common/harness.c

set clock 10
set part virtex7

open_solution fft
set_part $part
create_clock -period $clock
set_clock_uncertainty 0
#source ./fft_dir
config_rtl -reset all -reset_level low
csynth_design
cosim_design -rtl verilog
exit

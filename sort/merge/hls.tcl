open_project sort_merge_syn

add_files sort.c -cflags "-I../../common"
add_files input.data
add_files check.data
add_files -tb local_support.c -cflags "-I../../common"
add_files -tb ../../common/support.c
add_files -tb ../../common/harness.c

set_top ms_mergesort

open_solution -reset solution
set_part virtex7
create_clock -period 10
source ./sort_dir
csynth_design
cosim_design -rtl verilog

exit

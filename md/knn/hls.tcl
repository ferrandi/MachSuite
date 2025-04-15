open_project md_knn_syn

add_files md.c -cflags "-I../../common"
add_files input.data
add_files check.data
add_files -tb local_support.c -cflags "-I../../common"
add_files -tb ../../common/support.c
add_files -tb ../../common/harness.c

set_top md_kernel

open_solution -reset solution
set_part virtex7
create_clock -period 10
#source ./knn_dir
#config_rtl -reset all -reset_level low
csynth_design
cosim_design -rtl verilog

exit

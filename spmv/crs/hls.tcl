open_project spmv_crs_syn

add_files spmv.c -cflags "-I../../common"
add_files input.data
add_files check.data
add_files -tb local_support.c -cflags "-I../../common"
add_files -tb ../../common/support.c
add_files -tb ../../common/harness.c

set_top spmv

open_solution -reset solution
set_part virtex7
create_clock -period 10
source ./spmv_dir
csynth_design
cosim_design -rtl verilog 

exit

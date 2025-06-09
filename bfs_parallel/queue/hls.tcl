open_project bfs_parallel_queue_syn
source ../../config.tcl

add_files bfs.cpp -cflags "-I../../common"
add_files input.data
add_files check.data
add_files -tb ../../common/harness.cpp
add_files -tb ../../common/support.cpp
add_files -tb local_support.cpp

set_top bfs

open_solution -reset solution
set_part $part_name
create_clock -period $period
source ./bfs_dir

if {$enable_csim} {
    csim_design
}
if {$enable_synth} {
    csynth_design
}
if {$enable_cosim} {
    cosim_design -rtl verilog
}
if {$enable_impl} {
    export_design -flow impl -rtl verilog -format ip_catalog
}

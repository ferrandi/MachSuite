open_project sort_radix_syn
source ../../config.tcl

set_top ss_sort

add_files sort.c -cflags "-I../../common"
add_files input.data
add_files check.data
add_files -tb local_support.c -cflags "-I../../common"
add_files -tb ../../common/support.c
add_files -tb ../../common/harness.c

open_solution solution
set_part $part_name
create_clock -period $period
source ./inline_dir

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

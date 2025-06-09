open_project stencil2d_syn
source ../../config.tcl

add_files stencil.c -cflags "-I../../common"
add_files input.data
add_files check.data
#add_files -tb ../../common/support.h
add_files -tb ../../common/support.c -cflags "-I../../common -g"
add_files -tb local_support.c -cflags "-I../../common -g"
add_files -tb ../../common/harness.c -cflags "-I../../common -g"

set_top stencil

open_solution -reset solution
set_part $part_name
create_clock -period $period
source ./stencil_dir

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

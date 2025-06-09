open_project aes_syn
source ../../config.tcl

add_files aes.c -cflags "-I../../common"
add_files input.data
add_files check.data
add_files -tb local_support.c -cflags "-I../../common"
add_files -tb ../../common/support.c
add_files -tb ../../common/harness.c

#add_files -tb aes_test.c

set_top aes256_encrypt_ecb

open_solution -reset solution
set_part $part_name
create_clock -period $period
source ./aes_dir

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

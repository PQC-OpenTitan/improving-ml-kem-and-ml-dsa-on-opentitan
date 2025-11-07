set start_f 10

set outdir reports

set help_text {
Usage: vivado -mode batch -source my_script.tcl -tclargs [options]

Options:
  --top_module <name>   Name of the top module to synthesize.
  --start_freq <freq>   Start frequrncy for search (default: $start_f MHz).
  --outdir <dir>        Output directory for reports (default: reports).
  -h, --help            Show this help and exit.
}

if {$argc == 0 || [lindex $argv 0] in {"-h" "--help"}} {
    puts $help_text
    exit 0
}

set top_module ""

for {set i 0} {$i < $argc} {incr i} {
  set arg [lindex $argv $i]
  switch -- $arg {
    --top_module {
      incr i
      set top_module [lindex $argv $i]
    }
    --start_freq {
      incr i
      set start_f [lindex $argv $i]
    }
    --outdir {
      incr i
      set outdir [lindex $argv $i]
    }
    default {
      puts "Unknown option: $arg"
    }
  }
}

set file_utilization $outdir/utilization.txt
set file_utilization_hierarchical $outdir/utilization_hierarchical.txt
set file_timing $outdir/timing.txt
set file_timing_summary $outdir/timing_summary.txt
set file_clocks $outdir/clocks.txt

puts "top_module=$top_module, start_freq=$start_f"


# proc json_escape {s} {
#     regsub -all {\\} $s {\\\\} s
#     regsub -all {"}  $s {\\"} s
#     regsub -all {\n} $s {\\n} s
#     return $s
# }
# proc json_obj {dictVal} {
#     set parts {}
#     foreach {k v} $dictVal {
#         if {[string is double -strict $v]} {
#             lappend parts "\"[json_escape $k]\": $v"
#         } else {
#             lappend parts "\"[json_escape $k]\": \"[json_escape $v]\""
#         }
#     }
#     return "{[join $parts , ]}"
# }
# 
# set metrics [file join $outdir "child_result.json"]
# 
# # Gather what the child sees
# set d [list \
#     top_module $top_module \
#     start_freq $start_f
# ]
# 
# # Pretend we computed a "metric" (timestamp)
# lappend d timestamp [clock format [clock seconds] -gmt 1 -format "%Y-%m-%dT%H:%M:%SZ"]
# 
# set fh [open $metrics w]
# puts $fh [json_obj $d]
# close $fh
# 
# exit 0

source lowrisc_ip_otbn_0.1.tcl

source rounding.tcl
source timing.tcl

synth_design -mode out_of_context -top $top_module

opt_design
set ACTIVE_STEP opt_design
 
write_checkpoint -force $outdir/synth.dcp


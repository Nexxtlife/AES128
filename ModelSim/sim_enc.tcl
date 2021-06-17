sputs {
  ModelSimSE general compile script version 1.1
  Copyright (c) Doulos June 2004, SD
}

# Simply change the project settings in this section
# for each new project. There should be no need to
# modify the rest of the script.


# design files are in 'root' directory so it has 
# "../" prefix

set library_file_list {
  design_lib {
    ../hdl/reg.vhd
    ../hdl/add_round_key.vhd
    ../hdl/s_box.vhd
    ../hdl/byte_sub.vhd
    ../hdl/shft_row.vhd
    ../hdl/gf_mult.vhd
    ../hdl/column_calc.vhd
    ../hdl/mix_column.vhd
    ../hdl/key_sch_round_function.vhd
    ../hdl/controller.vhd
    ../hdl/key_schedule.vhd
    ../hdl/aes_enc.vhd
	../hdl/interface_controller_v5.vhd
  }
  test_lib {
    ../testbench/interface_controller_v4_tb.vhd
  }
}

set top_level test_lib.aes_enc_tb

set wave_patterns {
  {clk and reset} {
    clk_tb
    rst_tb
  }
  {aes} {
    key_tb
    plaintext_tb
    ciphertext_tb
    done_tb
  }
  {interface} {
	interface_0_avalon_slave_1_read_tb
	interface_0_avalon_slave_1_write_tb
	interface_0_avalon_slave_1_waitrequest_tb
	interface_0_avalon_slave_1_address_tb
	interface_0_avalon_slave_1_byteenable_tb
	interface_0_avalon_slave_1_readdata_tb
	interface_0_avalon_slave_1_writedata_tb

  }
  
}

set wave_radices {         
  binary {
    clk_tb
    rst_tb
  }
  hexadecimal {
    # tutaj wpisujesz nazwy sygnałów które mają być wyświetlane jako heksadecymalne
    key_tb
    plaintext_tb
    ciphertext_tb
	interface_0_avalon_slave_1_address_tb
	interface_0_avalon_slave_1_byteenable_tb
	interface_0_avalon_slave_1_readdata_tb
	interface_0_avalon_slave_1_writedata_tb
  }
  decimal {
    # tutaj wpisujesz nazwy sygnałów które mają być wyświetlane jako wartości dziesiętne
  }
}

# tutaj możesz zmienić kolory syganłów dla wygody debugowania
# valid color names are:
# gold, {sky blue}, plum, pink, wheat, gray80, {violet red}
set wave_colors {
  
  gold {
    ciphertext_tb
  }
}


# After sourcing the script from ModelSim for the
# first time use these commands to recompile.

proc r  {} {uplevel #0 source sim_setup.tcl}
proc rr {} {
  global last_compile_time
  set last_compile_time 0
  r
}
proc q  {} {
  quit -force
}

proc res {} {
  restart -f
  # Initialize SDRAM content
  # do sdram_mock/ram_init.do
  run -a
}

#Does this installation support Tk?
set tk_ok 1
if [catch {package require Tk}] {set tk_ok 0}

# Prefer a fixed point font for the transcript
set PrefMain(font) {Courier 10 roman normal}

# Compile out of date files
set time_now [clock seconds]
if [catch {set last_compile_time}] {
  set last_compile_time 0
}

foreach {library file_list} $library_file_list {
  vlib $library
  vmap work $library
  foreach file $file_list {
    if { $last_compile_time < [file mtime $file] } {
      if [regexp {.vhdl?$} $file] {
        vcom -2008 +cover -fsmverbose t $file
      } else {
        vlog $file
      }
      set last_compile_time 0
    }
  }
}
set last_compile_time $time_now

# Load the simulation
eval vsim -fsmdebug $top_level

if [llength $wave_patterns] {
  noview wave
  foreach {group signals} $wave_patterns {
    add wave -divider $group
    foreach signal $signals {
      add wave $signal
    }
  }
  # short wave names display
  configure wave -signalnamewidth 1
  foreach {radix signals} $wave_radices {
    foreach signal $signals {
      catch {property wave -radix $radix $signal}
    }
  }
  # set wave color
  foreach {color signals} $wave_colors {
    foreach signal $signals {
      catch {property wave -color $color $signal}
    }
  }
  configure wave -namecolwidth 180
}


# Initialize SDRAM content
#do sdram_mock/ram_init.do

# Run the simulation
run -all

# If waves are required
if [llength $wave_patterns] {
  if $tk_ok {wave zoomfull}
}

puts {
  Script commands are:

   r = Recompile changed and dependent files
  rr = Recompile everything
 res = Restart simulation without compilation
  q  = Quit without confirmation
}

# How long since project began?
if {[file isfile start_time.txt] == 0} {
  set f [open start_time.txt w]
  puts $f "Start time was [clock seconds]"
  close $f
} else {
  set f [open start_time.txt r]
  set line [gets $f]
  close $f
  regexp {\d+} $line start_time
  set total_time [expr ([clock seconds]-$start_time)/60]
  puts "Project time is $total_time minutes"
}

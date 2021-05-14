namespace eval console {
  variable mpath
  variable cpath

  proc get_service_path {service_type} {
    if {[catch {
        set service_path [lindex [get_service_paths $service_type] 0] 
      } errmsg]} {
      puts "Error during service path get"
      puts "$errmsg"
    } else {
      if {[string trimleft $service_path "\n"] eq ""} {
        puts "No valid service found. Check connection to FPGA and/or reconnect cables."
        set res 0
      } else {
        puts "Selected $service_type service path: $service_path"
        set res $service_path
      }
      return $res
    }
  }

  proc get_service_claim {service_path service_type} {
    if {[catch {
        set claim_path [claim_service $service_type $service_path ""]
    } errmsg]} {
      puts "Error during claiming service"
      puts $errmsg
    } else {
      if {[string trimleft $claim_path "\n"] eq ""} {
        puts "No valid claim found. Check connection to FPGA and/or reconnect cables."
        set res 0
      } else {
        puts "Selected $service_type type at path $service_path \nhas claim $claim_path"
        set res $claim_path
      }
      return $res
    }    
  }
  
  proc close_service_claim {service_type service_claim} {  
    puts "Closing $service_claim"
    if {[catch {
        close_service $service_type $service_claim  
      } errmsg]} {
      puts "Error during closing claim service"
      puts $errmsg
    } else {
      puts "Successfuly closed claim $service_claim"
    }
  }
  
  proc get_master_path {} {
    set ::console::mpath [get_service_path "master"]
  }

  proc get_master_claim {} {
    if {[set claim_path [get_service_claim $::console::mpath "master"]] != 0} {
      lappend ::console::cpath $claim_path
      puts "Success, now you can use your claimed service"
    } else {
      puts "Check connection and try again claim service"
    }
  }

  proc close_master_claim {} {
    if {[llength $::console::cpath] > 0} {
      close_service_claim "master" [lindex $::console::cpath end]
      set ::console::cpath [lreplace $::console::cpath end end]
    } else {
      puts "No more caims to close"
    }
  }

  proc close_all {} {
    foreach service $::console::cpath {
      close_service_claim "master" [lindex $::console::cpath end]
      set ::console::cpath [lreplace $::console::cpath end end]
    }
  }

  proc get_reg {address} {
    if {[llength $::console::cpath] > 0} {
      # puts "Reading 32 bit register from address $address"
      return [master_read_32 [lindex $::console::cpath end] $address 1]
    } else {
      puts "No open service"
    }
  }

  proc set_reg {address val_32_bit} {
    if {[llength $console::cpath] > 0} {
      # puts "Writing $val_32_bit value at address $address"
      master_write_32 [lindex $::console::cpath end] $address $val_32_bit
    } else {
      puts "No open service"
    }
  }

}

::console::get_master_path
::console::get_master_claim
::console::set_reg 0 0x00000000
::console::set_reg 4 0xaaaaaaaa
::console::set_reg 8 0xbbbbbbbb
::console::set_reg 12 0xcccccccc
::console::set_reg 16 0xdddddddd
::console::get_reg 0
::console::get_reg 4
::console::get_reg 8
::console::get_reg 12
::console::get_reg 16

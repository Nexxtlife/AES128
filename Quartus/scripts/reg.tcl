namespace eval reg {
# -------------register operations---------------------------------------------------
  proc get_bit {reg bit_pos} {
    # puts "reg: $reg, bit_pos: $bit_pos"

    # set reg_trim [string trimleft $reg 0x]
    set reg_trim [string range $reg 2 end]
    # puts "reg trim $reg_trim"

    set byte_list_be [regexp -inline -all {[0-9,a-f, A-F]{1,2}} $reg_trim]
    # puts $byte_list_be

    set byte_list_le [lreverse $byte_list_be]
    # puts $byte_list_le
    

    set byte_index [expr $bit_pos / 8]
    set bit_index [expr $bit_pos % 8]
    # puts "byte: $byte_index, bit $bit_index"

    set byte [lindex $byte_list_le $byte_index]
    # puts "byte: $byte"

    binary scan [binary format H* $byte] B* bits
    set bit_list [lreverse [regexp -inline -all {.} $bits]]

    # puts $bit_list

    return [lindex $bit_list $bit_index]
    
  }
    
  proc set_bit {reg_val bit_pos} {
    # puts "Set bit: $bit_pos"
    
    set new_reg_val [expr $reg_val | 1 << $bit_pos]

    # puts "new register value is $new_reg_val" 
    set new_reg_val [format 0x%x $new_reg_val]
    
    # set_reg $reg_address $new_reg_val

    return $new_reg_val
  }

  proc get_field {reg_32_bit start_pos size} {
    set bits ""
    # puts "register value is $reg_32_bit "
    
    for {set index $start_pos} {$index < $start_pos + $size} {incr index} {
      lappend bits [get_bit $reg_32_bit $index]
    }

    # set bits [lreverse $bits]
    # puts $bits

    return $bits
  }

  proc swap_bits_in_byte {hex_byte} {
    binary scan [binary format H2 $hex_byte] b8 temp
    return [binary format B8 $temp]
  } 

  proc reset_bit {reg_val bit_pos} {
    # puts "Reset bit: $bit_pos"
    
    set new_reg_val [expr $reg_val & ~(1 << $bit_pos)]

    # puts "new register value is $new_reg_val" 
    set new_reg_val [format 0x%x $new_reg_val]
    
    return $new_reg_val
  }

  proc set_field {reg val start_pos} {
    set new_reg_val $reg
    set position $start_pos
    # puts "start position = $position,\tstart_reg_val = $new_reg_val"

    foreach bit $val {
      if {$bit == 1} {
        set new_reg_val [set_bit $new_reg_val $position]
      } elseif {$bit == 0} {
        set new_reg_val [reset_bit $new_reg_val $position]
      }
      incr position
      # puts "bit = $bit,\tposition = $position,\tnew_reg_val = $new_reg_val"
    }
    return $new_reg_val
  }

}

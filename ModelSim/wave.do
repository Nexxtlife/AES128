onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /interface_tb/clk_tb
add wave -noupdate /interface_tb/rst_tb
add wave -noupdate /interface_tb/interface_0_avalon_slave_1_read_tb
add wave -noupdate /interface_tb/interface_0_avalon_slave_1_write_tb
add wave -noupdate /interface_tb/interface_0_avalon_slave_1_waitrequest_tb
add wave -noupdate /interface_tb/interface_0_avalon_slave_1_address_tb
add wave -noupdate /interface_tb/interface_0_avalon_slave_1_byteenable_tb
add wave -noupdate /interface_tb/interface_0_avalon_slave_1_readdata_tb
add wave -noupdate /interface_tb/interface_0_avalon_slave_1_writedata_tb
add wave -noupdate /interface_tb/clk_period
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {382 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {372 ns}

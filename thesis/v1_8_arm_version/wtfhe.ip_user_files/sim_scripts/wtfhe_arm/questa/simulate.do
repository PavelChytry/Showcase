onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib wtfhe_arm_opt

do {wave.do}

view wave
view structure
view signals

do {wtfhe_arm.udo}

run -all

quit -force

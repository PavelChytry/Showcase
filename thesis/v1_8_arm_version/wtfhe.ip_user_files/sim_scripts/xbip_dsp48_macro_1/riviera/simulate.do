onbreak {quit -force}
onerror {quit -force}

asim +access +r +m+xbip_dsp48_macro_1 -L xbip_dsp48_wrapper_v3_0_4 -L xbip_utils_v3_0_10 -L xbip_pipe_v3_0_6 -L xbip_dsp48_macro_v3_0_17 -L xil_defaultlib -L secureip -O5 xil_defaultlib.xbip_dsp48_macro_1

do {wave.do}

view wave
view structure

do {xbip_dsp48_macro_1.udo}

run -all

endsim

quit -force

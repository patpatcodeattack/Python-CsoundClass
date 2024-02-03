<Cabbage>
form caption("Untitled") size(400, 300), guiMode("queue"), pluginId("def1")
keyboard bounds(8, 158, 381, 95)
</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 --midi-key=4 --midi-velocity-amp=5
</CsOptions>
<CsInstruments>
; Initialize the global variables. 
ksmps = 32
nchnls = 2
0dbfs = 1
//for some reason c3 is 60 not c4
;instrument will be triggered by keyboard widget
instr 1

imidi = (((p4 - 60) * (12/13))) + 60
print imidi
ipitch mtof imidi
kEnv madsr .1, .2, .6, .4
aOut vco2 p5, ipitch
outs aOut*kEnv, aOut*kEnv
endin

</CsInstruments>
<CsScore>
;causes Csound to run for about 7000 years...
f0 z
</CsScore>
</CsoundSynthesizer>

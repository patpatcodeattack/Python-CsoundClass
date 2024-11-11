 bounds(0, 0, 0, 0)
<Cabbage>
form caption("Untitled") size(800, 500), guiMode("queue"), pluginId("def1")
keyboard bounds(8, 376, 398, 95)
gentable bounds(12, 8, 299, 103) tableGridColour(255, 0, 144, 255)  tableNumber(1.0) tableColour:0(255, 130, 0, 255)


gentable bounds(6, 124, 300, 94)  tableGridColour(255, 0, 0, 255) tableBackgroundColour(62, 37, 120, 255)  tableNumber(2.0) tableColour:0(0, 183, 255, 255)
gentable bounds(8, 230, 300, 105)  tableGridColour(255, 255, 255, 255) tableBackgroundColour(75, 163, 168, 255)  tableNumber(3.0) tableColour:0(255, 0, 0, 255)
signaldisplay bounds(418, 82, 372, 385) ,displayType("lissajous"), signalVariable("aL", "aR"),backgroundColour(0, 0, 0), zoom(-2),  channel("display")

vmeter bounds(322, 130, 82, 241) channel("vu1")  outlineColour(0, 0, 0, 255), overlayColour(0, 0, 0, 255) meterColour:0(255, 0, 0, 255) meterColour:1(255, 255, 0, 255) meterColour:2(13, 101, 13, 255)

rslider bounds(324, 32, 78, 97) channel("rev") range(0, 1, 0.5, 1, 0.001) text("dry/wet") colour(101, 69, 0, 255) outlineColour(255, 103, 172, 255) fontColour(0, 0, 0, 255) textColour(255, 255, 255, 255) trackerColour(224, 199, 60, 255)
label bounds(324, 6, 80, 27) channel("label10007") text("reverb")

</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-n --displays  -+rtmidi=NULL -M0 --midi-key-cps=4 --midi-velocity-amp=5
</CsOptions>
<CsInstruments>
; Initialize the global variables. 
ksmps = 32
nchnls = 2
0dbfs = 1
gkfund = 1
giSi    ftgen     1, 0, 2^13 + 1, 10, 1, 1
giS2    ftgen     2, 0, 2^13 + 1, 10, .5, .6, .8,1
giS3    ftgen     3, 0, 2^13 + 1, 10, .2, .6,.9
gkrev init .5
gaDacL init 0
gaDacR init  0
;instrument will be triggered by keyboard widget

instr 1

iAmp[] fillarray .5, .3, .5
ipitch[] fillarray random(50, 440),random(200, 500),random(250, 350) 
 
asound1 oscil .8, ipitch[0],giSi
kev1 madsr 1,.2,.2,5
asound1 = (asound1*kev1)*iAmp[0]

asound2 poscil .8, ipitch[1],giS2
kev2 madsr 3,.2,.2,3
asound2 = (asound2*kev2)*iAmp[1]

asound3 poscil .8, ipitch[2],giS3
kev3 madsr 1,4,.5,1
asound3 = (asound3*kev3)*iAmp[2]

al = (asound1 + (asound2*.5))*.5
ar = ((asound2 *.5) + asound3) * .5

gaDacL = gaDacL + al 
gaDacR = gaDacR + ar

endin

instr 55


gkrev cabbageGetValue "rev"   
gkrev portk gkrev, 0.01



endin


instr 2//dac


arevL, arevR freeverb gaDacL,gaDacR, .8,0.01
amixL        ntrpol        gaDacL, arevL, gkrev    ;CREATE A DRY/WET MIX BETWEEN THE DRY AND THE REVERBERATED SIGNAL
amixR        ntrpol        gaDacR, arevR, gkrev    ;CREATE A DRY/WET MIX BETWEEN THE DRY AND THE REVERBERATED SIGNAL


aL dcblock2 amixL * .5
aR dcblock amixR * .5

out aL, aR// DAC out


//gui display
display aL, .1
dispfft aL, .1, 1024
display aR, .1
//signalmeter
k1 rms aL, 20
k2 rms aR, 20
 
cabbageSetValue "vu1", portk(k1*10, .25), metro(10)





//gui display

endin




instr 3

clear gaDacL
clear gaDacR
endin



</CsInstruments>
<CsScore>
f0 z ;causes Csound to run until you quit

i 2 0  8000
i 3 0  8000
i 55 0 999
//i 44 0 8000
</CsScore>
</CsoundSynthesizer>

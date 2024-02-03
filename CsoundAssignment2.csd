<Cabbage>
form caption("Untitled") size(400, 300), guiMode("queue"), pluginId("def1")
keyboard bounds(8, 158, 381, 95)
button bounds(8, 12, 87, 54) channel("triger") latched(0) colour:1(78, 185, 255, 255)
rslider bounds(94, 16, 93, 136) channel("knob1") range(0, 1, 0, 1, 0.001) valueTextBox(1) colour(28, 94, 233, 255)
rslider bounds(190, 14, 84, 141) channel("knob2") range(0, 1, 0, 1, 0.001) colour(0, 73, 120, 255) valueTextBox(1)
encoder bounds(294, 22, 85, 117) channel("encoder10004") trackerColour(99, 159, 108, 255) colour(90, 95, 108, 255) 
rslider    bounds(55,20, 80, 80), channel("Crossfade"), range(0, 19, 0)  valueTextBox(1)
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

gicnt cntCreate 1
 giShape	ftgen		5,0,4097,20,2,1		; hanning

 giwave2    ftgen    2,0, 4096 + 1,10,0
 giwave    ftgen    1,0, 4096 + 1,10,0
;instrument will be triggered by keyboard widget



instr 2
gkstr1 cabbageGetValue "knob1"
gkstr2 cabbageGetValue "knob2"
ktrig cabbageGetValue "triger"

ktr    changed gkstr1 ,gkstr2
    if ktr==1 then
       reinit UPDATE
    endif
    
    UPDATE:   
    ic count_i gicnt
      
         if ic == 0 then
           print ic
             giwave1    ftgen    1,0, 4096,10, i(gkstr1),i(gkstr2)
       
         elseif ic == 1 then
            print ic + 99
            giwave2    ftgen    2,0, 4096,10, i(gkstr1),i(gkstr2)
       
         endif
         
         
         
    rireturn
    if ktrig==1 then
   //  chnset    "tableNumber(1)", "table1"    ; update table display    
    endif

endin


instr    3
 kFade  port    chnget:k("Crossfade"),1/ksmps ; a table index starting at zero
 
 kCPS   =          110 ; frequency of oscillator
 a1     oscilikt   0.1,kCPS, 1
 a2     oscilikt   0.1,kCPS, 2

 aMix   sum         a1*a(tablei:k(kFade*0.5,giShape,1,0.5,1)), \
                    a2*a(tablei:k(kFade*0.5,giShape,1,0,1))
 		outs		aMix, aMix
endin






//giwave    ftgen    1,0, 4096,10, 0    ; GEN10 generated wave
//giwave2    ftgen    2,0, 4096,10, 0    ; GEN10 generated wave
</CsInstruments>
<CsScore>
;causes Csound to run for about 7000 years...
f0 z

i 2 0 999
</CsScore>
</CsoundSynthesizer>

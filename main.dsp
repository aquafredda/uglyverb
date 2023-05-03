import("stdfaust.lib");

gain1 = hslider("gain allpass1",0,0,100,1)/100;
gain2 = hslider("gain allpass2",0,0,100,1)/100;
gain3 = hslider("gain allpass3",0,0,100,1)/100;
dry = _;
gainer1 = hslider("gainer1",0,0,101,1)/100;
gainer2 = hslider("gainer2",0,0,101,1)/100;
gainer3 = hslider("gainer3",0,0,101,1)/100;
gainer4 = hslider("gainer4",0,0,101,1)/100;


// calcolo delle lunghezze delle delay line - i coefficienti devono essere tra loro primi
T1 = 0.0297 * ma.SR;
T2 = 0.0371 * ma.SR;
T3 = 0.0411 * ma.SR;
T4 = 0.0437 * ma.SR;
T5 = 0.0043 * ma.SR;
T6 = 0.0061 * ma.SR;
T7 = 0.0079 * ma.SR;
T8 = 0.0097 * ma.SR;

// definizione delle delay line con feedback costante
d1 = +~  de.delay(ma.SR,T1) *(gainer1);
d2 =  +~  de.delay(ma.SR,T2) *(gainer2);
d3 =  +~  de.delay(ma.SR,T3) *(gainer3);
d4 =  +~  de.delay(ma.SR,T4) *(gainer4);

// delay line iniziali
rev = d1 + d2 + d3 + d4;

//filtro allpass
allpassfilter(x,g) = allpass(x,g)
with {
    allpass_block(x,g) = +~  de.delay(48000,x) * g : *(1-(g ^2));
    allpass(x,g) =  _ <: allpass_block(x,g)  + _*(-g);
};


process = _ <: rev*0.4 : allpassfilter(T5,gain1) <: allpassfilter(T6,gain2), allpassfilter(T7,gain3);

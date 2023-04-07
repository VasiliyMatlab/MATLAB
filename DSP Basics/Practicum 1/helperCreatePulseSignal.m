function helperCreatePulseSignal

originalFs = 20e3;
fc = 500;
Tpulse = 0:1/originalFs:0.03 - 1/originalFs;
Tsig = 0:1/originalFs:0.05 - 1/originalFs;
full_len = length(Tsig);
pulse_len = length(Tpulse);
zeros_len = full_len - pulse_len;

slope = linspace(-0.5,0.5,pulse_len);
attenuation = linspace(1,0.5,pulse_len);
noiseAmp = 0.2;
xc = sin(2*pi*fc*Tpulse);

original = [xc zeros(1,400)];
full_len = length(original);
sig = [(attenuation.*xc + slope) zeros(1,zeros_len)];

shiftsig = circshift(sig,300);

randintegers = randi(full_len,1,full_len/10);
randidx = unique(randintegers);
missingSig = shiftsig;
missingTx = Tsig;
missingTx(randidx) = NaN;
missingSig(randidx) = 0;

noise = noiseAmp * rand(1,full_len) - 0.5*noiseAmp;
missingSig = missingSig + noise;

assignin('base','originalSignal',original)
assignin('base','receivedSignal',missingSig)
assignin('base','timevector',Tsig)
assignin('base','timeNaN',missingTx)

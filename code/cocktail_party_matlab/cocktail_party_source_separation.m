clear all

%% Loading signals
Fs = 48000;
M1 = load("../../data/indoor_speech.mat");
speech1 = M1.data.channel_1(:,2);
%sound(2*speech1,Fs)

M2 = csvread("../../data/traffic_speech.csv");
speech2 = M2(:,2);
%sound(2*speech2,Fs)


%% Mixing signals
speech1 = speech1/norm(speech1);
speech2 = speech2/norm(speech2);
ampAdj = max(abs([speech1;speech2]));
speech1 = speech1/ampAdj;
speech2 = speech2/ampAdj;
mix = speech1 + speech2;
mix = mix ./ max(abs(mix));

t = (0 : numel(mix)-1*(1/Fs));


figure(1)
subplot(3,1,1)
plot(t,speech1)
title("Danilo Speech")
grid on
subplot(3,1,2)
plot(t,speech2)
title("Daniel Speech")
grid on
subplot(3,1,3)
plot(t,mix)
title("Speech Mixed")
xlabel("Time (s)")
grid on

%sound(mix,Fs)

%% Time-Frequency Analysis

WindowLength  = 128;
FFTLength     = 128;
OverlapLength = 96;
win           = hann(WindowLength,"periodic");

figure(2)
subplot(3,1,1)
%stft(speech1,Fs,'Window',win,'OverlapLength',OverlapLength,'FFTLength',FFTLength)
%R2020 version
spectrogram(speech1, win, OverlapLength, FFTLength, Fs, 'yaxis');
title("Danilo Speech")
subplot(3,1,2)
%stft(speech2,Fs,'Window',win,'OverlapLength',OverlapLength,'FFTLength',FFTLength)
%R2020 version
spectrogram(speech2, win, OverlapLength, FFTLength, Fs, 'yaxis');
title("Daniel Speech")
subplot(3,1,3)
%stft(mix,Fs,'Window',win,'OverlapLength',OverlapLength,'FFTLength',FFTLength)
%R2020 version
spectrogram(mix, win, OverlapLength, FFTLength, Fs, 'yaxis');
title("Mixed Speech")



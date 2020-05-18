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

WindowLength  = 1024;
FFTLength     = 1024;
OverlapLength = 1024/8;
win           = hann(WindowLength,"periodic");
synth_win     = hamming(WindowLength, 'periodic');

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


%% Source separation using binary masks (ideal case)

%[~,f,t,P_danilo] = spectrogram(speech1, win, OverlapLength, FFTLength, Fs);
P_danilo = stft(speech1, win, OverlapLength, FFTLength, Fs);
%P_daniel        = spectrogram(speech2, win, OverlapLength, FFTLength, Fs);
P_daniel = stft(speech2, win, OverlapLength, FFTLength, Fs);
%[P_mix,F]  = spectrogram(mix, win, OverlapLength, FFTLength, Fs);
[P_mix,F]  = stft(mix, win, OverlapLength, FFTLength, Fs);
binaryMask = abs(P_danilo) >= abs(P_daniel);

%figure(3)
%plotMask(binaryMask, WindowLength - OverlapLength, F, Fs)

P_danilo_Hard = P_mix .* binaryMask;
P_daniel_Hard = P_mix .* (1-binaryMask);

%speech1_Hard = ifft(P_danilo_Hard);
speech1_Hard = istft(P_danilo_Hard , win, synth_win, OverlapLength, FFTLength, Fs);
%speech2_Hard = ifft(P_daniel_Hard);
speech2_Hard = istft(P_daniel_Hard , win, synth_win, OverlapLength, FFTLength, Fs);

figure(4)
subplot(2,2,1)
plot(t, speech1)
axis([t(1) t(end) -1 1])
title("Original Danilo Speech")
grid on

subplot(2,2,3)
%plot(t, speech1_Hard)
plot(speech1_Hard)
axis([t(1) t(end) -1 1])
xlabel("Time (s)")
title("Estimated Danilo Speech")
grid on

subplot(2,2,2)
plot(t, speech2)
axis([t(1) t(end) -1 1])
title("Original Daniel Speech")
grid on

subplot(2,2,4)
%plot(t, speech2_Hard)
plot(speech2_Hard)
axis([t(1) t(end) -1 1])
title("Estimated Daniel Speech")
xlabel("Time (s)")
grid on


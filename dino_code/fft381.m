clear; close all; clc;

load('/Users/smitra/projects/webChronux/utils/257802-post_season_20161206_142914.mat');

eeg = eegData(14,:);

%remove mean
eeg = eeg - mean(eeg);

addpath('/Volumes/DATA/matlab/chronux/spectral_analysis/helper/');
addpath('/Volumes/DATA/matlab/chronux/spectral_analysis/continuous/');

eegFS = 250;

winLen = 3*eegFS;
params.fpass = [0,100]
params.Fs = eegFS;
params.tapers = [4,6]; %TW product, number of tapers (less than or equal to 2TW-1). 
params.trialave = 0;

[tapers,pad,Fs,fpass,err,trialave]=getparams(params);

nfft=max(2^(nextpow2(winLen)+pad),winLen);
[fx,findx]=getfgrid(Fs,nfft,fpass);
NF = (nfft/2)+1;
tap=dpsschk(tapers,winLen,Fs); % check tapers

%split eeg1 and eeg2 into windows of length winLen
Nw = floor(length(eeg)/winLen);

%S12x = zeros(Nw,NF);
%S1x = zeros(Nw,NF);
S1x = zeros(Nw,length(findx));
%S2x = zeros(Nw,NF);

for wI = 1:Nw

    st = (wI-1)*winLen+1;
    ed = wI*winLen;

    eegx = eeg(st:ed)';

    J1=mtfftc(eegx,tap,nfft,Fs); %mt fourier
    J1=J1(findx,:,:);
    
    S1=squeeze(mean(conj(J1).*J1,2));
    S1x(wI,:) = S1';

end
%save('/Users/smitra/projects/webChronux/matspectrogram.mat','S1x');
figure; 
hold on;
subplot(2,1,1);
%colormap rgb;
imagesc(log(S1x'));
set(gca,'Ydir','Normal');
axis([0 416 0 100]);
load('/Users/smitra/projects/webChronux/utils/spectrogram.mat');
subplot(2,1,2);
imagesc(log(spectrogramData'));
set(gca,'Ydir','Normal');
axis([0 416 0 100]);
hold off;
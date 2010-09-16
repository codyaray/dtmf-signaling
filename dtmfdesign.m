function hh = dtmfdesign(fcent, L, fs)
%DTMFDESIGN Returns a matrix (L by length(fcent)) where
% each column contains the impulse response of a BPF,
% one for each frequency in fcent.
% 
% usage: hh = dtmfdesign(fcent, L, fs)
%     fcent = vector of center frequencies
%         L = length of FIR bandpass filters
%        fs = sampling freq
%
% Each BPF must be scaled so that its frequency response has a
% maximum magnitude equal to one.

nn = 0:L-1;
ww = 0:pi/300:pi; % matrix of frequencies for finding B

% for each given frequency
for ii = 1:length(fcent)
    % simple band pass filter
    hu(ii,:) = cos(2*pi*fcent(ii)*nn/fs);

    % calculate vector of scaling coeffecients
    B(ii,:) = abs(1/(max(freqz(hu(ii,:),1,ww)))); 

    % scale each filter to finish
    ha(ii,:) = hu(ii,:)*B(ii,:);
end

% put filters in columns
hh = ha';
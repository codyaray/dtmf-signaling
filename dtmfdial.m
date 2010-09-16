function xx = dtmfdial(keyNames,fs)
%DTMFDIAL Create a signal vector of tones which will dial
% a DTMF (Touch Tone) telephone system.
%
% usage: xx = dtmfdial(keyNames,fs)
%  keyNames = vector of characters containing valid key names
%        fs = sampling frequency
%        xx = signal vector that is the concatenation of DTMF tones.

dtmf.keys = ... 
   ['1','2','3','A';
    '4','5','6','B';
    '7','8','9','C';
    '*','0','#','D'];

dtmf.colTones = ones(4,1)*[1209,1336,1477,1633];
dtmf.rowTones = [697;770;852;941]*ones(1,4);

dur1 = 0.20; % tone duration in seconds
dur2 = 0.05; % silence duration in seconds

tt = 0:1/fs:dur1; % time vector

xx = 0; % initialize it
for ii = 1:length(keyNames) % for each given keyname
    keyName = keyNames(ii);
    
    [r,c] = find(dtmf.keys==keyName); % find row and col for keyname

    % skip to the next keyname if this keyname was invalid
    if (numel(r) == 0 | numel(c) == 0)
        continue
    end;

    % sums the two frequency components
    tone = cos(2*pi*dtmf.rowTones(r,c)*tt) + cos(2*pi*dtmf.colTones(r,c)*tt);

    % concatonates the current output, zeros, and the new tone.
    xx = [xx, zeros(1, dur2*fs), tone];
end
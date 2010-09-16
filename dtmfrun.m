function keys = dtmfrun(xx,L,fs)
%DTMFRUN Returns the list of key names found in xx.
% 
% keys = dtmfrun(xx,L,fs)
%   xx = DTMF waveform
%    L = filter length
%   fs = sampling freq
% keys = array of characters, i.e., the decoded key names

dtmf.keys = ... 
   ['1','2','3','A';
    '4','5','6','B';
    '7','8','9','C';
    '*','0','#','D'];

dtmf.colTones = ones(4,1)*[1209,1336,1477,1633];
dtmf.rowTones = [697;770;852;941]*ones(1,4);

% defines 1X8 vector of freqs
center_freqs = [dtmf.rowTones(:,1)' , dtmf.colTones(1,:)]; 

% hh = L by 8 MATRIX of all the filters. Each column contains the
% impulse response of one BPF
hh = dtmfdesign(center_freqs, L, fs);

% find the beginning and end of tone bursts
[nstart,nstop] = dtmfcut(xx,fs);

keys = []; % initialize keys
locs = []; % initialize locs
for kk=1:length(nstart) % for each tone
    x_seg = xx(nstart(kk):nstop(kk)); % extract one DTMF tone
    locs = []; % clears previous locs

    for jj=1:length(center_freqs) % for each filter
        % boolean vector representing the location of frequency components
        locs = [locs, dtmfscore(x_seg,hh(:,jj))];
    end
    
    % create a vector of indices where ones occur
    aa = find(locs == 1);
    
    if length(aa) ~= 2 | aa(1) > 4 | aa(2) < 5
        % sanity check. skip any impossible scores
        continue
    end
    
    % decodes row and col position from aa
    row = aa(1);
    col = aa(2)-4;

    % sets keys equal to the curr keys and the key found in this iteration
    keys = [keys, dtmf.keys(row,col)];
end
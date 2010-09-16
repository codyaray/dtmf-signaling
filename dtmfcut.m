function [nstart,nstop] = dtmfcut(xx,fs)
%DTMFCUT Find the DTMF tones within x[n]
%
% usage: [nstart,nstop] = dtmfcut(xx,fs)
%    xx = input signal vector
%    fs = sampling frequency  
%    length of nstart = M = number of tones found
%       nstart is the set of STARTING indices
%       nstop is the set of ENDING indices
%
%  Looks for regions of silence at least 10 millisecs long with
%  tones longer than 100 msec

setpoint = 0.02; % zero everything below 2% zero

xx = xx(:)' / max(abs(xx)); % normalize xx
Lx = length(xx);
Lz = round(0.01*fs);

xx = filter(ones(1,Lz) / Lz, 1, abs(xx));
xx = diff(xx > setpoint);

jkl = find(xx ~= 0)';

% xx(jkl);
if xx(jkl(1)) < 0, jkl = [1; jkl];  end
if xx(jkl(end)) > 0, jkl = [jkl; Lx]; end

% jkl';
indx = [];
while length(jkl)>1
	if jkl(2)>(jkl(1)+10*Lz)
		indx = [indx, jkl(1:2)];
	end
	jkl(1:2) = [];
end

nstart = indx(1,:);
nstop = indx(2,:);

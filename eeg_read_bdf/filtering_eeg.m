function [y,y1] = filtering_eeg(x,fs)
%y = bandpass(x,wpass) filters the input signal x using a bandpass
% filter with a passband frequency range specified by the two-element
% vector wpass and expressed in normalized units of ? rad/sample. 
% bandpass uses a minimum-order filter with a stopband attenuation of
%60 dB and compensates for the delay introduced by the filter. If x is a matrix,
% the function filters each column independently.
% wpass=[8/3.14 14/3.14]%alpha
% wpass=[16/3.14 31/3.14]%beta
% %gamma is greater than 31/3.14
% wpass=[4/3.14 7/3.14]%theta
%y = highpass(x,wpass) filters the input signal x 
% using a highpass filter with normalized passband frequency
% wpass in units of ? rad/sample. highpass uses a minimum-order 
% filter with a stopband attenuation of 60 dB and compensates for 
% the delay introduced by the filter. If x is a matrix, the function 
% filters each column independently.
y={}
%% Filter
% Butterworth filter designing
% Removing 60Hz
fcut = 60; %Hz
%fs=1024;

%f1 = ((fcut - 2)/ (fs/2));
%f2 = ((fcut + 2)/ (fs/2));


for i=1:1:length(x)
x2=x{i}
%[b,a] = butter(3,[f1 f2],'stop');
f11=7/ (fs/2) %This was to cut off frequencies less than 7hz
%f2=40/ (fs/2) % This was to cut off frequencies greater than 40Hz (But I didnt use it)
[b,a] = butter(3,f11,'high');
x1=filter(b,a,x2)
f1 = ((fcut - 2)/ (fs/2));
f2 = ((fcut + 2)/ (fs/2));
[b,a] = butter(3,[f1 f2],'stop');
x0=filter(b,a,x1)
%% Taking only alpha beta gamma and theta
% Wpm = [4  7.9;  7.9  10;  10.1  12.9;  13  17.9;  18  27.9];    % Passband Matrix
% %fs                                                     % Sampling Frequency
% Fn = fs/2;                                                      % Nyquist Frequency
% Rp = 10;                                                        % Passband Ripple
% Rs = 40;                                                        % Stopband Ripple
% for k1 = 1:size(Wpm,1)
%     Wp = Wpm(k1,:)/Fn;
%     Ws = Wp .* [0.6  1.05];
%     [n,Ws] = cheb2ord(Wp,Ws,Rp,Rs);                             % Determine Optimal Order
%     [b,a] = cheby2(n,Rs,Ws);                                    % Transfer Function Coefficients
%     [sos{k1},g{k1}] = tf2sos(b,a);                              % Second-Order-Section For Stability
% end
%X_filtered=filter(b,a,x0)                                      %filtering
%X_filtered(isnan(X_filtered))=0;                               %To remove all nan values
%X_filtered = X_filtered( ~any( isnan( X_filtered ) | isinf( X_filtered ), 2 ),: )
%% Above uses Cheby filters , Now using butterworth
Wpm = [4  7.9;  7.9  10;  10.1  12.9;  13  17.9;  18  27.9];    % Passband Matrix
%fs                                                     % Sampling Frequency
Fn = fs/2;                                                      % Nyquist Frequency
for k1 = 1:size(Wpm,1)
Wp = Wpm(k1,:)/Fn;
[b,a] = butter(3,Wp);
x0=filter(b,a,x0)
end
 y{i}=x0
% X_filtered2(isnan(X_filtered2))=0;
% y1{i}=X_filtered2

end




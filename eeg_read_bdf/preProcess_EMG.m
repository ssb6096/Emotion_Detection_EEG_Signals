function [f t] = preProcess_EMG(data,freqs,noSamples)
%freqs = input data frequency
% noSamples = number of repeated gesture
    all_data = data{1, 1}.time_series';
    [a,b] = butter(4,[59/(freqs/2) 61/(freqs/2)],'stop');
    for j = 1:noSamples
        for(i=1:freqs)    
            data_sample(j).data(i,:)= all_data(i*j,:);
        end
    end
    
for j = 1:20
    for i = 1:960
        m1(j) = mean ( data_sample(j).data(:,1));
        m2(j) = mean ( data_sample(j).data(:,2));
        r(j).r1(i) = data_sample(j).data(i,1) - m1(j);
        r(j).r2(i) = data_sample(j).data(i,2) - m2(j);
        
    end
end
d1f=[];
d2f=[];
d1t=[];
d2t=[];
for j = 1:20
        f(j).f1=fft(r(j).r1);
        f(j).f2=fft(r(j).r2);
        d1f = [d1f;abs(filter(a,b,f(j).f1))];
        d2f = [d2f;abs(filter(a,b,f(j).f2))];
        
end
d1t = abs(ifft(d1f));
d2t = abs(ifft(d2f));

f = [d1f d2f];
t = [d1t d2t];
end

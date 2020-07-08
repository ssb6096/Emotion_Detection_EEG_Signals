%% Can be concluded that the classification cannot get better than 45% with the present features
% New set of features to try 
% Covmat eigen  entropy correlation fft & poissibly the fast fourier
% transform features enhanced by adding the above mentioned
% For eigen values the matrix must be square.. since its not, we can use
% svd DONE
%For correlation R2 = corrcoef(X) DONE
%entropy e = entropy(I) NOT USED
%E = wentropy(X,T) DONE

% For spatial co-variance : EEGdata, gnd, genSs, genMs, beta, gamma
[data,numChan,labels,txt,fs,gain,prefiltering,ChanDim] = eeg_read_bdf('eNTERFACE06_EMOBRAIN\Data\EEG\Part1_IAPS_SES3_EEG_fNIRS_08082006.bdf','all','n')
m = csvread('eNTERFACE06_EMOBRAIN\Data\EEG\Part1_IAPS_SES3_EEG_fNIRS_08082006.bdf.mrk.csv')
labels_class =readtable('eNTERFACE06_EMOBRAIN\Data\Common\IAPS_Classes_EEG_fNIRS.csv')

%% PRE-PROCESSING
data=data'
no_of_rows_data= size(data,1) %No of total samples
no_of_columns_data= size(data,2)%No of electrodes

no_of_rows_m=size(m,1)%No of classes
no_of_columns_m=size(m,2)% No of markers related to each class
j=1
i=1
k=1
data_chunk_fromsynch={}
while i<= no_of_rows_data
    l= m(j,1)-1
    if i~=1
    data_chunk_fromsynch{k}= data(i:l,1:64)
    k=k+1
    end
    i=m(j,1)
    j=j+2
    if j>no_of_rows_m
        break
    end
end



%% Annoting the data with labels
cl=zeros(30,1)
for i=1:1:30
    label_class=labels_class{i,3}
    if strcmp(label_class,'Calm')==1
             cl(i)=1; %CALM IS CLASS 1
     elseif strcmp(label_class,'Pos')==1
             cl(i)=2; %POSITIVE IS CLASS 2
     elseif strcmp(label_class,'Neg') ==1  
             cl(i)=3;%NEGATIVE IS CLASS 3
     end
end
length(data_chunk_fromsynch)
%% feature extraction
%Zero meaning 
zero_meaned_datachunk=zeromeaning(data_chunk_fromsynch)
clear data_chunk_fromsynch
%% Fourier transform 
frequency_d_data = fourier_transform(zero_meaned_datachunk)
clear zero_meaned_datachunk
%% trying butterworth
% Wn=0.8
% [b,a] = butter(3, Wn, 'low');
% filteredSignal = filter(b, a, zero_meaned_data_f );
%filteredSignal = filteredSignal - mean(filteredSignal); % Subtracting the mean to block DC Component
%% Filter
%Keeping only alpha, beta, gamma,theta
% fcut = 60; %Hz
filtered_f_data = filtering_eeg(frequency_d_data,fs)
clear frequency_d_data
%% Getting time domain back 
filtered_t_data=inverse_fourier(filtered_f_data)
%clear filtered_f_data
%% trying to get spatial covariance
%% using code requires array of 3 dimensions 
for i=1:1:length(filtered_t_data)
l(i) =length(filtered_t_data{i})
end 
len=round(mean(l))
%% resampling 
EEG_data=[];
for i=1:1:length(filtered_t_data)
no_of_samples=length(filtered_t_data{i});
x=filtered_t_data{i};

[p,q] = rat(len/no_of_samples);
resampled = resample(x,p,q);
if length(resampled)~=len
    resampled=resampled(1:length(resampled)-1,:) ; 
end 
EEG_data=cat(3,EEG_data,resampled);
end 
%% wait
%for i=1:1:length(filtered_t_data)
    %EEG_data=filtered_t_data;
    gnd=cl
    genSs=[]
    for i=1:1:size(EEG_data,3)
    genSs=cat(3,genSs,cov(EEG_data(:,:,i)));
    end
    genMs=[1 2 3]
    beta=0
    gamma=0
    W=RegCsp(EEG_data,gnd,genSs,genMs,beta,gamma)
%end 
%% Entropy 
s=[]
crr1=[]
crr2=[]
c=[]
for i=1:1:length(filtered_t_data)
X =filtered_t_data{i};
T='shannon';
E1(i) = wentropy(X,T);
T='log energy';
E2(i) = wentropy(X,T);
T='norm';
E3(i) = wentropy(X,T,1.1);
s =[s svd(X)]
%R2 = corrcoef(X)
%crr = xcorr2(X)
Corr2 =[]
Corr1=[]
c_dia=[]
for col = 1 : size(X,2)
	thisColumn = data(:, col);
    corr1=autocorr(thisColumn, 'NumLags', 1)
	% Call your custom-written function, autocorr().
	corr2 =  autocorr(thisColumn, 'NumLags', 2)
    corr1=corr1'
    corr2=corr2'
    Corr2=[Corr2 corr2]
    Corr1=[Corr1 corr1]
	% Now do something with someOutput.
end
crr2 =[crr2;Corr2] 
crr1 =[crr1;Corr1] 
c=cov(X)
c_diagonal =diag(c)
c_diagonal=c_diagonal'
c_dia(i,:)=c_diagonal
end 
s=s'

%% Discrete Wavelet Transform
% wname='db1' %Haar
% for i=1:1:length(filtered_f_data)
%         cA=[];
%         cH=[];
%         cV=[];
%         cD=[];
% 
%     for j=1:1:size(filtered_f_data{i},2)
%         h= filtered_f_data{i}(:,j)
%         [ca,ch,cv,cd] = dwt2(h,wname)
%          cA = [cA ca]
%          cH=[cH ch]
%          cV=[cV cv]
%          cD=[cD cd]
%     end
%     CA{i}=[cA]
%     CH{i}=[cH]
%     CV{i}=[cV] 
%     CD{i}=[cD]
% %         ca(i) = cA
% %         ch(i)=cH
% %         cv(i)= cV
% %         cd(i)= cD
% end
%% For the app 
classifier=[c_dia crr1 crr2 s E1' E2' E3' cl]

%% p100 n100 p200 n200
%1024 Hz- frequency 
%1024 samples per second 
%1.024 samples per ms
%80ms to 120ms, 150ms to 275ms, 250/275ms to 500ms
%81th sample, 122th sample, 153th sample, 281th sample, 512th smple
p100=zeros(length(filtered_t_data),size(filtered_t_data{1},2))
for i=1:length(filtered_t_data)
    x=filtered_t_data{i}
    p100(i,:)=max(x(81:123,:),[],1)
    n100(i,:)=min(x(81:123,:),[],1)
    p200(i,:)=max(x(153:282,:),[],1)
    n200(i,:)=max(x(153:282,:),[],1)
    p300(i,:)=max(x(281:512,:),[],1)
end

%% Applying PCA
data=data'
%% And 
[coeff,score,a,b,explained,mu] = pca(data);
%% Picking top 
% sum_explained = 0;
% idx = 0;
% while sum_explained < 95
%     idx = idx + 1;
%     sum_explained = sum_explained + explained(idx);
% end
% idx
n=10
[coff,score]=pca(data) 
newData = data*coff(:,1:n)
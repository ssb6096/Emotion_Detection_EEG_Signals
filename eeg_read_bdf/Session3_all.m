for main_loop_counter=1:1:5
clearvars -except main_loop_counter
%% Extracting EEG Signals
switch main_loop_counter
    case 1 
%% Extracting EEG Signals
%Participant-1/session-3 
[data,numChan,labels,txt,fs,gain,prefiltering,ChanDim] = eeg_read_bdf('eNTERFACE06_EMOBRAIN\Data\EEG\Part1_IAPS_SES3_EEG_fNIRS_08082006.bdf','all','n')
save ('participant1_session3_RAW','data','numChan','labels','txt','fs','gain','prefiltering','ChanDim')
    case 2 
% %Participant-2/session-3
[data,numChan,labels,txt,fs,gain,prefiltering,ChanDim] = eeg_read_bdf('eNTERFACE06_EMOBRAIN\Data\EEG\Part2_IAPS_SES3_EEG_fNIRS_09082006.bdf','all','n')
save ('participant2_session3_RAW','data','numChan','labels','txt','fs','gain','prefiltering','ChanDim')     
    case 3 
%Participant-3/session-3
[data,numChan,labels,txt,fs,gain,prefiltering,ChanDim] = eeg_read_bdf('eNTERFACE06_EMOBRAIN\Data\EEG\Part3_IAPS_SES3_EEG_fNIRS_08082006.bdf','all','n')
save ('participant3_session3_RAW','data','numChan','labels','txt','fs','gain','prefiltering','ChanDim')      
    case 4 
%Participant-4/session-3
[data,numChan,labels,txt,fs,gain,prefiltering,ChanDim] = eeg_read_bdf('eNTERFACE06_EMOBRAIN\Data\EEG\Part4_IAPS_SES3_EEG_fNIRS_09082006.bdf','all','n')
save ('participant4_session3_RAW','data','numChan','labels','txt','fs','gain','prefiltering','ChanDim')      
    case 5
%Participant-5/session-3
[data,numChan,labels,txt,fs,gain,prefiltering,ChanDim] = eeg_read_bdf('eNTERFACE06_EMOBRAIN\Data\EEG\Part5_IAPS_SES3_EEG_fNIRS_09082006.bdf','all','n')
save ('participant5_session3_RAW','data','numChan','labels','txt','fs','gain','prefiltering','ChanDim') 
end



%% Reading markers
switch main_loop_counter
    case 1 
% Participant1, session 3
m = csvread('eNTERFACE06_EMOBRAIN\Data\EEG\Part1_IAPS_SES3_EEG_fNIRS_08082006.bdf.mrk.csv')
    case 2 
%Participant-2/session-3
m = csvread('eNTERFACE06_EMOBRAIN\Data\EEG\Part2_IAPS_SES3_EEG_fNIRS_09082006.bdf.mrk.csv')
    case 3 
%Participant-3/session-3
m = csvread('eNTERFACE06_EMOBRAIN\Data\EEG\Part3_IAPS_SES3_EEG_fNIRS_08082006.bdf.mrk.csv')
    case 4 
%Participant-4/session-3
m = csvread('eNTERFACE06_EMOBRAIN\Data\EEG\Part4_IAPS_SES3_EEG_fNIRS_09082006.bdf.mrk.csv')
    case 5 
%Participant-5/session-3
m = csvread('eNTERFACE06_EMOBRAIN\Data\EEG\Part5_IAPS_SES3_EEG_fNIRS_09082006.bdf.mrk.csv')
end


%% reading class labels
labels_class =readtable('eNTERFACE06_EMOBRAIN\Data\Common\IAPS_Classes_EEG_fNIRS.csv')

%% PRE-PROCESSING
data=data'
%% taking chunks a different way 
% Using the markers to assign labels by considering the label 1 as start of
% video and the following label as start of logic
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
    %data_chunk_fromsynch{k}= data(i:l,:)%Using All Columns 
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
switch main_loop_counter
    case 1 
        save ('participant1_session3_data_chunk','zero_meaned_datachunk')
    case 2 
        save ('participant2_session3_data_chunk','zero_meaned_datachunk')
    case 3
        save ('participant3_session3_data_chunk','zero_meaned_datachunk')
    case 4
        save ('participant4_session3_data_chunk','zero_meaned_datachunk')
    case 5
        save ('participant5_session3_data_chunk','zero_meaned_datachunk')
end
        
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
clear zero_meaned_datachunk
%% Getting time domain back 
filtered_t_data=inverse_fourier(filtered_f_data)
switch main_loop_counter
    case 1 
        save ('participant1_session3_filtered','filtered_f_data','filtered_t_data')
    case 2 
        save ('participant2_session3_filtered','filtered_f_data','filtered_t_data')
    case 3
        save ('participant3_session3_filtered','filtered_f_data','filtered_t_data')
    case 4
        save ('participant4_session3_filtered','filtered_f_data','filtered_t_data')
    case 5
        save ('participant5_session3_filtered','filtered_f_data','filtered_t_data')
end
clear filtered_f_data
%% zero meaning i.e remove DC 
%zero_meaned_data = zeromeaning(filtered_t_data)
%% plotting zero meaned data
% figure
% hold on
% %plot(data_chunk{1}(:,1),'--')
% plot(zero_meaned_data{1}(:,5))
% hold off
%% Extracting statistical features time domain
% [mean_t, std_t] = statistical_feature_extraction(zero_meaned_data)
%% zeromeaning frequency data
%zero_meaned_data_f = zeromeaning(filtered_f_data)
%% Taking absolute value
%abs_value=absolute_value(zero_meaned_data_f)  
%% Extracting frequency domain 
%[mean_f, std_f] = statistical_feature_extraction(abs_value)
%% Consolidated to use in the ml app
% z=[mean_f  std_f mean_t std_t cl]
% z_t=[mean_t  std_t  cl] 
% z_f=[mean_f  std_f  cl]

% %% PSD
% Frequencies=1024
% Fs=1024
% %Hpsd = dspdata.psd(Data,Frequencies)
% for i=1:1:length(filtered_f_data)
%     xdft=filtered_f_data{i}
%     N = length(xdft);
%     %xdft = fft(x);
% %     xdft = xdft(1:(N/2+1),:);
%     psdx1 = (1/(Fs*N)) * abs(xdft).^2;
%     psdx=sum(psdx1,1)
% %     Data =data_chunk_fromsynch{i}
% %     Frequencies=length(Data)
% %     Hpsd = dspdata.psd(abs(Data),Frequencies)
%      psd{i}=psdx
% %     psd{i}=Hpsd
% end
% %psdx(2:end-1) = 2*psdx(2:end-1);
%% Another way to calculate PSD
Fsx =1024
dx=1/Fsx

     

for i=1:1:length(filtered_t_data)
    x=filtered_t_data{i}
    L = length(x);
    Lfft = 2^nextpow2(L); 
    dfx  = 1/(Lfft*dx);
    fourier_image  = fftshift(fft(x,Lfft)/Lfft);
    PSDfromFFT     = abs(fourier_image).^2;
    freq           = -Fsx/2:dfx:Fsx/2-dfx; % Frequency axis
    freqs{i}=freq
    PSD{i}=PSDfromFFT
    
end
 clear x
 clear L
 clear Lfft
 clear dfx
 clear fourier_image
 clear PSDfromFFT
 clear freqs
 
%% Extracting features from power spectral density (frequency domain )
% [mean_p, std_p] = statistical_feature_extraction(abs_value)
% [max_p,min_p] =max_min(PSD)


% %% whole set of statistical features
% features1 = extract(absolute_value(filtered_t_data))
% features2 = extract(absolute_value(filtered_f_data))
% features3 = extract(absolute_value(PSD))
%% Y
% trial=[features1 features2 features3 cl]
%% dwt 
%    winsize:	window size (length of x)
%    wininc:	spacing of the windows (winsize)

for i=1:1:length(filtered_t_data)
    features_dw=[]
    for j=1:1:size(filtered_t_data{1},2)
        h= filtered_t_data{i}(:,j)
        winsize=length(h)
        SF=1024
        wininc=32
        feat = getmswtfeat(h,winsize,wininc,SF)
        features_dw=[features_dw feat]
    end
features_discrete_wavelet(i,:)=features_dw
end


% %% Discrete Wavelet Transform
% wname='db1' %Haar
% for i=1:1:length(filtered_f_data)
%         cA=[];
%         cH=[];
%         cV=[];
%         cD=[];
% 
%     for j=1:1:size(filtered_f_data{1},2)
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
%% whole set of statistical features
features1 = extract(absolute_value(filtered_t_data))
features2 = extract(absolute_value(fourier_transform(filtered_t_data)))
features3 = extract(absolute_value(PSD))
features4 = More_extract(filtered_t_data)
features5 = More_extract(fourier_transform(filtered_t_data))
features6 = More_extract(PSD)
features7=Spectral_Features_Extract(filtered_t_data,SF)
features8=Spectral_Features_Extract(fourier_transform(filtered_t_data),SF)
features9=Spectral_Features_Extract(PSD,SF)
%features_discrete_wavelet
%features4 = extract(absolute_value(PSD))
% features=[features1 features2 features3 features_discrete_wavelet cl]
features=[features1 features2 features3 features4 features5 features6 features7 features8 features9 features_discrete_wavelet cl]
switch main_loop_counter
    case 1 
%save ('participant1_session3','features1','features2','features3','features_discrete_wavelet','features')
%save ('participant1_session3_more','features1','features2','features3','features_discrete_wavelet','features')
save ('participant1_session3_4_13','features1','features2','features3','features4','features5','features6','features7','features8','features9','features_discrete_wavelet','features')
    case 2
% save ('participant2_session3','features1','features2','features3','features_discrete_wavelet','features')
%save ('participant2_session3_more','features1','features2','features3','features_discrete_wavelet','features')
save ('participant2_session3_4_13','features1','features2','features3','features4','features5','features6','features7','features8','features9','features_discrete_wavelet','features')
    case 3
% save ('participant3_session3','features1','features2','features3','features_discrete_wavelet','features')
% save ('participant3_session3_more','features1','features2','features3','features_discrete_wavelet','features')
save ('participant3_session3_4_13','features1','features2','features3','features4','features5','features6','features7','features8','features9','features_discrete_wavelet','features')
    case 4
% save ('participant4_session3','features1','features2','features3','features_discrete_wavelet','features')
%save ('participant4_session3_more','features1','features2','features3','features_discrete_wavelet','features')
save ('participant4_session3_4_13','features1','features2','features3','features4','features5','features6','features7','features8','features9','features_discrete_wavelet','features')
    case 5
% save ('participant5_session3','features1','features2','features3','features_discrete_wavelet','features')
%save ('participant5_session3_more','features1','features2','features3','features_discrete_wavelet','features')
save ('participant5_session3_4_13','features1','features2','features3','features4','features5','features6','features7','features8','features9','features_discrete_wavelet','features')
end
end
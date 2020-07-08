%The following statement is the correct statement to load data
[data,numChan,labels,txt,fs,gain,prefiltering,ChanDim] = eeg_read_bdf('Sample_readable_files\Part1_IAPS_SES1_EEG_fNIRS_03082006.bdf','all','n')
%loads eeg signal data
%raw preprocessed
%How to use it to preprocess ?
%Dont use the option of reshape
%[data1,numChan1,labels1,txt1,fs1,gain1,prefiltering1,ChanDim1] = eeg_read_bdf('Part1_IAPS_SES1_EEG_fNIRS_03082006.bdf','all','y')
%Assuming the data is selected such that each video is about 12s
%HP: DC; LP: 67 Hz is saved in pre-filter
%Transpose the data and label it 
data=data'
%From reading the paper, there should have been 64 eeg channels
%Of these 10 have been removed leaving 54 electrodes
%73-54 = 19 extra channels 
%These record respiration, cardiac rate and galvanic skin resistance 
%[I THINK] under the assumption that the 1st 54 channels belong to EEG and
%the rest to other physiological signals they can be removed during
%pre-processing
%% Saving to .mat format
save('Sample_readable_files\extractingdata1s1.m','data')

%% Extracting markers
%mrk is a text file
%It has a list of samples at which triggers which include begning of each
%block of images as well as the begning of protocol 
%first trigger isnt there
%So I expected it to be 59 but we have 61 labels .
%Last 2 have same labels so we can assume it to be 60 labels in total 
%Assuming the first one is missing i.e, the first 10s black screen is
%missing, we assume 1to 19841 is the first chunk 
m = csvread('Sample_readable_files\Part1_IAPS_SES1_EEG_fNIRS_03082006.bdf.mrk.csv')
%% Using the markers to assign labels
no_of_rows_data= size(data,1) %No of total samples
no_of_columns_data= size(data,2)%No of electrodes

no_of_rows_m=size(m,1)%No of classes
no_of_columns_m=size(m,2)% No of markers related to each class

j=1
i=1
data_chunk={}
while i<= no_of_rows_data
    l= m(j,1)-1
    data_chunk{j}= data(i:l,:)
    i=m(j,1)
    j=j+1
    if j>no_of_rows_m
        data_chunk{j}= data(i:no_of_rows_data,:)
        break
    end
end
 %% Labelling 
%CSV is for numerical data only
%  f=fopen('IAPS_Classes_EEG_fNIRS.txt')
%  labels = textscan(f,'%s %s %s','Delimiter',' ')        
%labels=importdata('IAPS_Classes_EEG_fNIRS.txt')
labels_class =readtable('Sample_readable_files\IAPS_Classes_EEG_fNIRS.csv')
% %% accessing the elements in the label
% j=0;
% i=1;
% for i=1:1:60
%     
%     if rem(i,2)~=0
%     data_chunk{1,i}(:,no_of_columns_data+1)=4; %No emotional trigger, BLACK SCREEN
%     end
%     if rem(i,2)==0 
%     j=j+1  
%     label = labels{j,1};
%     %l=label{1,1};
%     if strcmp(label,'Calm')==1
%             data_chunk{1,i}(:,no_of_columns_data+1)=1; %CALM IS CLASS 1
%     elseif strcmp(label,'Pos')==1
%             data_chunk{1,i}(:,no_of_columns_data+1)=2; %POSITIVE IS CLASS 2
%     elseif strcmp(label,'Neg') ==1  
%             data_chunk{1,i}(:,no_of_columns_data+1)=3;%NEGATIVE IS CLASS 3
%     end
% end    
% end
 %% Removing black screen data
% %data_chunk = data_chunk{1,1:60};
% data_for_preprocessing={}
% %data_for_preprocessing={data_chunk{1,1:60}};
% j=1;
% for i=1:1:60
%     if data_chunk{1,i}(1,74)~=4
%         data_for_preprocessing{j}=data_chunk{1,i}
%         j=j+1
%     end
% end
% %% To see how it would be to take equal chunks of data
% j=1
% i=1
% l=0
% data_chunk_eq={}
% while i<= no_of_rows_data
%     l= i+3200
%     data_chunk_eq{j}= data(i:l,:)
%     j=j+1
%     
% end
%about 100 when it should have been about 60
%So totally not 
%% taking chunks a different way 
% Using the markers to assign labels by considering the label 1 as start of
% video and the following label as start of logic
j=1
i=1
k=1
i=1
counter=0
data_chunk_fromsynch={}
while i<= no_of_rows_data
    l= m(j,1)-1;
    if i~=1
    data_chunk_fromsynch{k}= data(i:l,1:64);
    k=k+1;
    counter=counter+1
    end
    i=m(j,1);
    j=j+2;
    if j>no_of_rows_m
        %data_chunk_fromsynch{k}= data(i:no_of_rows_data,1:64);
        break
    end
end

%% plotting data
%plot(data_chunk{1}(:,1)) %Just to visualize
%% zero meaning i.e remove DC 
zero_meaned_data = zeromeaning(data_chunk_fromsynch)
%% plotting zero meaned data
figure
hold on
%plot(data_chunk{1}(:,1),'--')
plot(zero_meaned_data{1}(:,5))
hold off
%% extracting class labels
labels_class =readtable('Sample_readable_files\IAPS_Classes_EEG_fNIRS.csv')

%% Extracting statistical features time domain
[mean_t, std_t] = statistical_feature_extraction(zero_meaned_data)
%% Fourier transform features
frequency_d_data = fourier_transform(data_chunk_fromsynch)
%% Extracting frequency domain 
[mean_f, std_f] = statistical_feature_extraction(frequency_d_data)
%% Annoting the data with labels
cl=zeros(30,1)
for i=1:1:30
    label=labels_class{i,1}
    if strcmp(label,'Calm')==1
             cl(i)=1; %CALM IS CLASS 1
     elseif strcmp(label,'Pos')==1
             cl(i)=2; %POSITIVE IS CLASS 2
     elseif strcmp(label,'Neg') ==1  
             cl(i)=3;%NEGATIVE IS CLASS 3
     end
end
%% Consolidated to use in the ml app
%z_t=[mean_t  std_t cl]
%z_f=[mean_f  std_f  cl] % cannot be used cuz imaginary values

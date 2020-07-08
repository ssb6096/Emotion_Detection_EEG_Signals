%% Writing all eeg data to csv files
[data,numChan,labels,txt,fs,gain,prefiltering,ChanDim] = eeg_read_bdf('eNTERFACE06_EMOBRAIN\Data\EEG\Part1_IAPS_SES3_EEG_fNIRS_08082006.bdf','all','n')
%dlmwrite('1test.csv',labels)
data=data'
n=length(data)
dlmwrite('1test.csv',data, '-append')
delete data

%Participant-4/session-1
[data,numChan,labels,txt,fs,gain,prefiltering,ChanDim] = eeg_read_bdf('eNTERFACE06_EMOBRAIN\Data\EEG\Part4_IAPS_SES1_EEG_fNIRS_07082006.bdf','all','n')
data=data'
n=n+length(data)
dlmwrite('1test.csv',data, '-append')
delete data

%Participan/-5/session-1                                                                                                          nbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbn  ,t-5/session-1
[data,numChan,labels,txt,fs,gain,prefiltering,ChanDim] = eeg_read_bdf('eNTERFACE06_EMOBRAIN\Data\EEG\Part5_IAPS_SES1_EEG_fNIRS_08082006.bdf','all','n')
data=data'
n=n+length(data)
dlmwrite('1test.csv',data, '-append')
delete data

%Participant-1/session-2
[data,numChan,labels,txt,fs,gain,prefiltering,ChanDim] = eeg_read_bdf('eNTERFACE06_EMOBRAIN\Data\EEG\Part1_IAPS_SES2_EEG_fNIRS_07082006.bdf','all','n')
data=data'
n=n+length(data)
dlmwrite('1test.csv',data, '-append')
delete data

%Participant-2/session-2
[data,numChan,labels,txt,fs,gain,prefiltering,ChanDim1] = eeg_read_bdf('eNTERFACE06_EMOBRAIN\Data\EEG\Part2_IAPS_SES2_EEG_fNIRS_08082006.bdf','all','n')
data=data'
n=n+length(data)
dlmwrite('1test.csv',data, '-append')
delete data

%Participant-3/session-2
[data,numChan,labels,txt,fs,gain,prefiltering,ChanDim1] = eeg_read_bdf('eNTERFACE06_EMOBRAIN\Data\EEG\Part3_IAPS_SES2_EEG_fNIRS_08082006.bdf','all','n')
data=data'
n=n+length(data)
dlmwrite('1test.csv',data, '-append')
delete data

%Participant-4/session-2
[data,numChan,labels,txt,fs,gain,prefiltering,ChanDim1] = eeg_read_bdf('eNTERFACE06_EMOBRAIN\Data\EEG\Part4_IAPS_SES2_EEG_fNIRS_08082006.bdf','all','n')
data=data'
n=n+length(data)
dlmwrite('1test.csv',data, '-append')
delete data

%Participant-5/session-2
[data,numChan,labels,txt,fs,gain,prefiltering,ChanDim1] = eeg_read_bdf('eNTERFACE06_EMOBRAIN\Data\EEG\Part5_IAPS_SES2_EEG_fNIRS_09082006.bdf','all','n')
data=data'
n=n+length(data)
dlmwrite('1test.csv',data, '-append')
delete data

%Participant-1/session-3 
[data,numChan,labels,txt,fs,gain,prefiltering,ChanDim] = eeg_read_bdf('eNTERFACE06_EMOBRAIN\Data\EEG\Part1_IAPS_SES3_EEG_fNIRS_08082006.bdf','all','n')
data=data'
n=n+length(data)
dlmwrite('1test.csv',data, '-append')
delete data

% %Participant-2/session-3
[data,numChan,labels,txt,fs,gain,prefiltering,ChanDim1] = eeg_read_bdf('eNTERFACE06_EMOBRAIN\Data\EEG\Part2_IAPS_SES3_EEG_fNIRS_09082006.bdf','all','n')
data=data'
n=n+length(data)
dlmwrite('1test.csv',data, '-append')
delete data

%Participant-3/session-3
[data,numChan,labels,txt,fs,gain,prefiltering,ChanDim1] = eeg_read_bdf('eNTERFACE06_EMOBRAIN\Data\EEG\Part3_IAPS_SES3_EEG_fNIRS_08082006.bdf','all','n')
 data=data'
 n=n+length(data)
dlmwrite('1test.csv',data, '-append')
delete data

%Participant-4/session-3
[data,numChan,labels1,txt,fs,gain,prefiltering,ChanDim1] = eeg_read_bdf('eNTERFACE06_EMOBRAIN\Data\EEG\Part4_IAPS_SES3_EEG_fNIRS_09082006.bdf','all','n')
data=data'
n=n+length(data)
dlmwrite('1test.csv',data, '-append')
delete data

%Participant-5/session-3
[data,numChan,labels1,txt,fs,gain,prefiltering,ChanDim1] = eeg_read_bdf('eNTERFACE06_EMOBRAIN\Data\EEG\Part5_IAPS_SES3_EEG_fNIRS_09082006.bdf','all','n')
data=data'
n=n+length(data)
dlmwrite('1test.csv',data, '-append')
delete data

%% IncrementalPCA()
QOld=0
n=1
coeffOld=[]
latentOld=[]
mOld=0
%sqsOld=0
%mOld
%sqsOld
[coeff,latent,QNew]=IncrementalPCA(QOld,n,data,coeffOld,latentOld)
n=n+1
coeffOld=coeff
latentOld=latent
QOld=QNew
[coeff,latent,QNew]=IncrementalPCA(QOld,n,data,coeffOld,latentOld)

%% PCA
[coeff,score,latent] = pca(data)
%dataInPrincipalComponentSpace = X*coeff
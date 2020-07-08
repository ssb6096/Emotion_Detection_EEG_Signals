% Extracting EEG Signals
%Participant-1/session-2
[data1,numChan1,labels1,txt1,fs1,gain1,prefiltering1,ChanDim1] = eeg_read_bdf('eNTERFACE06_EMOBRAIN\Data\EEG\Part1_IAPS_SES2_EEG_fNIRS_07082006.bdf','all','n')
%Participant-1/session-3
[data2,numChan1,labels1,txt2,fs1,gain1,prefiltering1,ChanDim1] = eeg_read_bdf('eNTERFACE06_EMOBRAIN\Data\EEG\Part1_IAPS_SES3_EEG_fNIRS_08082006.bdf','all','n')
%Participant-2/session-1
[data3,numChan3,labels3,txt3,fs1,gain1,prefiltering1,ChanDim1] = eeg_read_bdf('eNTERFACE06_EMOBRAIN\Data\EEG\Part2_IAPS_SES1_EEG_fNIRS_07082006.bdf','all','n')
%Participant-2/session-2
[data4,numChan4,labels4,txt4,fs1,gain1,prefiltering1,ChanDim1] = eeg_read_bdf('eNTERFACE06_EMOBRAIN\Data\EEG\Part2_IAPS_SES2_EEG_fNIRS_08082006.bdf','all','n')
%Participant-2/session-3
[data5,numChan5,labels5,txt5,fs1,gain1,prefiltering1,ChanDim1] = eeg_read_bdf('eNTERFACE06_EMOBRAIN\Data\EEG\Part2_IAPS_SES3_EEG_fNIRS_09082006.bdf','all','n')
%Participant-3/session-1
[data6,numChan6,labels6,txt6,fs1,gain1,prefiltering1,ChanDim1] = eeg_read_bdf('eNTERFACE06_EMOBRAIN\Data\EEG\Part3_IAPS_SES1_EEG_fNIRS_07082006.bdf','all','n')
%Participant-3/session-2
[data7,numChan7,labels7,txt7,fs1,gain1,prefiltering1,ChanDim1] = eeg_read_bdf('eNTERFACE06_EMOBRAIN\Data\EEG\Part3_IAPS_SES2_EEG_fNIRS_08082006.bdf','all','n')
%Participant-3/session-3
[data8,numChan1,labels1,txt8,fs1,gain1,prefiltering1,ChanDim1] = eeg_read_bdf('eNTERFACE06_EMOBRAIN\Data\EEG\Part3_IAPS_SES3_EEG_fNIRS_08082006.bdf','all','n')
%Participant-4/session-1
[data9,numChan1,labels1,tx9,fs1,gain1,prefiltering1,ChanDim1] = eeg_read_bdf('eNTERFACE06_EMOBRAIN\Data\EEG\Part4_IAPS_SES1_EEG_fNIRS_07082006.bdf','all','n')
%Participant-4/session-2
[data10,numChan1,labels1,txt10,fs1,gain1,prefiltering1,ChanDim1] = eeg_read_bdf('eNTERFACE06_EMOBRAIN\Data\EEG\Part4_IAPS_SES2_EEG_fNIRS_08082006.bdf','all','n')
%Participant-4/session-3
[data11,numChan1,labels1,txt11,fs1,gain1,prefiltering1,ChanDim1] = eeg_read_bdf('eNTERFACE06_EMOBRAIN\Data\EEG\Part4_IAPS_SES3_EEG_fNIRS_09082006.bdf','all','n')
%Participant-5/session-1
[data12,numChan1,labels1,txt12,fs1,gain1,prefiltering1,ChanDim1] = eeg_read_bdf('eNTERFACE06_EMOBRAIN\Data\EEG\Part5_IAPS_SES1_EEG_fNIRS_08082006.bdf','all','n')
%Participant-5/session-2
[data13,numChan1,labels1,txt13,fs1,gain1,prefiltering1,ChanDim1] = eeg_read_bdf('eNTERFACE06_EMOBRAIN\Data\EEG\Part5_IAPS_SES2_EEG_fNIRS_09082006.bdf','all','n')
%Participant-5/session-3
[data14,numChan1,labels1,txt14,fs1,gain1,prefiltering1,ChanDim1] = eeg_read_bdf('eNTERFACE06_EMOBRAIN\Data\EEG\Part5_IAPS_SES3_EEG_fNIRS_09082006.bdf','all','n')
%% Trying to concatenate
data=[data1]
clear data1
data=[data;data2]
clear data2
data=[data;data3]
clear data3
data=[data;data4]
clear data4
data=[data;data5]
clear data5
data=[data;data6]
clear data6
data=[data;data7]
clear data7
data=[data;data8]
clear data8
data=[data;data9]
clear data9
data=[data;data10]
clear data10
data=[data;data11]
clear data11
data=[data;data12]
clear data12
data=[data;data13]
clear data13
data=[data;data14]
clear data14
clear txt1 txt2 txt3 txt4 txt5 txt6 txt7 txt8 txt9 txt10 txt11 txt12 txt13 txt14
%% Saving the vorsace variables
save('EEG_data','data')

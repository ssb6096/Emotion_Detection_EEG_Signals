%% Reading Markers
% reading markers
%P1S2
m1 = csvread('eNTERFACE06_EMOBRAIN\Data\EEG\Part1_IAPS_SES1_EEG_fNIRS_03082006.bdf.mrk.csv')
%P1S2
m2 = csvread('eNTERFACE06_EMOBRAIN\Data\EEG\')
%P1S2
m3 = csvread('eNTERFACE06_EMOBRAIN\Data\EEG\')
%P1S2
m4 = csvread('eNTERFACE06_EMOBRAIN\Data\EEG\')
%P1S2
m5 = csvread('eNTERFACE06_EMOBRAIN\Data\EEG\')
%P1S2
m6 = csvread('eNTERFACE06_EMOBRAIN\Data\EEG\')
%P1S2
m7 = csvread('eNTERFACE06_EMOBRAIN\Data\EEG\')
%P1S2
m8 = csvread('eNTERFACE06_EMOBRAIN\Data\EEG\Part1_IAPS_SES1_EEG_fNIRS_03082006.bdf.mrk.csv')
%P1S2
m9 = csvread('eNTERFACE06_EMOBRAIN\Data\EEG\Part1_IAPS_SES1_EEG_fNIRS_03082006.bdf.mrk.csv')
%P1S2
m10 = csvread('eNTERFACE06_EMOBRAIN\Data\EEG\Part1_IAPS_SES1_EEG_fNIRS_03082006.bdf.mrk.csv')
%P1S2
m11 = csvread('eNTERFACE06_EMOBRAIN\Data\EEG\Part1_IAPS_SES1_EEG_fNIRS_03082006.bdf.mrk.csv')
%P1S2
m12 = csvread('eNTERFACE06_EMOBRAIN\Data\EEG\Part1_IAPS_SES1_EEG_fNIRS_03082006.bdf.mrk.csv')
%P1S2
m13 = csvread('eNTERFACE06_EMOBRAIN\Data\EEG\Part1_IAPS_SES1_EEG_fNIRS_03082006.bdf.mrk.csv')
%P1S2
m14 = csvread('eNTERFACE06_EMOBRAIN\Data\EEG\Part1_IAPS_SES1_EEG_fNIRS_03082006.bdf.mrk.csv')





%% reading class labels
labels_class =readtable('eNTERFACE06_EMOBRAIN\Data\Common\IAPS_Classes_EEG_fNIRS.csv')

%% PRE-PROCESSING
data=[data;data1]
data=data'
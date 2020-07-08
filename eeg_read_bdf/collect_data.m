clc
clear all 
close all

%% Global vars
x2=[];x3=[];x4=[];x5=[];x6=[];x7=[];x8=[];x9=[];
y=[];
allfeat = [];
%% Loading data
data = load_xdf('C:\Users\vinit\Desktop\bio_lab_project\data\data2_4_25_19.xdf');

data_emg = data{1, 1}.time_series;
data_num = data{1, 2}.time_series;
emg_time = data{1, 1}.time_stamps;
event_time = data{1, 2}.time_stamps;
y = str2num(cell2mat(data_num(1,:)'));

%% Filter
% butterworth filter designing
fcut = 60; %Hz
fs=200;
f1 = ((fcut - 2)/ (fs/2));
f2 = ((fcut + 2)/ (fs/2));

[b,a] = butter(3,[f1 f2],'stop');
   
%% Pre-process
n = 600;

 for j=1:(length(y)-1)
        
%  val = abs(data{2}.time_stamps-data{1}.time_stamps(2*j-1));
% [mv,loc] = min(val)
%         
    [amin,bmin]=min(abs((event_time(j)-emg_time)));
    x2=[x2; filter(b,a,data_emg(2,bmin:bmin+599)-mean(data_emg(2,bmin:bmin+599)))];
    x3=[x3; filter(b,a,data_emg(3,bmin:bmin+599)-mean(data_emg(3,bmin:bmin+599)))];
    x4=[x4; filter(b,a,data_emg(4,bmin:bmin+599)-mean(data_emg(4,bmin:bmin+599)))];
    x5=[x5; filter(b,a,data_emg(5,bmin:bmin+599)-mean(data_emg(5,bmin:bmin+599)))];
    x6=[x6; filter(b,a,data_emg(6,bmin:bmin+599)-mean(data_emg(6,bmin:bmin+599)))];
    x7=[x7; filter(b,a,data_emg(7,bmin:bmin+599)-mean(data_emg(7,bmin:bmin+599)))];
    x8=[x8; filter(b,a,data_emg(8,bmin:bmin+599)-mean(data_emg(8,bmin:bmin+599)))];
    x9=[x9; filter(b,a,data_emg(9,bmin:bmin+599)-mean(data_emg(9,bmin:bmin+599)))];
 
 end

%% feature extraction

numFeatures=5;
x=zeros((length(y)-1),8*numFeatures);

for i=1:(length(y)-1)
    x(i,:) = [KSM1(x2(i,:),n) KSM1(x3(i,:),n) KSM1(x4(i,:),n) ...
        KSM1(x5(i,:),n) KSM1(x6(i,:),n) KSM1(x7(i,:),n) KSM1(x8(i,:),n) KSM1(x9(i,:),n)];
end
%%
 xnorm=(x-ones((length(y)-1),1)*min(x))./(ones((length(y)-1),1)*(max(x)-min(x)));
 xy=[x y(1:(length(y)-1),:)];

 ex_length = round((length(x)*80)/100);
 xy_train = xy(1:ex_length,:);
 xy_test = xy((ex_length+1):end,:);

 %% 
 yfit = load('trainedModeltest2.mat');
data1_2=load('participant1_session2.mat')
data1_3=load('participant1_session3.mat')
%data2_1=load('participant2_session1.mat')
data2_2=load('participant2_session2.mat')
data2_3=load('participant2_session3.mat')
data3_1=load('participant3_session1.mat')
data3_2=load('participant3_session2.mat')
data3_3=load('participant3_session3.mat')
data4_1=load('participant4_session1.mat')
data4_2=load('participant4_session2.mat')
data4_3=load('participant4_session3.mat')
data5_1=load('participant5_session1.mat')
data5_2=load('participant5_session2.mat')
data5_3=load('participant5_session3.mat')

%% Features and class
x=[data1_2.features; data1_3.features;data2_2.features;data2_3.features;data3_1.features;data3_2.features;data3_3.features;data4_1.features;data4_2.features;data4_3.features;data5_1.features;data5_2.features;data5_3.features];
%% mRMR
x1=x(:,1:5312)
y1=x(:,5313)
%% mRMR
x2=int64(x1)
K=100
[fea1] = mrmr_miq_d(x2, y1, K)
[fea2] = mrmr_mid_d(x1, y1, K)
K=1000
[fea3] = mrmr_miq_d(x1, y1, K)
[fea4] = mrmr_mid_d(x1, y1, K)
K=500
[fea5] = mrmr_miq_d(x1, y1, K)
[fea6] = mrmr_mid_d(x1, y1, K)
%% here we go 
T1 = array2table(x1)
%% cuz too much time
T2 = array2table(y1)
%% plz work
[idx,scores] = fscmrmr(T1,T2) 
% //no argument of type double
%% Another try
%[idx,scores] = fsulaplacian(x1)
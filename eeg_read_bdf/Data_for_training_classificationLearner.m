%This file is for loading all data to be used in the classification leaner
%toolbox
%There will be 25% of data held out as test set
% x1=load('.\FeaturesExtracted\participant1_session2_con.mat')
% X=x1.features
% x1=load('.\FeaturesExtracted\participant1_session3_con.mat')
% x1=load('.\FeaturesExtracted\participant3_session1_con.mat')
% %X=[X;x1.features]

% x1=load('.\FeaturesExtracted\participant1_session2.mat')
% x2=load('.\FeaturesExtracted\participant1_session2_more.mat')
% x3=load('.\FeaturesExtracted\participant1_session3.mat')
% x4=load('.\FeaturesExtracted\participant1_session3_more.mat')
% x5=load('.\FeaturesExtracted\participant2_session2.mat')
% x6=load('.\FeaturesExtracted\participant2_session2_more.mat')
% x7=load('.\FeaturesExtracted\participant2_session3.mat')
% x8=load('.\FeaturesExtracted\participant2_session3_more.mat')
% x9=load('.\FeaturesExtracted\participant3_session1_nf_t1.mat')
% x10=load('.\FeaturesExtracted\participant3_session1_more.mat')
% x11=load('.\FeaturesExtracted\participant3_session2.mat')
% x12=load('.\FeaturesExtracted\participant3_session2_more.mat')
% x13=load('.\FeaturesExtracted\participant3_session3.mat')
% x14=load('.\FeaturesExtracted\participant3_session3_more.mat')
% x15=load('.\FeaturesExtracted\participant4_session1_nf_t1.mat')
% x16=load('.\FeaturesExtracted\participant4_session1_more.mat')
% x17=load('.\FeaturesExtracted\participant4_session2.mat')
% x18=load('.\FeaturesExtracted\participant4_session2_more.mat')
% x19=load('.\FeaturesExtracted\participant4_session3.mat')
% x20=load('.\FeaturesExtracted\participant4_session3_more.mat')
% x21=load('.\FeaturesExtracted\participant5_session1_nf_t1.mat')
% x22=load('.\FeaturesExtracted\participant5_session1_more.mat')
% x23=load('.\FeaturesExtracted\participant5_session2.mat')
% x24=load('.\FeaturesExtracted\participant5_session2_more.mat')
% x25=load('.\FeaturesExtracted\participant5_session3.mat')
% x26=load('.\FeaturesExtracted\participant5_session3_more.mat')
% 
% % x1=load('participant1_session3_con.mat')
% % x2=load('participant2_session3_con.mat')
% % x3=load('participant3_session3_con.mat')
% % x4=load('participant4_session3_con.mat')
% % x5=load('participant5_session3_con.mat')
% 
% % To use with app
% x=[x2.features1 x2.features2 abs(x2.features3) x1.features;
%     x4.features1 x4.features2 abs(x4.features3) x3.features;
%     x6.features1 x6.features2 abs(x6.features3) x5.features;
%     x8.features1 x8.features2 abs(x8.features3) x7.features;
%     x10.features1 x10.features2 abs(x10.features3) x9.features;
%     x12.features1 x12.features2 abs(x12.features3) x11.features;
%     x14.features1 x14.features2 abs(x14.features3) x13.features;
%     x16.features1 x16.features2 abs(x16.features3) x15.features;
%     x18.features1 x18.features2 abs(x18.features3) x17.features;
%     x20.features1 x20.features2 abs(x20.features3) x19.features;
%     x22.features1 x22.features2 abs(x22.features3) x21.features;
%     x24.features1 x24.features2 abs(x24.features3) x23.features;
%     x26.features1 x26.features2 abs(x26.features3) x25.features;
%     ]
x1=load('x1.mat')
x=x1.x1
y1=load('y1.mat')
y=y1.y1
%% Normalize and divide
[m,n]=size(n_x)
n_x=normalize(x)
P=0.8
idx=randperm(m)

Training_x=n_x(idx(1:round(P*m)),:);
Training_y=y(idx(1:round(P*m)),:);
Testing_x=n_x(idx(round(P*m):m),:);
Testing_y=y(idx(round(P*m):m),:);
X_forLearner=[Training_x Training_y]
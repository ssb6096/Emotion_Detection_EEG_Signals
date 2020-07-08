
%Data = dlmread('Concrete_Data.csv', ',', 2, 0);
x= load('participant3_session1_4_13')
Data=x.features
delete x
x= load('participant4_session1_4_13')
Data=[Data;x.features]
delete x
x= load('participant5_session1_4_13')
Data=[Data;x.features]
delete x
x= load('participant1_session2_4_13')
Data=[Data;x.features]
delete x
x= load('participant2_session2_4_13')
Data=[Data;x.features]
delete x
x= load('participant3_session2_4_13')
Data=[Data;x.features]
delete x
x= load('participant4_session2_4_13')
Data=[Data;x.features]
delete x
x= load('participant5_session2_4_13')
Data=[Data;x.features]
delete x
x= load('participant1_session3_4_13')
Data=[Data;x.features]
delete x
x= load('participant2_session3_4_13')
Data=[Data;x.features]
delete x
x= load('participant3_session3_4_13')
Data=[Data;x.features]
delete x
x= load('participant4_session3_4_13')
Data=[Data;x.features]
delete x
x= load('participant5_session3_4_13')
Data=[Data;x.features]
delete x
%% Saving to use later
%save ('All_participant_All_session_features_4_18','Data')
%% Saving again like 
X=Data(:,1:size(Data,2)-1);
y=Data(:,size(Data,2));
%save ('All_participant_All_sessions','X','y')

%% Save train and test split
XdataTrain = Data(1:360,1:size(Data,2)-1);
yTrain = Data(1:360,length(Data));
% xx=[XdataTrain yTrain]
XdataTest = Data(360:390,1:size(Data,2)-1);
yTest = Data(360:390,size(Data,2));

Data_for_classifier=[XdataTrain yTrain]
save('All_participants_train_test','XdataTrain','yTrain','XdataTest','yTest')
% %% For classifier
% X_classifier_train=abs(Data(1:360,:))
% %% Brute force feature selection
% msee=10000
% msea=zeros(size(Data,2),1)
%  c=zeros(size(Data,2)-1);
% 
% for j=1:1:size(Data,2)-1
% for i=1:1:size(Data,2)-1   
% % i=5
% % j=8
% i
% q = nchoosek(1:size(Data,2)-1,j);
% qc=nchoosek(size(Data,2),j);
% for k=1:1:qc
% TrainData=[XdataTrain(:,q(k,1):q(k,j))];
% TestData =[XdataTest(:,q(k,1):q(k,j))];
% for this=5:10:size(Data,2)+100
% rng(2000);
% tree = ClassificationTree.fit(TrainData,yTrain,'MinParentSize',this);
% maxprune = max(tree.PruneList);
% [E,SE,Nleaf,BestLevel] = cvloss(tree,'SubTrees',0:maxprune,'KFold',5);
% treePrune = prune(tree,'level',BestLevel);
% pred = predict(tree,TestData);
% mse = (1/length(yTest))*sum((yTest-pred).^2);
% acc=1-mse
% %mse1= [mse1 mse];
% if msee>mse
%   msee=mse;
%   ssii=size(k,2);
%   c1=zeros(1,ssii);
%   c1=q(k,:);
%   c2=this
% end 
% end
% end
% 
% end
% j
% end
% % end
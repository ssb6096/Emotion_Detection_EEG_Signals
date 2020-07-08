clear all;
close all;
clc;
%rock=1
%paper=2
%scissors=3

%loading data
label = [1 2 3];
rock = load_xdf('Rock.xdf');
paper = load_xdf('Paper.xdf');
scissor = load_xdf('Scissor.xdf');

data=[rock paper scissor];
fds=[];
for i=label
    %preprocessing rock data
    [f t] = preProcess_EMG(data(i),960,20);
    %feature extraction
    fds=[fds;fExtract(f,t,i)];
end

%testIndex=[randperm(60,10)]

testIndex=[2 5 24 32 44 48]

%split data into testing and training
testData=[];
trainData=[];
for i=1:60
    if(find(i==testIndex))
        %testing data
        testData = [testData; fds(i,:)];
    else
        %training data
        trainData = [trainData; fds(i,:)];
    end
end

% plot(fds(:,[1:size(fds,2)-1]));
% plot(fds_un(:,[1:size(fds,2)-1]));

% plot(fds);

%classification

[mc,accu]=trainClassifier(trainData);

%testing
 yfit = mc.predictFcn(testData(:,[1:size(fds,2)-1]));
 ytrainSet = testData(:,15);
 
 
% confusion matrix and accuracy
figure
confusionMatrix=confusionmat(ytrainSet,yfit  );
cm = confusionchart(confusionMatrix);
acu = sum(diag(confusionMatrix))/sum(sum(confusionMatrix));
 
 
 
%prediction accuracy
 counter=0;
 for i=1:length(yfit)
     if(yfit(i)==(testData(i,15)))
        counter=counter+1;
     end
 end
accuracy=counter*100/length(yfit);





    
  
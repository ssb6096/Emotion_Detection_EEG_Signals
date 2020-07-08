
% x1=load('participant1_session2.mat')
% x2=load('participant1_session2_more.mat')
% x3=load('participant1_session3.mat')
% x4=load('participant1_session3_more.mat')
% x5=load('participant2_session2.mat')
% x6=load('participant2_session2_more.mat')
% x7=load('participant2_session3.mat')
% x8=load('participant2_session3_more.mat')
%x9=load('participant3_session1_nf_t1.mat')
% x10=load('participant3_session1_more.mat')
% x11=load('participant3_session2.mat')
% x12=load('participant3_session2_more.mat')
% x13=load('participant3_session3.mat')
% x14=load('participant3_session3_more.mat')
%x15=load('participant4_session1_nf_t1.mat')
% x16=load('participant4_session1_more.mat')
% x17=load('participant4_session2.mat')
% x18=load('participant4_session2_more.mat')
% x19=load('participant4_session3.mat')
% x20=load('participant4_session3_more.mat')
%x21=load('participant5_session1_nf_t1.mat')
% x22=load('participant5_session1_more.mat')
% x23=load('participant5_session2.mat')
% x24=load('participant5_session2_more.mat')
% x25=load('participant5_session3.mat')
% x26=load('participant5_session3_more.mat')
x1=load('participant1_session3_con.mat')
x2=load('participant2_session3_con.mat')
x3=load('participant3_session3_con.mat')
x4=load('participant4_session3_con.mat')
x5=load('participant5_session3_con.mat')

%% To use with app
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
% % x=[x9.features; x15.features; x21.features]
% % n_x=normalize(x)
%% And this
% x_1=[x2.features;x4.features;x6.features;x8.features;x10.features;x12.features;x14.features;x16.features;x18.features;x20.features;x22.features;x24.features;x26.features]
%% using nnl  (DIDNT WORK, KEPT THROWING ERRORS)
%net = feedforwardnet(20);
% net = network
% %net.numInputs = 6665
% net.input{1}.size=6665
% net.numLayers = 10
% net.inputConnect = repmat([1],[10 6665]);
% %net.outputs{20}=1
% net.trainFcn = 'trainscg'
% net.layers{1}.transferFcn = 'tansig';
% net.layers{2}.transferFcn = 'logsig';
% net.layers{3}.transferFcn = 'tansig';
% net.layers{4}.transferFcn = 'logsig';
% net.layers{5}.transferFcn = 'tansig';
% net.layers{6}.transferFcn = 'logsig';
% net.layers{7}.transferFcn = 'tansig';
% net.layers{8}.transferFcn = 'logsig';
% net.layers{9}.transferFcn = 'tansig';
% net.layers{10}.transferFcn = 'logsig';
% input =abs(x(:,1:6665));
% output=x(:,6666);
% net = configure(net,input);
% net = train(net,input,output,'useParallel','yes','showResources','yes');
% view(net)
% y = net(input);
% perf = perform(net,y,output)
%% Trying CNN (TRY LSTM 1ST)
%%May have syntax errors

% options = trainingOptions('sgdm', ...
%     'LearnRateSchedule','piecewise', ...
%     'LearnRateDropFactor',0.2, ...
%     'LearnRateDropPeriod',5, ...
%     'MaxEpochs',20, ...
%     'MiniBatchSize',64, ...
%     'Plots','training-progress')
% inputSize=64
% layers = [
%     sequenceInputLayer(inputSize)
%     
%     convolution2dLayer(3,8,'Padding','same')
%     batchNormalizationLayer
%     reluLayer   
%     
%     maxPooling2dLayer(2,'Stride',2)
%     
%     convolution2dLayer(3,16,'Padding','same')
%     batchNormalizationLayer
%     reluLayer   
%     
%     maxPooling2dLayer(2,'Stride',2)
%     
%     convolution2dLayer(3,32,'Padding','same')
%     batchNormalizationLayer
%     reluLayer   
%     
%     fullyConnectedLayer(10)
%     softmaxLayer
%     classificationLayer];
% net = trainNetwork(XTrain,YTrain,layers,options);

%% LSTM 
% %Trying LSTM with no feature extraction 
% %This will show how useful time series is for classifying EEG 
% %This is LSTM
% %Combination of CNN and LSTM would be a good choice too 
% %There will be memory out of bound error when trying to run this 
% % hence ds = datastore('path/to/file.csv')
% %or ds = datastore('data/*.csv')
% %Has to be used 
% %Can even use data augmentation
% XTrain=
% YTrain=
% 
% idx = randperm(size(XTrain,1),30);
% XValidation = XTrain(:,:,:,idx);
% XTrain(:,:,:,idx) = [];
% YValidation = YTrain(idx);
% YTrain(idx) = [];
% 
% miniBatchSize = 27;
% inputSize = 64;
% numHiddenUnits = 100;
% numClasses = 3;
% maxEpochs = 100;
% 
% layers = [ ...
%     sequenceInputLayer(inputSize)
%     bilstmLayer(numHiddenUnits,'OutputMode','last')
%     fullyConnectedLayer(numClasses)
%     softmaxLayer
%     classificationLayer]
% 
% options = trainingOptions('adam', ...
%     'ExecutionEnvironment','cpu', ...
%     'GradientThreshold',1, ...
%     'MaxEpochs',maxEpochs, ...
%     'MiniBatchSize',miniBatchSize, ...
%     'SequenceLength','longest', ...
%     'Shuffle','never', ...
%     'Verbose',0, ...
%     'Plots','training-progress');
% 
% net = trainNetwork(XTrain,YTrain,layers,options);
% %% When needed
% YPred = classify(net,XTest, ...
%     'MiniBatchSize',miniBatchSize, ...
%     'SequenceLength','longest');
% 
% acc = sum(YPred == YTest)./numel(YTest)
%% Just nnfc
XTrain=[x1.features(:,1:(size(x1.features,2)-1));x2.features(:,1:(size(x2.features,2)-1));x3.features(:,1:(size(x3.features,2)-1));x4.features(:,1:(size(x4.features,2)-1));x5.features(:,1:(size(x5.features,2)-1));]
YTrain=[x1.features(:,size(x1.features,2));x2.features(:,(size(x2.features,2)));x3.features(:,(size(x3.features,2)));x4.features(:,(size(x4.features,2)));x5.features(:,(size(x5.features,2)));]

% XTrain=num2cell(XTrain',1);
% YTrain=num2cell(YTrain,2);
% idx = randperm(length(XTrain),round(0.25*(length(XTrain))));
% XValidation = XTrain{idx};
% XTrain(idx) = [];
% YValidation = YTrain{idx};
% YTrain(idx) = [];
% options = trainingOptions('sgdm', ...
%     'LearnRateSchedule','piecewise', ...
%     'LearnRateDropFactor',0.2, ...
%     'LearnRateDropPeriod',5, ...
%     'MaxEpochs',20, ...
%     'MiniBatchSize',30, ...
%     'Plots','training-progress')
% inputSize=size(XTrain{1},1)
% %expectedOutput=categorical(YTrain);
% layers = [ sequenceInputLayer([1 1 inputSize])
%     flattenLayer
%     lstmLayer(10,'OutputMode','last')
%     fullyConnectedLayer(6000)
%     dropoutLayer(0.5)
%     fullyConnectedLayer(2000)
%     dropoutLayer(0.5)
%     fullyConnectedLayer(500)
%     dropoutLayer(0.5)
%     fullyConnectedLayer(100)
%     softmaxLayer
%     classificationLayer]
% net = trainNetwork(XTrain,YTrain,layers,options);
%% Here we go
net = feedforwardnet(50);
% net = configure(net,XTrain,YTrain);
% y1 = net(XTrain)
% plot(XTrain,YTrain,'o',XTrain,y1,'x')
X_Train=X_features'
Y_Train=YTrain'

net = train(net,abs(X_Train),Y_Train);
% y2 = net(X_Train)
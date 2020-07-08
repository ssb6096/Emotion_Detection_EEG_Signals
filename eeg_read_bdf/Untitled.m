% x = csvread('D:\\Final Year Project\Datasets\eeg-brainwave-dataset-feeling-emotions\emotions.csv')
%T = readtable('D:\\Final Year Project\Datasets\eeg-brainwave-dataset-feeling-emotions\emotions.csv')
%% NOw what ?
Xx=array2table(abs(XTrain));
Yy=array2table(YTrain);
X_features=[]
[idx1,scores1] = fscmrmr(Xx,Yy)
[idx2,scores2] = fsulaplacian(abs(XTrain));
[idx3,weights3] = relieff(abs(XTrain),YTrain,k)
idx1(1:5)
idx2(1:5)
features_i=idx3(1:100)
for i=1:1:40
X_features=[X_features XTrain(:,features_i)]
end 
%% using only 10 features
x1=abs(XTrain')
y1=YTrain
%x_try_with_app= [x1(:,1251) x1(:,2074) x1(:,4415) x1(:,4418) x1(:,2242) x1(:,4492) x1(:,4481) x1(:,4493) x1(:,4509) x1(:,4487) y1(:)]
%% plotting to make sense
bar(scores(idx))
xlabel('Predictor rank')
ylabel('Predictor importance score')
%% another feature selection method
mdl = fscnca(x1,y1,'Solver','sgd','Verbose',1);
figure()
plot(mdl.FeatureWeights,'ro')
grid on
xlabel('Feature index')
ylabel('Feature weight')

%% Feature selection 
XTrain_1=abs(XTrain)
rng(1); % For reproducibility
cvp = cvpartition(150,'holdout',30)
Xtrain = XTrain_1(cvp.training,:);
ytrain = YTrain(cvp.training,:);
Xtest  = XTrain_1(cvp.test,:);
ytest  = YTrain(cvp.test,:);
%% cont. 
nca = fscnca(Xtrain,ytrain,'FitMethod','none');
%% and then
nca = fscnca(Xtrain,ytrain,'FitMethod','exact','Lambda',0,...
      'Solver','sgd','Standardize',true);
L = loss(nca,Xtest,ytest)
%% WAsnt a good idea but still
cvp = cvpartition(ytrain,'kfold',5);
numvalidsets = cvp.NumTestSets;
n = length(ytrain);
lambdavals = linspace(0,20,20)/n;
lossvals = zeros(length(lambdavals),numvalidsets);
for i = 1:length(lambdavals)
    for k = 1:numvalidsets
        X = Xtrain(cvp.training(k),:);
        y = ytrain(cvp.training(k),:);
        Xvalid = Xtrain(cvp.test(k),:);
        yvalid = ytrain(cvp.test(k),:);

        nca = fscnca(X,y,'FitMethod','exact', ...
             'Solver','sgd','Lambda',lambdavals(i), ...
             'IterationLimit',30,'GradientTolerance',1e-4, ...
             'Standardize',true);
                  
        lossvals(i,k) = loss(nca,Xvalid,yvalid,'LossFunction','classiferror');
    end
end
L = loss(nca,Xtest,ytest)
meanloss = mean(lossvals,2);
figure()
plot(lambdavals,meanloss,'ro-')
xlabel('Lambda')
ylabel('Loss (MSE)')
grid on
[~,idx] = min(meanloss) % Find the index
bestlambda = lambdavals(idx) % Find the best lambda value
bestloss = meanloss(idx)
%% Plotting more

nca = fscnca(Xtrain,ytrain,'FitMethod','average','Solver','sgd',...
    'Lambda',bestlambda,'Standardize',true,'Verbose',1);
figure()
plot(nca.FeatureWeights,'ro')
xlabel('Feature index')
ylabel('Feature weight')
grid on
% Select features using the feature weights and a relative threshold.
tol    = 0.40;
selidx = find(nca.FeatureWeights > tol*max(1,max(nca.FeatureWeights)))
% selidx = find(nca.FeatureWeights > 0.2)
L = loss(nca,Xtest,ytest)
features_best = Xtrain(:,selidx);
svmMdl= fitcensemble(features_best,ytrain);
L = loss(svmMdl,Xtest(:,selidx),ytest)
%% Accuracy is still bad so trying other methods



clc;
clear all;
close all;

sam_freq = 200;
%%%%%%%%%%%%%%%%%%%%LOAD DATA%%%%%%%%%%%%%%%%%%%%%%
data = load_xdf('iTrial6.xdf');
%%%%%%%%%%%%%%%%%%%LOAD GESTURE%%%%%%%%%%%%%%%%%%%%
gesturedata10 = double(data{1, 2}.time_series);
gesturedata8 = gesturedata10(2:9,:);
labels = data{1, 1}.time_series;  
%%%%%%%%%%%%%%%%%%%%%%%SEPERATE TRAIN DATA%%%%%%%%%%%%%%
%gesture_train = gesturedata8(:,1:0.75*length(gesturedata8));
%%%%%%%%%%%%%%%%%%%%%%%LOAD TIME STAMPS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gesture_time1 = data{1, 2}.time_stamps;
%gesture_time = gesture_time1(:,1:0.75*length(gesturedata8));
%%%%%%%%%%%%%%%%%LOAD KEYBOARD TIME STAMP%%%%%%%%%%%%%%%%%%%%%%%
keytimegesture = data{1, 1}.time_stamps;
%%%%%%%%%%%%%%PREPROCESS DATA%%%%%%%%%%%%%%%%%%%%%%%%%
[data_processed data_features feature_label] = preprocess_training_data(gesturedata8, gesture_time1, keytimegesture, sam_freq, labels);
train_data = dataset(data_features,feature_label);
train = dataset2table(train_data);
 
%%%%%%%%%%%%%%%%TRAINED MODEL%%%%%%%%%%%%%%%
C = trainClassifier(train);
%%%%%%%%%%%%%%%%TEST MODEL%%%%%%%%%%%%%%%%%%

%yfit = c.predictFcn(test_features);
 
%confusion_matrix = confusionmat(ground_test_features,yfit);
%accuracy = sum(diag(confusion_matrix))/sum(sum(confusion_matrix))
%figure,
%confusionchart(confusion_matrix);
disp('Loading the library...');
lib = lsl_loadlib();

% resolve a stream...
disp('Resolving an EMG stream...');
result = {};
while isempty(result)
    result = lsl_resolve_byprop(lib,'type','EMG'); end

% create a new inlet
disp('Opening an inlet...');
inlet = lsl_inlet(result{1});
a=[0 0 0 0 0 0 0 0 0 0];
d=zeros(1,32);

disp('Now receiving data...');
i=1;
while true
    % get data from the inlet
    [vec,ts] = inlet.pull_sample();
    % and display it
%     fprintf('%.2f\t',vec);
%     fprintf('%.5f\n',ts);
%  y = dsp.Buffer(200,1,vec)
    a =  [a
          vec];
    
    if(rem(i,200)==0)
        features_instant= preprocess_realtime_data(a(i-199:i,:));
        display(features_instant);
        %features_instant = dataset(features_instant1);
%        classinst= C.predictFcn(features_instant);
   %    classp=predict(C,features_instant);
    end
    i=i+1;
end
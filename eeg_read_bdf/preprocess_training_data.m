function [processed_data features data_label] = preprocess_training_data(data, gesture_time, key_time, sam_freq, label)
Ckey = ['C pressed'];
Lkey = ['L pressed'];
Okey = ['O pressed'];
Rkey = ['R pressed'];
Ukey = ['U pressed'];
Dkey = ['D pressed'];
meandata1 = mean(data(1,:));
meandata2 = mean(data(2,:));
meandata3 = mean(data(3,:));
meandata4 = mean(data(4,:));
meandata5 = mean(data(5,:));
meandata6 = mean(data(6,:));
meandata7 = mean(data(7,:));
meandata8 = mean(data(8,:));
data1 = data(1,:) - meandata1;
data2 = data(2,:) - meandata2; 
data3 = data(3,:) - meandata3;
data4 = data(4,:) - meandata4;
data5 = data(5,:) - meandata5;
data6 = data(6,:) - meandata6;
data7 = data(7,:) - meandata7;
data8 = data(8,:) - meandata8; %REMOVING DC COMPONENT
feature1=zeros(0,0);
feature2=zeros(0,0);
feature3=zeros(0,0);
feature4=zeros(0,0);
feature5=zeros(0,0);
feature6=zeros(0,0);
feature7=zeros(0,0);
feature8=zeros(0,0);
chunk_data1=zeros(0,0);
chunk_data2=zeros(0,0);
chunk_data3=zeros(0,0);
chunk_data4=zeros(0,0);
chunk_data5=zeros(0,0);
chunk_data6=zeros(0,0);
chunk_data7=zeros(0,0);
chunk_data8=zeros(0,0);
data_label = [];
data_points = length(key_time)-1;
j=1;
for i=2:2:data_points
    %%%%%%%%%DETERMINE GESTURE START TIME%%%%%%%%%
    [find_gesture_time] = round(gesture_time/10^3,5);
    find_key_start_time = round(key_time(i)/10^3,5);
    gesture_start_time = min(find(find_key_start_time == find_gesture_time));
    %%%%%%%%%DETERMINE GESTURE END TIME%%%%%%%%%%%%
    find_key_end_time = round(key_time(i+1)/10^3,5);
    gesture_end_time = max(find(find_key_end_time == find_gesture_time));
    %%%%%%%%%%%%%CHUNK DATA%%%%%%%%%%%%%%%%%%%%
    chunk_data1 = data1(1,gesture_start_time:gesture_end_time);
    chunk_data2 = data2(1,gesture_start_time:gesture_end_time);
    chunk_data3 = data3(1,gesture_start_time:gesture_end_time);
    chunk_data4 = data4(1,gesture_start_time:gesture_end_time);
    chunk_data5 = data5(1,gesture_start_time:gesture_end_time);
    chunk_data6 = data6(1,gesture_start_time:gesture_end_time);
    chunk_data7 = data7(1,gesture_start_time:gesture_end_time);
    chunk_data8 = data8(1,gesture_start_time:gesture_end_time);

    d = designfilt('bandstopiir','FilterOrder',2, ...
               'HalfPowerFrequency1',59,'HalfPowerFrequency2',61, ...
               'DesignMethod','butter','SampleRate',sam_freq);   
    %figure, freqz(d)
    chunk_data1_filter = filtfilt(d,chunk_data1);
    chunk_data2_filter = filtfilt(d,chunk_data2);
    chunk_data3_filter = filtfilt(d,chunk_data3);
    chunk_data4_filter = filtfilt(d,chunk_data4);
    chunk_data5_filter = filtfilt(d,chunk_data5);
    chunk_data6_filter = filtfilt(d,chunk_data6);
    chunk_data7_filter = filtfilt(d,chunk_data7);
    chunk_data8_filter = filtfilt(d,chunk_data8);

    tf_c = strcmp(label(1,i),Ckey);
    tf_l = strcmp(label(1,i),Lkey);
    tf_o = strcmp(label(1,i),Okey);
    tf_r = strcmp(label(1,i),Rkey);
    tf_u = strcmp(label(1,i),Ukey);
    tf_d = strcmp(label(1,i),Dkey);
    
    if tf_c == 1
        data_label(j,:) = 1;
        j=j+1;
    elseif tf_l == 1
        data_label(j,:) = 2;
        j=j+1;
    elseif tf_o == 1
        data_label(j,:) = 3;
        j=j+1;
    elseif tf_r == 1
        data_label(j,:) = 4;
        j=j+1;
    elseif tf_u == 1
        data_label(j,:) = 5;
        j=j+1;
    elseif tf_d == 1
        data_label(j,:) = 6;
        j=j+1;
    end
    %%%%%%%%%%%%%EXTRACT FEATURES%%%%%%%%%%%%%%%%%%%%%
    extract1 = extract(chunk_data1_filter);
    extract2 = extract(chunk_data2_filter);
    extract3 = extract(chunk_data3_filter);
    extract4 = extract(chunk_data4_filter);
    extract5 = extract(chunk_data5_filter);
    extract6 = extract(chunk_data6_filter);
    extract7 = extract(chunk_data7_filter);
    extract8 = extract(chunk_data8_filter);
    %%%%%%%%%%%%%%%APPEND FEATURES%%%%%%%%%%%%%%%%%%%%%
    feature1 = [feature1; extract1];
    feature2 = [feature2; extract2];
    feature3 = [feature3; extract3];
    feature4 = [feature4; extract4];
    feature5 = [feature5; extract5];
    feature6 = [feature6; extract6];
    feature7 = [feature7; extract7];
    feature8 = [feature8; extract8];
    end

processed_data = [chunk_data1; chunk_data2;chunk_data3;chunk_data4;chunk_data5;chunk_data6;chunk_data7;chunk_data8];
features = [feature1, feature2, feature3, feature4, feature5, feature6, feature7, feature8];

%features = normalize(features);

end
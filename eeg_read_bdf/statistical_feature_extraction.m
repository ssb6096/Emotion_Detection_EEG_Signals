function [mean_data, std_data] = statistical_feature_extraction(data)
l=size(data,2)

for i=1:1:l
    l1=size(data{i},2)
  for j=1:1:l1    
    mean_data(i,j) =mean(data{i}(:,j))
    std_data(i,j)= std(data{i}(:,j))
  end
end
function [max_data, min_data] = max_min(data)
l=size(data,2)

for i=1:1:l
    l1=size(data{i},2)
  for j=1:1:l1    
    max_data(i,j) =max(data{i}(:,j))
    min_data(i,j)= min(data{i}(:,j))
  end
end
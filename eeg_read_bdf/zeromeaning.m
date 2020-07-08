function zero_meaned_data = zeromeaning(data_chunk)

l=size(data_chunk,2)

for i=1:1:l
    l1=size(data_chunk{i},2)
  for j=1:1:l1    
 mean_data(i,j) =mean(data_chunk{i}(:,j))
 zero_meaned_data{i}(:,j) = data_chunk{i}(:,j) - mean_data(i,j);
end
end
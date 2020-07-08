function features = extract(data)
l=size(data,2)

for i=1:1:l
    datachunk=data{i}
    %output_length = length(datachunk);
    output_mean = mean(datachunk,1);
    output_SD = std(datachunk,1);
    output_max = max(datachunk,[],1);
    output_min = min(datachunk,[],1);
    output_var=var(datachunk,1);
    sk=skewness(datachunk,1);
    k=kurtosis(datachunk,1);
    mav=mad(datachunk,1);
    %Simple Squared Integral
    ssi = sum((datachunk).^2,1);
   %Slope Sign change
   for j=1:1:size(datachunk,2)
       summ=0;
    for counter = 2:1:length(datachunk)-1
        if ((datachunk(counter)-datachunk(counter-1)*(datachunk(counter)-datachunk(counter+1)))>0)
        a=1;
        else 
        a=0;
        end
        summ = summ+a;
    end
    ssc(j)=summ;
    end

% %Willison Amplitude
 for j=1:1:size(datachunk,2)
     sum1=0
     for l = 1:1:(length(datachunk)-1)
         if (abs(datachunk(l)-datachunk(l+1))>0)
         a=1;
         else 
         a=0;
         end
         sum1 = sum1 +a;
     end
         wamp(j)=sum1 
     end
    %log Detector
    logan = exp(((1/length(datachunk)).*sum(log(abs(datachunk)))));
    sum_first=zeros(1,size(datachunk,2));
    sum_second=zeros(1,size(datachunk,2));
    sum_first_norm=zeros(1,size(datachunk,2));
    sum_second_norm=zeros(1,size(datachunk,2));
    for len=1:1:(length(datachunk)-1)
        sum_first(1,:)=sum_first(1,:)+abs(datachunk(len+1,:)-datachunk(len,:));
        sum_first_norm(1,:)=sum_first_norm(1,:)+abs(norm(datachunk(len+1,:))-norm(datachunk(len,:)));
    end 
    for len=1:1:(length(datachunk)-2)
        sum_second(1,:)=sum_second(1,:)+abs(datachunk(len+2,:)-datachunk(len,:));
        sum_second_norm(1,:)=sum_second_norm(1,:)+abs(norm(datachunk(len+2,:))-norm(datachunk(len,:)));
    end 
        
    features(i,:) = [output_mean output_SD output_max output_min output_var sk k ssi ssc wamp mav output_var logan sum_first/(len-1) sum_first_norm/(len-1) sum_second/(len-2) sum_second_norm/(len-2)]; 
end

end
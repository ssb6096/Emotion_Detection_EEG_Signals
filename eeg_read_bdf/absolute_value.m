    function abs_value=absolute_value(zero_meaned_data_f)
    l=length(zero_meaned_data_f)
    for i=1:1:l   
    x=zero_meaned_data_f{i};
    x1 =abs(x)
    abs_value{i}=x1  
    end 
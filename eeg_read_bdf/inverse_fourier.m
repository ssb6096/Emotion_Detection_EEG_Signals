function frequency_d_data = inverse_fourier(data_chunk)
    
    l=size(data_chunk,2)

    for i=1:1:l

        frequency_d_data{i}=ifft(data_chunk{i})
        
     end
end
function frequency_d_data = fourier_transform(data_chunk)
    
    l=size(data_chunk,2)

    for i=1:1:l

        frequency_d_data{i}=fft(data_chunk{i})
        
     end
end
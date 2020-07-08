function features = Spectral_Features_Extract(data,f)
% Peak amplitude — Generate a feature based on the amplitude of the peaks.
% 
% Peak frequency — Generate a feature based on the frequency of the peaks.
% 
% Peak value lower threshold — Constrain peak size to exclude low-amplitude peaks. For more information, in findpeaks, see the MinPeakHeight name-value pair argument.
% 
% Number of peaks — Number of peaks to generate features for. The software selects N most prominent peaks in the chosen frequency band, going in the descending amplitude order. For more information, in findpeaks, see the NPeaks name-value pair argument.
% 
% Minimum frequency gap — Specify a minimum frequency gap. If the gap between two peaks is less than this specification, the software ignores the smaller peak of the pair. For more information, in findpeaks, see the MinPeakDistance name-value pair argument.
% 
% Peak excursion tolerance — Specify the minimum prominence of a peak. The prominence of a peak measures how much the peak stands out due to its intrinsic height and its location relative to other peaks. For more information, in findpeaks, see the MinPeakProminence name-value pair argument.
%Spectral moments
    %Spectral Centroid
    features=[]
    for len=1:1:length(data)
    X=data{len}
    %f=length(X)
    %X = obw(x);
    Spec_centroid(1,:) = mean(spectralCentroid(abs(X),f),1)
    Spec_skewness(1,:) =  mean(spectralSkewness(abs(X),f),1)
    %sampled at rate or time interval sampx.
    for colmn=1:1:size(X,2)
    Spec_kurt(1,:) =mean(pkurtosis(abs(X(:,colmn)),f),1)
    crest(1,:) = mean(spectralCrest(abs(X),f),1)
    end
    
    slope(1,:) = mean(spectralSlope(abs(X),f),1)
    decrease(1,:) =mean(spectralDecrease(abs(X),f),1) 
    flux(1,:) = mean(spectralFlux(abs(X),f),1)
    
    features(len,:)=[Spec_centroid Spec_skewness Spec_kurt  crest slope decrease flux]
    end
end
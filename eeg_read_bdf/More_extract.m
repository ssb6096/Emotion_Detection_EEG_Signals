function features = More_extract(data)
s=[]
crr1=[]
crr2=[]
c=[]
for i=1:1:length(data)
X =data{i};
T='shannon';
E1(i) = wentropy(X,T);
T='log energy';
E2(i) = wentropy(X,T);
T='norm';
E3(i) = wentropy(X,T,1.1);
s =[s svd(X)]
%R2 = corrcoef(X)
%crr = xcorr2(X)
Corr2 =[]
Corr1=[]
c_dia=[]
for col = 1 : size(X,2)
	thisColumn = X(:, col);
    corr1=autocorr(thisColumn, 'NumLags', 1)
	% Call your custom-written function, autocorr().
	corr2 =  autocorr(thisColumn, 'NumLags', 2)
    corr1=corr1'
    corr2=corr2'
    Corr2=[Corr2 corr2]
    Corr1=[Corr1 corr1]
	% Now do something with someOutput.
end
crr2 =[crr2;Corr2] 
crr1 =[crr1;Corr1] 
c=cov(X)
c_diagonal =diag(c)
c_diagonal=c_diagonal'
c_dia(i,:)=c_diagonal
end 

s=s'
%ERP Features
    p100(i,:)=max(X(81:123,:),[],1)
    n100(i,:)=min(X(81:123,:),[],1)
    p200(i,:)=max(X(153:282,:),[],1)
    n200(i,:)=max(X(153:282,:),[],1)
    p300(i,:)=max(X(281:512,:),[],1)
    
features=[c_dia crr1 crr2 s E1' E2' E3' p100 n100 p200 n200 p300]
end
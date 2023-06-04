function B=Retrieve_Corr_seg (Nuc,L)
Len=length(unique(L));
  B=zeros(size(L));
  
for i=2:Len
B=(L==i);  
st = regionprops(B);
if length(st)>=1
    
N=and(Nuc==1,B==1) ;
NuNum=length(unique(bwlabel(N,8)))-1;

if NuNum==1
    i=Len;
    break;
end
end
end
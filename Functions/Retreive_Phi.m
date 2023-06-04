function Phi=Retreive_Phi(test_img,pts,Outedges_cell,x)

pts(:,1)=round(pts(:,1));
pts(:,2)=round(pts(:,2));

[M N]=size(test_img);
Phi=zeros(M,N);

for i=1:size(pts,1)
    if pts(i,1)<=0 pts(i,1)=1; end
    if pts(i,2)<=0 pts(i,2)=1; end
    if pts(i,1)>M pts(i,1)=M; end
    if pts(i,2)>N pts(i,2)=N; end
Phi(pts(i,1),pts(i,2))=1;
end

Phi = imclose(Phi,strel('disk',10));
Phi = imdilate(Phi, strel('disk',2));
if x==1 Phi=or(Outedges_cell,Phi); end
Phi=imfill(Phi,'holes');

Phi=Check_Cytoplasm(Phi);
CC = bwconncomp(Phi);
Cell_num=CC.NumObjects;

if Cell_num<1 
  [X Y] = find(Phi==1);
  Phi = bwconvhull(Phi, 'Union');
else 
  Phi = imerode(Phi,strel('disk',2)); end
end
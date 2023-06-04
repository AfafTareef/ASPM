function [BW,found,Roundness,ECC,A]=Check_Cytoplasm (BW)

thr.minCellSize=2000;
%/////////////////////////////////////////////////////////////////

lblimage=bwlabel(BW,8);
Cell_num=length(unique(lblimage))-1;


for i=1:Cell_num
    
 CBW=(lblimage==i); ID=CBW; 
 st = regionprops( CBW, 'Area', 'PixelIdxList','Eccentricity','ConvexHull','Perimeter');
 Roundness=(4*st(1).Area*pi)/st(1).Perimeter.^2;
 ECC=double(st(1).Eccentricity);


    if Roundness>=0.4 && Roundness<1 && st(1).Area >= thr.minCellSize && ECC<0.90
       CBW(st(1).PixelIdxList)=1;
    else
        CBW(st(1).PixelIdxList)=0;
    end
   
end
BW(ID)=CBW(ID);


%/////////////////////////////////////////////////////////////////

st = regionprops( BW, 'Area', 'PixelIdxList','Eccentricity','ConvexHull','Perimeter');
if length(st)>=1
found=1;
else
found=0;
end
end
 function [BW,found]=Check_size (BW,Hmin,Hmax)
st = regionprops( BW, 'Area', 'PixelIdxList','Eccentricity','ConvexHull','Perimeter');
le=length(st);

if le>=1
for idx=1:length(st)
 ECC=double(st(idx).Eccentricity);
 if (st(idx).Area >Hmin || st(idx).Area <Hmax)&& ECC<0.90
       found=1;
   else
      found=0;
 end   
   
end

else
found=0;
end
 end
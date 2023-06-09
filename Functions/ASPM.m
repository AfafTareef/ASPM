function seg=ASPM(test_img, Map, Out_it,In_it,cell_dmtr,Smin,Smax)

vis=1;                                           % 1 to display results
BK=Map==255; Nu=Map==0; Nu=logical(Nu);Clump=~BK;   % Read Clusters map
%+-------------------------------------------------+
%|              PRE-PROCESSING STEP                |
%+-------------------------------------------------+
FG=imclose(Clump,strel('disk',2));
FG=imclearborder(FG,8);
BK=~FG;
Outedges=edge(BK,'sobel'); Outedges=imdilate(Outedges,strel('disk',1)); Outedges(BK)=0;
edges=Outedges;
edges(BK)=0; edges(Outedges)=1;
edges = imdilate(edges,strel('disk',2));
Region=~edges;

%+-------------------------------------------------+
%|             SHAPE-BASED MODELLING               |
%+-------------------------------------------------+
seg=[];
count=1;
Nu_lbl=bwlabel(Nu,8);
cell_lbl=bwlabel(Region,8);
Nu_num=length(unique(Nu_lbl))-1;

for i=1:Nu_num      % Loop for each nucleus
%+---------------------------------------------------+
%| ---------- Find INDIVIDUAL Cytoplasm  ----------- |
%+---------------------------------------------------+
h=[];   
CNu=(Nu_lbl==i);  

D = round(bwdist(CNu));
ROI=(D<=(cell_dmtr));

% This step is useful in case of existance of isolated cell where the rest of steps are not required, 
% or when using initial segmentation, so this function retrieve 
% the corresponding cell for each nucleus
Cell=Retrieve_Corr_seg (CNu,cell_lbl); 
initBW=and(Cell,ROI);
Outedges_cell=and(Outedges,ROI); 

%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Cell(Outedges)=1;  Cell(~initBW)=0; Cell=imfill(Cell,'holes');
Cell(BK)=0; 

if vis==1 figure,imshow(test_img), hold on, contour(Outedges,'k'); end

for k=1:Out_it     
 Cell=Shape_Deformation(Cell,test_img,vis,CNu,cell_dmtr,Outedges_cell, In_it,h);
  Cell(BK)=0; Cell(~initBW)=0;
end   

Cell=Check_size (Cell,Smin,Smax); 
seg{count,1}=Cell; count=count+1;
end

end


function BW=Shape_Deformation(Cell,test_img,vis,CNu,MaxD,Outedges,it,Outedges_cell,h) 

STEpts=[];
InputShape=[];

% upload the reference shape which is semi-elliptical shape here. Instead,
% learning shape reference or ellipse-fitting function can be used 
% to generate a reference shape.
load('Data\Ref_Shape.mat');

% Get the nucleus center 
STATS = regionprops(CNu, 'Centroid');
cen=STATS.Centroid;
y0=round(cen(1));
x0=round(cen(2)); 
Pre_D=MaxD;

% Get the iteratively update detailed edge
edges=edge(Cell,'sobel');

%--------------------------------------------------------------------------
% Loop until finding the first outer edge points in order to strat generating 
% the input shape from feature points to get more accurate shape establishment

for th1=1:1:360
    th= degtorad(th1);    
    x1 = ((MaxD* -cos(th) + x0));
    y1 = ((MaxD* sin(th) + y0));
    [X_line,Y_line]=fillline(x0,y0, x1,y1, MaxD);
    X_OP=[floor(X_line) ceil(X_line)];
    Y_OP=[floor(Y_line) ceil(Y_line)];
    [X,Y]=Check_edge_Pts(X_OP,Y_OP,edges)
    if length(X)~=0 break; end
end

% Now, start input shape prediction process
for th2=th1:(th1+359)
    th= degtorad(th2);    
    x1 = ((MaxD* -cos(th) + x0));
    y1 = ((MaxD* sin(th) + y0));
    if th2==th1 xp=x1;yp=y1;  end

 [x,y,Pre_D]=Get_points(edges,x0,y0, x1,y1, xp,yp,th,Pre_D,MaxD,vis);
 InputShape=[InputShape;x y];

% Save the coordinates of feature points (if exist)
if Outedges(x,y)==1 
STEpts=[STEpts;x y];
xp=x; yp=y;
if vis==1     h=plot(y,x,'r.'); drawnow('expose');     end 
end
end 
OutputShape=InputShape;

% Save the index of feature points in the established input shape
try
[~,STE_indx]=ismember(STEpts,InputShape,'rows');
catch
    STE_indx=[];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:it

% This transform is based on a reference shape; You can give more priority
% to this transform if the shape of cells is uniform
% Reference-based deformation is performed in two steps: 
% first, the input shape is transferred to match reference shape, 
% then, the resulted shape is transformed back to the input shape domain.
[d1,AlignedShape,Transform] = procrustes(referenceShape,InputShape);
% Transform the modifeied shape points to the domain of input cell shape
AlignedShape=Domain_Transform(AlignedShape,Transform);

% This transform is based on the input points extracted based on cell
% contour. You can give more weight to this transform is the cell is
% touched or slightly overlapped, where the number of contour points is adequate
[d2,AlignedShape]=procrustes(AlignedShape,InputShape); 

% To keep the coordinates of feature points (if exist) after each
% point transformation
try OutputShape(STE_indx,:)=InputShape(STE_indx,:);  end

% Smooth points by low-pass moving average filter 
OutputShape(:,1) = smooth(OutputShape(:,1));
OutputShape(:,2) = smooth(OutputShape(:,2));
try OutputShape(STE_indx,:)=InputShape(STE_indx,:); end

% Build the mask from the points coordinates
BW1=Retreive_Phi(test_img,OutputShape,Outedges_cell,1);
BW2=Retreive_Phi(test_img,AlignedShape,Outedges_cell,2);
BW=or(BW1,BW2);

if vis==1 
    if(ishandle(h)); delete(h); end
        h=plot(OutputShape(:,2),OutputShape(:,1),'r.'), title('Shape Deformation'), drawnow('expose'); 
end
end
end

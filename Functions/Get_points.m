function [x,y,minD]=Get_points(edges,x0,y0, x1,y1, xp,yp,th,Pre_D,MaxD,vis)

[M N]=size(edges);
[X_line,Y_line]=fillline(x0,y0, x1,y1, MaxD);

x_l=floor(X_line);
y_l=floor(Y_line);
x_h=ceil(X_line);
y_h=ceil(Y_line);

%%%%%%%%%%%%%%%% CHECK EDGE POINTS IF EXIST %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Only one points is retrieved at each angle, so, guaranteeing a one-to-one
% landmark correspondence between input and reference shape

[X Y]=Check_edge_Pts(x_l,y_l,edges);

if length(X)==0
[X Y]=Check_edge_Pts(x_h,y_h,edges);
end

if length(X)==0 
[X Y]= Fill_missed_pts(x0,y0,xp, yp,1,M,N); 
end
 
 X=round(X);
 Y=round(Y);
 [x, y,minD]=Checknearest(X, Y,x0,y0);

try
 Str_pts=edges(x,y)==1 || edges(x+1,y)==1 || edges(x-1,y)==1 || edges(x,y+1)==1 || edges(x,y-1)==1 || edges(x+1,y+1)==1 || edges(x-1,y-1)==1;
catch
 Str_pts=edges(x,y)==1;
end
 if ~Str_pts || (minD-Pre_D)>10
     minD=Pre_D;
     x = ((minD* -cos(th) + x0));
     y = ((minD* sin(th) + y0));
   if vis==1 h=plot(y, x, 'c.'); drawnow('expose'); end  

 end

 x=round(x);
 y=round(y);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

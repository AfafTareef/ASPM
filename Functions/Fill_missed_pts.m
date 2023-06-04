function [x_rot, y_rot]= Fill_missed_pts(x0,y0,xp,yp,th,M,N)

pts = [xp;yp];
center = [x0; y0];

% define a counter-clockwise rotation matrix
R = [cos(th) -sin(th); sin(th) cos(th)];
s = pts - center;   
so = R*s;          
vo = so + center;  

x_rot = vo(1,:);
y_rot = vo(2,:);

if x_rot <1 x_rot=1; end
if x_rot >M x_rot=M; end
if y_rot <1 y_rot=1; end
if y_rot >N y_rot=N; end
end
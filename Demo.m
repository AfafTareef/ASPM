function Demo

warning off;
addpath Functions;

load('Data\TestIm.mat');
load('Data\Clusters.mat');

clc;
close all;
ImNum=1;            
test_img=TestIm{ImNum};
Map=Clusters{ImNum};
%+-------------------------------------------------+
%|           PARAMETERS CONFIGURATION              |
%+-------------------------------------------------+       
Out_it=5;In_it=10;           % deformation iterations
cell_dmtr=100;               % Maximum cell diameter
Smin = 4000; Smax = 25000;  % Range of Cell size
col=['r','b','k','g','m','c'];

%+-------------------------------------------------+
%|          ADAPTIVE SHAPE PREDICTION MODEL        |
%+-------------------------------------------------+
seg=ASPM(test_img, Map, Out_it,In_it,cell_dmtr,Smin,Smax);
 
%+----------------------------------------------------+
%| ---------- DISPLAY FINAL SEGMENTATION  ----------- |
%+----------------------------------------------------+

figure,imshow(test_img),title('Our segmentation'),hold on,

for i=1:size(seg,1) 
j=i; if j>length(col) j=randi([1, length(col)],1,1);   end 
contour(seg{i,1},col(i),'LineWidth',1.5);
end
end


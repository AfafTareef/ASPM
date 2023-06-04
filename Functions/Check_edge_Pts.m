function [X,Y]=Check_edge_Pts(x,y,edges)

[M N]=size(edges);
Phi=zeros(size(edges));
    for j=1:length(x)
        if x(j)<=0 || x(j)>=M || y(j)<=0 || y(j)>=M 
           if x(j)<=0 x(j)=1; end
           if x(j)>M  x(j)=M; end
           if y(j)<=0 y(j)=1; end
           if y(j)>M  y(j)=M; end
        end
      Phi(x(j),y(j))=1;
    end
    
 Map=and(Phi==1,edges==1);
[X Y]=find(Map==1);
end
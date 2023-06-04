function [Lx, Ly,mind]=Checknearest(LM_x,LM_y,x0,y0)

K=length(LM_x);
dis=zeros(K,1);

for i=1:K
X = [x0 y0;LM_x(i) LM_y(i)];
dis(i) = pdist(X,'euclidean');
end

mind=min(dis);
id=find(dis==mind);
id=id(1);
Lx=LM_x(id);
Ly=LM_y(id);
end
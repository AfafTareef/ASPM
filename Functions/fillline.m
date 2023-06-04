
function [xx,yy,L]=fillline(x0,y0, x1,y1, pts)
        m=(y1-y0)/(x1-x0); %gradient 
L=0;
        if m==Inf %vertical line
            xx(1:pts)=(x0);
            yy(1:pts)=(linspace(y0,y1,pts));
            L=1;
        elseif m==0 %horizontal line
            xx(1:pts)=(linspace(x0,x1,pts));
            yy(1:pts)=y0;
             L=2;
        else %if (endp(1)-startp(1))~=0
            xx=(linspace(x0,x1,pts));
            yy=(m*(xx-x0)+y0);
            if isnan(yy) yy(1:pts)=y0; end
            L=3;
        end
        
       
end

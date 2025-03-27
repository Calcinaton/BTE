function [f] = Saeman_equation(theta,omega,fdr,R,h,B)
%THETA IS FRICTION
  f = 1.5*tand(theta)/omega*fdr*(R^2-(h-R)^2)^(-1.5) - tand(B)/cosd(theta);
  
end  


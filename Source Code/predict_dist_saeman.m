function [Temperature,std_old] =  predict_dist_saeman(Tw,To,T,tau,phi,phi_old,dt,handles,std_old,i,length_x)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%cla(handles.axes2,'reset')
%bin_size = 5;
   
  delta_T = Tw - T(2);
  Tave = Tw - exp(-dt/tau)*(delta_T);
  
  std_T = std_old/(phi_old)^(-1/3)*((phi_old+phi)/2)^(-1/3)*exp(-dt/tau);
  
  %std_T = 42*phi^(-1/3)*exp(-dt/tau);

  B = Tave + sqrt(3)*std_T;
  A = 2*Tave - B;

%  A = A - bin_size/2;
    if ( A<To);
       A = To;
    end
%    B = B + bin_size/2.0;
    if ( B >Tw);
       B = Tw;
    end
    
    %plot temperature
%    TimeT(count_t) = t;
%    Distance(count_t) = t*Uax;
    Temperature(1:3) = [A, Tave, B];
    std_old = std_T;

%{
    %pause(5)   
   hold on;
   if (Uax == 0)
       plot(handles.axes2,TimeT,Temperature(1,:),'-b')
       plot(handles.axes2,TimeT,Temperature(2,:),'-k')
       plot(handles.axes2,TimeT,Temperature(3,:),'-r')
       set(handles.axes2,'box','on');
   else
       plot(handles.axes2,Distance,Temperature(1,:),'-b')
       plot(handles.axes2,Distance,Temperature(2,:),'-k')
       plot(handles.axes2,Distance,Temperature(3,:),'-r')
       set(handles.axes2,'box','on');       
   end
%}
 
   



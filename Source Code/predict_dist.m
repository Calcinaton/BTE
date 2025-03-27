function [TimeT,Temperature,Distance] =  predict_dist(Tw,To,delta_T,tau,phi,n,handles,Uax)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

global figure_Ttime
global table_pop

bin_size = 5;
Tmax = n;
count_t = 0;
%TimeT(count_t) = 0;
%Temperature(1:3,count_t) = [A, Tave, B];
    
for t = 0.000:Tmax/100:Tmax
    count_t = count_t +1;
    Tave = Tw - exp(-t/tau)*(delta_T);
    std_T = 42*phi^(-1/3)*exp(-t/tau);

    B = Tave + sqrt(3)*std_T;
    A = 2*Tave - B;

    A = A - bin_size/2;
    if ( A<To);
       A = To;
    end
    B = B + bin_size/2.0;
    if ( B >Tw);
       B = Tw;
    end

    %plot(pdf)
    %{
    pd2 = makedist('Uniform','lower',A,'upper',B);
    xx = [275:bin_size:600];

    pdf2 = pdf(pd2,xx);
    set(handles.axes2,'XScale','linear','YScale','linear');
    stairs(handles.axes2,xx,pdf2,'-r','LineWidth',2);
    %}
    
    %plot temperature
    TimeT(count_t) = t;
    Distance(count_t) = t*Uax;
    Temperature(1:3,count_t) = [A, Tave, B];
end    
    %pause(5)   

   if (Uax == 0 || isempty(str2num(get(handles.Velocity,'String'))))
       cla(handles.axes2,'reset')
       hold on;
       plot(handles.axes2,TimeT,Temperature(1,:),'-b')
       plot(handles.axes2,TimeT,Temperature(2,:),'-k')
       plot(handles.axes2,TimeT,Temperature(3,:),'-r')
       set(handles.axes2,'box','on');
   else
       str = get(handles.VelocityChoice,'String');
       val = get(handles.VelocityChoice,'Value');
       if (~strcmp(str{val},'Saeman Model'))
           cla(handles.axes2,'reset')
           hold on;
           plot(handles.axes2,Distance,Temperature(1,:),'-b')
           plot(handles.axes2,Distance,Temperature(2,:),'-k')
           plot(handles.axes2,Distance,Temperature(3,:),'-r')
           set(handles.axes2,'box','on');     
       end
   end

    
%{
if(~ishandle(figure_Ttime))
    figure_Ttime = figure
    hold on;
    plot(TimeT,Temperature(1,:),'-b')
    plot(TimeT,Temperature(2,:),'-k')
    plot(TimeT,Temperature(3,:),'-r')      
    
elseif(ishandle(figure_Ttime))
    figure(figure_Ttime)
    cla;
    hold on;
    plot(TimeT,Temperature(1,:),'-b')
    plot(TimeT,Temperature(2,:),'-k')
    plot(TimeT,Temperature(3,:),'-r')    
    
end   
%}

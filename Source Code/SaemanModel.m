function SaemanModel(B,friction,omega,R,fdr,d,L,handles)
%%% Saeman model
%function []= SeamanModel(incline_angle,friction_angle,w,D/2,feed_rate_v,particle_d,L);

global figure_profile;

eps = 0.00001;
dx = 0.001;
x = 0:dx:L;
length_x = length(x);

%h is the fill level
h = zeros(size(x));
hdam = d;
h(1) = hdam;

%OMEGA IN RADIANS PER SECOND
%R IN METERS
%FDR = M^3/S
%FRICTION IN DEGREES
for i=2:length_x
    [f] = Saeman_equation(friction,omega,fdr,R,h(i-1),B);
    h(i) = h(i-1) +  f*dx;
    
    [f2] = Saeman_equation(friction,omega,fdr,R,h(i),B);
    h(i) = h(i-1) +  0.5*(f+f2)*dx;  
    
    if ((f+f2)*0.5 < eps)
      break;
    end    
end

if (i<length_x)
  h_const = h(i);   
  h(i+1:length_x)= h_const;
end

%THETA IN RADIANS (FILL LEVEL)
theta = 2*acos(1-h./R);

for i=1:length_x-1
    volume(i) = R^2/2*(theta(i+1) - sin(theta(i+1)))*dx;    
end    

D = 2*R;
Tw = get(handles.Wall_Temperature,'string');
     %temperature of wall in K
Tw = str2double(Tw);

To = get(handles.Initial_Temperature,'string');
     %initial temperature in K
To = str2double(To);
    
 %Tw = 578;
delta_T = Tw - To;

tau_p = get(handles.tau_p,'string') ;
tau_p = str2double(tau_p);

comp_tp = get(handles.calc_phi,'Value');
if(comp_tp ==1)
  %if (handles.calc_phi.Value==1)
  density = get(handles.density,'string') ;
  density = str2double(density); 
      
  k = get(handles.conductivity,'string') ;
  k = str2double(k); 
       
  cp = get(handles.heatCapacity,'string') ;
  cp = str2double(cp);
       
  E = get(handles.YoungsModulus,'string') ;
  %E in GPa
  E = str2double(E);
  E = E*1000000000;
       
  nu = get(handles.Poissons,'string') ;
  nu = str2double(nu); 
       
  Estar = E/2/(1-nu^2);
      
  %correct this later.
  tau_p = density^(2/3)*d^(5/3)*Estar^(1/3)*cp/k;     
  set(handles.tau_p,'String',num2str(tau_p));
end

Temperature = zeros(length_x,3);
%[Tmin, Tave, Tmax];
Temperature(length_x,:) = To;

Distance = zeros(length_x,1);
Distance(length_x) = L;
A = (D/2)^2*(theta(length_x) - sin(theta(length_x)));
Ap = pi/4*d^2;
tau_c = (theta(length_x)/omega);     
phi_old = tau_p/tau_c;
  
tau_old = 0.21*(A/Ap)^(2/3)*phi_old^(0.88)*tau_c;
std_old = 42*phi_old^(-1/3);

for i=length_x-1:-1:1;
     
    A = (D/2)^2*(theta(i) - sin(theta(i)));
    Ap = pi/4*d^2;
 
    tau_c = (theta(i)/omega);     
    phi = tau_p/tau_c;
    
    tau = 0.21*(A/Ap)^(2/3)*phi^(0.88)*tau_c;
         
    volume = A*dx;
    dt = volume/fdr; 
    
    Distance(i) = dx*i;
    
    [Temperature(i,:),std_old] =  predict_dist_saeman(Tw,To,Temperature(i+1,:),tau,phi,phi_old,dt,handles,std_old,i,length_x-1);
    phi_old = phi;
end  

%Temperature
%Distance
cla(handles.axes2,'reset')
hold on;
plot(handles.axes2,L-Distance,Temperature(:,1),'-b')
plot(handles.axes2,L-Distance,Temperature(:,2),'-k')
plot(handles.axes2,L-Distance,Temperature(:,3),'-r')
set(handles.axes2,'box','on');     

%figure;
%h_saeman=plot(dx*(length_x-1:-1:0),Temperature(:,1),'b');
%hold on;
%plot(dx*(length_x-1:-1:0),Temperature(:,2),'k');
%plot(dx*(length_x-1:-1:0),Temperature(:,3),'r');

for i=1:length_x
    for j=1:2
        xx(i,j)=dx*(i-1); %x(i);
        yy(i,j)=h(i)*(j-1);
        zz(i,j)=Temperature(i,2);
    end
end

if(~ishandle(figure_profile))
    figure_profile = figure;
    set(figure_profile,'MenuBar','none','NumberTitle','off','Name','Saeman''s Model Profile','Color','w')
    surf(xx,yy,zz,'EdgeColor','none')
    caxis([To Tw])
    %colormap(flipud(colormap))
    colormap jet;
    colorbar;
    xlabel('L (m)','FontSize',12)
    ylabel('h (m)','FontSize',12)
    set(gca,'FontSize',12)
    box on;
    %zlabel('z')
    view(2)
    
elseif(ishandle(figure_profile))
    figure(figure_profile);
    cla;
    surf(xx,yy,zz,'EdgeColor','none')
    caxis([To Tw])
    %colormap(flipud(colormap))
    colormap jet;
    colorbar;
    xlabel('L (m)','FontSize',12)
    ylabel('h (m)','FontSize',12)
    set(gca,'FontSize',12)
    box on;
    %zlabel('z')
    view(2)
end   

%}
%figure;
%h_saeman=plot(dx*(0:length_x-1),theta*180/pi,'b');

%}


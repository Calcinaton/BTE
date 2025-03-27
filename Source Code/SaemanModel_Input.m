%Saeman Model input

%theta = repose angle in degrees
theta = 32.0; %37.0;  %8.659; %21

%density of bulk kg/m^3
rho = 790.0; %763.36;   %800;

%omega = speed of rotation (rpm)
omega = 2.0; %3.5;

  %in rad/s
  omega = omega*2*pi/60;

%fdr = volumetric feed rate ccm/min
fdr = 100.0; %240.0; %48.9;  %11.2; %46.04; %75; 

%in m^3/s
fdr = fdr/100^3/60;

%R = radius of drum  (m)
R = 0.0682625;
%0.0508;   %0.0508 %0.075;

%L = length of drum in m
L = 3.048; %2.286; %/2.0;   %0.4572*2;     %1.5;

%B = inclination angle in degrees
B = 2.0;     %2.5;

%hdam = boundary condition at x = 0 in meters
hdam =  0.01; %0.00008;   %.002; 

%integration length (m)
dx = 0.00011;
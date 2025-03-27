function Uax =  compute_velocity(handles,mymode)

str = get(handles.VelocityChoice,'String');
val = get(handles.VelocityChoice,'Value');

switch str{val};
  case 'Ignore Flow' 
      Uax = 0;
      
      %set(handles.Velocity,'String',num2str(Uax));

  case 'Plug Flow (input u)'
      Uax = get(handles.Velocity,'string');
      Uax = str2num(Uax);
      if (Uax <= 0)
        uiwait(errordlg('Uax must be $>=$ 0. Uax is set to 1.0 m/s.','Value Error', mymode));
        Uax = 1.0;
        set(handles.Velocity,'String',num2str(Uax));
      end 
      
  case 'Sullivan Model'
       
      incline_angle = get(handles.incline,'string');
      incline_angle = str2num(incline_angle);
      
      if (incline_angle <= 0)
        uiwait(errordlg('Incline angle must be $>$ 0. Incline angle is set to 1.0 degree.','Value Error', mymode));
        incline_angle = 1.0;
        set(handles.incline,'String',num2str(incline_angle));
      end 
            
      friction_angle = get(handles.friction,'string');
      friction_angle = str2num(friction_angle);
      if (friction_angle <= 0)
        uiwait(errordlg('Friction angle must be $>$ 0. Friction angle is set to 1.0 degree.','Value Error', mymode));
        friction_angle = 1.0;
        set(handles.friction,'String',num2str(friction_angle));
      end 
      
      
      w = get(handles.w,'string');
      %w in rpm; for Sullivan model
      w = str2double(w);
      %w = w*2*pi/60;
      
      if (w <= 0)
        uiwait(errordlg('$\omega$ must be $>$ 0. $\omega$ is set to 1 rpm.','Value Error', mymode));
        w = 1.0;
        set(handles.w,'String',num2str(w));
      end 
      
      D = get(handles.DrumDiameter,'string') ;
      D = str2double(D);
      if (D <= 0)
        uiwait(errordlg('$D$ must be $>$ 0. $D$ is set to 1 m.','Value Error', mymode));
        D = 1.0;
        set(handles.DrumDiameter,'String',num2str(D));
      end
            
      Uax = incline_angle*w*D/(1.77*sqrt(friction_angle));
      Uax = Uax/60;   %convert from m/min to m/sec
      set(handles.Velocity,'string',num2str(Uax));
      
      feed_rate = get(handles.feed_rate,'string');
      feed_rate = str2double(feed_rate);
      if (feed_rate <= 0)
        uiwait(errordlg('Feed rate must be $>$ 0. Feed rate is set to 100 kg/hr.','Value Error', mymode));
        feed_rate = 100.0;
        set(handles.feed_rate,'String',num2str(feed_rate));
      end
                 
      bulk_density = get(handles.bulk_density,'string');
      bulk_density = str2double(bulk_density);
      if (bulk_density <= 0)
        uiwait(errordlg('Bulk density must be $>$ 0. Bulk density is set to 1000 kg/cu.m.','Value Error', mymode));
        bulk_density = 1000.0;
        set(handles.bulk_density,'String',num2str(bulk_density));
      end
      
      feed_rate_v = feed_rate/3600/bulk_density; %m^3 per second
      
      FL = feed_rate_v/(Uax*D^2*pi/4);
      FL = FL*100;
      set(handles.fill_level,'string',num2str(FL));
      
      theta = 4.0*(FL/100)^0.38; 
      theta = theta*180/pi;
      set(handles.theta,'String',num2str(theta))

  case 'Saeman Model'
      %Saeman Model is for future use only
      incline_angle = get(handles.incline,'string');
      incline_angle = str2num(incline_angle);
      
      friction_angle = get(handles.friction,'string');
      friction_angle = str2num(friction_angle);
      
      w = get(handles.w,'string');
      %w in rpm;
      w = str2double(w);
      w = w*2*pi/60;
      
      D = get(handles.DrumDiameter,'string') ;
      D = str2double(D);
      
      feed_rate = get(handles.feed_rate,'string');
      feed_rate = str2double(feed_rate);
      
      bulk_density = get(handles.bulk_density,'string');
      bulk_density = str2double(bulk_density);
      
      feed_rate_v = feed_rate/3600/bulk_density;
    
      particle_d = get(handles.particle_d,'string') ;
      %d in mm
      particle_d = str2double(particle_d);
      particle_d = particle_d/1000;
      
      L = get(handles.calciner_length,'string');
      L = str2double(L);
      
      SaemanModel(incline_angle,friction_angle,w,D/2,feed_rate_v,particle_d,L,handles);
      Uax = 0;
      
 end
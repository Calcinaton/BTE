function [] = check_conditions(handles)
%p_value = {'w';'fill_level'}
%Level 0: w=1,D=2,theta=3,fill_level=4
%Level 1:density=5;conductivity=6;heatCapcity=7;Youngs'Modulus=8;Poissons=9
%Level 2:
%'Velocity'=10;'incline'=11;'friction'=12;'bulk_density=13';'FeedRate'=14;
%'calciner_length'=15
%tau_c = 16, tau_p = 17;

faintout = [0.8 0.8 0.8];
highlight_p = [0 0 0];
calculated_color = 'y';
input_color = 'w';
p_value = {'w';'DrumDiameter';'theta';'fill_level';...
           'density';'conductivity';'heatCapacity';'YoungsModulus';'Poissons';...
           'Velocity';'incline';'friction';'bulk_density';'feed_rate';'calciner_length';...
           'tau_c';'tau_p'};
       
%Level 0 run
set(handles.phi,'BackgroundColor',input_color);    
set(handles.A,'BackgroundColor',input_color);
set(handles.Ap,'BackgroundColor',calculated_color);
set(handles.tau_c,'ForegroundColor',highlight_p);

if (get(handles.calp,'Value') ==0)
    %level 0 run
    for i=1:5
        propertyname = sprintf('text%d',i);
        propertyname=handles.(propertyname);
        set(propertyname,'ForegroundColor',faintout);
    end  
    for i=1:17
        set(handles.(p_value{i}),'String','');
        set(handles.(p_value{i}),'BackgroundColor',input_color);
    end
    set(handles.calc_phi,'Value',0)
    set(handles.calc_phi,'ForegroundColor',faintout);    
    set(handles.VelocityChoice,'Value',1)
    set(handles.VelocityChoice,'ForegroundColor',faintout)
    set(handles.tau_c,'String','1')
    set(handles.tau_c,'ForegroundColor',faintout)
    
  
%Level 1 run (tc is computed)
elseif (get(handles.calp,'Value') ==1);
    set(handles.phi,'BackgroundColor',calculated_color);
    set(handles.A,'BackgroundColor',calculated_color);
    set(handles.(p_value{16}),'BackgroundColor',calculated_color);
    for i=1:3
        if(isempty(get(handles.(p_value{i}),'String')))
           set(handles.(p_value{i}),'String','1')
        end 
    end    
    
    set(handles.(p_value{17}),'BackgroundColor',input_color);
    if(isempty(get(handles.(p_value{17}),'String')))
       set(handles.(p_value{17}),'String','1')
    end   
    
    for i=1:1
        propertyname = sprintf('text%d',i);
        propertyname=handles.(propertyname);
        set(propertyname,'ForegroundColor',highlight_p);
    end 
    for i=2:5
        propertyname = sprintf('text%d',i);
        propertyname=handles.(propertyname);
        set(propertyname,'ForegroundColor',faintout);
    end 
    set(handles.calc_phi,'Foreground',highlight_p);
    
    %control tau p
    if(get(handles.calc_phi,'Value')==0);
      for i=5:9   
          set(handles.(p_value{i}),'String','');
      end    
    else %if(get(handles.calc_phi,'Value')==1);
      %Level 2 run (tp is computed)    
        for i=2:2
            propertyname = sprintf('text%d',i);
            propertyname=handles.(propertyname);
            set(propertyname,'ForegroundColor',highlight_p);
        end 
        if(isempty(get(handles.(p_value{17}),'String')))
           set(handles.(p_value{17}),'String','1')
        end
        set(handles.(p_value{17}),'BackgroundColor',calculated_color);
        for i=5:9   
          if(isempty(get(handles.(p_value{i}),'String')))  
             set(handles.(p_value{i}),'String','10');
             if (i==9)
                set(handles.(p_value{i}),'String','0.25');
             end  
          end   
        end 
    end 
    
    %control flow
    set(handles.VelocityChoice,'ForegroundColor',highlight_p) 
    for i=10:15
        set(handles.(p_value{i}),'BackgroundColor',input_color);
    end 
    
    for i=3:4
        if(isempty(get(handles.(p_value{i}),'String')))
          set(handles.(p_value{i}),'String','1')
        end 
        set(handles.(p_value{i}),'BackgroundColor',input_color);
    end
    
    str = get(handles.VelocityChoice,'String');
    val = get(handles.VelocityChoice,'Value');
    
    if (strcmp(str{val},'Ignore Flow'))
       for i=10:15
           set(handles.(p_value{i}),'String','');
       end
              
    else  %if (~strcmp(str{val},'Ignore Flow')) 
        %Level 3 run (constantt velocity input)       
       for i=3:3
            propertyname = sprintf('text%d',i);
            propertyname=handles.(propertyname);
            set(propertyname,'ForegroundColor',highlight_p);
       end 
       
       switch str{val};
           
            case 'Plug Flow (input u)'
               for i=10:10
                   set(handles.(p_value{i}),'BackgroundColor',input_color);
                   if(isempty(get(handles.(p_value{i}),'String')))
                       set(handles.(p_value{i}),'String','1')
                   end    
               end  
               for i=11:15
                   set(handles.(p_value{i}),'String','');
               end   
               
            case 'Sullivan Model'
               %Level 4 run (sullivan model) 
               for i=4:4
                   propertyname = sprintf('text%d',i);
                   propertyname=handles.(propertyname);
                   set(propertyname,'ForegroundColor',highlight_p);
               end 
               for i=15:15
                   set(handles.(p_value{i}),'String','');
               end
               for i=3:4
                   set(handles.(p_value{i}),'String','');
                   set(handles.(p_value{i}),'BackgroundColor',calculated_color);
               end
               
               set(handles.(p_value{10}),'BackgroundColor',calculated_color)
               
            %Level 5 run (Saeman's Model)  
            case 'Saeman Model' 
                
               for i=4:5
                 propertyname = sprintf('text%d',i);
                 propertyname=handles.(propertyname);
                 set(propertyname,'ForegroundColor',highlight_p);
               end   
               for i=3:4
                 set(handles.(p_value{i}),'String','');
                 set(handles.(p_value{i}),'BackgroundColor',calculated_color);
               end 
               set(handles.(p_value{10}),'BackgroundColor',calculated_color)
       end  
    end        
      
end    
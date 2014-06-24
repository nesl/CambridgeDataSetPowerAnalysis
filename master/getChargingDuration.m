%Author: Salma Elmalaki
%selmalaki@ucla.edu

% Get the charging duration ... How long it was plugged 
% Get the time of the day when it is plugged 


function [ chargingintervals, timeofdayplugged] = getChargingDuration( pluggeddata, leveldata, id )

path='../../user-datasets/CambridgeDataGenerated/';

%Make a local copy
plugged = pluggeddata;
level = leveldata;
[rowp, colp]=size(plugged);
[rowl, coll]=size(level);

%clean the time second field to remove the partial second 
plugged(:,7) = int64(plugged(:,7));
level(:,7) = int64(level(:,7));

flagplugged = 0; 
timeplugged = [];
timeunplugged = [];
t1 = [];
t2 = [];
elapsedtime = [];

chargingintervals = [];
timeofdayplugged = [];
%socvsduration = []; % Captures the duration of charging at different plugging SOC
for p = 1:rowp   
    if p == 1; continue; end; % to avoid invalid access 
    
      if plugged(p,8) ~= 0 && ... %plugged
              flagplugged == 0 && plugged(p-1,8) == 0; 
         
          flagplugged = 1; 
          timeplugged = plugged(p,1:7); %for calculations
          timeofdayplugged(end+1, : ) = [timeplugged(1,1:3) timeplugged(1,5:7)];  % for saving 
          continue;
      end
      
       
     
      if plugged(p,8) == 0 && ... %unplugged
         plugged(p-1,8) ~= 0 && flagplugged == 1
         
        flagplugged = 0;
        timeunplugged = plugged(p-1,1:7); 
        
            if  ~isempty(timeplugged) && ~isempty(timeunplugged)

                %calculate the elapsed time during charging
                t1 = [timeplugged(:,1:3) timeplugged(:,5:7)]; %remove the time zone
                t2 = [timeunplugged(:,1:3) timeunplugged(:,5:7)];     %remove the time zone
                elapsedtime = etime(t2,t1);     
                if elapsedtime < 0 
                        %clear variables for next round
                    timeplugged = [];
                    timeunplugged = [];
                    t1 = [];
                    t2 = [];
                    elapsedtime = [];
                    continue;
                end
                
                if elapsedtime == 0
                                           %clear variables for next round
                    timeplugged = [];
                    timeunplugged = [];
                    t1 = [];
                    t2 = [];
                    elapsedtime = [];
                    continue;
                end
                
                if elapsedtime > 700*60
                    %clear variables for next round
                    timeplugged = [];
                    timeunplugged = [];
                    t1 = [];
                    t2 = [];
                    elapsedtime = [];
                    continue;
                end
                
                chargingintervals(end+1,:) = [elapsedtime  plugged(p-1,8)]; %put type of charger as well 
                
                
                %clear variables for next round
                timeplugged = [];
                timeunplugged = [];
                t1 = [];
                t2 = [];
                elapsedtime = [];
               
            end
     
      end
end

% 
% % Note::: Remaining to draw charging intervals vs charger type 
if ~isempty(chargingintervals)
     chargingintervals(:,1) = chargingintervals(:,1) ./ 60; % Convert to minutes. 
     removeindices = find(chargingintervals(:,1) == 0);
     chargingintervals(removeindices,:) = [];

     figure
     bar(chargingintervals(:,1));figure(gcf);title(strcat('ChargingDuration',id)); 
     ylabel('Charging Duration');
     xlabel('# of times charging events');
     saveplot(gcf,strcat(path,'user',id,'/ChargingDuration'));
     saveas(gcf,strcat(path,'user',id,'/ChargingDuration'),'fig');
end

%  
% if ~isempty(timeofdayplugged) 
%     figure;
%     count = length(timeofdayplugged);
%     plot(timeofdayplugged, count);datetick('x','HHPM');
%     figure(gcf);title(strcat('TimeOfDayCharging',id));
%      ylabel('Charging Events');
%      xlabel('Time of the Day');
%      saveas(gcf,strcat('user',id,'/TimeOfDayCharging'), 'jpeg');
% end
if ~isempty(timeofdayplugged) && ~isempty(chargingintervals)
    hist(timeofdayplugged(:,4),10);
    figure(gcf);title(strcat('TimeOfDayCharging',id));
    xlabel('Time of the Day');
    ylabel('# of Charging Events');
    saveas(gcf,strcat(path,'user',id,'/TimeOfDayCharging'), 'fig');
    saveplot(gcf,strcat(path,'user',id,'/TimeOfDayCharging'));
end


% if ~isempty(socvsduration) 
%     figure(gcf);title('State of charge at plugging vs duration');
%    
%     scatter(socvsduration(:,1), socvsduration(:,3)./60);
%     set(gca,'XTick',[0:10:100]);
%     ylabel('duration in charging min');
%     xlabel('percentage of SOC at plugging event');
%     saveas(gcf,strcat(path,'user',id,'/SOCvsChargingDuration'), 'jpeg');
% end

end


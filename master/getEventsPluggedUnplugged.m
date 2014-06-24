%Author: Salma Elmalaki
%selmalaki@ucla.edu

%Input:
% status: status file as a sting  
% level:  level file as a sting
% plugged:  plugged  file as a sting
% id: user id

function [plugged_vs_level , unplugged_vs_level,  soc_vs_chargingduration] = getEventsPluggedUnplugged( statusdata, leveldata, pluggeddata, id )
%PLUGGINGUNPLUGGINGEVENT Summary of this function goes here
%   Detailed explanation goes here

path='../../user-datasets/CambridgeDataGenerated/';


%Model it as a queue and get the time of arrival and charging interval

%Make a local copy
status = statusdata;
level = leveldata;
plugged = pluggeddata;

[rowl, coll] = size(level);
[rows,cols]= size(status);
[rowp, colp]=size(plugged);

%clean the time second field to remove the partial second 
status(:,7) = int64(status(:,7));
level(:,7) = int64(level(:,7));
plugged(:,7) = int64(plugged(:,7));


timestampsplugged = [];

%get arrival time of plugging event 
for r = 1:rowp
    if(r-1 == 0) continue; end
    if (plugged(r,8) ~= 0 && plugged(r-1,8) == 0) %event of plugged
        timestampsplugged(end+1,:) = plugged(r,:);
    end

end

%get the charge level at the plug time
[rowtp, coltp] = size(timestampsplugged);    
plugged_vs_level = [];
 
 for j = 1:rowtp
    for r = 1:rowl    
         if level(r,1:7) == timestampsplugged(j,1:7) %Check the timestamp
             plugged_vs_level(end+1,:) =[level(r,:) timestampsplugged(j,8)] ;
             continue;
         end
     end
 end
 
 
 
if ~isempty(plugged_vs_level)
    figure;
    %removeindices = find(plugged_vs_level(:,8) == 100);
    %plugged_vs_level (removeindices,:)=[];
    hist(plugged_vs_level(:,8));figure(gcf);title(strcat('PluggingEventsUser',id)); 
     ylabel('#of times phone is plugged');
     xlabel('Battery capacity %');
     saveplot(gcf, strcat(path,'user',id, '/PluggingEvents'));
     saveas(gcf, strcat(path,'user',id, '/PluggingEvents'),'fig');
end
 

 
%% Capture the Unplugged event 
 
 %initialize
timestampsUnPlugged = [];
%get time stamps at discharging event
for r = 1:rowp
    if (r -1 == 0) continue; end
    if (plugged(r,8) == 0 && plugged(r-1,8) ~= 0)
      timestampsUnPlugged(end+1,:) = plugged(r-1,:);
    end
   
    
end

 [rowtup, coltup] = size(timestampsUnPlugged);    
unplugged_vs_level = [];
 for j = 1:rowtup
    for r = 1:rowl    
         if level(r,1:7) == timestampsUnPlugged(j,1:7)
             unplugged_vs_level(end+1,:) = [level(r,:) timestampsUnPlugged(j,8)] ;
             continue;
         end
     end
 end
 if ~isempty(unplugged_vs_level)
     figure;
     %removeindices = find(unplugged_vs_level(:,8) == 0);
     %unplugged_vs_level(removeindices,:) = [];
     hist(unplugged_vs_level(:,8));figure(gcf);title(strcat('UnpluggingEventsUser',id)); 
     ylabel('#of times phone is unplugged');
     xlabel('Battery capacity %');
     saveplot(gcf,strcat(path,'user',id,'/UnpluggingEvents'));
     % for the presentation
     saveas(gcf,strcat(path,'user',id,'/UnpluggingEvents'),'fig');
 end
 
 %Get the duration vs SOC at plugged in
 %Note: Difference of 5 minutes between the charging duration and this
 %duration due to the fact that the in the chgarging duration file we stop
 %counting the time at the last event of charging while here we stop
 %counting till the after last event of charging event  
 %Need to run this file again after fixing this but it takes forever .. has
 %to do it overnight
 soc_vs_chargingduration = [];
 elapsedtime = [];

if ~isempty(plugged_vs_level) && ~isempty(unplugged_vs_level)
     t1 = plugged_vs_level(:,[1:3 5:7]);
     t2 = unplugged_vs_level(:,[1:3 5:7]);

     
     [rowupl, colupl]= size(unplugged_vs_level);
     [rowpl, colpl]= size(plugged_vs_level);
     
     % % If starts with charging and ends with charging 
     % so one unplugged event at the beginning and one plugged event at the end 
     % hence skip at the beginning and at the end
     if plugged(1,8) == 1
         if plugged(rowp, 8) == 1
            unplugged_vs_level = unplugged_vs_level(2:end,:);
            plugged_vs_level = plugged_vs_level(1:end-1,:);
            t1 = plugged_vs_level(:,[1:3 5:7]);
            t2 = unplugged_vs_level(:,[1:3 5:7]);
         end
     end
     
     % % if starting charging so there is a skip
     if rowupl - rowpl == 1
        unplugged_vs_level = unplugged_vs_level(2:end,:);
        t2 = unplugged_vs_level(:,[1:3 5:7]);
        
     end
     
     % % if ending with charging then there is a skip 
    if rowpl - rowupl == 1
        plugged_vs_level = plugged_vs_level(1:end-1,:);
        t1 = plugged_vs_level(:,[1:3 5:7]);
        
     end


     elapsedtime = etime(t2,t1);
     
     
      soc_vs_chargingduration = [plugged_vs_level(:,8) unplugged_vs_level(:,8) elapsedtime./60];

     % clear the delta 0
     indicestoremove = find(soc_vs_chargingduration(:,3) == 0);
     soc_vs_chargingduration(indicestoremove,:) = [];
     % clear the delta -ve
     indicestoremove = find(soc_vs_chargingduration(:,1) > soc_vs_chargingduration(:,2));
     soc_vs_chargingduration(indicestoremove,:) = [];
     % clear the time elapsed more than 700 min 
     indicestoremove = find(soc_vs_chargingduration(:,3) > 700);
     soc_vs_chargingduration(indicestoremove,:) = [];
     % clear the time that is -ve 
     indicestoremove = find(soc_vs_chargingduration(:,3) < 0);
     soc_vs_chargingduration(indicestoremove,:) = [];
      
     
    if ~isempty(soc_vs_chargingduration) 
        figure(gcf);

        scatter(soc_vs_chargingduration(:,1), soc_vs_chargingduration(:,3));
        set(gca,'XTick',[0:10:100]);
        title(strcat('State of charge at plugging vs duration',id)); 
        ylabel('duration in charging min');
        xlabel('percentage of SOC at plugging event');
        saveas(gcf,strcat(path,'user',id,'/SOCvsChargingDuration'), 'fig');
        saveplot(gcf,strcat(path,'user',id,'/SOCvsChargingDuration'));
    end
end
 
 return
 
 
 
 
 
 
 
 %% Time of charging at certain level 
 % Not working as expected (This code does not run in this function)
 stimeplugged = [];
 etimeplugged = [];
for r = 1:rowp
    if(r-1 == 0) continue; end
    if (plugged(r,8) ~= 0 && plugged(r-1,8) == 0) %event of plugged
        stimeplugged(end+1,1:8) =  plugged(r,:);
        for l = 1:rowl    
         if level(l,1:7) == stimeplugged(end,1:7) %check time stamp to get level
             stimeplugged(end,9) = level(l,8);
             break;
         end
        end
    
        continue;
    end
    if (plugged(r,8) ~= 0 && plugged(r-1,8) ~= 0) %event of still plugged
        continue;
    
    
    elseif (plugged(r,8) == 0 && plugged(r-1,8) ~= 0) %event of unplugged
        etimeplugged(end+1,1:8) = plugged(r,:);
        for l = 1:rowl    
         if level(l,1:7) == etimeplugged(end,1:7) %check the time stamp to get level
             etimeplugged(end,9) = level(l,8);
             break;
         end
        end
        
    end
    
end

% Calculate elapsed time
t1 = [stimeplugged(:,1:3) stimeplugged(:,5:7)];
t2 = [etimeplugged(:,1:3) etimeplugged(:,5:7)];
% if starting discharging so there is a skip
 if(t2(1,3) < t1(1,3)) 
     t2 = t2(2:end, :);
 end
elapsedtime = etime(t2(1:length(t1),:),t1);
charging = [elapsedtime stimeplugged(:,9) etimeplugged(1:length(stimeplugged),9)];
deltachargevstime = [charging charging(:,3)-charging(:,2)];
figure;
scatter(deltachargevstime(:,4), deltachargevstime(:,5));
end


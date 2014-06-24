%Author: Salma Elmalaki
%selmalaki@ucla.edu

% Get the amount of time it remains charging while it is 100% full 


function [ timeFullandPlugged ] = getTimeIntervalFull( statusdata, pluggeddata, id )

path='../../ee202b-share/data/origData/';

%Make a local copy
status = statusdata;
plugged = pluggeddata;

[rows,cols]= size(status);
[rowp, colp]=size(plugged);

%clean the time second field to remove the partial second 
status(:,7) = int64(status(:,7));
plugged(:,7) = int64(plugged(:,7));


%combine the status value with the plugged value (With all its values) in one array based on
%their time stamp
status_vs_plugged_data = [] ; 

for r = 1:rows
    curtimestamp = status(r,1:7);
    for p = 1:rowp
        if plugged(p,1:7) == curtimestamp
            status_vs_plugged_data(end+1,:) = [status(r,:) plugged(p,8)];
        end
    end

end


[rowsp, colsp] = size(status_vs_plugged_data);
startFulltime = [];
endFulltime = [];
flagfullandplugged = 0; 
timeFullandPlugged = [];
t1 = [];
t2 = [];
elapsedtime = [];
for sp=1:rowsp
    if  (sp - 1) == 0; continue; end;
      % When full and plugged ... 
      % capture the start time of just being full and plugged
    if status_vs_plugged_data(sp,8) == 5 && ... % full
       status_vs_plugged_data(sp,9) ~= 0  && ... % plugged
       status_vs_plugged_data(sp-1,8) ~= 5     % just when it becomes full
       
   
        if flagfullandplugged == 0
            flagfullandplugged = 1;   %raise flag
            startFulltime = status_vs_plugged_data(sp,:);  %capture this time
        end
    end    
        
    % Capture when full and time of unplugged
    if flagfullandplugged == 1 && ...
       status_vs_plugged_data(sp,9) == 0  %unplugged
       
        flagfullandplugged = 0; %lower flag
        endFulltime = status_vs_plugged_data(sp-1,:);  %capture this time
        
        if  ~isempty(startFulltime) && ~isempty(endFulltime)
            
            %calculate the elapsed time when full and plugged
            t1 = [startFulltime(:,1:3) startFulltime(:,5:7)]; %remove the time zone
            t2 = [endFulltime(:,1:3) endFulltime(:,5:7)];     %remove the time zone
            elapsedtime = etime(t2,t1);     
            
            if elapsedtime < 0
               %clear variables for next round
                startFulltime = [];
                endFulltime = [];
                t1 = [];
                t2 = [];
                elapsedtime = []; 
                continue;
            end
            
            if elapsedtime > 700*60
                %clear variables for next round
                startFulltime = [];
                endFulltime = [];
                t1 = [];
                t2 = [];
                elapsedtime = []; 
                continue;
            end
            
            timeFullandPlugged(end+1,:) = elapsedtime;
            
            
            %clear variables for next round
            startFulltime = [];
            endFulltime = [];
            t1 = [];
            t2 = [];
            elapsedtime = [];
        end
        
    end
      
    
end

if ~isempty(timeFullandPlugged)
     timeFullandPlugged(:,1) = timeFullandPlugged(:,1) ./ 60; % Convert to minutes. 
     figure;
     bar(timeFullandPlugged(:,:));figure(gcf);title(strcat('TimeIntervalFullandPlugged',id)); 
     ylabel('time interval when it is full and plugged');
     xlabel('number of events when it is full and plugged');

     saveas(gcf,strcat(path,'user',id,'/FullandPlugged'), 'fig');
     saveplot(gcf,strcat(path,'user',id,'/FullandPlugged'));
else 
    timeFullandPlugged = 0;
    
end


end


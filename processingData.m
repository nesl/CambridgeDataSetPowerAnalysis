%Author: Salma Elmalaki
%Date: 20 June 2014
%selmalaki@ucla.edu


%Description: Script which passes by users folders one by one and create a big structure called AllUsersData.mat
% First it puts all the chunks of the user in one file to be easily managed
% For each user, information arrays are are generated which contains this user specific info. (shown in the fields of the struct below) 



clear all
close all

path_User_folder='../processed';
path='../../ee202b-share/user-datasets/CambridgeDataGenerated';

UsersDir = getFolders(path_User_folder);

 field1 = 'userIndex'             ; value1 = '';
 field2 = 'level'                 ; value2 = [];
 field3 = 'plugged'               ; value3 = [];
 field4 = 'status'                ; value4 = [];
 field5 = 'durationfullandplugged'; value5 = [];
 field6 = 'chargingduration'      ; value6 = [];
 field7 = 'timeofdayCharging'     ; value7 = [];
 field8 = 'pluggingvslevel'       ; value8 = [];
 field9 = 'unpluggingvslevel'     ; value9 = [];
 field10 = 'SOCvsChargingDuration'; value10 = [];
 field11 = 'class'          ; value11 = []; 
 field12 = 'corrSOCandChargingDuration'  ; value12 = [];
 
 DataPerUser = struct(field1,value1,...
                      field2,value2, ...
                      field3,value3, ... 
                      field4,value4, ...
                      field5,value5, ...
                      field6,value6, ...
                      field7,value7, ...
                      field8,value8, ...
                      field9,value9, ...
                      field10,value10, ...
                      field11, value11, ...
                      field12, value12);
 
 %initialize the array of structs for all users data
 numofusers=length(UsersDir);
 AllUsersData = [];
 
 %%
 %fill the array of structs 
  for i=1:length(UsersDir)     
      level = [];
      status = [];
      plugged = [];
        
         user_index = UsersDir(i,1).name;
         UserFiles = getFiles([path_User_folder '/' user_index]);
         DataPerUser.userIndex = user_index;
         for k=1:length(UserFiles)
             data_file = UserFiles(k).name;
             %Get all the level files 
             if (strfind(data_file,'level'))
                 curlevel = csvread([path_User_folder '/' user_index '/' data_file]);
                 level = [level; curlevel];   
             end
             %Get all the status files 
             if (strfind(data_file,'status'))
                 curstatus = csvread([path_User_folder '/' user_index '/' data_file]);
                 status = [status; curstatus];
             end
             %Get all the plugged files 
             if (strfind(data_file,'plugged'))
                 curplugged = csvread([path_User_folder '/' user_index '/' data_file]);
                 plugged = [plugged; curplugged];
             end

         end
         DataPerUser.level = level;
         DataPerUser.plugged = plugged;
         DataPerUser.status = status;
         mkdir(strcat(path,'user',user_index));
        AllUsersData = [AllUsersData ; DataPerUser];
  end

%% 
%save('AllUsersData.mat','AllUsersData') ;
for u=1:numofusers
    plugged_vs_level = [];
    unplugged_vs_level = [];
    disp(strcat('Processing user ', AllUsersData(u).userIndex, ' for plugging and unplugging events...'));
    %if ~exist(strcat('user',AllUsersData(u).userIndex),'dir') %check if already processed
        disp(strcat(' .... user',AllUsersData(u).userIndex,' ',' is new ... '));
        [plugged_vs_level , unplugged_vs_level, soc_vs_chargingduration] = getEventsPluggedUnplugged(AllUsersData(u).status, AllUsersData(u).level, AllUsersData(u).plugged, AllUsersData(u).userIndex);
         AllUsersData(u).pluggingvslevel=plugged_vs_level;
         AllUsersData(u).unpluggingvslevel=unplugged_vs_level;
         AllUsersData(u).SOCvsChargingDuration=soc_vs_chargingduration;
    %else
    %    disp(strcat(' .... user',AllUsersData(u).userIndex,' ',' already processed ... '))
    %end
    close all
end

%save('AllUsersData.mat','AllUsersData') ;
%%
save('AllUsersData.mat','AllUsersData') ;
for u=1:numofusers
    timeFullandPlugged = [];
    disp(strcat('Processing user ', AllUsersData(u).userIndex, ' for full time interval while plugged ...'));
    timeFullandPlugged = getTimeIntervalFull(AllUsersData(u).status, AllUsersData(u).plugged, AllUsersData(u).userIndex); 
    AllUsersData(u).durationfullandplugged = timeFullandPlugged;
    close all
end
save('AllUsersData.mat','AllUsersData') ;
%% 
save('AllUsersData.mat','AllUsersData') ;
for u=1:numofusers
    timechargingduration = [];
    timeOfdayCharging = [];
    disp(strcat('Processing user ', AllUsersData(u).userIndex, ' for charging interval ...'));
    [timechargingduration, timeOfdayCharging] = getChargingDuration(AllUsersData(u).plugged,AllUsersData(u).level, AllUsersData(u).userIndex); 
    AllUsersData(u).chargingduration = timechargingduration;
    AllUsersData(u).timeofdayCharging = timeOfdayCharging;
    close all
end
% Save the data
save('AllUsersData.mat','AllUsersData') ;
%%
save('AllUsersData.mat','AllUsersData') ;
% User Classification based on the charging behavior
for u=1:numofusers
   
    if ~isempty(AllUsersData(u).pluggingvslevel)
        u
        [rowpl, colpl] = size(AllUsersData(u).pluggingvslevel);
        
        above50indices = find(AllUsersData(u).pluggingvslevel(:,8) > 50);
        above30indices = find(AllUsersData(u).pluggingvslevel(:,8) > 30) ;
 
        
        numofusersabove50 = length(above50indices) %class 1
        numofusersbetween30and50 = length(above30indices) - numofusersabove50 % class 2
        numofusersbetween0and30 = rowpl - numofusersbetween30and50 - numofusersabove50 % class 3
        
        
        percentageofabove50 = (numofusersabove50/rowpl)  * 100;
        percentageof30to50 = (numofusersbetween30and50/rowpl) * 100;
        percentageof0to30 = (numofusersbetween0and30/rowpl)*100;
        
        classification = [percentageofabove50;percentageof30to50;percentageof0to30]
        find(classification == max(classification))
        AllUsersData(u).class = find(classification == max(classification));
        if length(AllUsersData(u).class) > 1
            %means 50% in each class hence choose any class
             AllUsersData(u).class = AllUsersData(u).class(1,:);
        end
%         
%         if percentageofabove50 >= 50
%           AllUsersData(u).class = 1;
%         else
%           AllUsersData(u).class = 0;
%         end
    end
    close all
end
 save('AllUsersData.mat','AllUsersData') ;

%%  Correlation Coeffecient between the charging duration and the SOC
 save('AllUsersData.mat','AllUsersData') ;
 corrArray = [];
 for u=1:numofusers 
     if isempty(AllUsersData(u).SOCvsChargingDuration)
         continue;
     end
      if length(AllUsersData(u).SOCvsChargingDuration) < 30 
          continue;
      end
     correlationcoeff = corr( AllUsersData(u).SOCvsChargingDuration(:,1), AllUsersData(u).SOCvsChargingDuration(:,3));
     AllUsersData(u).corrSOCandChargingDuration = correlationcoeff;
     corrArray(end+1,:) = [ u, correlationcoeff];

 end
 figure
 for u=1:numofusers 
     if isempty(AllUsersData(u).corrSOCandChargingDuration)
         continue;
     end
     
  
     scatter(corrArray(:,1), corrArray(:,2), 'fill' );
     hold on
 end
 hold off
 save('AllUsersData.mat','AllUsersData') ;
 %%
% save('AllUsersData.mat','AllUsersData') ;
 aggregateInformation();
 %close all
 %save('AllUsersData.mat','AllUsersData') ;

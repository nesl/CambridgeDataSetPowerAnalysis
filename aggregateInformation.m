%Author: Salma Elmalaki
%Date: 20 June/2014
%selmalaki@ucla.edu
%Desciption: Aggregate all the users information to get aggregated figures. 
% It uses 'AllUsersData.mat'
% It generates the following:
% 1-  histaggregatedpluggedvslevel
% 2-  histaggregatedunpluggedvslevel
% 3-  histaggregateddurationpluggedandfull
% 4-  histaggregatedchargingduration
% 5-  histaggregatedelapsedtime (same as above but with different way of computation)
% 6-  socvschargingdurationaggregateUserClassified (a figure contains x-axis as SOC, y-axis as the charging duration. Each point on the graph is a charging event. Each color is from a class of users)
% 7-  socvschargingdurationaggregate (same as above but not classified per user --- i.e. no coloring) 
% 8-  aggregatedsocvsdurationcorrelation -- the correlation between the SOC at charging event and the charging duration for all users
% 9-  Some Statistics: 
%	9.1  geomean_durationfullandplugged  	+ global mean (which is mean of the means), median
%	9.2  arithmean_durationfullandplugged	+ global mean , median , std dev, histofmeansofdurationfullandplugged
%	9.3  geomean_elapsedtime		+ global mean , median , std dev, 
%	9.4  arithmean_elapsedtime		+ global mean , median , std dev, histofmeansofelapsedtime
%	9.5  geomean_pluggingvslevel		+ global mean , median , std dev, 
%	9.6  arithmean_pluggingvslevel		+ global mean , median , std dev, histofmeansofpluggedvslevel 
%	9.10 percentageoftimeOfbenefit --- uses SOCatexponentialStage = 35; % can be change
% 10-  userClassification into three classes and save a parameter per user with its class number

% figures for each item is generated in CambridgeDataGenerated/aggregate folder as .fig, .eps and .png


function [] = aggregateInformation()

close all
data = load ('AllUsersData.mat');
path='../../user-datasets/CambridgeDataGenerated/';
userindex = [];
userindexstring = {};
geomean_durationfullandplugged =[]; 
arithmean_durationfullandplugged = [];
geomean_chargingduration = [];
arithmean_chargingduration = [];
geomean_elapsedtime = [];
arithmean_elapsedtime = [];
geomean_pluggingvslevel = [];
arithmean_pluggingvslevel = [];
geomean_unpluggingvslevel = [];
arithmean_unpluggingvslevel = [];

socvschargingdurationaggregateUserClassified =[];

SOCatexponentialStage = 35; % can be changed
percentageoftimeOfbenefit = [];


 %% Aggregate data to check if the arithmetic mean makes sense!!  
pluggedaggregate =[];
unpluggedaggregate=[];
fullandpluggedaggregate=[];
chargingdurationaggregate=[];
elapsedtimeaggregate = [];
socvschargingdurationaggregate = [];
for d = 1:length(data.AllUsersData)

    if length(data.AllUsersData(d).status) < 200 
        continue;
    else
        d
        data.AllUsersData(d).userIndex
        if ~isempty(data.AllUsersData(d).pluggingvslevel)
          pluggedaggregate =[pluggedaggregate; data.AllUsersData(d).pluggingvslevel(:,8)];
        end
        if ~isempty(data.AllUsersData(d).unpluggingvslevel)
          unpluggedaggregate=[unpluggedaggregate; data.AllUsersData(d).unpluggingvslevel(:,8)];
        end
        if ~isempty(data.AllUsersData(d).durationfullandplugged)
            fullandpluggedaggregate =[fullandpluggedaggregate; data.AllUsersData(d).durationfullandplugged(:,1)];
        end
        if ~isempty(data.AllUsersData(d).chargingduration)
            chargingdurationaggregate =[chargingdurationaggregate; data.AllUsersData(d).chargingduration(:,1)];
        end
        if ~isempty(data.AllUsersData(d).SOCvsChargingDuration(:,3))
            elapsedtimeaggregate = [elapsedtimeaggregate; data.AllUsersData(d).SOCvsChargingDuration(:,3)];
        end
        if ~isempty(data.AllUsersData(d).SOCvsChargingDuration)
            socvschargingdurationaggregate = [socvschargingdurationaggregate; data.AllUsersData(d).SOCvsChargingDuration];
            [rowsocvsdur, colsocvsdur]=size(data.AllUsersData(d).SOCvsChargingDuration);
            currentclass = ones(rowsocvsdur,1)*data.AllUsersData(d).class;
            socvschargingdurationaggregateUserClassified = [socvschargingdurationaggregateUserClassified; [data.AllUsersData(d).SOCvsChargingDuration currentclass] ];
        end
        
    end
end
gcf = cfigure(40,60);
hist(pluggedaggregate,10);title('Aggregate Plugged vs Level');
ylabel('#of times phone is plugged');
xlabel('Battery capacity %');
saveplot(gcf,strcat(path,'aggregate/histaggregatedpluggedvslevel'));
saveas(gcf,strcat(path,'aggregate/histaggregatedpluggedvslevel'),'fig');
%close all
gcf = cfigure(40,60);
hist(unpluggedaggregate,10);title('Aggregate Unplugged vs Level');
ylabel('#of times phone is unplugged');
xlabel('Battery capacity %');
saveplot(gcf,strcat(path,'aggregate/histaggregatedunpluggedvslevel'));
saveas(gcf,strcat(path,'aggregate/histaggregatedunpluggedvslevel'),'fig');
%close all
gcf = cfigure(40,60);
removeindices = find(fullandpluggedaggregate > 700);
fullandpluggedaggregate(removeindices) = [];
hist(fullandpluggedaggregate,100);title('Aggregate Full and plugged');
ylabel('#of times phone is full and plugged');
xlabel('duration (min)');
saveplot(gcf,strcat(path,'aggregate/histaggregateddurationpluggedandfull'));
saveas(gcf,strcat(path,'aggregate/histaggregateddurationpluggedandfull'),'fig');
%close all
gcf = cfigure(40,60);
removeindices = find(chargingdurationaggregate > 700);
chargingdurationaggregate(removeindices) = [];
hist(chargingdurationaggregate,100);title('Aggregate Charging duration');
ylabel('#of times phone is Charging');
xlabel('duration (min)');
saveplot(gcf,strcat(path,'aggregate/histaggregatedchargingduration'));
saveas(gcf,strcat(path,'aggregate/histaggregatedchargingduration'),'fig');
%close all
gcf = cfigure(40,60);
removeindices = find(elapsedtimeaggregate > 700);
elapsedtimeaggregate(removeindices) = [];
hist(elapsedtimeaggregate ,100);title('Aggregate Elapsed Time');
ylabel('#of times phone is Charging');
xlabel('elapsedtime in min');
saveplot(gcf,strcat(path,'aggregate/histaggregatedelapsedtime'));
saveas(gcf,strcat(path,'aggregate/histaggregatedelapsedtime'),'fig');
%close all
gcf = cfigure(40,60);
scatter(socvschargingdurationaggregate(:,1), socvschargingdurationaggregate(:,3));title('Aggregate SOC vs Charging duration');
ylabel('duration (min)');
xlabel('battery capacity at event of start charging');
saveplot(gcf,strcat(path,'aggregate/aggregatedsocvschargingduration'));
saveas(gcf,strcat(path,'aggregate/aggregatedsocvschargingduration'),'fig');
%close all

%% Draw the SOC vs charging duration with classified users
gcf = cfigure(30,40); 
[rowsocvsduragg, colsocvsduragg] = size(socvschargingdurationaggregateUserClassified);
for i=1:rowsocvsduragg
    %class 1 ==> color blue ==> Above 60
    %class 2 ==> color green ==> Between 40 and 60
    %class 3 ==> color red ==> Below 40
    
    if socvschargingdurationaggregateUserClassified(i,4) == 1
        scatter(socvschargingdurationaggregateUserClassified(i,1), socvschargingdurationaggregateUserClassified(i,3), 'b', '*');
        hold on
        continue
    elseif socvschargingdurationaggregateUserClassified(i,4) == 2 
        scatter(socvschargingdurationaggregateUserClassified(i,1), socvschargingdurationaggregateUserClassified(i,3),'g', 'fill');    
        hold on 
        continue
    elseif socvschargingdurationaggregateUserClassified(i,4) == 3
        scatter(socvschargingdurationaggregateUserClassified(i,1), socvschargingdurationaggregateUserClassified(i,3), 'r','+');    
        hold on
        continue
    end
   
end

ylabel('Charging Duration (min)', 'FontSize', 15);
xlabel('SOC at the time of charging event', 'FontSize', 15);
saveplot(gcf,strcat(path,'aggregate/aggregatedsocvschargingdurationclassified'));
saveas(gcf,strcat(path,'aggregate/aggregatedsocvschargingdurationclassified'),'fig');

%% Get the correlation between the SOC and the charging duration for aggregated users
close all
correlationCoeffSOCvsDuration = corr(socvschargingdurationaggregateUserClassified(:,1), socvschargingdurationaggregateUserClassified(:,3)); % = -0.0614

% Get the correlation for all same class users
class1socvsdurationaggregated = [];
class2socvsdurationaggregated = [];
class3socvsdurationaggregated = [];
for r = 1: rowsocvsduragg
    if socvschargingdurationaggregateUserClassified(r,4) == 1
    class1socvsdurationaggregated(end+1,:) = socvschargingdurationaggregateUserClassified(r,:);
    elseif socvschargingdurationaggregateUserClassified(r,4) == 2
        class2socvsdurationaggregated(end+1,:) = socvschargingdurationaggregateUserClassified(r,:);
         elseif socvschargingdurationaggregateUserClassified(r,4) == 3
        class3socvsdurationaggregated(end+1,:) = socvschargingdurationaggregateUserClassified(r,:);
    end
end

correlationCoeffSOCvsDurationClass1 = corr(class1socvsdurationaggregated(:,1),class1socvsdurationaggregated(:,3))
correlationCoeffSOCvsDurationClass2 = corr(class2socvsdurationaggregated(:,1),class2socvsdurationaggregated(:,3))
correlationCoeffSOCvsDurationClass3 = corr(class3socvsdurationaggregated(:,1),class3socvsdurationaggregated(:,3))

gcf = cfigure(30,40);
bar( 1:4 , [correlationCoeffSOCvsDuration; correlationCoeffSOCvsDurationClass1; correlationCoeffSOCvsDurationClass2; correlationCoeffSOCvsDurationClass3]);
ylabel('Correlation Coefficient', 'FontSize', 15);
set(gca, 'XTickLabel',{'AllUsers', 'Class1', 'Class', 'Class3'});
saveplot(gcf,strcat(path,'aggregate/aggregatedsocvsdurationcorrelation'));
saveas(gcf,strcat(path,'aggregate/aggregatedsocvsdurationcorrelation'),'fig');
return
%% Calculate some data per user to aggregate it in one plot
%remove the users which have less than 100 points in order not to
%spoil the results with low points of one user and get dome data from the
%users

for d = 1:length(data.AllUsersData)

    if length(data.AllUsersData(d).status) < 200 
        continue;
    else
        
        disp(strcat('index ', num2str(d), '  Processing user: ',data.AllUsersData(d).userIndex));
        userindex(end+1,:) = str2num(data.AllUsersData(d).userIndex);
        userindexstring(end+1,:) =cellstr(data.AllUsersData(d).userIndex(1,3:end));
        
        % Aggregate Duration full and plugged
        geomean_durationfullandplugged(end+1,:) = geomean(data.AllUsersData(d).durationfullandplugged);
        arithmean_durationfullandplugged(end+1,:) = mean(data.AllUsersData(d).durationfullandplugged);

        % Aggregate charging duration 
        geomean_chargingduration(end+1,:) = geomean(data.AllUsersData(d).chargingduration(:,1));
        arithmean_chargingduration(end+1,:) = mean(data.AllUsersData(d).chargingduration(:,1));

        % Aggrgate elapsed time in charger
        % This should be the same as charging duraing calculating above. 
        % The only difference is the way this parameter was calculated
        geomean_elapsedtime(end+1,:) = geomean(data.AllUsersData(d).SOCvsChargingDuration(:,3));
        arithmean_elapsedtime(end+1,:) = mean(data.AllUsersData(d).SOCvsChargingDuration(:,3));
        
        % Aggregate plugging vs level
        geomean_pluggingvslevel(end+1,:) = geomean(data.AllUsersData(d).pluggingvslevel(:,8));
        arithmean_pluggingvslevel(end+1,:) = mean(data.AllUsersData(d).pluggingvslevel(:,8));

        %Aggregate unpluggging vs level 
        geomean_unpluggingvslevel(end+1,:) = geomean(data.AllUsersData(d).unpluggingvslevel(:,8));
        arithmean_unpluggingvslevel(end+1,:) = mean(data.AllUsersData(d).unpluggingvslevel(:,8));
        
        %Find the percentage of users which can benefit from the idea of deferring tasks
        numofchargingtime = length(find(data.AllUsersData(d).pluggingvslevel(:,8) < SOCatexponentialStage));  
        [rowpl, colpl] = size(data.AllUsersData(d).pluggingvslevel(:,8));
        totalnumchargingtimes = rowpl;
        percentageoftimeOfbenefit(end+1,1) = (numofchargingtime/totalnumchargingtimes)*100;
  
    end
end
% draw the percentage of charging times the user can benefit from
% deferrability which is the number of times the user starts plugging the
% phone when the level of charge was less than 'SOCatexponentialStage'
gcf = cfigure(50,70);
numofusersbenefit = length(find(percentageoftimeOfbenefit(:,1) > 50 ));
bar(1:length(userindex),percentageoftimeOfbenefit, ... 
                     'FaceColor',[0.2,0.2,0.5], ...
                     'EdgeColor','none');
set(gca, 'XTick',1:length(userindex), 'XTickLabel',userindexstring');
title(strcat('Percentage of Charging time when SOC Less than ',num2str(SOCatexponentialStage)));
ylabel('Percentage of charging events (%)', 'FontSize', 15); 
%text(1, 95, strcat('Num of users have percentage of charging events less than ',num2str(SOCatexponentialStage),' is ', num2str(numofusersbenefit) ));
saveas(gcf,strcat(path,'aggregate/percentageofchargingeventsabove',num2str(SOCatexponentialStage)),'fig');
saveplot(gcf,strcat(path,'aggregate/percentageofchargingeventsabove',num2str(SOCatexponentialStage)));




%% Get statistics

%Duration full and plugged
mean_geomeanfullandplugged = mean(geomean_durationfullandplugged); 
median_geomeanfullandplugged = median(geomean_durationfullandplugged);
std_geomeanfullandplugged = std(geomean_durationfullandplugged);

mean_arithmeanfullandplugged = mean(arithmean_durationfullandplugged); 
median_arithmeanfullandplugged = median(arithmean_durationfullandplugged);
std_arithmeanfullandplugged = std(arithmean_durationfullandplugged);


%charging duration 
mean_geomeanchargingduration = mean(geomean_chargingduration); 
median_geomeanchargingduration = median(geomean_chargingduration); 
std_geomeanchargingduration = std(geomean_chargingduration); 

mean_arithmeanchargingduration = mean(arithmean_chargingduration); 
median_arithmeanchargingduration = median(arithmean_chargingduration); 
std_arithmeanchargingduration = std(arithmean_chargingduration);

%Elapsed time (should be almost the same as charging duration)
mean_geomeanelapsedtime = mean(geomean_elapsedtime);
median_geomeanelapsedtime = median(geomean_elapsedtime);

mean_arithmeanelapsedtime = mean(arithmean_elapsedtime);
median_arithmeanelapsedtime = median(arithmean_elapsedtime);
        

%plugging vs level
mean_geomeanpluggingvslevel=mean(geomean_pluggingvslevel);
median_geomeanpluggingvslevel=median(geomean_pluggingvslevel);
std_geomeanpluggingvslevel=std(geomean_pluggingvslevel);

mean_arithmeanpluggingvslevel=mean(arithmean_pluggingvslevel);
median_arithmeanpluggingvslevel=median(arithmean_pluggingvslevel);
std_arithmeanpluggingvslevel=std(arithmean_pluggingvslevel);

%unpluggging vs level 
mean_geomeanunpluggingvslevel=mean(geomean_unpluggingvslevel);
median_geomeanunpluggingvslevel=median(geomean_unpluggingvslevel);
std_geomeanunpluggingvslevel=std(geomean_unpluggingvslevel);

mean_arithmeanunpluggingvslevel=mean(arithmean_unpluggingvslevel);
median_arithmeanunpluggingvslevel=median(arithmean_unpluggingvslevel);
std_arithmeanunpluggingvslevel=std(arithmean_unpluggingvslevel);

%% Draw full and plugged

% Fishy!!!! Time full and plugged is too much almost 6 hours !!! 
if ~isempty(geomean_durationfullandplugged) 
     
    %First remove outlayers 
    removeindices = find(geomean_durationfullandplugged > 700);
    geomean_durationfullandplugged(removeindices,:)=[];
    
    removeindices = find(arithmean_durationfullandplugged > 700);
    arithmean_durationfullandplugged(removeindices,:)=[];
    
    width = 0.5;
     
     gcf = cfigure(50,70);
     
     subplot(2,1,1);title('geo. and arith. mean of durationfullandplugged');
     %bar(1:length(userindex),geomean_durationfullandplugged,width, ... 
     %                'FaceColor',[0.2,0.2,0.5], ...
     %                'EdgeColor','none');
     bar(1:length(geomean_durationfullandplugged),geomean_durationfullandplugged,width, ... 
                     'FaceColor',[0.2,0.2,0.5], ...
                     'EdgeColor','none');
     set(gca, 'XTick',1:length(userindex), 'XTickLabel',userindexstring');
     ylabel('Geom. Mean','FontSize',15);
     
     %put the statistics
     hold on
     plot(1:length(userindex),ones(length(userindex),1)*mean_geomeanfullandplugged, '--','LineWidth',2);
     plot(1:length(userindex),ones(length(userindex),1)*median_geomeanfullandplugged, ':','LineWidth',2);     
     hold off
     legend('Geom. Mean', 'Mean', 'Median')
     subplot(2,1,2);
     bar(1:length(arithmean_durationfullandplugged),arithmean_durationfullandplugged,width, ... 
                     'FaceColor',[0,0.7,0.7],...
                     'EdgeColor',[0,0.7,0.7]);
     ylabel('Arith. Mean','FontSize',15);
     set(gca, 'XTick',1:length(userindex), 'XTickLabel',userindexstring');
     %put the statistics
     hold on
     plot(1:length(userindex),ones(length(userindex),1)*mean_arithmeanfullandplugged, '--','LineWidth',2);
     plot(1:length(userindex),ones(length(userindex),1)*median_arithmeanfullandplugged, ':','LineWidth',2);     
     hold off
     legend('Geom. Mean', 'Mean', 'Median')
     
     
     %Overlayed
%      subplot(3,1,3);
%      legend('Geom. Mean','Arith. Mean');
%      title('geo. and arith. mean of durationfullandplugged');
%      bar(1:length(geomean_durationfullandplugged),geomean_durationfullandplugged,width, ... 
%                      'FaceColor',[0.2,0.2,0.5], ...
%                      'EdgeColor','none');
%      set(gca, 'XTick',1:length(userindex), 'XTickLabel',userindexstring');
%         
%      hold on
%      bar(1:length(arithmean_durationfullandplugged),arithmean_durationfullandplugged,width/2, ... 
%                      'FaceColor',[0,0.7,0.7],...
%                      'EdgeColor',[0,0.7,0.7]);
%      set(gca, 'XTick',1:length(userindex), 'XTickLabel',userindexstring');
%      hold off
      saveplot(gcf,strcat(path,'aggregate/durationfullandplugged'));
      saveas(gcf,strcat(path,'aggregate/durationfullandplugged'),'fig');

      %Overlayed
      gcf = cfigure(50,70);
      bar(1:length(geomean_durationfullandplugged),geomean_durationfullandplugged,width, ... 
                      'FaceColor',[0.2,0.2,0.5], ...
                      'EdgeColor','none');
      set(gca, 'XTick',1:length(userindex), 'XTickLabel',userindexstring');
         
      hold on
      bar(1:length(arithmean_durationfullandplugged),arithmean_durationfullandplugged,width/4, ... 
                      'FaceColor',[0,0.7,0.7],...
                      'EdgeColor',[0,0.7,0.7]);
      set(gca, 'XTick',1:length(userindex), 'XTickLabel',userindexstring');
      ylabel('Geom-Arith Means for Duration Full and Plugged (min)', 'FontSize', 15);
      %Put the statistics
      plot(1:length(userindex),ones(length(userindex),1)*mean_geomeanfullandplugged, '--','LineWidth',2, 'Color', [0.2,0.2,0.5]);
      plot(1:length(userindex),ones(length(userindex),1)*median_geomeanfullandplugged, ':','LineWidth',2, 'Color', [0.2,0.2,0.5]);     
      
      plot(1:length(userindex),ones(length(userindex),1)*mean_arithmeanfullandplugged, '-','LineWidth',2, 'Color', [0,0.7,0.7]);
      plot(1:length(userindex),ones(length(userindex),1)*median_arithmeanfullandplugged, '-.','LineWidth',2, 'Color', [0,0.7,0.7]);     
      
      hold off
      legend('Geom. Mean', 'Arith. Mean', 'Mean of Geom.Mean', 'Median of Geom. Mean', 'Mean of Arith.Mean', 'Median of Arith.Mean');
      xlabel('User ID', 'FontSize', 15);
      saveplot(gcf,strcat(path,'aggregate/durationfullandpluggedoverlayed'));
      saveas(gcf,strcat(path,'aggregate/durationfullandpluggedoverlayed'),'fig');

end


%% Draw charging duration

if ~isempty(geomean_chargingduration) 
     width = 0.5;
     
    gcf = cfigure(50,70);
     
    %First remove outlayers 
    removeindices = find(geomean_chargingduration > 700);
    geomean_chargingduration(removeindices,:)=[];
    
    removeindices = find(arithmean_chargingduration > 700);
    arithmean_chargingduration(removeindices,:)=[];
     
     
     
     subplot(2,1,1);title('geo. and arith. mean of charging duration');
     bar(1:length(userindex),geomean_chargingduration,width, ... 
                     'FaceColor',[0.2,0.2,0.5], ...
                     'EdgeColor','none');
     set(gca, 'XTick',1:length(userindex), 'XTickLabel',userindexstring');
     ylabel('Geom. Mean','FontSize',15);
     
     %put the statistics
     hold on
     plot(1:length(userindex),ones(length(userindex),1)*mean_geomeanchargingduration, '--','LineWidth',2);
     plot(1:length(userindex),ones(length(userindex),1)*median_geomeanchargingduration, ':','LineWidth',2);     
     hold off
     legend('Geom. Mean', 'Mean', 'Median');
     
     subplot(2,1,2);
     bar(1:length(userindex),arithmean_chargingduration,width, ... 
                     'FaceColor',[0,0.7,0.7],...
                     'EdgeColor',[0,0.7,0.7]);
     ylabel('Arith. Mean','FontSize', 15);
     set(gca, 'XTick',1:length(userindex), 'XTickLabel',userindexstring');
     %put the statistics
     hold on
     plot(1:length(userindex),ones(length(userindex),1)*mean_arithmeanchargingduration, '--','LineWidth',2);
     plot(1:length(userindex),ones(length(userindex),1)*median_arithmeanchargingduration, ':','LineWidth',2);     
     hold off
     legend('Geom. Mean', 'Mean', 'Median');
     
     
     %Overlayed
%      subplot(3,1,3);
%      legend('Geom. Mean','Arith. Mean');
%      title('geo. and arith. mean of charging duration');
%      bar(1:length(userindex),geomean_chargingduration,width, ... 
%                      'FaceColor',[0.2,0.2,0.5], ...
%                      'EdgeColor','none');
%      set(gca, 'XTick',1:length(userindex), 'XTickLabel',userindexstring');
%         
%      hold on
%      bar(1:length(userindex),arithmean_chargingduration,width/2, ... 
%                      'FaceColor',[0,0.7,0.7],...
%                      'EdgeColor',[0,0.7,0.7]);
%      set(gca, 'XTick',1:length(userindex), 'XTickLabel',userindexstring');
%      hold off
      
      saveplot(gcf,strcat(path,'aggregate/chargingduration'));
      saveas(gcf,strcat(path,'aggregate/chargingduration'),'fig');
      
      %overlayed
      gcf = cfigure(50,70);
      bar(1:length(userindex),geomean_chargingduration,width, ... 
                      'FaceColor',[0.2,0.2,0.5], ...
                      'EdgeColor','none');
      set(gca, 'XTick',1:length(userindex), 'XTickLabel',userindexstring');
         
      hold on
      bar(1:length(userindex),arithmean_chargingduration,width/4, ... 
                      'FaceColor',[0,0.7,0.7],...
                      'EdgeColor',[0,0.7,0.7]);
      set(gca, 'XTick',1:length(userindex), 'XTickLabel',userindexstring');
      
      plot(1:length(userindex),ones(length(userindex),1)*mean_geomeanchargingduration, '--','LineWidth',2, 'Color', [0.2,0.2,0.5]);
      plot(1:length(userindex),ones(length(userindex),1)*median_geomeanchargingduration, ':','LineWidth',2, 'Color', [0.2,0.2,0.5]);     

      plot(1:length(userindex),ones(length(userindex),1)*mean_arithmeanchargingduration,  '-','LineWidth',2, 'Color', [0,0.7,0.7]);
      plot(1:length(userindex),ones(length(userindex),1)*median_arithmeanchargingduration,  '-.','LineWidth',2, 'Color', [0,0.7,0.7]);           
     
      hold off
      legend('Geom. Mean', 'Arith. Mean', 'Mean of Geom.Mean', 'Median of Geom. Mean', 'Mean of Arith.Mean', 'Median of Arith.Mean');
      xlabel('User ID', 'FontSize', 15);
      saveplot(gcf,strcat(path,'aggregate/chargingdurationoverlayed'));
      saveas(gcf,strcat(path,'aggregate/chargingdurationoverlayed'),'fig');
end



%% Draw Elapsed Time

if ~isempty(geomean_elapsedtime) 
     width = 0.5;
     
      gcf = cfigure(50,70);
     
     %First remove outlayers 
    removeindices = find(geomean_elapsedtime > 700);
    geomean_elapsedtime(removeindices,:)=[];
    
    removeindices = find(arithmean_elapsedtime > 700);
    arithmean_elapsedtime(removeindices,:)=[];
     
     
     
     
     subplot(2,1,1);title('geo. and arith. mean of elapsed time');
     bar(1:length(userindex),geomean_elapsedtime,width, ... 
                     'FaceColor',[0.2,0.2,0.5], ...
                     'EdgeColor','none');
     set(gca, 'XTick',1:length(userindex), 'XTickLabel',userindexstring');
     ylabel('Geom. Mean','FontSize', 15);
     
     %put the statistics
     hold on
     plot(1:length(userindex),ones(length(userindex),1)*mean_geomeanelapsedtime, '--','LineWidth',2);
     plot(1:length(userindex),ones(length(userindex),1)*median_geomeanelapsedtime, ':','LineWidth',2);     
     hold off
     legend('Geom. Mean', 'Mean', 'Median');
     
     subplot(2,1,2);
     bar(1:length(userindex),arithmean_elapsedtime,width, ... 
                     'FaceColor',[0,0.7,0.7],...
                     'EdgeColor',[0,0.7,0.7]);
     ylabel('Arith. Mean','FontSize', 15);
     set(gca, 'XTick',1:length(userindex), 'XTickLabel',userindexstring');
     %put the statistics
     hold on
     plot(1:length(userindex),ones(length(userindex),1)*mean_arithmeanelapsedtime, '--','LineWidth',2);
     plot(1:length(userindex),ones(length(userindex),1)*median_arithmeanelapsedtime, ':','LineWidth',2);     
     hold off
     legend('Arith.Mean','Mean','Median');
     
     
     %Overlayed
%      subplot(3,1,3);
%      legend('Geom. Mean','Arith. Mean');
%      title('geo. and arith. mean of elapsed time');
%      bar(1:length(userindex),geomean_elapsedtime,width, ... 
%                      'FaceColor',[0.2,0.2,0.5], ...
%                      'EdgeColor','none');
%      set(gca, 'XTick',1:length(userindex), 'XTickLabel',userindexstring');
%         
%      hold on
%      bar(1:length(userindex),arithmean_elapsedtime,width/2, ... 
%                      'FaceColor',[0,0.7,0.7],...
%                      'EdgeColor',[0,0.7,0.7]);
%      set(gca, 'XTick',1:length(userindex), 'XTickLabel',userindexstring');
%      hold off
     saveplot(gcf,strcat(path,'aggregate/ChargingElapsedTime'));
     saveas(gcf,strcat(path,'aggregate/ChargingElapsedTime'),'fig');
     
     %Overlayed
     gcf = cfigure(50,70);
      bar(1:length(userindex),geomean_elapsedtime,width, ... 
                     'FaceColor',[0.2,0.2,0.5], ...
                      'EdgeColor','none');
      set(gca, 'XTick',1:length(userindex), 'XTickLabel',userindexstring');
         
      hold on
      bar(1:length(userindex),arithmean_elapsedtime,width/4, ... 
                      'FaceColor',[0,0.7,0.7],...
                      'EdgeColor',[0,0.7,0.7]);
      set(gca, 'XTick',1:length(userindex), 'XTickLabel',userindexstring');
      ylabel('Geom-Arith Means for Charging Time (min)', 'FontSize', 15);
      plot(1:length(userindex),ones(length(userindex),1)*mean_geomeanelapsedtime, '--','LineWidth',2, 'Color', [0.2,0.2,0.5]);
      plot(1:length(userindex),ones(length(userindex),1)*median_geomeanelapsedtime, ':','LineWidth',2, 'Color', [0.2,0.2,0.5]);    
      plot(1:length(userindex),ones(length(userindex),1)*mean_arithmeanelapsedtime, '-','LineWidth',2, 'Color', [0,0.7,0.7]);
      plot(1:length(userindex),ones(length(userindex),1)*median_arithmeanelapsedtime, '-.','LineWidth',2, 'Color', [0,0.7,0.7]);       
      hold off
     legend('Geom. Mean', 'Arith. Mean', 'Mean of Geom.Mean', 'Median of Geom. Mean', 'Mean of Arith.Mean', 'Median of Arith.Mean');
    xlabel('User ID', 'FontSize', 15);
     saveplot(gcf,strcat(path,'aggregate/ChargingElapsedTimeoverlayed'));
     saveas(gcf,strcat(path,'aggregate/ChargingElapsedTimeoverlayed'),'fig');
end

%% Draw Plugged vs Level 

if ~isempty(geomean_pluggingvslevel) 
     width = 0.5;
     
     gcf = cfigure(50,70);
     
     
     subplot(2,1,1);title('geo. and arith. mean of charging duration');
     bar(1:length(userindex),geomean_pluggingvslevel,width, ... 
                     'FaceColor',[0.2,0.2,0.5], ...
                     'EdgeColor','none');
     set(gca, 'XTick',1:length(userindex), 'XTickLabel',userindexstring');
     ylabel('Geom. Mean','FontSize',15);
     
     %put the statistics
     hold on
     plot(1:length(userindex),ones(length(userindex),1)*mean_geomeanpluggingvslevel, '--','LineWidth',2);
     plot(1:length(userindex),ones(length(userindex),1)*median_geomeanpluggingvslevel, ':','LineWidth',2);     
     hold off
     legend('Geom. Mean', 'Mean', 'Median');
     
     subplot(2,1,2);
     bar(1:length(userindex),arithmean_pluggingvslevel,width, ... 
                     'FaceColor',[0,0.7,0.7],...
                     'EdgeColor',[0,0.7,0.7]);
     ylabel('Arith. Mean','FontSize', 15);
     set(gca, 'XTick',1:length(userindex), 'XTickLabel',userindexstring');
     %put the statistics
     hold on
     plot(1:length(userindex),ones(length(userindex),1)*mean_arithmeanpluggingvslevel, '--','LineWidth',2);
     plot(1:length(userindex),ones(length(userindex),1)*median_arithmeanpluggingvslevel, ':','LineWidth',2);     
     hold off
     legend('Geom. Mean', 'Mean', 'Median');
     
     
     
     %Overlayed
%      subplot(3,1,3);
%      legend('Geom. Mean','Arith. Mean');
%      title('geo. and arith. mean of plugged vs level');
%      bar(1:length(userindex),geomean_pluggingvslevel,width, ... 
%                      'FaceColor',[0.2,0.2,0.5], ...
%                      'EdgeColor','none');
%      set(gca, 'XTick',1:length(userindex), 'XTickLabel',userindexstring');
%         
%      hold on
%      bar(1:length(userindex),arithmean_pluggingvslevel,width/2, ... 
%                      'FaceColor',[0,0.7,0.7],...
%                      'EdgeColor',[0,0.7,0.7]);
%      set(gca, 'XTick',1:length(userindex), 'XTickLabel',userindexstring');
%      hold off
     saveplot(gcf,strcat(path,'aggregate/pluggedvslevel'));
     saveas(gcf,strcat(path,'aggregate/pluggedvslevel'),'fig');
     
     
     %Overlayed
     gcf = cfigure(50,70);
      bar(1:length(userindex),geomean_pluggingvslevel,width, ... 
                      'FaceColor',[0.2,0.2,0.5], ...
                      'EdgeColor','none');
      set(gca, 'XTick',1:length(userindex), 'XTickLabel',userindexstring');
         
      hold on
      bar(1:length(userindex),arithmean_pluggingvslevel,width/4, ... 
                      'FaceColor',[0,0.7,0.7],...
                      'EdgeColor',[0,0.7,0.7]);
      set(gca, 'XTick',1:length(userindex), 'XTickLabel',userindexstring');
      
      ylabel('Geom-Arith Mean for SOC at Charging Event (%)', 'FontSize', 15);
      
      plot(1:length(userindex),ones(length(userindex),1)*mean_geomeanpluggingvslevel, '--','LineWidth',2, 'Color', [0.2,0.2,0.5]);
      plot(1:length(userindex),ones(length(userindex),1)*median_geomeanpluggingvslevel, ':','LineWidth',2, 'Color', [0.2,0.2,0.5]);       
      
      plot(1:length(userindex),ones(length(userindex),1)*mean_arithmeanpluggingvslevel,  '-','LineWidth',2, 'Color', [0,0.7,0.7]);
      plot(1:length(userindex),ones(length(userindex),1)*median_arithmeanpluggingvslevel,  '-.','LineWidth',2, 'Color', [0,0.7,0.7]);    
      hold off     
      legend('Geom. Mean', 'Arith. Mean', 'Mean of Geom.Mean', 'Median of Geom. Mean', 'Mean of Arith.Mean', 'Median of Arith.Mean');  
      xlabel('User ID', 'FontSize', 15);
      saveplot(gcf,strcat(path,'aggregate/pluggedvsleveloverlayed'));
      saveas(gcf,strcat(path,'aggregate/pluggedvsleveloverlayed'),'fig');
      
end

%% Draw Unplugged vs Level 

if ~isempty(geomean_unpluggingvslevel) 
     width = 0.5;
     
     gcf = cfigure(50,70);
     
     subplot(2,1,1);title('geo. and arith. mean of unplugged vs level');
     bar(1:length(userindex),geomean_unpluggingvslevel,width, ... 
                     'FaceColor',[0.2,0.2,0.5], ...
                     'EdgeColor','none');
     set(gca, 'XTick',1:length(userindex), 'XTickLabel',userindexstring', 'TickDir', 'in');
     ylabel('Geom. Mean');
     
     %put the statistics
     hold on
     plot(1:length(userindex),ones(length(userindex),1)*mean_geomeanunpluggingvslevel, '--');
     plot(1:length(userindex),ones(length(userindex),1)*median_geomeanunpluggingvslevel, ':');     
     hold off

     subplot(2,1,2);
     bar(1:length(userindex),arithmean_unpluggingvslevel,width, ... 
                     'FaceColor',[0,0.7,0.7],...
                     'EdgeColor',[0,0.7,0.7]);
     ylabel('Arith. Mean');
     set(gca, 'XTick',1:length(userindex), 'XTickLabel',userindexstring', 'TickDir', 'in');
     %put the statistics
     hold on
     plot(1:length(userindex),ones(length(userindex),1)*mean_arithmeanunpluggingvslevel, '--');
     plot(1:length(userindex),ones(length(userindex),1)*median_arithmeanunpluggingvslevel, ':');     
     hold off
     
     
     
%      %Overlayed
%      subplot(3,1,3);
%      legend('Geom. Mean','Arith. Mean');
%      title('geo. and arith. mean of charging duration');
%      bar(1:length(userindex),geomean_unpluggingvslevel,width, ... 
%                      'FaceColor',[0.2,0.2,0.5], ...
%                      'EdgeColor','none');
%      set(gca, 'XTick',1:length(userindex), 'XTickLabel',userindexstring');
%         
%      hold on
%      bar(1:length(userindex),arithmean_unpluggingvslevel,width/2, ... 
%                      'FaceColor',[0,0.7,0.7],...
%                      'EdgeColor',[0,0.7,0.7]);
%      set(gca, 'XTick',1:length(userindex), 'XTickLabel',userindexstring');
%      hold off
     saveplot(gcf,strcat(path,'aggregate/unpluggedvslevel'));
     saveas(gcf,strcat(path,'aggregate/unpluggedvslevel'),'fig');
     
     
     %overlayed
      gcf = cfigure(50,70);
      bar(1:length(userindex),geomean_unpluggingvslevel,width, ... 
                      'FaceColor',[0.2,0.2,0.5], ...
                      'EdgeColor','none');
      set(gca, 'XTick',1:length(userindex), 'XTickLabel',userindexstring');
         
      hold on
      bar(1:length(userindex),arithmean_unpluggingvslevel,width/4, ... 
                      'FaceColor',[0,0.7,0.7],...
                      'EdgeColor',[0,0.7,0.7]);
      set(gca, 'XTick',1:length(userindex), 'XTickLabel',userindexstring');
      ylabel('Geom-Arith Mean for the SOC at unplugging Event (%)', 'FontSize', 15);
      plot(1:length(userindex),ones(length(userindex),1)*mean_geomeanunpluggingvslevel, '--','LineWidth',2, 'Color', [0.2,0.2,0.5]);
      plot(1:length(userindex),ones(length(userindex),1)*median_geomeanunpluggingvslevel, ':','LineWidth',2, 'Color', [0.2,0.2,0.5]);     
      plot(1:length(userindex),ones(length(userindex),1)*mean_arithmeanunpluggingvslevel, '-','LineWidth',2, 'Color', [0,0.7,0.7]);
      plot(1:length(userindex),ones(length(userindex),1)*median_arithmeanunpluggingvslevel, '-.','LineWidth',2, 'Color', [0,0.7,0.7]);     
      hold off
      legend('Geom. Mean', 'Arith. Mean', 'Mean of Geom.Mean', 'Median of Geom. Mean', 'Mean of Arith.Mean', 'Median of Arith.Mean');  
      xlabel('User ID', 'FontSize', 15);
      saveplot(gcf,strcat(path,'aggregate/unpluggedvsleveloverlayed'));
      saveas(gcf,strcat(path,'aggregate/unpluggedvsleveloverlayed'),'fig');
end
return

%% Draw the histogram of the means of all users 

%Hist of mean of plugged vs level 

gcf = cfigure(50,70);
subplot(2,1,1)
hist(arithmean_pluggingvslevel, 10);title('Histogram of means of plugged vs SOC')
ylabel('Histogram of Airthmetic Mean');
hold on
subplot(2,1,2)
hist(geomean_pluggingvslevel, 10); ylabel('Histogram of Geometric Mean');
hold off
saveplot(gcf,strcat(path,'aggregate/histofmeansofpluggedvslevel'));
saveas(gcf,strcat(path,'aggregate/histofmeansofpluggedvslevel'),'fig');



% Hist of mean of charging duration
gcf = cfigure(50,70);
%assumption: Remove the outlayers. Remove whatever means is above 900 min
indicesremove = find(arithmean_chargingduration >= 700);
arithmean_chargingduration(indicesremove) = [];
subplot(2,1,1)
hist(arithmean_chargingduration); title('Histogram of mean of charging duration')
ylabel('Histogram of Airthmetic Mean');
hold on
subplot(2,1,2)
%Remove outlayers
indicesremove = find(geomean_chargingduration >= 700);
geomean_chargingduration(indicesremove)=[];
hist(geomean_chargingduration); ylabel('Histogram of Geometric Mean');
hold off
saveplot(gcf,strcat(path,'aggregate/histofmeansofchargingduration'));
saveas(gcf,strcat(path,'aggregate/histofmeansofchargingduration'),'fig');




%Hist of mean of duration full and plugged
gcf = cfigure(50,70);
subplot(2,1,1)
%Remove outlayers
indicesremove = find(arithmean_durationfullandplugged >= 700);
arithmean_durationfullandplugged(indicesremove)=[];
hist(arithmean_durationfullandplugged);title('Histogram of mean of duration full and plugged')
ylabel('Histogram of Airthmetic Mean');
hold on
subplot(2,1,2)
%Remove outlayers
indicesremove = find(geomean_durationfullandplugged >= 700);
geomean_durationfullandplugged(indicesremove)=[];
hist(geomean_durationfullandplugged); ylabel('Histogram of Geometric Mean');
hold off
saveplot(gcf,strcat(path,'aggregate/histofmeansofdurationfullandplugged'));
saveas(gcf,strcat(path,'aggregate/histofmeansofdurationfullandplugged'),'fig');


%% Classify users
user_vs_class = [];
for d = 1:length(data.AllUsersData)
    if isempty(data.AllUsersData(d).class)
        continue;
    else
        user_vs_class(end+1,:)=[d, data.AllUsersData(d).class, str2num(data.AllUsersData(d).userIndex)];
    end
end
numinClass1 = length(find(user_vs_class(:,2) == 1)); % > 50%
numinClass2 = length(find(user_vs_class(:,2) == 2)); % 30% to 50%
numinClass3 = length(find(user_vs_class(:,2) == 3)); % < 40%


% numinClass1 = sum(user_vs_class(:,2));
% numinClass0 = length(user_vs_class(:,2)) - numinClass1;

gcf = cfigure(30,20);
pie([numinClass1;numinClass2;numinClass3]); title('Classification of Users based on State of charge at plugging time');
legend('Class 1: Above 60%','Class 2: Between 40% and 60%', 'Class 3: Less than 40%');
saveplot(gcf,strcat(path,'aggregate/userClassification')); 
saveas(gcf,strcat(path,'aggregate/userClassification'),'fig');

end

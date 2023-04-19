clc
clear

tbl = readtable('rsfmeasureddata2011.csv');
building_net = tbl(:,11);
building_net = table2array(building_net);


date_time = tbl(:,2);
date_time = table2array(date_time)';
date_time_arr = datetime(date_time, 'InputFormat', 'MM/dd/yyyy HH:mm');

hour_arr = hour(date_time_arr)';

ds = [hour_arr, building_net];


%I'll say peak daily demand (W)
%Min daily demand
%hours between peak and min
%hour of day when peak occurs
%diff between peak and min (W)
%avg power demand (W)
customer = [];

for cust = 1:365
    max_power = 0;
    min_power = 10000;
    hour_of_peak = 0;
    hour_of_min = 0;

    total_power_consumed = 0;
    for hour = 1:23
        %updates the peak daily demand(W)
        if (ds(hour*cust, 2) > max_power)
            max_power = ds(hour*cust,2);
            hour_of_peak = hour; %updates the peak hour
        end

        %updates the min daily demand (W)
        if (ds(hour*cust, 2) < min_power)
            min_power = ds(hour*cust,2);
            hour_of_min = hour; %updates the min hour
        end
        
        %updates the total power consumed to calc mean
        total_power_consumed = total_power_consumed + ds(hour*cust, 2);

        
    end

    
    avg_power = total_power_consumed / 23;
    diff_peak_min_power = max_power - min_power;
    diff_peak_min_hour = abs(hour_of_peak - hour_of_min); %abs so alwasy pos

    customer{cust, 1} = [max_power];
    customer{cust, 2} = [min_power];
    customer{cust, 3} = [avg_power];
    customer{cust, 4} = [hour_of_peak];
    customer{cust, 5} = [hour_of_min];
    customer{cust, 6} = [diff_peak_min_power];
    customer{cust, 7} = [diff_peak_min_hour];


end


final_table = cell2table(customer);

final_table.Properties.VariableNames = {'Max Power (W)','Min Power (W)', 'Average Power (W)','Hour of Peak Power','Hour of Min Power','Different in Peak and Minimum Power (W)','Difference in Peak and Minimum Hours'};

writetable(final_table, 'final_table.csv')



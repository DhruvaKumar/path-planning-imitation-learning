
% =========================== Desciption ===============================
%
% Author: Dhruva Kumar
% 
% test script to plot the shortest distance given the cost map
%
% i/p: cost map
% 
% how to use: click on two points, it'll display the shortest path
%             press any button to clear and continue to the next trial
%
% ======================================================================

% add path and set cd
% addpath(genpath('/home/dhruva/Documents/Learning in Robotics/5-Path_planning'));
% cd '/home/dhruva/Documents/Learning in Robotics/5-Path_planning'

% load cost map
load models/costMapVeh
% load models/costMapPed

% load init
I = imread('aerial_resize.jpg');

costMap = exp(s);
while (1)
    figure(30),
    imshow(I), hold on,
    [x,y] = ginput(2);
    
    start = round([x(1), y(1)]);
    goal = round([x(2), y(2)]);
    ctg = dijkstra_matrix(costMap, goal(2), goal(1));
    [ip2, jp2] = dijkstra_path(ctg, costMap, start(2), start(1));
    
    plot(jp2, ip2, 'b-', 'LineWidth', 2);
    pause;
   
    hold off;
end




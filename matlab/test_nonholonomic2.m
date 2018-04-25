% generate random cost map 
costs = gen_costs(100, 100, .03);

goal = [60 60 1.25*pi];
start = [1 1 .25*pi];

tic,
% USAGE
%  [cost_to_go] = dijkstra_nonholonomic(A, xya_goal, xya_start);
%
% INPUT
%   A: cost map
%   xya_goal : the goal point [x y orientation]   
%   xya_start : the starting point [x y orientation]  
% 
% OUTPUT
%   cost-to-go: cost-to-go for 16 different orientations. 
%               (dimention [x]x[y]x[orientation])
nav = dijkstra_nonholonomic16(costs, goal, start);
toc

% USAGE
%  [xpath, ypath, apath, cpath] = dijkstra_nonholonomic_path(D, ...
% 						  xstart, ystart, astart, ...
% 						  resolution);
% INPUT
%   D : cost-to-go map
%   xstart: x-coordinate of the starting point 
%   ystart: y-coordinate of the starting point 
%   astart: orientation of the starting point 
%   resolution: resolution of motion (set it 1 as default)
% 
% OUTPUT
%   ip : x-coordinates of the path 
%   jp : y-coordinates of the path
%   ap : orientations along the path
%   cp : cost-to-go's along the path
[ip, jp, ap, cp] = dijkstra_nonholonomic_path(nav, ...
                                              start(1), start(2), ...
                                              start(3), 1);
figure(1), hold on;
imagesc(costs,[1 10]);
colormap(1-gray);
hold on;
plot(jp, ip, 'r-');
hold off;
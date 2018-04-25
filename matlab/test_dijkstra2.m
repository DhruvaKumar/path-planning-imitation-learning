% generate random cost map 
costs = gen_costs(2000, 1000, .05);
% costs = zeros(2000,1000);

goal = [1000 1200];
tic;
% USAGE
%  [cost_to_go] = dijkstra_matrix(A,x_goal,y_goal);
%
% INPUT
%   A: cost map
%   x_goal : x-coordinate of the goal point 
%   y_goal : y-coordinate of the goal point 
% 
% OUTPUT
%   cost-to-go: corresponding cost-to-go map 
%               (dimention [x]x[y])
ctg = dijkstra_matrix(costs,goal(1),goal(2));
toc

% USAGE
%  [ip,jp] = dijkstra_path(C,A,x_start,y_start);
%
% INPUT
%   C: cost-to-go map
%   A: cost map
%   x_goal : x-coordinate of the starting point 
%   y_goal : y-coordinate of the starting point 
% 
% OUTPUT
%   ip : x-coordinates of the path 
%   jp : y-coordinates of the path
% 
% NOTE 8-connected neighbors
[ip1, jp1] = dijkstra_path(ctg, costs, 300, 400);


% USAGE, INPUT, OUTPUT
%   same to dijkstra_path
% 
% NOTE 64-connected neighbors
[ip2, jp2] = dijkstra_path2(ctg, costs, 300, 400);

% subplot(1,2,1);
% imagesc(costs,[1 10]);
% colormap(1-gray);
% hold on;
% plot(jp2, ip2, 'r-');
% hold off;
% 
% subplot(1,2,2);
% imagesc(ctg);
% colormap(1-gray);
% hold on;
% plot(jp2, ip2, 'r-');
% hold off;

subplot(1,2,1);
imagesc(costs,[1 10]);
colormap(1-gray);
hold on;
plot(jp1, ip1, 'b-',...
     jp2, ip2, 'r-');
hold off;

subplot(1,2,2);
imagesc(ctg);
colormap(1-gray);
hold on;
plot(jp1, ip1, 'b-',...
     jp2, ip2, 'r-');
hold off;
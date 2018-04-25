
% ============================ Description ===========================
%
% Author: Dhruva Kumar
%
% This script includes the imitation learning algorithm LEARCH
%
% Some results are present in the 'results' directory
% To TEST with the given cost map, please run test.m
%
% Procedure:
%       - Load image and scale it by a factor of 0.2
%       - create the binary feature masks
%           [road, vegetation, buildings, bridge]
%       - Plot desired paths (expert policy) for the modality required
%       - This gets stored in a struct 'trainData' which contains the loss
%       map (using a generalized Hamming loss function along the path)
%       also.
%       
%       - LEARCH
%
% ====================================================================

%% add path and set cd

addpath(genpath('/home/dhruva/Documents/Learning in Robotics/5-Path_planning'));
cd '/home/dhruva/Documents/Learning in Robotics/5-Path_planning'

%% read in image and resize

I_original = imread('aerial_color.jpg');
I = imresize(I_original,0.2);
[m,n,~] = size(I);


%% create feature masks and process them

createFeatMasks;

%% LEARCH

% Train
% trainPaths
load models/trainDataVeh.mat
% load models/trainDataPed.mat

% init params
N = length(trainData);
T = 150;
path_planned = cell(N,T);

% initialize log cost map to 0
s = zeros(m,n);

% alpha learning rate: exponential decay function
% alpha_t = 0.2*exp(-0.1*(0:T-1));

% stack all negative examples beforehand (desired path)
featNeg = [];
for i = 1:N
    featNeg = [featNeg; trainData(i).feat];
end
F_reshape = reshape(F, [], size(F,3));
%%
for t = 1:T
    fprintf('iteration %d \n', t);
    
    % initialize data set to empty
    featPos = []; % neg = []; in the training data
    
    for i = 1:N
        % compute loss augmented costmap
        c_augloss = exp(s) - trainData(i).loss_map;
        
        % remove negatives from cost augmented costmap. shift to zero
        if (min(min(c_augloss)) < 0)
            c_augloss = c_augloss - min(min(c_augloss));
        end
        
        % planned path: find shortest path through loss-augmented costmap
        start = round(trainData(i).start);
        goal = round(trainData(i).end);
        ctg = dijkstra_matrix(c_augloss, goal(2), goal(1));
        [ip2, jp2] = dijkstra_path(ctg, c_augloss, start(2), start(1));
        path_planned{i,t} = [ip2, jp2];

        % generate positve and negative examples for the features of the
        % corresponding planned path and desired path
        ind = sub2ind([m,n], ip2, jp2);
        feat = F_reshape(ind,:);
        featPos = [featPos; feat]; 
    end

    % train svm on data generated. test. 
    feat = [featNeg; featPos];
    train_label = [-ones(size(featNeg,1),1); ones(size(featPos,1),1)];
    
    model = train(train_label, sparse(feat), '-s 11 -q');
    predict_test = predict(zeros(size(F_reshape,1),1), ...
        sparse(double(F_reshape)), model);
    
    % update log cost map
    alpha = 0.1; % learning rate
%     alpha = alpha_t(t);
    predict_test(predict_test>0) = predict_test(predict_test>0) / max(predict_test);
    predict_test(predict_test<0) = -predict_test(predict_test<0) / min(predict_test);

    predict_map = reshape(predict_test, m,n);
    s = s + alpha * predict_map;
    
    % convergence?
    cost_map = exp(s);
    cost_diff_avg = 0;
    for i = 1:N
        ind = sub2ind([m,n], trainData(i).between(:,2), trainData(i).between(:,1));
        cost_desired = sum(cost_map(round(ind)));
        path = path_planned{i,t};
        ind = sub2ind([m,n], path(:,1), path(:,2));
        cost_planned = sum(cost_map(round(ind)));
        cost_diff_avg = cost_diff_avg + abs(cost_desired - cost_planned);
    end
    cost_diff_avg = cost_diff_avg / N;
    fprintf('cost difference: %f \n', cost_diff_avg);
    
    % plot and test
%     figure(1),
% %     imagesc(c_augloss),colormap(gray),  hold on,
%     imagesc(exp(s)),colormap(gray),  hold on,
%     for i = 1:N
%         % plot start and end points
%         plot(trainData(i).start(1), trainData(i).start(2), '*r');
%         plot(trainData(i).end(1), trainData(i).end(2), '*r');
%         % desired path
%         plot(trainData(i).between(:,1), trainData(i).between(:,2), 'b-'), hold on,
%         % planned path
%         path = path_planned{i,t};
%         plot(path(:,2), path(:,1), 'r-');
%     %     plot(jp2, ip2, 'r-');
%     end
%     hold off;
%     pause;
    
end

save('costMapVeh', 's', 'path_planned');
% save('costMapPed', 's', 'path_planned');

%% plot final cost map and paths

N=length(trainData);
figure(22);
imagesc(exp(s)),colormap(gray),  hold on,
for i = 1:N
    % plot start and end points
    plot(trainData(i).start(1), trainData(i).start(2), '*r');
    plot(trainData(i).end(1), trainData(i).end(2), '*r');
    % desired path
    plot(trainData(i).between(:,1), trainData(i).between(:,2), 'b-'), hold on,
    % planned path
    path = path_planned{i,t};
    plot(path(:,2), path(:,1), 'r-');
end
hold off;

%% test

test







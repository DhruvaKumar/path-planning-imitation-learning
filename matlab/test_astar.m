adj_matrix = zeros(4*4, 4*4); 
xy = zeros(4*4, 2); 
counter = 1; 

for i=1:4, 
    for j=1:4, 
        xy(counter,:) = [i,j]; 
        counter = counter + 1; 
    end
end

for i=1:4, 
    for j=1:4, 
        
        current_index = sub2ind([4,4],i,j); 
        
        if(i - 1 >= 1), 
            left_neighbor = [i-1, j]; 
            
            neighbor_index = sub2ind([4,4], left_neighbor(1), left_neighbor(2)); 
            
            adj_matrix(current_index, neighbor_index) = 1; 
        end
        
        if(i + 1 <= 4),
            right_neighbor = [i + 1, j]; 
            
            neighbor_index = sub2ind([4,4], right_neighbor(1), right_neighbor(2)); 
            
            adj_matrix(current_index, neighbor_index) = 1; 
        end
        
        if(j - 1 >= 1), 
            top_neighbor = [i, j-1]; 
            
            neighbor_index = sub2ind([4,4], top_neighbor(1), top_neighbor(2)); 
            
            adj_matrix(current_index, neighbor_index) = 1; 
        end
        
        if(j + 1 <= 4),
            bottom_neighbor = [i, j+1]; 
            
            neighbor_index = sub2ind([4,4], bottom_neighbor(1), bottom_neighbor(2)); 
            
            adj_matrix(current_index, neighbor_index) = 1; 
        end
    end
end
% adj_matrix(1,10000) = 1;

tic;
path = astar_graph(sparse(adj_matrix), xy, [1, 16]); 
% path = astar_graph(sparse(adj_matrix), xy, [1, 10000]); 
toc;

start_xy = ind2sub([4,4], xy(1,:))
% end_xy = ind2sub([4,4], xy(10000,:))
end_xy = ind2sub([4,4], xy(16,:))

[a,b] = ind2sub([4,4], path);

plot(a,b)



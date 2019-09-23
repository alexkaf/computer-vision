%% FUNCTION displ()
% This function calculates the final face movement by examining the energy
% of the ptical flow calculated with Lucas-Kanade Algorithm.

function [displ_x, displ_y] = displ(d_x, d_y)
    
    % At first we calculate the energy velocity vector from the optical
    % flow matrices.
        energy = d_x .^2 + d_y .^ 2;
        
    % We put a threshold on the values of the energy to locate the ones
    % that contribute most to the movement. To do so, we keep the values
    % that are more than the 5% of the maximum of the energy and in order
    % to keep on the next step we apply an inverse comparison (to have
    % value of 1 on the pixels that do not satisfy our condition, so we can
    % erase them easily). 
        max_energy = max(max(energy));
        threshold = 0.05 * max_energy;
        energy_thr = energy < threshold;
    
    % We keep the values that do not satisfy the above condition.
        energy(energy_thr) = 0;
        disp_energy = energy ./ max_energy;
        disp_energy = imresize(disp_energy,3);
        
        figure(1);
        imshow(disp_energy);
        title("Energy optical flow");
       
        
    % We keep those dx and dy that do not satisfy the above condition.
        d_x(energy_thr) = 0;
        d_y(energy_thr) = 0;
    
    % Count the non zero elements of the matrices.
        d_xcount = sum(sum(d_x ~= 0));
        d_ycount = sum(sum(d_y ~= 0));
   
    % Find the sum of dx and dy values.
        d_xsum = sum(sum(d_x));
        d_ysum = sum(sum(d_y));
        
    % Calculate the mean of each direction vector.
        displ_x = d_xsum / d_xcount;
        displ_y = d_ysum / d_ycount;
    
        
end
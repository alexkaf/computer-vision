%% PART 2.2 - harris_laplacian(...): A function for multiscale corner detection.
% This function uses the harris_stephens function on a multiscale way and
% then it combines all the resulting points in one image. We work according
% to the instructions of the lab.

function hl_points = harris_laplacian(image,s,sigma,p,k,th_corn,N)
    % Part 2.2.1 - In this part, we use the same method as before but applied with several
    % scales so we can have more accurate results. At first, we make the scales
    % we want to examine. This will be done according to the formula from the
    % assignment.
        scales = sigma.* s.^(0:N-1);
        ps = p .* p.^(0:N-1);   
    % Part 2.2.2 - Repeat the Harris-Stephens method N times and store the
    % resulting points.
        hs_points = cell(N,1);
        LoG = cell(N,1);
        for i = 1:N
            hs_points{i} = harris_stephens(image,scales(i),ps(i),k,th_corn);
            % We also calculate Lxx and Lyy in order to calculate the
            % normalized Laplacian of Gaussian.
                ns = 2*ceil(3*scales(i)) + 1;
                HSIZE = [ns ns];
                Gs = fspecial('gaussian',HSIZE,scales(i));
                Is = imfilter(image,Gs,'symmetric'); 
                [Lx,Ly] = imgradientxy(Is);
                [Lxx,~] = imgradientxy(Lx);
                [~,Lyy] = imgradientxy(Ly);
                LoG{i} = scales(i)^2 .* abs(Lxx + Lyy);  
        end
        % Finally, we choose those points that do maximize the LoG
        % function in a neighborhood of 2 scales.
           log = LoG{1};
           log_a = LoG{2};
           points = hs_points{1};
           max_sc = log >= log_a;
           t_points = [];
           for j = 1:size(points,1)
               x = points(j,2);
               y = points(j,1);
               if max_sc(x,y) == 1
                   t_points = cat(1,t_points,[y x scales(1)]);
               end
           end
           log = LoG{N};
           log_b = LoG{N-1};
           points = hs_points{N};
           max_sc = log >= log_b;
           for j = 1:size(points,1)
               x = points(j,2);
               y = points(j,1);
               if max_sc(x,y) == 1
                   t_points = cat(1,t_points,[y x scales(N)]);
               end
           end
           for i = 2:N-1
               log = LoG{i};
               log_b = LoG{i-1};
               log_a = LoG{i+1};
               points = hs_points{i};
               max_sc = (log >= log_a) & (log >= log_b);
               for j = 1:size(points,1)
                   x = points(j,2);
                   y = points(j,1);
                   if max_sc(x,y) == 1
                       t_points = cat(1,t_points,[y x scales(i)]);
                   end
               end
           end
           hl_points = t_points;
end
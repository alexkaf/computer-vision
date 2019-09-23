%% PART 2.4 - find_blobs_ms(...): A multiscale approach to find_blobs.
% This function does as similar job with harris_laplacian, but it locates
% blobs instead of corners.
function ms_blobs = find_blobs_ms(image,s,sigma,th_corn,N)
    % We will follow a process similar to harris_laplacian. Hence, no
    % comments are essential.
        scales = sigma .* (s.^(0:N-1));
        
        blobs = cell(N,1);
        LoG = cell(N,1);
        for i = 1:N
            blobs{i} = find_blobs(image,scales(i),th_corn);
                ns = 2*ceil(3*scales(i)) + 1;
                HSIZE = [ns ns];
                Gs = fspecial('gaussian',HSIZE,scales(i));
                Is = imfilter(image,Gs,'symmetric'); 
                [Lx,Ly] = imgradientxy(Is);
                [Lxx,~] = imgradientxy(Lx);
                [~,Lyy] = imgradientxy(Ly);
                LoG{i} = scales(i)^2 .* abs(Lxx + Lyy);  
        end
        
           log = LoG{1};
           log_a = LoG{2};
           points = blobs{1};
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
           points = blobs{N};
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
               points = blobs{i};
               max_sc = (log >= log_a) & (log >= log_b);
               for j = 1:size(points,1)
                   x = points(j,2);
                   y = points(j,1);
                   if max_sc(x,y) == 1
                       t_points = cat(1,t_points,[y x scales(i)]);
                   end
               end
           end
           ms_blobs = t_points;
end
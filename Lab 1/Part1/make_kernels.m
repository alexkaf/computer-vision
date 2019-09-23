%% make_kernels(s): This function creates two kernels.
% The kernels are the Gaussian and the Laplacian of the Gaussian. The sizes
% of the kernels is calclulated acording to the value of standard deviation
% s.
function [G,LoG] = make_kernels(s)
    % Firstly, we calculate the size of the kernel which will be a nxn
    % matrix.
        n = 2*ceil(3*s) + 1;
        HSIZE = [n n];
        G = fspecial('gaussian',HSIZE,s);
        LoG = fspecial('log',HSIZE,s);
end
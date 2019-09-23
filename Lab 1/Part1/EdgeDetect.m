%% PART 1.2 - Edge Detection Algorithm Creation
% In this part we will create an algorithm that can detect the edges on an
% image. We follow the instructions from the lab paper.

function edge_image = EdgeDetect(image,s,LaplacType,th_edge)
    % 1.2.1 First we calculate the impulse response of two discrete linear
    % filters using the function make_kernels.
        [G,LoG] = make_kernels(s);
    
    % 1.2.2 - We try to approximate the Laplacian of the normalized image
    % using two methods, one linear and one non - linear.
    B = strel('arbitrary',[0 1 0; 1 1 1; 0 1 0]);
    Is = imfilter(image,G,'symmetric');
    if LaplacType == 0
        % This is the linear way with the convolution of the gaussian with
        % the image.
            L = imfilter(image,LoG,'symmetric');
    else
        % The second way is a non-linear way, which involves erosion and
        % dilation of the image.
            L = imdilate(Is,B) + imerode(Is,B) - 2.*Is;
    end
    
    % 1.2.3 - Find the zerocrossings of image L.
        % At first, we create the binary singned image X.
            X = (L >= 0);
        % Then we locate the edges of image X.
            Y = imdilate(X,B) - imerode(X,B);
    
    % 1.2.4 - Now we reject the zerocrossing in relatively smooth areas of
    % the image. To do so, we use the given formula, so we conclude that:
        [G_1,G_2] = imgradientxy(Is);
        abs_grad = sqrt(G_1.^2 + G_2.^2);
        maxIs = max(max(abs_grad));
        edge_image = (Y == 1)&(abs_grad > th_edge * maxIs);
end
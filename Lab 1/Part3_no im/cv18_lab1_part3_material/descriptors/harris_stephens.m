%% Part 2.1 - harris_stephens(...): A function to locate corners.
% In the first part, we will use the Harris-Stephens method to
% locate the corners in the given image. First, we set some parameters that
% will be used.

function points = harris_stephens(image,sigma,p,k,th_corn)
    %Part 2.1.1 - At first, we calculate J1,J2,J3 which are elements of tensor J.
        ns = 2*(ceil(3*sigma)) + 1;
        np = 2*(ceil(3*p)) + 1;
        HSIZEs = [ns ns];
        HSIZEp = [np np];
        Gs = fspecial('gaussian',HSIZEs,sigma);
        Gp = fspecial('gaussian',HSIZEp,p);
    
    % Now we can calculate the Js.
        Is = imfilter(image,Gs,'symmetric');
        [Isx,Isy] = imgradientxy(Is);
        J1 = imfilter((Isx .^ 2),Gp,'symmetric');
        J2 = imfilter((Isx .* Isy),Gp,'symmetric');
        J3 = imfilter((Isy .^ 2),Gp,'symmetric');
    
    % Part 2.1.2 - Calculate the eigenvalues of the J array according to
    % the given formula.
        lambda_plus = 1/2 .* (J1 + J3 + sqrt((J1 - J3) .^2 + 4 .* J2.^2));
        lambda_minus = 1/2 .* (J1 + J3 - sqrt((J1 - J3) .^2 + 4 .* J2.^2));
    
    % Part 2.1.3 - We will use those eigenvalues in order to apply the
    % corner criterion. At first, we calculate the array R on which the
    % criterion will be applied.
        R = lambda_plus .* lambda_minus - k .* (lambda_minus + lambda_plus) .^ 2;
        
    % Apply condition 1.
        ns = ceil(3*sigma)*2 + 1;
        B_sq = strel('disk',ns);
        Cond1 = (R == imdilate(R,B_sq));
    
    % Apply condition 2.
        Cond2 = (R > th_corn * max(max(R)));
    
    % Combine those 2 conditions to get the final points.
        points = Cond1 & Cond2;
        [row,column] = find(points == 1);
        sigmas(1:size(row,1),1) = sigma;
        points = [column row sigmas];
end
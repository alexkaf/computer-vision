%% FUNCTION lk() that implements the Lucas-Kanade Algorithm.
function [d_x, d_y] = lk(I1,I2,rho,epsilon,d_x0,d_y0)
   
    % Calculate the sigma of the Gaussian.
        n = 2 * ceil(3 * rho) + 1;
        Gp = fspecial('gaussian',[n n],rho);
        
    % Initialize the d_xi and d_yi values;
        d_xi = d_x0;
        d_yi = d_y0;
        [dI1x, dI1y] = gradient(I1);
    
    % Iterate in order to make the dx and dy variables converge.
        [x_0, y_0] = meshgrid(1:size(I1,2),1:size(I1,1));
        
        for i = 1:50
            intI1 = interp2(I1,x_0 + d_xi,y_0 + d_yi,'linear',0);

        % Calculate the derivatives of the image and interpolate them.
            A1 = interp2(dI1x,x_0 + d_xi, y_0 + d_yi,'linear',0);
            A2 = interp2(dI1y,x_0 + d_xi, y_0 + d_yi,'linear',0);

        % Calculate E.
            E = I2 - intI1;

        % Calculate u.
            A = imfilter(A1.^2,Gp,'symmetric') + epsilon;
            B = imfilter(A1.*A2,Gp,'symmetric');
            C = imfilter(A2.^2,Gp,'symmetric') + epsilon;
            D = imfilter(A1.*E,Gp,'symmetric');
            E = imfilter(A2.*E,Gp,'symmetric');
            u_x = (B.*E - C.*D)./(B.^2 - A.*C);
            u_y = -(A.*E - B.*D)./(B.^2 - A.*C);
            
        % Calculate the new d_xi after the calculated u.
            d_xi = d_xi + u_x;
            d_yi = d_yi + u_y;
            
        % Check a condition to stop the algortithm if it is converging to a
        % point.
%              if (norm(u_x) <= 0.5 && norm(u_y) <= 0.5)
%                  break;
%              end
     
        end
        
        d_x = d_xi;
        d_y = d_yi;
    
end
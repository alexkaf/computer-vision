%% tune_params(...): A function to find the best parameter comnination.
% Our purpose here is to maximize the accuracy percentage by combining the
% parameters in such a way that it reaches it maximum value.
function best_params = tune_params(image,psnrs,sigmas,types,thetas)
    % At first we find the real edges of the image.
        edges_0 = real_edges(image,0.2);
    
    % Then, we do the following tuning.
        best_params = zeros(size(psnrs,2),5);
        
        for psnr = psnrs
            % Calculate the noisy image and set the maximum.
                noisy_image = add_noise(image,psnr);
                maximum_C = 0;
            % Try all the parameter combinations.
                for sigma = sigmas
                    for theta = thetas
                        for type = types  
                            edges_x = EdgeDetect(noisy_image,sigma,type,theta);
                            C = calculate_accuracy(edges_0,edges_x);
                            if maximum_C < C
                                maximum_C = C;
                                best_params(psnr/10,:) = [psnr sigma type theta C];
                            end
                        end
                    end
                end
        end
end
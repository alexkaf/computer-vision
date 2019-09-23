%% add_noise(image,psnr): This function makes an image with a desired PSNR
function image_psnr = add_noise(image,psnr)
    % Firstly, let's calculate the correct standard deviation in order to
    % achieve the desired PSNR. From the given formula, it follows that:
        Imax = max(max(image));
        Imin = min(min(image));
        dev = (Imax - Imin) ./ 10.^(psnr/20);
        image_psnr = imnoise(image,'gaussian',0,dev^2);
end
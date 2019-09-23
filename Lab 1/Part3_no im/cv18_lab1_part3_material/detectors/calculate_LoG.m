function LoG_norm = calculate_LoG(sigma,I)
  n = ceil(3*sigma)*2+1;
  Gaussian = fspecial('Gaussian',n,sigma);
  Is = imfilter(I,Gaussian,'symmetric');
  [gx,gy]= gradient(Is);
  [gxx,gxy]=gradient(gx);
  [gyx,gyy]=gradient(gy);
  LoG_norm = sigma.^2 * abs(gxx + gyy);
end

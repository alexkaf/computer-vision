function Final_Points  = box_det_multiscale(I,sigma,s,theta_corn,N)

%Part 2.5.2


%at first we calculate the normalized Laplacian of Gaussian LoG for all scales!!
%and we also find all corners pixels for each scale
% sizes = zeros(N,2);
% for i = 1:N;
%   current_sigma = sigma * s.^(i-1);
%   norm_LoG(i,:,:) = calculate_LoG(current_sigma,I);
%   Box_temp = box_det(I,current_sigma,theta_corn);
%   sizes(i,:) = size(Box_temp);
%   if(i==1) maxsize = size(Box_temp);
%   end
%   Box_mult(i,:,:) = cat(1,Box_temp,zeros(maxsize(1)-size(Box_temp,1),3 ) );
%   
% end

    for i = 1:N;
      current_sigma = sigma * s.^(i-1);
      norm_LoG(i,:,:) = calculate_LoG(current_sigma,I);
      Box_temp = box_det(I,current_sigma,theta_corn);
      sizes(i,:) = size(Box_temp);

    end
    maxsize = max(sizes);
    for i = 1:N;
      current_sigma = sigma * s.^(i-1);
      norm_LoG(i,:,:) = calculate_LoG(current_sigma,I);
      Box_temp = box_det(I,current_sigma,theta_corn);
      Box_mult(i,:,:) = cat(1,Box_temp,zeros(maxsize(1)-size(Box_temp,1),3 ) );
    end
%now for each interest point we will apply the max_LOG_neighbor criterion
j=1;
for i = 1:N;
  %for k=1:size(Blobs_mult,2);
  for k=1:sizes(i,1);
    if( i==1) 
      if(  norm_LoG(i,Box_mult(i,k,2),Box_mult(i,k,1)) > norm_LoG(2,Box_mult(i,k,2),Box_mult(i,k,1) ) )
        Final_Points(j,:)=Box_mult(i,k,:);
        j=j+1;
      end
    elseif(i==N)
      if(  norm_LoG(i,Box_mult(i,k,2),Box_mult(i,k,1)) > norm_LoG(N-1,Box_mult(i,k,2),Box_mult(i,k,1) ) )
        Final_Points(j,:)=Box_mult(i,k,:);
        j=j+1;
      end
    else
      if(  norm_LoG(i,Box_mult(i,k,2),Box_mult(i,k,1)) > norm_LoG(i-1,Box_mult(i,k,2),Box_mult(i,k,1))  && norm_LoG(i,Box_mult(i,k,2),Box_mult(i,k,1)) > norm_LoG(i+1,Box_mult(i,k,2),Box_mult(i,k,1)) )
        Final_Points(j,:)=Box_mult(i,k,:);
        j=j+1;
      end
    end
  end
end
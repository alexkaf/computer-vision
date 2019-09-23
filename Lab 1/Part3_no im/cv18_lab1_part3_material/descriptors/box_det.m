function [Points] = box_det(I,sigma,theta_corn )
%Part 2.5.1

n=2*ceil(3*sigma)+1;
%omalo padding tis eikonas wste meta to box filter na min vgainei e3w apo
%ta oria autis
Im_padded = padarray(I,[floor(n/2) floor(n/2)],'replicate');

integralIm_padded=integralImage(Im_padded);

%Lxx approximation
hDxx = 4*floor(n/6)+1;
wDxx = 2*floor(n/6)+1;

%Computation for the central box 
shift_Hor = (wDxx -1)/2;
shift_Vert = (hDxx -1)/2;
magnitude = -3;
padding = floor(n/2) + 1;
[a,b,c,d] = shifted_arrays_computation( integralIm_padded, shift_Hor, shift_Vert, 0, 0);
[A,B,C,D] = unpad(a,b,c,d,padding);
Lxx = magnitude*(D + A - B - C);

%Computation for the left and right boxes
shift_Hor =wDxx+ (wDxx -1)/2;
shift_Vert = (hDxx -1)/2;
magnitude = 1;
[a,b,c,d] = shifted_arrays_computation( integralIm_padded, shift_Hor, shift_Vert, 0, 0);
[A,B,C,D] = unpad(a,b,c,d,padding);
Lxx = Lxx + magnitude*(D + A - B - C);


% Lyy
wDyy = 4*floor(n/6) + 1;
hDyy = 2*floor(n/6) + 1;

%Computation for the Central Box
magnitude = -3;
shift_Hor =(wDyy -1)/2;
shift_Vert =(hDyy -1)/2;
padding = floor(n/2) + 1;
[a,b,c,d] = shifted_arrays_computation( integralIm_padded, shift_Hor, shift_Vert, 0, 0);
[A,B,C,D] = unpad(a,b,c,d,padding);
Lyy = magnitude*(D + A - B - C);

%Computation for the Up and Down Box
magnitude = 1;
shift_Hor =(wDyy -1)/2;
shift_Vert =(hDyy -1)/2+hDyy;
padding = floor(n/2) + 1;
[a,b,c,d] = shifted_arrays_computation( integralIm_padded, shift_Hor, shift_Vert, 0, 0);
[A,B,C,D] = unpad(a,b,c,d,padding);
Lyy = Lyy+magnitude*(D + A - B - C); 



%Lxy approximation
wDxy = 2*floor(n/6)+1;
hDxy = 2*floor(n/6)+1;
zDxy = floor((n - wDxy - hDxy)/3);

% %we assume that inline is always 1
% if( mod(ceil((n-2*wDxy)/3),2) == 1)
%     iDxy = ceil((n-2*wDxy)/3);
% else
%     iDxy = floor((n-2*wDxy)/3);
% end;
iDxy=1;

%%%% Lxy approximation
%Computation for the Up Left Box
magnitude = 1;
shift_Hor = (wDxy -1)/2;
shift_Vert = (hDxy -1)/2;
horz_offset = (wDxy -1)/2+(iDxy-1)/2  ; 
vert_offset = (hDxy -1)/2 + (iDxy-1)/2 ;
[a,b,c,d ] = shifted_arrays_computation(integralIm_padded, shift_Hor, shift_Vert, horz_offset,vert_offset);
[A,B,C,D ] = unpad(a,b,c,d,padding);
Lxy = magnitude*(D + A - B - C);
%Computation for the Up Right Box
magnitude = -1;
shift_Hor = (wDxy -1)/2;
shift_Vert = (hDxy -1)/2;
horz_offset = -(iDxy-1)/2 - (wDxy -1)/2; 
vert_offset = (iDxy-1)/2 + (hDxy -1)/2; 
[ a,b,c,d ] = shifted_arrays_computation(integralIm_padded, shift_Hor, shift_Vert, horz_offset,vert_offset);
[A,B,C,D ] = unpad(a,b,c,d,padding);
Lxy = magnitude*(D + A - B - C)  +Lxy;
%Computation for the Down Left Box
magnitude = -1;
shift_Hor = (wDxy -1)/2;
shift_Vert = (hDxy -1)/2;
horz_offset =  (wDxy -1)/2+(iDxy-1)/2 ; 
vert_offset = - (hDxy -1)/2 -(iDxy-1)/2 ; 
[ a,b,c,d ] = shifted_arrays_computation(integralIm_padded, shift_Hor, shift_Vert, horz_offset,vert_offset);
[A,B,C,D ] = unpad(a,b,c,d,padding);
Lxy = Lxy + magnitude*(D + A - B - C);
%Computation for the Down Right Box
magnitude = 1;
shift_Hor = (wDxy -1)/2;
shift_Vert = (hDxy -1)/2;
horz_offset = -(iDxy-1)/2 - (wDxy -1)/2; 
vert_offset = -(iDxy-1)/2 - (hDxy -1)/2; 
[ a,b,c,d ] = shifted_arrays_computation(integralIm_padded, shift_Hor, shift_Vert, horz_offset,vert_offset);
[A,B,C,D ] = unpad(a,b,c,d,padding);
Lxy = Lxy+magnitude*(D + A - B - C);

%Calculate R in order to apply R criterion
R=Lxx.*Lyy - (0.9*Lxy).^2;

%select theta_corn for Thresholding to eliminate weak Blobs
threshold = theta_corn * max(max(R));

%select a disk for non-maxing suspession (to examine neighbor pixels)
ns=ceil(3*sigma)*2+1;
B_sq = strel('disk',ns);

%lets now apply to R thresholding and non-maxing suspession!
Cond1 = ( R == imdilate(R,B_sq) );
Cond2 = ( R > threshold );
Conds=Cond1 & Cond2;
%%save corner-pixels to a Nx3 matrix
[points_temp(:,2),points_temp(:,1)] = find(Conds==1);
Points = horzcat(points_temp,ones(size(points_temp,1),1)*sigma);

end

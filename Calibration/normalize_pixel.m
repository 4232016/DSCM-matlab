function [xn] = normalize_pixel(x_kk,fc,cc,kc,alpha_c)

%normalize
%
%[xn] = normalize_pixel(x_kk,fc,cc,kc,alpha_c)
%
%Computes the normalized coordinates xn given the pixel coordinates x_kk
%and the intrinsic camera parameters fc, cc and kc.
%
%INPUT: x_kk: Feature locations on the images
%       fc: Camera focal length
%       cc: Principal point coordinates
%       kc: Distortion coefficients
%       alpha_c: Skew coefficient
%
%OUTPUT: xn: Normalized feature locations on the image plane (a 2XN matrix)
%
%Important functions called within that program:
%
%comp_distortion_oulu: undistort pixel coordinates.

if nargin < 5,
   alpha_c = 0;
   if nargin < 4;
      kc = [0;0;0;0;0];
      if nargin < 3;
         cc = [0;0];
         if nargin < 2,
            fc = [1;1];
         end;
      end;
   end;
end;


% First: 减去主点，并处以焦距:
x_distort = [(x_kk(1,:) - cc(1))/fc(1);(x_kk(2,:) - cc(2))/fc(2)];

% Second: 纠正偏度
x_distort(1,:) = x_distort(1,:) - alpha_c * x_distort(2,:);

if norm(kc) ~= 0,
	% 补偿透镜畸变:
	xn = comp_distortion_oulu(x_distort,kc);  %补偿径向和切向畸变
else
   xn = x_distort;
end;

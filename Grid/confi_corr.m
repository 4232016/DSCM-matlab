function C = confi_corr(T,A)
 
% 根据文献  "Fast Normalized Cross-Correlation", by J. P. Lewis, Industrial Light & Magic.
% 计算归一化相关系数

[m, n] = size(T);

mean_T = mean(T(:));  
mean_A = mean(A(:));

numer = 0;

% 计算分子项
for i = 1:m
    for j = 1:n
        numer = numer + (A(i,j)-mean_A)*(T(i,j)-mean_T);
    end
end

% 计算分母项

denom_T = std(T(:));
denom_A = std(A(:));

% 计算相关系数

C = numer/(m*n*denom_T*denom_A);
C( ( abs(C) - 1 ) > sqrt(eps(1)) ) = 0;

if 0
    % matlab 自带的相关算法
[T, A] = ParseInputs(varargin{:});
xcorr_TA = xcorr2_fast(T,A);    % 计算 T A 的傅里叶卷积

[m, n] = size(T);
mn = m*n;

local_sum_A = local_sum(A,m,n);
local_sum_A2 = local_sum(A.*A,m,n);

% Note: diff_local_sums should be nonnegative, but may have negative
% values due to round off errors. Below, we use max to ensure the
% radicand is nonnegative.
diff_local_sums = ( local_sum_A2 - (local_sum_A.^2)/mn );
denom_A = sqrt( max(diff_local_sums,0) ); 

denom_T = sqrt(mn-1)*std(T(:));
denom = denom_T*denom_A;
numerator = (xcorr_TA - local_sum_A*sum(T(:))/mn );

% We know denom_T~=0 from input parsing;
% so denom is only zero where denom_A is zero, and in 
% these locations, C is also zero.
C = zeros(size(numerator));
tol = sqrt( eps( max(abs(denom(:)))) );
i_nonzero = find(denom > tol);
C(i_nonzero) = numerator(i_nonzero) ./ denom(i_nonzero);

% Another numerics backstop. If any of the coefficients are outside the
% range [-1 1], the numerics are unstable to small variance in A or T. In
% these cases, set C to zero to reflect undefined 0/0 condition.
C( ( abs(C) - 1 ) > sqrt(eps(1)) ) = 0;
end

%-------------------------------
% Function  local_sum
%
function local_sum_A = local_sum(A,m,n)

% We thank Eli Horn for providing this code, used with his permission,
% to speed up the calculation of local sums. The algorithm depends on
% precomputing running sums as described in "Fast Normalized
% Cross-Correlation", by J. P. Lewis, Industrial Light & Magic.

B = padarray(A,[m n]);
s = cumsum(B,1);
c = s(1+m:end-1,:)-s(1:end-m-1,:);
s = cumsum(c,2);
local_sum_A = s(:,1+n:end-1)-s(:,1:end-n-1);

%-------------------------------
% Function  xcorr2_fast
%
function cross_corr = xcorr2_fast(T,A)

T_size = size(T);
A_size = size(A);
outsize = A_size + T_size - 1;

% figure out when to use spatial domain vs. freq domain
conv_time = time_conv2(T_size,A_size);     % 计算时域相关的时间
fft_time = 3*time_fft2(outsize); % 2 fft2 + 1 ifft2   计算频域相关的时间

if (conv_time < fft_time)
    cross_corr = conv2(rot90(T,2),A);
else
    cross_corr = freqxcorr(T,A,outsize);
end


%-------------------------------
% Function  freqxcorr
%
function xcorr_ab = freqxcorr(a,b,outsize)
  
% calculate correlation in frequency domain
Fa = fft2(rot90(a,2),outsize(1),outsize(2));
Fb = fft2(b,outsize(1),outsize(2));
xcorr_ab = ifft2(Fa .* Fb,'symmetric');

%-------------------------------
% Function  time_conv2
%
function time = time_conv2(obssize,refsize)

K = 2.7e-8; 

time =  K*prod(obssize)*prod(refsize);


%-------------------------------
%
function time = time_fft2(outsize)


R = outsize(1);
S = outsize(2);

K_fft = 3.3e-7; 
Tr = K_fft*R*log(R);

if S==R
    Ts = Tr;
else
%    Ts = time_fft(S);  % uncomment to estimate explicitly
   Ts = K_fft*S*log(S); 
end

time = S*Tr + R*Ts;


%-----------------------------------------------------------------------------
function [T, A] = ParseInputs(varargin)

narginchk(2,2)

T = varargin{1};
A = varargin{2};

validateattributes(T,{'logical','numeric'},{'real','nonsparse','2d','finite'},mfilename,'T',1)
validateattributes(A,{'logical','numeric'},{'real','nonsparse','2d','finite'},mfilename,'A',2)

checkSizesTandA(T,A)

A = shiftData(A);
T = shiftData(T);

checkIfFlat(T);

%-----------------------------------------------------------------------------
function B = shiftData(A)

B = double(A);

is_unsigned = isa(A,'uint8') || isa(A,'uint16') || isa(A,'uint32');
if ~is_unsigned
    
    min_B = min(B(:)); 
    
    if min_B < 0
        B = B - min_B;
    end
    
end

%-----------------------------------------------------------------------------
function checkSizesTandA(T,A)

if numel(T) < 2
    error(message('images:normxcorr2:invalidTemplate'))
end

if size(A,1)<size(T,1) || size(A,2)<size(T,2) 
    error(message('images:normxcorr2:invalidSizeForA'))
end

%-----------------------------------------------------------------------------
function checkIfFlat(T)

if std(T(:)) == 0
    error(message('images:normxcorr2:sameElementsInTemplate'))
end

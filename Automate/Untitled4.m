load('filenamelist_R.mat');

for i = 1:12

fname=filenamelist_R(i,:); 
src = imread(fname);  
result = imadjust(src, [0 1], [1 0]);  
imwrite(result,fname); 
end

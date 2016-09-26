function out_image = gauss_pyramid(in_image)
hgausspymd = vision.Pyramid;
hgausspymd.PyramidLevel = 2;
x= in_image;
y = step(vision.Pyramid,x);
out_image=mat2gray(double(y));

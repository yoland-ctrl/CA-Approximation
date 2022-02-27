%% Approximation of CA Measurements %%
clc, clear, close all
%% MAIN
% Load Image
%Alcohol, Oil and Water on Glass and Plastic (PETE)
file = input('Enter Drop Image: ', 's');
fileName = [file,'.jpg'];
w_1 = imread(fileName);
%% Crop Image and change to grayscale
%[w_1, J] = imcrop(w);
imshow(w_1);
grey = convert2grey(w_1);
%% Fit Circle
[x, y] = select_points(grey);
Re  = circfit(x,y);
%% Thresholding to locate calibration circle and obtain real radius
thresh = input('Enter threshold: '); %Values chosen between 0.75 and 0.95, depending on how dark the image is
final_rad = findradius(grey, Re, thresh);
%% Calculate CA with given info
V = 10; %Volume at ~10uL for each liquid used
[CA_deg] = findCA(V, final_rad)
%% FUNCTIONS
%Split up for implementation in application code
function grey = convert2grey(im) %#codegen
    %grey = (0.2989 * double(R) + 0.5870 * double(G) + 0.1140 * double(B))/255;
    grey = rgb2gray(im);
end
function [x, y] = select_points(w_1) %User selects 4 points from circle
    figure;
    imshow(w_1);
    [x, y] = ginput(4); 
end
function R  = circfit(x,y) %Fit circle around selected points
   x=x(:); y=y(:);
   a=[x y ones(size(x))]\[-(x.^2+y.^2)];
   xc = -.5*a(1);
   yc = -.5*a(2);
   R  =  sqrt((a(1)^2+a(2)^2)/4-a(3));
end
function final_rad = findradius(grey, R, th) %Calculate radius using calibration circle
    yourbwimage = imbinarize(grey,'adaptive','Sensitivity',th);
    figure;
    imshow(yourbwimage);
    %Dot Measurements - 2mm radius, 4mm diameter
    dot = sum(yourbwimage(:) == 0); %counts number of pixels in bead
    fot_rad = (sqrt((dot)/pi)); %number of pixels in 2mm in real life
    dotradius = fot_rad/2; %number of pixels in 1mm 
    % Calibration
    final_rad = R/dotradius %unit = mm
end
function [final_theta] = findCA(V, final_rad) %Calculate CA assuming drop is spherical cap
    % syms theta1 final_rad V
    % sol_theta = simplify(expand(simplify(solve(V == (final_rad/sin(theta1))*((final_rad/sin(theta1))*(1-cos(theta1))^2*(2+cos(theta1)))))));
    theta1 = pi - acos((V - (V^2 - 2*V*final_rad^2 + 9*final_rad^4)^(1/2) + final_rad^2)/(2*final_rad^2));
    final_theta = (180/pi)*theta1
end
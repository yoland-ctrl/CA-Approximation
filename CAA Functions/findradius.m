function final_rad = findradius(grey, R, th) %Calculate radius using calibration circle
    yourbwimage = imbinarize(grey,'adaptive','Sensitivity',th);
    figure;
    %imshow(yourbwimage);
    %Dot Measurements - 2mm radius, 4mm diameter
    dot = sum(yourbwimage(:) == 0); %counts number of pixels in bead
    fot_rad = (sqrt((dot)/pi)); %number of pixels in 2mm in real life
    dotradius = fot_rad/2; %number of pixels in 1mm 
    % Calibration
    final_rad = R/dotradius %unit = mm
end
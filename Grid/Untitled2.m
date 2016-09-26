       moving = imread('onion.png');
       fixed = imread('peppers.png');
       movingPoints = [127 93; 74 59];
       fixedPoints = [323 195; 269 161];
       movingPointsAdjusted = line_cpcorr(movingPoints,fixedPoints,...
                                 moving(:,:,1),fixed(:,:,1));
        %movingPointsAdjusted = cpcorr(movingPoints,fixedPoints,...
         %                       moving(:,:,1),fixed(:,:,1));
       subplot(1,2,2);
       imshow(moving(:,:,1))
       hold on

       x1 = movingPointsAdjusted(1,:);
       y1 = movingPointsAdjusted(2,:);
       plot(x1,y1,'r*');
       hold off
       subplot(1,2,1);
       imshow(fixed(:,:,1)); 
       hold on
       x3 = fixedPoints(1,:);
       y3 = fixedPoints(2,:);
       plot(x3,y3,'g+');

       hold off
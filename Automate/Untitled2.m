     moving = imread('onion.png');
     fixed = imread('peppers.png');
     movingPoints = [127 93; 74 59];
      fixedPoints = [323 195; 269 161];
      %movingPointsAdjusted = search(movingPoints,fixedPoints,moving(:,:,1),fixed(:,:,1))
      movingPointsAdjusted = search(fixedPoints,movingPoints,fixed(:,:,1),moving(:,:,1))
% extract the SURF features of the reference image
templateNum = 1;
load('../data/refCell.mat');
webcamlist;
cam = webcam;
pointTracker = vision.PointTracker('MaxBidirectionalError', 1);
recognized = false;
rect0 = [279,246,361,318];
w = rect0(3)-rect0(1);
h = rect0(4)-rect0(2);
centerX = (rect0(3)+rect0(1))/2;
centerY = (rect0(4)+rect0(2))/2;
totalFrameNum = 10000;
save_rect = zeros(totalFrameNum,4);
figure(1);
hold on;
for i=1:totalFrameNum
    camera = snapshot(cam);
    camera = rgb2gray(camera);
    hold off;
    imshow(camera);
    hold on;
    BW = edge(camera);
    if ~recognized
        cameraPoints = detectSURFFeatures(camera, 'MetricThreshold', 300);
        cameraFeatures = extractFeatures(camera, cameraPoints);
        flag = 0;
        for j=1:templateNum
            idxPairs = matchFeatures(cameraFeatures, referenceFeaturesCell{j});
            rectangle('Position',[centerX-50 centerY-50 w h],'EdgeColor','y');
            save_rect(i,:)=[centerX-50 centerY-50 centerX-50+w centerY-50+h];
            if size(idxPairs,1)<3
                continue;
            end
            matchedCameraPts = cameraPoints(idxPairs(:,1));
            matchedRefPts = referencePointsCell{j}(idxPairs(:,2));  
            [refTrans, inlierRefPts, inlierCamPts, status] = estimateGeometricTransform(matchedRefPts,matchedCameraPts, 'affine');
            disp(inlierCamPts.Count);
            if inlierCamPts.Count<3
                continue;
            end
            flag = 1;
            break;
        end
        if(flag == 0)
            continue;
        end
        initialize(pointTracker,inlierCamPts.Location, camera);
        oldLoc = inlierCamPts.Location;
        recognized = true;
        continue;
    else
        [trackedPoints, isValid] = step(pointTracker, camera);
        if nnz(isValid) < 3
            recognized = false;
            release(pointTracker);
            rectangle('Position',[centerX-50 centerY-50 w h],'EdgeColor','y');
            continue;
        end
        newLoc = trackedPoints(isValid,:);
        oldLoc = inlierCamPts.Location(isValid,:);
        [trackingTrans, oldInLoc, newInLoc,status] = estimateGeometricTransform(oldLoc,newLoc,'similarity');
        setPoints(pointTracker,newLoc);
    end
    centerX = mean(newLoc(:,1));
    centerY = mean(newLoc(:,2));
    scatter(newLoc(:,1),newLoc(:,2));
    rectangle('Position',[centerX-50 centerY-50 w h],'EdgeColor','y');
    save_rect(i,:)=[centerX-50 centerY-50 centerX-50+w centerY-50+h];
    pause(0.005);
end
clear('cam');
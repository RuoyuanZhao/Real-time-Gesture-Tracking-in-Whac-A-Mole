background = imread('../data/map.jpg');
load('../data/rat.mat');
load('../data/hand1.mat');
load('../data/hand2.mat');
load('../data/boom.mat');
load('../data/centers.mat');
webcamlist;
cam = webcam;
pointTracker = vision.PointTracker('MaxBidirectionalError', 3);
recognized = false;
rect0 = [300,200,390,260];
w = rect0(3) - rect0(1);
h = rect0(4) - rect0(2);
centerX = (rect0(3) + rect0(1))/2;
centerY = (rect0(4) + rect0(2))/2;
totalFrameNum = 10000;
figure(1);hold on;
figure(2);hold on;
count = 0;
exist = zeros(1, 9);
caught = zeros(1, 9);
for time = 1:totalFrameNum
    camera = snapshot(cam);
    camera = camera(1:380,end:-1:100,:);
    camera = imresize(camera, [480,640]);
    hold off;
    figure(1);
    imshow(camera);
    camera = rgb2gray(camera);
    output = background;
    hold on;
    [exist,caught,output] = updata_background(output,time,exist,caught,rat,mask_rat,boom,mask_boom,centers);
    if ~recognized
        output = add_object(output, hand1, mask1, [centerY, centerX]);
        rectangle('Position',[centerX-w/2 centerY-h/2 w h],'EdgeColor','y');
        leftmost = max(round([centerY - h/2, centerX - w/2]), [1, 1]);
        leftmost = min(size(camera) - [h,w], leftmost);
        patch = camera(leftmost(1):leftmost(1)+h-1, leftmost(2):leftmost(2)+w-1);
        points = detectHarrisFeatures(patch);
        points = points.Location;
        points(:,1) = points(:,1) + leftmost(2);
        points(:,2) = points(:,2) + leftmost(1);
        if length(points) < 15 || length(points) > 40
            figure(2); hold off; imshow(output);
            count = 0; continue;
        end
        count = count + 1;
        if count < 10
            continue;
        end
        initialize(pointTracker,points,camera);
        [exist,caught] = catch_rats(exist,caught, centers, centerX, centerY);
        oldLoc = points;
        recognized = true;
        continue;
    else
        output = add_object(output, hand2, mask2, [centerY, centerX]);
        [trackedPoints, isValid] = step(pointTracker, camera);
        if length(isValid) - nnz(isValid) > length(isValid)/3 || length(isValid) - nnz(isValid) > 5
            recognized = false;
            release(pointTracker);
            rectangle('Position',[centerX-w/2 centerY-h/2 w h],'EdgeColor','y');
            continue;
        end
        newLoc = trackedPoints(isValid,:);
        setPoints(pointTracker,newLoc);
    end
    centerX = mean(newLoc(:,1));
    centerY = mean(newLoc(:,2));
    scatter(newLoc(:,1),newLoc(:,2));
    rectangle('Position',[centerX-w/2 centerY-h/2 w h],'EdgeColor','y');
    figure(2); hold off; imshow(output);
    pause(0.005);
end
clear('cam');
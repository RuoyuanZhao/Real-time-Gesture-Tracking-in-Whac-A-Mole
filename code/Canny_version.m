background = imread('../data/map.jpg');
load('../data/rat.mat');
load('../data/hand1.mat');
load('../data/hand2.mat');
load('../data/boom.mat');
centers = [150, 155; 150, 305; 155, 465; 240, 135; 240, 310; 240, 465; 340, 125; 345, 305; 345, 480];
webcamlist;
cam = webcam;
pointTracker = vision.PointTracker('MaxBidirectionalError', 3);
recognized = false;
rect0 = [300,200,390,260];
w = rect0(3)-rect0(1);
h = rect0(4)-rect0(2);
centerX = (rect0(3)+rect0(1))/2;
centerY = (rect0(4)+rect0(2))/2;
totalFrameNum = 10000;
save_rect = zeros(totalFrameNum,4);
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
        BW = edge(patch);
        disp(sum(BW(:)));
        score = ssim(double(BW), double(template));
        if score < 0.50
            figure(2); hold off; imshow(output);
            count = 0; continue;
        end
        count = count + 1;
        if count < 10
            continue;
        end
        points = zeros(sum(BW(:)), 2);
        [points(:,1), points(:,2)] = find(BW);
        perm = randperm(length(points), 15);
        points = points(perm,:);
        points(:,1) = points(:,1) + leftmost(2);
        points(:,2) = points(:,2) + leftmost(1);
        hold on;
        for m = 1:length(points)
            plot(points(m,1),points(m,2),'.');
        end
        initialize(pointTracker,points,camera);
        for i = 1:9
            if exist(i) <= 0
                continue;
            elseif abs(centers(i,1) - centerY) + abs(centers(i,2) - centerX) < 50
                exist(i) = 5;
                caught(i) = 5;
            end
        end
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
    save_rect(i,:)=[centerX-w/2 centerY-h/2 centerX+w/2 centerY+h/2];
    figure(2);
    hold off;
    imshow(output);
    pause(0.005);
end
clear('cam');
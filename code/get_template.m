webcamlist;
cam = webcam;
for idx = 1:200
    rgbImage = snapshot(cam);
    grayImage = rgb2gray(rgbImage);
    hold off;
    imshow(grayImage);
    hold on;
    rectangle('Position',[301,201,90,60]);
end
clear('cam');
template = grayImage(201:260,301:390);
%template = imresize(template, [60,80]);
imshow(template);
template = edge(template);
save('../data/template.mat','template');
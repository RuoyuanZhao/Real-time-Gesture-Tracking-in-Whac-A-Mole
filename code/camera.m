webcamlist;
cam = webcam;
video1 = '../data/test.avi';
video2 = '../data/test1.avi';
obj1=VideoWriter(video1); 
open(obj1);
for idx = 1:500
    rgbImage = snapshot(cam);
    grayImage = rgb2gray(rgbImage);
    hold on;
    imshow(grayImage);
    if idx > 50
        writeVideo(obj1, rgbImage);
    end
    hold on;
end
close(obj1);
clear('cam');

obj1 = VideoReader(video1);
obj2 = VideoWriter(video2);
open(obj2);
numFrames = obj1.NumberOfFrames;
 for k = 1 : numFrames
     frame = read(obj1,k);
     frame = rgb2gray(frame);
     writeVideo(obj2, frame);
 end
close(obj2);
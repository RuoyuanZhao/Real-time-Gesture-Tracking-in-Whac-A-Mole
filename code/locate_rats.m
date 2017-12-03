background = imread('../data/map.jpg');
imshow(background);
center = [150, 155; 150, 305; 155, 465; 240, 135; 240, 310; 240, 465; 340, 125; 345, 305; 345, 480];
figure(1);
hold on;
output = background;
for i = 1:9
    output = add_object(output, rat, mask_rat, center(i,:));
end
imshow(output);
save('../data/centers.mat','centers')
img = imread('../data/hand.jpg');
imshow(img);
hand1 = img(25:93,123:-1:63);
imshow(hand1);
hold on;
hand1_b = imbinarize(hand1);
CC = bwconncomp(hand1_b);
points = CC.PixelIdxList{1};
[x, y] = ind2sub(size(hand1_b), points);
mask1 = uint8(ones(size(hand1)));
for i = 1:length(x)
    mask1(x(i),y(i)) = 0;
end
hand1 = repmat(hand1, 1, 1, 3);
mask1 = repmat(mask1, 1, 1, 3);
imshow(hand1);
save('../data/hand1.mat', 'hand1', 'mask1');

clf;
img = imread('../data/hand.jpg');
imshow(img);
hand2 = img(30:90, 330:387);
imshow(hand2);
hold on;
hand2_b = imbinarize(hand2);
CC = bwconncomp(hand2_b);
points = CC.PixelIdxList{1};
[x, y] = ind2sub(size(hand2_b), points);
mask2 = uint8(ones(size(hand2)));
for i = 1:length(x)
    mask2(x(i),y(i)) = 0;
    hand2(x(i),y(i)) = 127;
end
hand2 = repmat(hand2, 1, 1, 3);
mask2 = repmat(mask2, 1, 1, 3);
imshow(hand2);
save('../data/hand2.mat', 'hand2', 'mask2');

clf;
img = imread('../data/rat.jpg');
pad1 = ones(87,550,3) * 255;
pad2 = ones(50,550,3) * 255;
img = cat(1, pad1, img, pad2);
imshow(img);
rat = imresize(img, [110, 110]);
imshow(rat);
hold on;
rat_b = imbinarize(rat);
CC = bwconncomp(rat_b);
points = CC.PixelIdxList{1};
[x, y] = ind2sub(size(rat_b), points);
mask_rat = uint8(ones(size(rat)));
for i = 1:length(x)
    mask_rat(x(i),y(i)) = 0;
    rat(x(i),y(i)) = 127;
end
imshow(rat);
save('../data/rat.mat', 'rat', 'mask_rat');

clf;
img = imread('../data/boom.jpg');
% pad1 = ones(87,550,3) * 255;
% pad2 = ones(50,550,3) * 255;
% img = cat(1, pad1, img, pad2);
imshow(img);
boom = imresize(img, [110, 110]);
imshow(boom);
hold on;
boom_b = imbinarize(boom);
CC = bwconncomp(boom_b);
points = CC.PixelIdxList{1};
[x, y] = ind2sub(size(boom_b), points);
mask_boom = uint8(ones(size(boom)));
for i = 1:length(x)
    mask_boom(x(i),y(i)) = 0;
    boom(x(i),y(i)) = 127;
end
imshow(boom);
save('../data/boom.mat', 'boom', 'mask_boom');
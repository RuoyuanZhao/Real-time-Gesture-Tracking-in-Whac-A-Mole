function output = add_object(background, object, mask, center)
output = background;
[h, w, ~] = size(object);
x = round(center(1) - h / 2);
y = round(center(2) - w / 2);
output(x:x+h-1,y:y+w-1,:) = (1-mask) .* output(x:x+h-1,y:y+w-1,:) + mask .* object;

end


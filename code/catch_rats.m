function [exist,caught] = catch_rats(exist,caught, centers, centerX, centerY)
    for i = 1:9
        if exist(i) <= 0
            continue;
        elseif abs(centers(i,1) - centerY) + abs(centers(i,2) - centerX) < 50
            exist(i) = 5;
            caught(i) = 5;
        end
    end
end


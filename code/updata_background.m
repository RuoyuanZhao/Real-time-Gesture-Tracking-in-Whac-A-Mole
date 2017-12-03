function [exist,caught,output] = updata_background(output,time,exist,caught,rat,mask_rat,boom,mask_boom,centers)
    if mod(time, 60) == 0
        perm = randperm(9, 1);
        exist(perm) = 100;
    end
    for i = 1:9
        if exist(i) > 0
            output = add_object(output, rat, mask_rat, centers(i, :));
        end
        if caught(i) > 0
            output = add_object(output, boom, mask_boom, centers(i, :));
        end
    end
    exist = exist - 1;
    caught = caught - 1;
end


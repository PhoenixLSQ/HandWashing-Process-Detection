function c = Judge_washcurrent(hand,result_et)
%only used to judge current frame if the hand is in the water

[~,col] = find(hand==1);
if result_et == 1
    if min(col)<0.2*size(hand,2)                                            % judge hand exceeding the middle of ROI
        c = 1;
    else
        c = 0;
    end
else
    c = 0;
end
function [result] = Judge_soap(c_sp,j,fps,tt) 

if c_sp(j) == 0    
    if sum(c_sp(1:j)==1)/fps<tt                                             % judge if previous result over exceed the time thresh
        result = 0;
    else
        result = 3;
    end
else
    if sum(c_sp(1:j)==1)/fps<tt
        result = 4;
    else
        result = 5;
    end
end

% num_soap = sum(result==1);
% time = num_soap/fps;
end

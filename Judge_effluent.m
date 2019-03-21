function result = Judge_effluent(score,result_total,j,mint,maxt,ef_et)

if score>mint&&score<maxt                                                   % minthresh < score < maxthresh
    result = 1;
elseif score>=maxt
    if j <= ef_et
        result = mode(result_total(1:j));
    else
        result = mode(result_total(j-ef_et:j-1));
    end
else
    result = 0;
end
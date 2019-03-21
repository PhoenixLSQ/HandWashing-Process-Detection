function result = Judge_wash(c,j,ef)
% judge previous ef frames result and return a final result

if j<=ef
    if mode(c(1:j)) == 1
        result = 1;
    else
        result = 0;
    end
    
else
    
    if mode(c(j-ef:j)) == 1                                                 %mode £ºÈ¡ÖÚÊý
        result = 1;
    else
        result = 0;
    end
end
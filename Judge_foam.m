function result = Judge_foam(num,j,ef,crnt,pfnt,tpft)

% ef= ceil(fps)*2;    %error frame
% crnt = 6;            %thresh of connected region number
% pfnt = 40;           %thresh of positive frame number
% tpft = 3;            %thresh of total positive frame number

    if j<=ef
        pfn(j) = sum(num(1:j)>crnt);     %positive frame number
    else
        pfn(j) = sum(num(j-ef:j)>crnt);
    end
    
%     imshow(IM{j,1})
    %title(num2str(CRnum(j)));
    
    if length(find(pfn>pfnt)) > tpft;
    %if isempty(find(PFnum>PFNthresh))==0
        result = 1;
        %if sum(result(1:j)==1)/fps<1
        %title('已产生足够泡沫');
    else
        result = 0;
        %title('未产生足够泡沫');
    end
    
%    drawnow
    %figure;imshow(diff{j,1})
    %pause(0.02)
end

%a=sort(CRnum,'descend');
% % [n,y]=hist(sum,40);
% % bar(y,n);xlabel('连通区域数量/个');ylabel('对应数量连通区域的帧数/帧');
% % num_soap = sum(result==1);
% % time = num_soap/fps

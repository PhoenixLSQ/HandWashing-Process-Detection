clear;clc;close all

vidObj = VideoReader('Video\yy5.mp4');                                     % inputing video position
load('ROI_yy5.mat')                                                        % load the ROI region
fps = vidObj.FrameRate;                                                    % fps of this video
I_t = read(vidObj,1);                                                      % template image
%% Parameters
stf = 1;                                                                    % start frame
ovf = vidObj.NumberOfFrames;                                                % over frame
time = 0; 

min_et = 0.25;                                                              % min effluent thresh 
max_et = 0.45;                                                              % max effluent thresh 
bwt_et = 30/255;                                                            % thresh of binarization writing
wid_et = 1;     %%%%%%%%%%%%%%%                                             % ͳ�ƴ�ֱ��Ե��Ŀ�ȣ�wid_et+1
ef_et = 10;     %%%%%%%%%%                                                  % error frame of effluent

bwt_ws = 50/255;                                                            % thresh of binarization writing
dlt_ws = 10;                                                                % thresh area of deleting small regions
ef_ws = 20;                                                                 % erro frame of hand washing
epnt_down = 13;%%%%%%%%%%%%%%

lr_sp = 0.1;                                                                % light ratio of soap
tt_sp = 0.5;                                                                % time thresh (s) of soap
lt_sp = 100;                                                                % light thresh of soap

ef_fm = ceil(fps)*2;                                                        % error frame 
bwt_fm = 200/255;                                                           % thresh of binarization writing
dlt_fm = 15;                                                                % thresh area of deleting small regions
rtt_fm = 0.08;                                                              % thresh of connected region number  yy3: 0.14  ,yy5 = 0.08
prtt_fm = 15;                                                               % thresh of positive frame number
tpft_fm = 15;                                                               % thresh of total positive frame number

mina_st = 100;                                                             % min area of set judging
maxa_st = 700;                                                             % max area of set judging

ef_it = 2;                                                                 % interaction
ef_jy = 5;                                                                 % journey
jyt_mv = 10;                                                               % journey thresh of move
jyt_it = 10;                                                               % journey thresh of interact twist
pft_it = 60;                                                               % positive frame number thresh of interact twist
rgt_it = 100;                                                              % connected region area thresh
stt_it = 1;                                                                % set time thresh
rt_it = 0.6;                                                               % ratio of interact

snt_cs = 20;                                                               % set number thresh of cross
dlr_it = 0.69;                                                             % delete ratio of interact twist(bwdlt/hand width)
strelr_cs = 0.086;                                                         % ratio of cross(strel_para/hand width)
tt_cs =3;                                                                  % time thresh
crnt_cs = 4;   %yy3:5 --������Ƶyy3ʱ���轫�β�����Ϊ5                       % ��ͨ��������ֵ of cross
pfnt_cs = 13;                                                              % ������֡����ֵ of cross

tt_bk = 1;                                                                 % time thresh of back
at_bk = 1200;                                                              % area thresh of back���պ����������ֵ
pfnt_bk = 20;                                                              % positive frame number thresh of back
pt_bk = 10;                                                                % parea frame thresh of back
tt_lrbk = 1;                                                               % time thresh of left right back���ж������ֵ�ʱ����ֵ
rgt_lrbk = 150;
dbt_lrbk = 10;                                                             % difference of back thresh of left right back
pfnt_lrbk = 7;                                                             % positive frame number thresh of left right back
%% ROI coordinate extracting
x_point_gs = x_gs(1);
y_point_gs = y_gs(1);
width_gs =  y_gs(2)-y_gs(1);
height_gs = x_gs(2)-x_gs(1);
%% Precomputation
c_et = 0;
result_et = 0;
result_it = 0;
result_cs = 0;
result_lbk = 0;
result_rbk = 0;
ef_cs = fps*tt_cs;
[~,bw_It] = Comp_foam(I_t,bwt_fm,x_gs,y_gs);%%%%%%%%%%%%%%%
tic
figure;
for i = stf:ovf
%     tic
    IM = read(vidObj,i);                                                   % load the ist frame
    j = i-(stf-1);
%%%%%% effluent judging

    [s_et,bw_et,diff_et] = Comp_effluent(IM,I_t,bwt_et,x_et,y_et);         % score of effluent
    %%%%%%%%%%%%%��
    [diff,box_rgb] = Comp_effluent_edge(IM,I_t,x_et,y_et);                 
    rotdiff = imrotate(diff_et,-5,'bilinear','crop');                      % ˳ʱ����ת5��  
    rotde = edge(rotdiff,'sobel',0.05,'vertical');                         % ��ֱ��Ե���
    for k = 1:size(rotde,2)-wid_et  
    vn(k) = length(find(rotde(:,k:k+wid_et)==1));                          % vertical edge pixel number����ֱ��Ե���ظ���
    end
    [epn(j),~] = max(vn);                                                  % edge pixel number
    epnt = 0.6*size(rotde,1);
    if epn(j) > epnt
        c_ep(j) = 1;
    else
        c_ep(j) = 0;
    end

    if c_ep(j) ==1                                                         % jugdg effluent
        result_et(j) = 1;
    elseif s_et>=max_et
        if j <= ef_et
            result_et(j) = mode(result_et(1:j-1));
        else
            result_et(j) = mode(result_et(j-ef_et:j-1));
        end
    else
        result_et(j) = 0;
    end
    %%%%%%%%%%%%%    
%%%%%% hand washing judging    
    [diff_down,box_down] = Comp_effluent_edge(IM,I_t,x_et2,y_et2);
    rotdiff_down = imrotate(box_down,-5,'bilinear','crop');                % ˳ʱ����ת5��  
    rotde_down = edge(rotdiff_down,'sobel',0.03,'vertical');               % ��ֱ��Ե���
    rotde_down(:,1:2) = [];
    rotde_down(:,end-9:end) = [];
    for k = 1:size(rotde_down,2)-wid_et  
    vn_down(k) = length(find(rotde_down(:,k:k+wid_et)==1));                % vertical edge pixel number����ֱ��Ե���ظ���
    end
    [epn_down(j),index] = max(vn_down);                                    % edge pixel number
    if epn_down(j)>epnt_down
        ce_ws = 1;                                                         % current edge result of wash
    else
        ce_ws = 0;
    end
    
    hand_ws = Comp_wash(IM,x_ws,y_ws);                                     % the position of the effluent for hand
     %%%%%%%%  ��
    c_w(j) = Judge_washcurrent(hand_ws,result_et(j));                      % judge current result of washing hand
    if c_w(j)==1 && ce_ws==0
        c_ws(j) = 1;
    else
        c_ws(j) = 0;
    end
    result_ws(j) = Judge_wash(c_ws,j,ef_ws);                               % judge total result of washing hand 
     %%%%%%%%  
    time_ws = length(find(result_ws==1))/fps;                              % time of putting hands into the water
    
%%%%%% soap gathering judging

    [hl,hand_sp] = Comp_soap_new(IM,x_sp,y_sp);                            % compute the high light region ratio
    if hl>lr_sp
        c_sp(j) = 1;
    else
        c_sp(j) = 0;
    end
    [result_sp(j)] = Judge_soap(c_sp,j,fps,tt_sp);                         % the result of judging if get the soap
    
%%%%%% foam generating judging   
%  result_sp(j) = 3;
if result_sp(j) == 3
    
    [s_fm(i),bw_fm,gray] = Comp_foam(IM,bwt_fm,x_fm,y_fm);%%%%%%%%%%       % compute the number of connected regions and hand image
    rt_fm(j) = s_fm(i);

    if j<=ef_fm
        prt_fm(j) = sum(rt_fm(1:j)>rtt_fm);                                % positive frame number;(positive :number of connected region meet the condition)
    else
        prt_fm(j) = sum(rt_fm(j-ef_fm:j)>rtt_fm);                          % positive frame number in previous ef_fm frames
    end
    
     if length(find(prt_fm>prtt_fm)) > tpft_fm                            % total thresh if meet the condition
        rst_fm(j) = 1;
    else
        rst_fm(j) = 0;
     end
     if sum(rst_fm==1)>1
         result_fm(j) = 1;
     else
         result_fm(j) = 0;
     end
else
     result_fm(j) = 0;
end
% toc
%% Gesture 
if result_sp(j) == 3
%     tic
    box = imcrop(IM,[y_point_gs,x_point_gs,width_gs,height_gs]);
    box = imresize(box,0.3);
    box_c = ColorEnhance(box);
    I = skindetect2(box_c);
%     toc
    %% Move
%     tic
    rgdl = bwareaopen(I,5);                                                % ɾ�����С��5�����
    [~,xi,yi,wi(j),hi] = autoroi2(rgdl);                                   % xiΪ���Ͻǵ������У�yiΪ������
    Ifill = imfill(rgdl,'holes');
    Ifill(:,1) = 0;
    I_reg_mv = regionprops(~Ifill,'area','boundingbox');                   % ͳ��Ifillȡ��ͼƬ����ͨ�������λ��
    [Area_mv,idx_mv] = sort([I_reg_mv.Area],'descend');
    crn_mv(j) = length(I_reg_mv);                                          % connected region number_move:��ͨ������
    % set���жϴ�'�ɼ�ϴ��Һ������뿪ϴ��Һ'���ʱ��㵽'�ֱ۲�£��ʼ����ϴ����'�ڼ䣬�ֱ��Ƿ�ڷź���
    if crn_mv(j)>1 && Area_mv(2)>mina_st && Area_mv(2)<maxa_st
        pfn_st(j) = 1;
    else
        Area_mv(2)=0;
        pfn_st(j) = 0;
    end
    if j <= stt_it*ceil(fps)                                               % ȡʱ����ֵstt_it�ڵĽ��������֮ǰ2s�ڵ��жϽ��
        if sum(pfn_st(1:end)==1)/(stt_it*ceil(fps)) > rt_it
            set(j) = 1;
        else
            set(j) = 0;
        end
    else
        if sum(pfn_st(j-stt_it*ceil(fps):end)==1)/(stt_it*ceil(fps)) > rt_it 
            set(j) = 1;
        else
            set(j) = 0;
        end
    end
%  set(j) = 1;
    if sum(set==1) > 0                                                     % set=1,���ж�˫���Ѿ���λ����ʼ�������̬�ж�
        if crn_mv(j) > 1 && I_reg_mv(idx_mv(2)).Area > rgt_it              % ��ͨ����>1�ҵڶ������ͨ������������ֵ
            y_end = I_reg_mv(idx_mv(2)).BoundingBox(1);                    % ȡ�ڶ������ͨ�����С�� y_end ��Ϊ��������
            wi(j) = abs(y_end-yi);                                         % ��£���˫�ֵ����ֳ�
            
            for m = 1 : (ef_it-1)
                if j <= m
                    dw(m,j) = 0;
                else
                    dw(m,j) = wi(j) - wi(j-m);                             % ��֮֡�����ֳ��Ĳ�:difference of widths
                end
            end
            
            if j < ef_jy
                jy(j) = sum(abs(dw(1:j)));
            else
                jy(j) = sum(abs(dw(j-ef_jy+1:j)));                         % ���5֡��·��
            end
        else
            jy(j) = 0;
            y_end = size(I,2);%%%%%%%%%%%%%
        end
        
        if jy(j) > jyt_mv                                                  % �ж����Ƿ����ڶ�
            c_it = 1;
        else
            c_it = 0;
        end
        
        if sum(jy>jyt_it) > pft_it
            rst_it(j) = 1;
            %%%%%%%%%%%%%��
            result_it = 1;
            if rst_it(j-1) == 0
                if j <= ef_cs
                    crn_cs2(1:end) = 0;
                else
                    crn_cs2(j-ef_cs:end) = 0;
                end
            end
            %%%%%%%%%%%%%
        else
            rst_it(j) = 0;
        end
    else
        rst_it(j) = 0;
        c_it = 0;
        y_end = size(I,2);%%%%%%%%%%%%%%%
    end
    %% Cross
if result_cs == 0%%%%%%%%%%
    if sum(set==1)>snt_cs
        hw = min(wi(j-10:j));                                              % hand width
    else
        hw = size(box_c,1);
    end
    
    Ifill2 = imfill(I,'holes');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%��
    [~,bw_fm] = Comp_foam_gsni(box,bwt_fm);                                % ��ĭ����� ���޹���У����
    bw_fm2 = bw_fm.*~bw_It;                                                % ȥ�����������ĭ���Ľ��
    orimg = or(bw_fm2,Ifill2);                                             % ����ĭ��������ֱۼ�����������㣬�����ĭ�����޷��������ֱ�
    I2 = orimg;
    I2(:,y_end:end) = 0;
    [meanx,meany] = Gcenter(I2);
    strel_para = round(strelr_cs*hw);
    se1=strel('disk',strel_para);
    Io2 = imopen(I2,se1);
    Io2 = imclose(Io2,se1);
    Iod2 = ~Io2;                                                           % image for open diverse
    Iod2(:,round(meanx):end)=0;
    bwdiff2 = I2.*Iod2;
    dlt_para = ceil(dlr_it*hw);                                            % �����ֳ�ȷ��ɾ��С��������������С
    finger2 = bwareaopen(bwdiff2,dlt_para);                                % ȥ����⵽��ָ�����
    crn_cs2(j) = length(regionprops(finger2,'area'));                      % ͳ���м�����ָ
   %%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     strel_para = round(strelr_cs*hw);
%     se1=strel('disk',strel_para);
%     Io = imopen(I,se1);
%     Io = imclose(Io,se1);
%     Iod = ~Io;                                                           % image for open diverse
%     Iod(:,round(meanx):end)=0;
%     bwdiff = I.*Iod;
%     dlt_para = ceil(dlr_it*hw);                                          % �����ֳ�ȷ��ɾ��С��������������С
%     finger = bwareaopen(bwdiff,dlt_para);                                % ȥ����⵽��ָ�����
%     crn_cs(j) = length(regionprops(finger,'area'));                      % ͳ���м�����ָ
    %%%%%%%%%%%%%%%%%
    
    if j <= ef_cs
        pfn_cs(j) = sum(crn_cs2(1:j)>=crnt_cs);
    else
        pfn_cs(j) = sum(crn_cs2(j-ef_cs:j)>=crnt_cs);
    end
    if c_it == 1
        if pfn_cs(j) >= pfnt_cs
            rst_cs(j) = 1;
            result_cs = 1;%%%%%%%%%%%%%%
        else
            rst_cs(j) = 0;
        end
    else
        rst_cs(j) = 0;
    end
    %%%%%%%%%%%%%%
%     if sum(rst_cs==1)>1
%         result_cs = 1;
%     else
%         result_cs = 0;
%     end
    %%%%%%%%%%%%%%
%%%%%%%%%%%    
else
    result_cs = 1;
    Ifill2 = imfill(I,'holes');
end
%%%%%%%%%%%
    %% Back
if result_it == 1 && result_cs == 1
if result_lbk==0 || result_rbk==0%%%%%%%%%%%%%
    [~,bw_fm] = Comp_foam_gsni(box,bwt_fm);%%%%%%%%%%                      % ��ĭ�����
    bw_fm2 = bw_fm.*~bw_It;                                                % ȥ�����������ĭ���Ľ��
    orimg = or(bw_fm2,Ifill2);                                             % ����ĭ��������ֱۼ�����������㣬�����ĭ�����޷��������ֱ�
    dlorextr = bwareaopen(orimg,15);                                       % deleted or extracted image:ɾ��С�����������ͼƬ
    se1=strel('disk',3);                                                   % �����뾶Ϊ3��Բ�̣���Ϊ�ղ����ĽṹԪ��
    Icl = imclose(dlorextr,se1);                                           % Image close�����ϲ�����û�������ϵ�С��϶
    Icl(:,1) = 0;                                                          % ����ͼƬ��һ�����㣬���ֱ�����ͳһΪһ����ͨ��
    
    I_reg_bk = regionprops(~Icl,'area','boundingbox');                     % ͳ����ͨ�������λ��
    crn_bk(j) = length(I_reg_bk);                                          % ��ͨ������
    
    %      set(1) = 1;
    
    if sum(set==1) > 0                                                     % ��ʼ�жϵ�������setΪ1 ���ֹ�λ
        [Area,idx] = sort([I_reg_bk.Area],'descend');                      % ���������������ͨ��
        if crn_bk(j) >1 && Area(2) > rgt_lrbk                              % ��ͨ����>1�ҵڶ������ͨ������������ֵ
            area2(j) = Area(2);                                            % ���ֱ�֮����ͨ�����
            bottom(j) = I_reg_bk(idx(2)).BoundingBox(2) + I_reg_bk(idx(2)).BoundingBox(4); % ���ֱ�֮����ͨ��ĵײ�����
        else
            area2(j) = 0;
            bottom(j) = 0;
        end
    else
        area2(j) = 0;
        bottom(j) = 0;
    end
    
    if j<3 || area2(j)==0 || area2(j-2)==0                                 % �ų���Ч֡��ǰ֡������3���պ��������Ϊ0��ǰ֡�պ��������Ϊ0
        db(j) = 0;                                                         % difference of bottom:��֮ͬ֡��ײ�����Ĳ�
    else
        db(j) = bottom(j) - bottom(j-2);                                   % ����֮֡��ײ�ˮƽ�߶�֮��
    end
    %%%%%%%%% �ж���������Ҫ���֡ %%%%%%%%%%
    if j <= tt_bk*ceil(fps)
        if j <= pt_bk%%%%%%%%%%%%%
        if isempty(max(area2)-min(area2(area2~=0)))==1                     % Ѱ��area2�������Ϊ0����Ч֡����ͨ���������
            darea(j) = 0;
        else
            darea(j) = max(area2)-min(area2(area2~=0));                    % difference between two frames' areas
        end 
        else%%%%%%%%%%%%%
            prarea = area2(j-pt_bk:end); %%%%%%%%%%%%%                     % previous area
        if isempty(max(prarea)-min(prarea(prarea~=0)))==1
            darea(j) = 0;
        else
            darea(j) = max(prarea)-min(prarea(prarea~=0));
        end
        end%%%%%%%%%%%%%
        pfn_bk(j) = sum(darea(1:end)>at_bk);                               % �жϼ����Ƿ������ֵ
    else
        prarea = area2(j-pt_bk:end);  %%%%%%%%%%%%%                        % previous area
        if isempty(max(prarea)-min(prarea(prarea~=0)))==1
            darea(j) = 0;
        else
            darea(j) = max(prarea)-min(prarea(prarea~=0));
        end
        pfn_bk(j) = sum(darea(j-tt_bk*ceil(fps):end)>at_bk);               % positive frame number of back��������֡��������Ҫ���֡������
    end
    if c_it == 1                                                           % current result of interact���໥��ϴ�ĵ�ǰ֡�жϽ�����жϴ�ʱ���Ƿ����ڶ�
        if pfn_bk(j) > pfnt_bk                                            
            rst_bk(j) = 1;                                                 % result of back :�ֱ��жϽ���������������֣�
        else
            rst_bk(j) = 0;
        end
    else
        rst_bk(j) = 0;
    end
    % �ж������ֲ��֣�����Ҫ���֡
    if j <= tt_lrbk*ceil(fps)
        pfn_lrbk(j) = sum(db(1:end) > dbt_lrbk);
    else
        pfn_lrbk(j) = sum(db(j-tt_lrbk*ceil(fps):j) > dbt_lrbk);           % positive frame number of left and right back:��������������������֡��
    end
    if c_it == 1                                                           % �ж�ǰ���ǣ������ڶ�
        if pfn_lrbk(j) >= pfnt_lrbk
            rst_lrbk(j) = 1;
        else
            rst_lrbk(j) = 0;
        end
        
        if rst_bk(j) == 1
            if rst_lrbk(j) == 1
                rst_rbk(j) = 1;                                            % rst_lrbk�Ľ��Ϊ1����ʾ�ж�Ϊ���ڴ�ϴ���ֱ�����rst_rbk=1
                %%%%%%%%%%%%%��
                result_rbk = 1;
                rst_it(j) = 0;
                rst_cs(j) = 0;
                rst_lbk(j) = 0;
            elseif rst_lrbk(j-1) == 1
                darea(j-tt_bk*ceil(fps):end) = 0;
                rst_lbk(j) = 0;
                rst_rbk(j) = 0;
                rst_it(j) = 0;
                rst_cs(j) = 0;
                %%%%%%%%%%%%%
            else
                rst_lbk(j) = 1;
                result_lbk = 1;%%%%%%%%%
                rst_it(j) = 0;%%%%%%%%
                rst_cs(j) = 0;%%%%%%%
                rst_rbk(j) = 0;%%%%%%%
            end
        else
            rst_lbk(j) = 0;
            rst_rbk(j) = 0;
        end
    else
        rst_lrbk(j) = 0;
        rst_lbk(j) = 0;
        rst_rbk(j) = 0;
    end
    %%%%%%%%%%%%%%
%     if sum(rst_lbk==1) > 1                                               % ����������ֱ��жϽ��Ϊ1�����ʾ��������ֱ���ϴ������resultΪ����������
%         result_lbk = 1;
%     else
%         result_lbk = 0;
%     end
%     
%     if sum(rst_rbk==1) > 1
%         result_rbk = 1;
%     else
%         result_rbk = 0;
%     end
   %%%%%%%%%%%%%%
else
    result_lbk = 1;
    result_rbk = 1;
end 
%%%%%%%%%%%%%%%%%��
else
     result_lbk = 0;
     result_rbk = 0;
     darea(j) = 0;
end
%%%%%%%%%%%%%%%%%
else
    c_it = 0;
    result_it = 0;
    result_cs = 0;
    result_lbk = 0;
    result_rbk = 0;
end

% toc
%%  Result visualization
    word_et = ShowResult(result_et(j));                                     % effluent result
    word_ws = ShowResult(result_ws(j));                                     % washing hand result
    word_sp = ShowResult_win10(result_sp(j));                               % soap result
    word_fm = ShowResult(result_fm(j));                                     % foam result
    word_cit = ShowResult(c_it);
    word_it = ShowResult(result_it);
    word_cs = ShowResult(result_cs);
    word_lbk = ShowResult(result_lbk);
    word_rbk = ShowResult(result_rbk);
    
imshow(IM)
% WIN7
%      title({[num2str(i),'  Water��',word_et,'  Wash��',word_ws,'  Soap��',word_sp,'  Foam��',word_fm];[];...
%                        ['  Palm��',word_it,'  Cross��',word_cs,'  Left��',word_lbk,'  Right��',word_rbk];[];...
%                        ['����ˮ��ʱ�䣺',num2str(time_ws),'(s)']},'position',[275 85]);
% WIN10
 title({[num2str(i),'          ����ˮ��ʱ�䣺',num2str(time_ws),'(s)'];
        ['Water��',word_et,'                                                                                              ','Palm��',word_it];[];
        ['Wash��',word_ws,'                                                                                              ','Cross��',word_cs];[];
        ['Soap��',word_sp,'                                                                                                 ','Left��',word_lbk];[];
        ['Foam��',word_fm,'                                                                                              ','Right��',word_rbk];[];
        },'position',[275 245]);

    drawnow
%     pause
end
toc
% figure;
% o = stf:1:stf+658-1;
% plot(o,pfn_cs);
% title('crnt=4');
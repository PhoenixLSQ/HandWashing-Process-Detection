function word = ShowResult_win10(result)

if result == 1
    word = '是';
elseif result == 2
    word = '无法判断';
elseif result == 3
    word = '是';
elseif result == 4
    word = '是（正在）';
elseif result == 5
    word = '是（完成）';
else
    word = '否';
end
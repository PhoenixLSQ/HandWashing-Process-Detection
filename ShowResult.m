function word = ShowResult(result)

if result == 1
    word = '是';
elseif result == 2
    word = '无法判断';
elseif result == 3
    word = '否（完成）';
elseif result == 4
    word = '是（正在）';
elseif result == 5
    word = '是（完成）';
else
    word = '否';
end
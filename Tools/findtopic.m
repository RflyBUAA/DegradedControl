function index = findtopic(stringarray, stringTofind)
%UNTITLED 此处显示有关此函数的摘要
%   举例
%   known_logger = msg.TopicMessages{findtopic(msg.TopicNames, 'known_logger')};
    idx = (strfind(stringarray,stringTofind));
    length_idx = size(idx);
    for i = 1:length_idx(1)
        if cell2mat(idx(i)) ==1
            index = i;
            break;
        end
    end
end


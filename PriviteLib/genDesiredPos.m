function pos_d = genDesiredPos(current_pos, current_pos_desired, last_pos_desired, K_CURRENT, K_PERP)
% GENDESIREDPOS 根据先后两个航路点生成期望的位置
% current_pos 当前位置
% current_pos_desired 当前航路点
% last_pos_desired 上一个航路点
% pos_perp 当前位置到航路上的垂直交点

    Distent = norm(current_pos_desired - last_pos_desired);
    if Distent>0.1%0.1m
        % 计算垂直点
        pos_perp = current_pos_desired + (last_pos_desired - current_pos_desired)...
            *(current_pos - current_pos_desired)'*(last_pos_desired - current_pos_desired)/Distent^2;
        % 计算期望位置
        pos_d = current_pos + mysatsingle(K_CURRENT*(current_pos_desired - current_pos)+K_PERP*(pos_perp - current_pos),8);
    else
        % 直接使用当前航点作为期望位置
        pos_d = current_pos_desired;
    end
end


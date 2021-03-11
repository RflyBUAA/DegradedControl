function [ output_args ] =mysat( input_args, m)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明

temp = norm(input_args);
if temp<=m
   k = (1.0); 
else
   k = m/temp; 
end
    output_args = k*input_args;

end


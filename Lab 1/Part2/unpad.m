function [ A,B,C,D ] = unpad(a,b,c,d,pad)
%   Detailed explanation goes here
sx = size(a,1);
sy = size(a,2);
A = a(pad:sx - pad ,pad:sy - pad);
sx = size(b,1);
sy = size(b,2);
B = b(pad:sx - pad ,pad:sy - pad);
sx = size(c,1);
sy = size(c,2);
C = c(pad:sx - pad ,pad:sy - pad);
sx = size(d,1);
sy = size(d,2);
D = d(pad:sx - pad ,pad:sy - pad);
end
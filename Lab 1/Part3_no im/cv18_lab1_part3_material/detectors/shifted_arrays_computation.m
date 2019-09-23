function [ A,B,C,D ] = shifted_arrays_computation( I, X, Y, offX, offY )
%gwnia katw aristera
c = circshift(I,-Y + offY,1);
C = circshift(c,X + offX,2);
%gwnia katw dexia
d = circshift(I,-Y + offY,1);
D = circshift(d,-X + offX,2);
%gwnia panw dexia
b = circshift(I,Y + offY,1);
B = circshift(b,-X + offX,2);
%gwnia panw aristera
a = circshift(I,Y + offY,1);
A = circshift(a,X + offX,2);
end
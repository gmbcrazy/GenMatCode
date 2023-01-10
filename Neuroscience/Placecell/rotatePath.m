% Rotated the position angles according to the angle tAngle [radians]
function [newX,newY] = rotatePath(x,y,tAngle)

newX = x * single(cos(tAngle)) - y * single(sin(tAngle)); % Tilted x-coord
newY = x * single(sin(tAngle)) + y * single(cos(tAngle)); % Tilted y-coord

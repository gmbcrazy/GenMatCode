clear all
clc
close all

z=rand(10,10);
[x,y]=meshgrid(1:10,1:10);
figure;
subplot(1,2,1);
surf(x,y,z);
colormap gray;
freezeColors;
h=colorbar;
cbfreeze(h)


subplot(1,2,2)
surf(x,y,z);
colormap jet;
h1=colorbar;
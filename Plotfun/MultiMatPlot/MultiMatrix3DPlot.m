function MultiMatrix3DPlot(Data,XPlot)
%%%%%%%%Data is 3D matrix, each sample is Data(:,:,i)

[X,Y]=meshgrid(1:size(Data,1),1:size(Data,2));

% surf(x,y,[1 2;3 4],gradient(z))
%# create stacked images (I am simply repeating the same image 5 times)
% img = load('clown');
I = repmat(squeeze(Data(:,:,1)),[1 1 size(Data,3)]);
% cmap = img.map;

%# coordinates
[X,Y] = meshgrid(1:size(I,2), 1:size(I,1));
Z = ones(size(I,1),size(I,2));

%# plot each slice as a texture-mapped surface (stacked along the Z-dimension)
for k=1:size(I,3)
    surface('XData',floor(Z.*XPlot(k)*size(Z,1)/2), 'YData',X, 'ZData',Y+size(Data,1)*k/2, ...
        'CData',Data(:,:,k)*20, 'CDataMapping','direct', ...
        'EdgeColor','none', 'FaceColor','texturemap');
    hold on;
end
% colormap(cmap)
view(3), box off,
% axis tight square
% set(gca, 'YDir','reverse', 'ZLim',[1 size(Data,3)])

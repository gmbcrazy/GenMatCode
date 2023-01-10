mask.info = spm_vol(AALPath);
mask_data = spm_read_vols(mask.info);
% mask1_ind = find(mask_data>0.5 & mask_data<116.5);
% [mask1_dim1, mask1_dim2, mask1_dim3] = ind2sub(size(mask_data),mask1_ind);
% mask1_size = length(mask1_dim1);
[mask1_dim1, mask1_dim2, mask1_dim3] = size(mask_data);

              [img_dataTemp,~] = rest_ReadNiftiImage(image_dir);

              
    SurfFileName='D:\matlab plug in\FMRI\BrainNetViewer_20150414\Data\SurfTemplate\BrainMesh_Ch2withCerebellum.nv';
    fid=fopen(SurfFileName);
    % Modified by Mingrui, 20150206, support comments in commandline
    %     surf.vertex_number=fscanf(fid,'%f',1);
    %     surf.coord=fscanf(fid,'%f',[3,surf.vertex_number]);
    %     surf.ntri=fscanf(fid,'%f',1);
    %     surf.tri=fscanf(fid,'%d',[3,surf.ntri])';
    
    data = textscan(fid,'%f','CommentStyle','#');
    surf.vertex_number = data{1}(1)
    surf.coord  = reshape(data{1}(2:1+3*surf.vertex_number),[3,surf.vertex_number]);
    surf.ntri = data{1}(3*surf.vertex_number+2);
    surf.tri = reshape(data{1}(3*surf.vertex_number+3:end),[3,surf.ntri])';
    fclose(fid);

    
    
    surf(surf.coord(1,:),surf.coord(2,:),surf.coord(3,:))
    
    surfc(surf.coord)
    
    trisurf(surf.tri,surf.coord(1,:)',surf.coord(2,:)',surf.coord(3,:)','facecolor','b','edgecolor','none','facealpha',0.02)
    view([-1 0 0])
    hold on;
    EdgeBrainLu([3 50;43 103],[0.3 0.1 0.2]);hold on;
    NodeBrainLu(1:116,zeros(1,116)+0.1);
     
    load('D:\FMRI\AAL\AAL116_BrainNetView.mat')
NodeP=114;
hold on;
plot3(CellNode{NodeP,1},CellNode{NodeP,2},CellNode{NodeP,3},'o','markersize',20)
  
plot3(-300,CellNode{NodeP,2},CellNode{NodeP,3},'ro','markersize',20)

    grid off
    
    
    
    
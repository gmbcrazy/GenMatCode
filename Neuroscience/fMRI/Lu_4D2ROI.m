function varargout=Lu_4D2ROI(DataFolder,AALPath,SavePath)

% % 'Z:\Software\matlab_toolbox\DPARSF_V2.3_130615_new\Templates\AAL_61x73x61_YCG.nii'
% % % data_path = 'Z:\DATA\Schizophrenia\Huaxi_new\Patient\Results\patient_nii\';

mask.info = spm_vol(AALPath);
mask_data = spm_read_vols(mask.info);
% mask1_ind = find(mask_data>0.5 & mask_data<116.5);
% [mask1_dim1, mask1_dim2, mask1_dim3] = ind2sub(size(mask_data),mask1_ind);
% mask1_size = length(mask1_dim1);
[mask1_dim1, mask1_dim2, mask1_dim3] = size(mask_data);

mask_data=mask_data(:);
mask_data=reshape(mask_data,mask1_dim1*mask1_dim2*mask1_dim3,1);

data_dir = dir(DataFolder);
data_dir(1:2) = [];
l=0;
InvalidIndex=[];
for k=1:length(data_dir)
tic

    display(['Processing the ', data_dir(k).name]);
% %     dirIndividual=dir([DataFolder, data_dir(k).name, '.nii']);
% %     image_dir = strcat(data_path, '\', data_dir(k).name, '\',  dirIndividual(1).name);
   if data_dir(k).isdir==1
      tempDir=dir([DataFolder, data_dir(k).name,'\*.nii']);
      if isempty(tempDir)
         ['Nodata in' data_dir(k).name];
         InvalidIndex=[InvalidIndex;k];
         continue
      end
      image_dir=[DataFolder, data_dir(k).name '\' tempDir(1).name];
      saveName=tempDir(1).name(1:end-4);

   else
      image_dir=[DataFolder, data_dir(k).name];
      saveName=data_dir(k).name(1:end-4);

   end

    [img_data,~] = rest_ReadNiftiImage(image_dir);
    img_dataN=reshape(img_data,mask1_dim1*mask1_dim2*mask1_dim3,length(img_data(1,1,1,:)));
    l1=length(img_dataN(1,:));
    clear TempData;
       for brainAAL=1:116
%             brainAAL
            index=find(mask_data==brainAAL);
            TempData(:,brainAAL)=nanmean(img_dataN(index,:));
            
        end
       save([SavePath saveName],'TempData');

% % %     if l1<DurationTh
% % %         InvalidIndex=[InvalidIndex;k];
% % %         continue 
% % %     end

    
% % %     if l==0
% % %        l=l1;
% % %     else
% % %        l=min(l1,l);
% % %     end
% % %        Data(1:l,:,k)=TempData(1:l,:);
       clear TempData;
% % % % % % % % % 
% % % % % % % % %        for brainAAL=1:116
% % % % % % % % % %             brainAAL
% % % % % % % % %             index=find(mask_data==brainAAL);
% % % % % % % % %             Data(1:l,brainAAL,k)=nanmean(img_dataN(index,1:l));
% % % % % % % % %             TempData(:,brainAAL)=nanmean(img_dataN(index,:));
% % % % % % % % %             
% % % % % % % % %         end
% % % % % % % % %        Data(1:l,:,k)=TempData(1:l,:);

        clear TempData
        clear img_data
    toc
end

varargout{1}=1;


function varargout=Lu_4D2Vox(DataFolder,AALPath,SavePath)

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
NeedIndex=find(mask_data>0.5&mask_data<116.5);
mask_data=mask_data(NeedIndex);

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
    
    
   TempData=img_dataN(NeedIndex,:);
   save([SavePath saveName],'TempData','mask_data');

        clear TempData img_dataN img_data
    toc
end

varargout{1}=1;


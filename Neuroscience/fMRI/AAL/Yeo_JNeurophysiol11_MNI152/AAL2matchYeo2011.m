
clear all
mask.info = spm_vol('D:\FMRI\AAL\aal2_for_SPM12\aal\aal2.nii\aal2.nii');
mask_data1 = spm_read_vols(mask.info);

file2='D:\FMRI\AAL\Yeo_JNeurophysiol11_MNI152\JunYi\rYeo2011_7Networks_MNI152_FreeSurferConformed1mm_LiberalMask.nii';
% file2='D:\FMRI\AAL\Yeo_JNeurophysiol11_MNI152\AT638_FSL_2mm\AT638_FSL_2mm.nii';


mask.info = spm_vol(file2);
mask_data2 = spm_read_vols(mask.info);


mask_data1new=mask_data1(:);
mask_data2new=mask_data2(:);




% mask_data=reshape(mask_data,mask1_dim1*mask1_dim2*mask1_dim3,1);
% temp=mask_data1(:);
% NeedIndex=find(temp>0.5&temp<116.5);
% temp=temp(NeedIndex);

mask1_ind = find(mask_data1>-1 & mask_data1<130);
[mask1_dim1, mask1_dim2, mask1_dim3] = ind2sub(size(mask_data1),mask1_ind);
%
mask2_ind = find(mask_data2>-1 & mask_data2<130.5);
[mask2_dim1, mask2_dim2, mask2_dim3] = ind2sub(size(mask_data2),mask2_ind);
% 
[k1,v1] = convhull(mask1_dim1(:),mask1_dim2(:),mask1_dim3(:));
[k2,v2] = convhull(mask2_dim1(:),mask2_dim2(:),mask2_dim3(:));
% 
m1=[mask1_dim1(:) mask1_dim2(:) mask1_dim3(:)];
% m2=[mask2_dim1(:) mask2_dim3(:) mask2_dim2(:)];
m2=[mask2_dim1(:) mask2_dim2(:) mask2_dim3(:)];


figure;
plot3(m1(k1(:,1),1),m1(k1(:,2),2),m1(k1(:,3),3),'b.');hold on;
plot3(m2(k2(:,1),1),m2(k2(:,2),2),m2(k2(:,3),3),'r.');hold on;

figure;
plot3(m1(:,1),m1(:,2),m1(:,3),'b.');hold on;
plot3(m2(:,1),m2(:,2),m2(:,3),'ro');hold on;

% % parfor i=1:length(m1(:,1))
% %     [m1Dist(i),m1Index(i)]=min(sum(abs(m2-repmat(m1(i,:),length(m2(:,1)),1)),2));
% % end

mask_data1=mask_data1(:);
mask_data2=mask_data2(:);

mask_data1=mask_data1(mask1_ind);
mask_data2=mask_data2(mask2_ind);

save('D:\FMRI\AAL\Yeo_JNeurophysiol11_MNI152\JunyiProcessAAL2Yeo2011.mat','mask_data1','mask_data2')

%%%%%mask_data1New=mask_data2;
%%%%
Yeo2011Color=[120  18 134;
70 130 180;
0 118  14;
196  58 250;
220 248 164;
230 148  34;
205  62  78;]/255;

imagesc([1:7]);colormap(Yeo2011Color);

hist(m1Dist,50);
Subcortical=[33 34 75:82];
SubIndex=[];
for i=1:length(Subcortical);
SubIndex=[SubIndex(:);find(mask_data1==Subcortical(i))];
end

mask_data1New(m1Dist>4)=-1;
% % hist(m1Dist(SubIndex),50);
% % hist(m1Dist(setdiff(1:size(mask_data1),SubIndex)),20);

UniqueMask=setdiff(unique(mask_data2new),0);
figure;
for i=1:length(UniqueMask)
    temp2=find(mask_data2new==UniqueMask(i));
    plot3(m1(temp2,1),m1(temp2,2),m1(temp2,3),'.','color',Yeo2011Color(i,:));hold on;
end

for i=1:94
    for j=1:7
        AALratio7Net(i,j)=length(intersect(find(mask_data1new==i),find(mask_data2new==j)))/length(find(mask_data1new==i));
    end
end

[AALratio7Net,Index7Net]=sort(AALratio7Net,2,'descend');

save('D:\FMRI\AAL\Yeo_JNeurophysiol11_MNI152\JunyiProcessAAL2Yeo2011.mat','AALratio7Net','Index7Net')



ThresholdRatio=0.20;
Index7Net(a<ThresholdRatio)=-1;


surf(mask2_dim1(:),mask2_dim2(:),mask2_dim3(:),zeros(size(mask2_dim3)))
figure;hold on
for i=1:mask1_dim1
    for ii=2:mask1_dim2
        for iii=3:mask1_dim3
            plot3(i,ii,iii,'r.')
        end
    end
end
mask_data=mask_data(:);




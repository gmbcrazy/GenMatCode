function [FileList,SampleN]=GT_rhd2mdaMultiWrite(filename,ExcludeKeyWord,NewFilePath,dtype)

%%%%reading raw data file(.RHD) to Matlab
%%%%prepocessing by high pass filter for spike sorting and 
%%%%Creat file for (.MDA) format (Mountainlab Sorting Required), and 

%%%%%Lu Zhang 10-31-2017
%%%%%filename => raw rhd file.
%    NewFilePath - path to the output .mda file
%    dtype - 'complex32', 'int32', 'float32','float64'

WriteFileNum=1;               %%%%%%%%%%%%%%%%Reading 1 rhd files each time and write it to .mda




if nargin<4
    dtype='';
end
    I=strfind(NewFilePath,'\');
    NewFileFolder=NewFilePath(1:(I(end)-1));
    clear I
    
    if ~exist(NewFileFolder)
    mkdir(NewFileFolder);
    end
    
    
if findstr(filename,'.rhd')         %%%%%one single rhd file
    [X,freq]=GT_RHD2Mat(filename);
    writemda(X,NewFilePath,dtype)
else                              %%%%%recording integrated from multi rhd files
    I=strfind(filename,'\');
    Path=filename(1:(I(end)-1));
    fileTemp=filename(I(end)+1:end);
    FileList=dir([Path '/' fileTemp '*.rhd']);
    
    if ~isempty(ExcludeKeyWord)
        InvalidF=[];
        for j=1:length(ExcludeKeyWord)
        for i=1:length(FileList)
            if ~isempty(strfind(FileList(i).name,ExcludeKeyWord{j}))
               InvalidF=[InvalidF;i];
            end
        end
        end
        FileList(InvalidF)=[];
    end
    
    fprintf(1,[num2str(length(FileList)) ' files in Total']);
    fprintf(1, '\n');

    h = waitbar(0,'RHD to MDA');
    Data=[];    
    LoopNum=ceil(length(FileList)/WriteFileNum);
    if WriteFileNum==1
       LoopNum=length(FileList);
    end
    
%     SampleN=0;    %%%%%%%%%%%%%%%%%%%%%sample numbers

    
    for j=1:LoopNum
        X=[];
        LoopS=(j-1)*WriteFileNum+1;
        LoopO=min(j*WriteFileNum,length(FileList));
        for i=LoopS:LoopO
    fprintf(1,['loading ' FileList(i).name]);
    fprintf(1, '\n');


        [tempX,freq]=GT_RHD2Mat([Path '\' FileList(i).name]);
%%%%%%%%%%%       tempX=[tempX;tempX;tempX;tempX;tempX;tempX;tempX;tempX];
% % % % % %         tempX=[tempX;tempX;tempX;tempX];

%         tempX=[tempX;tempX];
        X=[X tempX];
        clear tempX
         fprintf(1,['file' FileList(i).name]);
         fprintf(1, '\n');
        end
        per=(j-1)/LoopNum;
        waitbar(per,h);
        
     sampleTemp=size(X);
     SampleN(j)=sampleTemp(end);  %%%%%%%updated sample Num. with new rhd files added in.

if isempty(dtype)
    %warning('Please use writemda32 or writemda64 rather than directly calling writemda. This way you have control on whether the file stores 32-bit or 64-bit floating points.');
    is_complex=1;
    if (isreal(X)) is_complex=0; end;

    if (is_complex)
        dtype='complex32';
    else
        is_integer=check_if_integer(X);
        if (~is_integer)
            dtype='float32';
        else
            dtype='int32';
        end;
    end;
end;


 %%%%%%%%%%%%%%%%%%%%%reading the first rhd; open new mda file for writing.
 %%%%%%%%%%%%%%%%%%%%%Headers is needed. Thus sample num. of first rhd
 %%%%%%%%%%%%%%%%%%%%%file is writen to file header

if j==1       
FF=fopen([NewFilePath],'w+');

num_dims=2;
if (size(X,3)~=1) num_dims=3; end; % ~=1 added by jfm on 11/5/2015 to handle case of, eg, 10x10x0
if (size(X,4)~=1) num_dims=4; end;
if (size(X,5)~=1) num_dims=5; end;
if (size(X,6)~=1) num_dims=6; end;
%%%%%%%%%%writing
if strcmp(dtype,'complex32')
    fwrite(FF,-1,'int32');
    fwrite(FF,8,'int32');
    fwrite(FF,num_dims,'int32');
    dimprod=1;
    for dd=1:num_dims
        fwrite(FF,size(X,dd),'int32');
        dimprod=dimprod*size(X,dd);
    end;
    XS=reshape(X,dimprod,1);
    Y=zeros(dimprod*2,1);
    Y(1:2:dimprod*2-1)=real(XS);
    Y(2:2:dimprod*2)=imag(XS);
    fwrite(FF,Y,'float32');
elseif strcmp(dtype,'float32')
    fwrite(FF,-3,'int32');
    fwrite(FF,4,'int32');
    fwrite(FF,num_dims,'int32');
    dimprod=1;
    for dd=1:num_dims
        fwrite(FF,size(X,dd),'int32');
        dimprod=dimprod*size(X,dd);
    end;
    Y=reshape(X,dimprod,1);
    fwrite(FF,Y,'float32');
elseif strcmp(dtype,'float64')
    fwrite(FF,-7,'int32');
    fwrite(FF,8,'int32');
    fwrite(FF,num_dims,'int32');
    dimprod=1;
    for dd=1:num_dims
        fwrite(FF,size(X,dd),'int32');
        dimprod=dimprod*size(X,dd);
    end;
    Y=reshape(X,dimprod,1);
    fwrite(FF,Y,'float64');
elseif strcmp(dtype,'int32')
    fwrite(FF,-5,'int32');
    fwrite(FF,4,'int32');
    fwrite(FF,num_dims,'int32');
    dimprod=1;
    for dd=1:num_dims
        fwrite(FF,size(X,dd),'int32');
        dimprod=dimprod*size(X,dd);
    end;
    Y=reshape(X,dimprod,1);
    fwrite(FF,Y,'int32');
elseif strcmp(dtype,'int16')
    fwrite(FF,-4,'int32');
    fwrite(FF,2,'int32');
    fwrite(FF,num_dims,'int32');
    dimprod=1;
    for dd=1:num_dims
        fwrite(FF,size(X,dd),'int32');
        dimprod=dimprod*size(X,dd);
    end;
    Y=reshape(X,dimprod,1);
    fwrite(FF,Y,'int16');
elseif strcmp(dtype,'uint16')
    fwrite(FF,-6,'int32');
    fwrite(FF,2,'int32');
    fwrite(FF,num_dims,'int32');
    dimprod=1;
    for dd=1:num_dims
        fwrite(FF,size(X,dd),'int32');
        dimprod=dimprod*size(X,dd);
    end;
    Y=reshape(X,dimprod,1);
    fwrite(FF,Y,'uint16');
elseif strcmp(dtype,'uint32')
    fwrite(FF,-8,'int32');
    fwrite(FF,4,'int32');
    fwrite(FF,num_dims,'int32');
    dimprod=1;
    for dd=1:num_dims
        fwrite(FF,size(X,dd),'int32');
        dimprod=dimprod*size(X,dd);
    end;
    Y=reshape(X,dimprod,1);
    fwrite(FF,Y,'uint32');
else
    error('Unknown dtype %s',dtype);
end
%%%%%%%%%%writing
%%%%%%%%%%%%%%%%%%%%%reading the first rhd; open new mda file for writing.



else
%%%%%%%%%%%%%%%%%%%%%reading the rest rhd files; write to current mda
if strcmp(dtype,'complex32')
    dimprod=1;
    for dd=1:num_dims
        dimprod=dimprod*size(X,dd);
    end;
    XS=reshape(X,dimprod,1);
    Y=zeros(dimprod*2,1);
    Y(1:2:dimprod*2-1)=real(XS);
    Y(2:2:dimprod*2)=imag(XS);
    fwrite(FF,Y,'float32');
elseif strcmp(dtype,'float32')
    dimprod=1;
    for dd=1:num_dims
        dimprod=dimprod*size(X,dd);
    end;
    Y=reshape(X,dimprod,1);
    fwrite(FF,Y,'float32');
elseif strcmp(dtype,'float64')
    dimprod=1;
    for dd=1:num_dims
        dimprod=dimprod*size(X,dd);
    end;
    Y=reshape(X,dimprod,1);
    fwrite(FF,Y,'float64');
elseif strcmp(dtype,'int32')
    dimprod=1;
    for dd=1:num_dims
        dimprod=dimprod*size(X,dd);
    end;
    Y=reshape(X,dimprod,1);
    fwrite(FF,Y,'int32');
elseif strcmp(dtype,'int16')
    dimprod=1;
    for dd=1:num_dims
        dimprod=dimprod*size(X,dd);
    end;
    Y=reshape(X,dimprod,1);
    fwrite(FF,Y,'int16');
elseif strcmp(dtype,'uint16')
    dimprod=1;
    for dd=1:num_dims
        dimprod=dimprod*size(X,dd);
    end;
    Y=reshape(X,dimprod,1);
    fwrite(FF,Y,'uint16');
elseif strcmp(dtype,'uint32')
    dimprod=1;
    for dd=1:num_dims
        dimprod=dimprod*size(X,dd);
    end;
    Y=reshape(X,dimprod,1);
    fwrite(FF,Y,'uint32');
else
    error('Unknown dtype %s',dtype);
end
%%%%%%%%%%%%%%%%%%%%%reading the rest rhd files; write to current mda


end
  
        
end
end

close(h)
fseek(FF,0,'bof');
Header=fread(FF,5,'int32');   % %%%%%%%%%%%%%%%%%%%%%Current headers
% Header=fread(FF,1,'int32');   % %%%%%%%%%%%%%%%%%%%%%Current headers
Header(5)=sum(SampleN);%%%%%%Update current headers with Total Sample Num.
fseek(FF,0,'bof')
fwrite(FF,Header,'int32');
SampleN=SampleN;
fclose(FF)


temp1=strfind(NewFilePath,'.mda');

FF=fopen([NewFilePath(1:(temp1-1)) 'FList.txt'],'w+');

for i=1:length(FileList)
fprintf(FF,'%s %f \n',[FileList(i).name ' '],SampleN(i));
%%fprintf(FF, '\n');
end
fclose(FF);

for i=1:length(FileList)
    t1=strfind(FileList(i).name,fileTemp)+length(fileTemp);
    t2=strfind(FileList(i).name,'_')-1;
    SessionID(i)=str2num(FileList(i).name(t1:t2(1)));
%%fprintf(FF, '\n');
end


save([NewFilePath(1:(temp1-1)) 'SessionID.mat'],'SessionID','FileList','SampleN');


% debuging
% fseek(FF,0,'bof');
% fread(FF,5,'*int32')
% fseek(FF,0,'bof')
% fwrite(FF,Header,'*int32');
% fseek(FF,0,'bof');
% fread(FF,5,'int32')
% debuging





function ret=check_if_integer(X)
ret=0;
if (length(X)==0) ret=1; return; end;
if (X(1)~=round(X(1))) ret=0; return; end;
tmp=X(:)-round(X(:));
if (max(abs(tmp))==0) ret=1; end;





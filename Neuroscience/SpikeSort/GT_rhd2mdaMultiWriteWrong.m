function FileList=GT_rhd2mdaMultiWriteWrong(filename,NewFile,dtype)

%%%%reading raw data file(.RHD) to Matlab
%%%%prepocessing by high pass filter for spike sorting and 
%%%%Creat file for (.MDA) format (Mountainlab Sorting Required), and 

%%%%%Lu Zhang 28-09-2017.
%%%%%filename => raw rhd file.
%    NewFile - path to the output .mda file
%    dtype - 'complex32', 'int32', 'float32','float64'

WriteFileNum=1;               %%%%%%%%%%%%%%%%Reading 1 rhd files each time and write it to .mda




if nargin<3, dtype=''; end;

if findstr(filename,'.rhd')         %%%%%one single rhd file
    [X,freq]=GT_RHD2Mat(filename);
    writemda(X,NewFile,dtype)
else                              %%%%%recording integrated from multi rhd files
    I=strfind(filename,'\');
    Path=filename(1:(I(end)-1));
    fileTemp=filename(I(end)+1:end);
    FileList=dir([Path '/' fileTemp '*.rhd']);
    fprintf(1,[num2str(length(FileList)) ' files in Total']);
    fprintf(1, '\n');

    h = waitbar(0,'RHD to MDA');
    Data=[];    
    LoopNum=ceil(length(FileList)/WriteFileNum);
    if WriteFileNum==1
       LoopNum=length(FileList);
    end
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
        
        
        
%WRITEMDA - write to a .mda file. MDA stands for
%multi-dimensional array.
%
% See http://magland.github.io//articles/mda-format/
%
% Syntax: writemda(X,fname)
%
% Inputs:
%    X - the multi-dimensional array
%    fname - path to the output .mda file
%    dtype - 'complex32', 'int32', 'float32','float64'
%
% Other m-files required: none
%
% See also: readmda

% Author: Jeremy Magland
% Jan 2015; Last revision: 15-Feb-2016; typo fixed Barnett 2/26/16


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

if j==1
FF=fopen(NewFile,'w');

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

end



  
        
end
end
    close(h)
    fclose(FF);



function ret=check_if_integer(X)
ret=0;
if (length(X)==0) ret=1; return; end;
if (X(1)~=round(X(1))) ret=0; return; end;
tmp=X(:)-round(X(:));
if (max(abs(tmp))==0) ret=1; end;





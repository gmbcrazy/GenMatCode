function GT_rhd2mda_HighPassFilter(filename,Freband,NewFile)

%%%%reading raw data file(.RHD) to Matlab
%%%%prepocessing by high pass filter for spike sorting and 
%%%%Creat file for (.MDA) format (Mountainlab Sorting Required), and 

%%%%%Lu Zhang 28-09-2017.
%%%%%filename => raw rhd file.
%%%%%Freband =>cut of frequency band in filtering.
%%%%%NewFile => path and name for new created .mda file.


if findstr(filename,'.rhd')         %%%%%one single rhd file
[Data,Fre]=GT_RHD2Mat(filename);
else                              %%%%%recording integrated from multi rhd files
    I=strfind(filename,'\');
    Path=filename(1:(I(end)-1));
    fileTemp=filename(I(end)+1:end);
    FileList=dir([Path '/' fileTemp '*.rhd']);
    fprintf(1,[num2str(length(FileList)) ' files in Total']);
    fprintf(1, '\n');

    h = waitbar(0,'RHD Files Loading...');
    Data=[];    
    for i=1:length(FileList)
    fprintf(1,['loading ' FileList(i).name]);
    fprintf(1, '\n');


        [TempData,Fre]=GT_RHD2Mat([Path '\' FileList(i).name]);
        Data=[Data TempData];
        per=i/length(FileList);
        waitbar(per,h);
    end
    close(h)
end

fprintf(1,'RHD to Matlab Done');
fprintf(1, '\n');
fprintf(1,'Filtering Process...Please Wait');
fprintf(1, '\n');

if isempty(Freband)
Data=double(Data);
% clear Data;
%%%%filtering
else
Wn = Freband/(Fre/2);
[b,a] = butter(4, Wn);
Data = filtfilt(b,a,double(Data));
%%%%filtering
fprintf(1,'Filtering Done');
fprintf(1, '\n');
fprintf(1,'Creating MDA File...Please Wait');
fprintf(1, '\n');
% clear Data;
end
writemda(Data,NewFile);
fprintf(1,'MDA File Created');
fprintf(1, '\n');








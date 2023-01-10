function sf=FilterBeta(data,freq,filterorder)
         lowf=15;
         highf=30;
         freq=1000;
%          fz=freq/2;
%          [b,a]=ellip(6,3,50,highf/500);
%          sf=filtfilt(b,a,x);
%          [b,a]=ellip(6,3,50,lowf/500,'high');
%          sf=filtfilt(b,a,sf);


% filterorder=500;


[sf,filtwts] = eegfilt(data(:)',freq,lowf,highf,0,filterorder,0);

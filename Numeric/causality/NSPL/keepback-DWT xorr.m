tmpConZero=DataNo-runningwinlen-timedelay+2;
tmpConOne=HalfTotalDelayNo+1;
for j=1:tmp_maxscale
    MRAX = wrcoef('d',Cx,Lx,wname,j); 
    MRAY = wrcoef('d',Cy,Ly,wname,j);     

    NoTime=0;    
    for k=timedelay:runningstep:tmpConZero
       NoTime=NoTime+1;
       tmpConTwo=k+runningwinlen;
       tmpConThree=k+1;
       Xseg=MRAX(k:tmpConTwo-1);
       for m=-HalfTotalDelayNo:HalfTotalDelayNo            
           tmpConFour=m*delaystep;
           Yseg=MRAY(tmpConThree-tmpConFour:tmpConTwo-tmpConFour);
           RC(j).Data(m+tmpConOne,NoTime)=xcorr(Xseg,Yseg,0,'coeff');             
        end
    end        
end

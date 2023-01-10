function [cicular_sig,cicular_timestamps]=cicular_num_gamma(wave,sig,gamma_normalize,normalize_range)         %set up cicular number of sig according to wave%


%normalize_range(1) is the start time of the normlize data of wave,normalize_range(2) is the end time of the normlize data of wave%


m=diff(wave);
invalidWaveIndex=find(m>0.03333|m<0.01);
t=sig;

if  (~isempty(gamma_normalize))&(~isempty(normalize_range))%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%we don't have to rule out the data excluded in the normalize wave
   qq=0;
   qqq=0;
   q1=[];q2=[];tt=gamma_normalize;                                                                                    
   q=floor(normalize_range(1)*1000);
   mm=floor(normalize_range(2)*1000);
   while  q<mm 
          qq=q;
          if tt(q)==0
       
          
           
              while tt(q)==0&q<mm
                    q=q+1;
              end
           
              qqq=q;
              tt(qq:qqq)=1;
              q1=[q1,qq];
              q2=[q2,qqq];
          end
      
          q=max(qqq,qq+1);
   end

   if ~isempty(q1)
      wave_start=q1*0.001;
      wave_end=q2*0.001;                                                                     %Get field potential data at 1000Hz%

      for i=1:length(wave_start)
      t(find(wave_start(i)<sig&sig<wave_end(i)))=-1;
      end                                                                                    %find out the invalid spike which is not in the gamma_normlise duration%

   t(find(t<normalize_range(1)))=-1;
   t(find(t>normalize_range(2)))=-1;
   end  
    
    
    


for i=1:(length(invalidWaveIndex)-1)
    invalidSigIndex=find(wave(invalidWaveIndex(i))<=sig&sig<wave(invalidWaveIndex(i)+1));
     t(invalidSigIndex)=-1;  
end                                                                                        %find out the invalid spike outside wave of 30HZ to 100HZ%

       invalidSigIndex_final=find(t==-1|t<wave(1)|t>wave(length(wave)));
       t(invalidSigIndex_final)=[];
   if t==[];
      cicular_sig=[];
   else
       for i=1:length(t)
        q=max(find((t(i)-wave)>=0.0000));
        cicular_sig(i)=360*(t(i)-wave(q))/m(q);
       end
   end
   cicular_timestamps=t;

   
elseif isempty(gamma_normalize)&isempty(normalize_range);
       
       for i=1:(length(invalidWaveIndex)-1)
           invalidSigIndex=find(wave(invalidWaveIndex(i))<=sig&sig<wave(invalidWaveIndex(i)+1));
           t(invalidSigIndex)=-1;  
       end                                                                                        %find out the invalid spike outside wave of 30HZ to 100HZ%
 
       invalidSigIndex_final=find(t==-1|t<wave(1)|t>wave(length(wave)));
       t(invalidSigIndex_final)=[];
       if isempty(t)
          cicular_sig=[];
       else
           for i=1:length(t)
               q=max(find((t(i)-wave)>=0.0000));
               cicular_sig(i)=360*(t(i)-wave(q))/m(q);
           end
       end
       cicular_timestamps=t;

    
end                                           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%we don't have to rule out the data excluded in the normalize wave


function [sf,RMS_ripple,norm_rsf,ripplemax_ts,ripplemax_ts_p,ripplestart_ts,rippleover_ts]=FilterRipple(data,freq,filterorder)
         lowf=140;
         highf=230;
%          freq=1000;
%          fz=freq/2;
%          [b,a]=ellip(6,3,50,highf/500);
%          sf=filtfilt(b,a,x);
%          [b,a]=ellip(6,3,50,lowf/500,'high');
%          sf=filtfilt(b,a,sf);


% filterorder=75;


[sf,filtwts] = eegfilt(data(:)',freq,lowf,highf,0,filterorder,0);

            
	len_r=length(sf);
	mark_rsf=zeros(1,len_r);
	norm_rsf=zeros(1,len_r);
	ave_rsf=sum(sf)/len_r;
	
    sf=sf(:)';
    n_r_h=7;
    n_r_h_start_over=3;

    for i=1:10
    sf1(i,:)=sf(i:len_r+i-10);
    end
    

    sf_p=(mean(sf1.*sf1)).^0.5;
    
    ave_p=mean(sf_p);
    sd_p7=n_r_h*std(sf_p);
    sd_p1=n_r_h_start_over*std(sf_p);
    mark_ripple=zeros(1,len_r-9);
%     i=1;
    
    mark_ripple(find((sf_p-ave_p)>sd_p7))=1;
    
    
    RMS_ripple=[[0 0 0 0],sf_p,[0 0 0 0 0]];
    
%     while i<=length(sf_p)
%           if (sf_p(i)-ave_p)>sd_p7
%               mark_ripple(i)=1;
%               i=i+10;
%           else
%               i=i+1;
%           end
%       end
      
 rippleindex=find(mark_ripple==1);    
 start_ripple=rippleindex;
 over_ripple=rippleindex;

      for i=1:length(rippleindex)
        p=rippleindex(i);
        temp_p1=p;
        temp_p2=p;
        
        while (sf_p(temp_p1)-ave_p)>sd_p1
              mark_ripple(temp_p1)=1;
              temp_p1=temp_p1+1;
              if temp_p1==len_r-8;
                 break    
              end
          end
          
        over_ripple(i)=temp_p1-1;
          
          
        while (sf_p(temp_p2)-ave_p)>sd_p1
              mark_ripple(temp_p2)=1;
              temp_p2=temp_p2-1;
          
               if temp_p2==0
                  break
              end
          end
          start_ripple(i)=temp_p2;
      end
      
      
%        i=1;
%       while i<length(start_ripple)
%             if over_ripple(i)>=start_ripple(i+1)    
%                 mark_ripple(rippleindex(i))=[];
%                 start_ripple(i)=[];
%                 over_ripple(i)=[];
%             else    
%             i=i+1;
%             end
%       end
% 
      
start_ripple=start_ripple*1;
over_ripple=over_ripple*1+9;


  	max_rsf=max(sf);
	min_rsf=min(sf);
	level_rsf=0;
%     level_rsf=round((max_rsf+min_rsf)/2);
%     norm_rsf(1:len_r)=level_rsf
	norm_rsf(1:len_r)=0;
    
    
    norm_index=find(mark_ripple==1);
    for i=1:9
    norm_index=union(norm_index+1,norm_index);
    end
    norm_rsf(norm_index)=sf(norm_index);
    
    


          max_sf=max(abs(sf_p));

            
            ripplemax_ts_p = [];
            ripplemax_ts = [];
			ripplestart_ts=[];
            rippleover_ts=[];
            len_r = length(norm_rsf);
			
			mark_r = zeros(1,len_r);
			iii= find(abs(norm_rsf)>0);
			mark_r(iii) = 1;
			
			for jj=1:len_r-2 %%%%%%%%%% for pick the spike in the normalized ripple  %%%%%% kk 20051008   
                if mark_r(jj+2)
                    mark_r(jj+1)=1;
                end%%%%%%%%%% for pick the spike in the normalized ripple  %%%%%% kk 20051008
			end
			
			flag = 0;
			flag1 = 0;
			flag2 = 0;
			p_start = 1;
			p_end = 1;
			
			for i=1:len_r
                   
                if mark_r(i) & ~flag
                    flag = 1;
                    flag1 = 1;
                    p_start = i;
                end
                if flag & ~mark_r(i)
                    flag = 0;
                    flag2 = 1;
                    p_end = i;
                end
                if flag1 & flag2
%                     [ad_max,p_max] = max(abs(norm_rsf(p_start:p_end)));
                    [ad_max,p_max] = min(norm_rsf(p_start:p_end));
                    [ad_max_p,p_max_p] = max(norm_rsf(p_start:p_end));
                    ripplemax_ts_p =[ripplemax_ts_p,p_max_p+p_start-1];
                    ripplemax_ts=[ripplemax_ts,p_max+p_start-1];
                    ripplestart_ts=[ripplestart_ts,p_start];
                    rippleover_ts=[rippleover_ts,p_end];
                    flag1 = 0;
                    flag2 = 0;
                end
            end
            
                ripplemax_ts=(ripplemax_ts-1)/freq;
                ripplemax_ts_p=(ripplemax_ts_p-1)/freq;
                ripplestart_ts=ripplestart_ts/freq;
                rippleover_ts=(rippleover_ts-2)/freq;
%                 if (~isempty(ripplemax_ts))&(~isempty(ripplestart_ts))&(~isempty(rippleover_ts))
          
          
          
          
          
          
          
          
          


function [S,F,T]=spec_kal(path_filename,data_name,KalmanInput,fre,timerange,F)

bin_width=0.001;
step=0.001;
[bin_x,T]=rate_historam(path_filename,data_name,timerange,bin_width,step);
% 
% if findstr(data_name,'sig')
% bin_x=bin_x+random('norm',0,std(bin_x)*0.5,1,length(bin_x));
% 
% end
MOP=KalmanInput.MOP;
UC=KalmanInput.UC;
p=KalmanInput.p;
Mode=KalmanInput.Mode;
Z0=KalmanInput.Z0;
V0=KalmanInput.V0;
W=KalmanInput.W;

[x,e,Kalman,Q2] = mvaar(bin_x',p,UC,4);  
[z,e,REV,ESU,V,Z,SPUR,z_smooth] = amarma_smooth(bin_x', Mode, MOP, UC, x(36,:), Z0, V0, W);     
[S.Power,F]=mode2spec(z_smooth.z,[],F,z_smooth.e,fre);

% [z,e,REV,ESU,V,Z,SPUR] = amarma(bin_x, Mode, MOP, UC, x(i,:), Z0, V0, W); 
% [S(i).Power,F]=mode2spec(z,[],F,e,fre);
%  

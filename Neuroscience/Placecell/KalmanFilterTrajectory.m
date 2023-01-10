function  [x_filt, y_filt] = KalmanFilterTrajectory(x,y,dt,option)

%implemented from the book 
%of Gerard Blanchet and Maurice Charbit
%"Signaux et images sous Matlab"
n=length(x);
 
vx=(diff(x)./dt).^2;
vy=(diff(y)./dt).^2;
%we compute v
v=sqrt(vx+vy);

%noisy observation 
var_obs=0.001;
Ru=var_obs*diag([1 1]);


Y=[x';y'];%+sqrt(var_obs)*randn(2,n);

AA=[1 0 1 0; 
    0 1 0 1; 
    0 0 1 0;
    0 0 0 1];

CC=[1 0 0 0;
    0 1 0 0];

%We chose the noise of the model

%var_mod=1e-4;
if strcmp(option,'kf')
    %we estimate the variance of the noise
    var_mod=sqrt(estimatenoise(v));
    var_mod=var_mod*(abs(mean(randn(length(v),1)))^2);
    %var_mod = evar(v);
else
    var_mod=str2num(option);
end    

Rb=var_mod*diag([0 0 1 1]);
%States
xchap=zeros(4,n);
%Initialization
KK=eye(4);
xchap(1,1)=x(1);
xchap(2,1)=y(1);
xchap(3,1)=0;
xchap(4,1)=0;
KK(1,1)=x(1)^2;
KK(2,2)=y(1)^2;
%Kalman's algorithm
for k=2:n    
   GG=KK*CC'*inv(CC*KK*CC'+Ru);
   xchap(:,k)=AA*xchap(:,k-1)+GG*(Y(:,k)-CC*AA*xchap(:,k-1));
   KK=AA*(eye(4)-GG*CC)*KK*(eye(4)-GG*CC)'*AA'+AA*GG*Ru*GG'*AA'+Rb;   
end  

x_filt=xchap(1,:)';
y_filt=xchap(2,:)';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% for debug purpose%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% figure;
% %we plot the trajectory
% subplot(3,1,1);
% plot(xchap(1,:),xchap(2,:))
% hold on;
% plot(x,y,'r');
% hold off;
% 
% %now the speed
% x1=xchap(1,:);
% y1=xchap(2,:);
% n1=length(x1);
% v11=1:(n-1);
% v21=sqrt((diff(x1)./dt).^2+(diff(y1)./dt).^2);
% %we apply AR1 filter to v
% % v21_filt=KalmanFilter_AR1(v21,dt);
% subplot(3,1,2);
% plot(v11(2:end),v21(2:end));
% % hold on;
% % plot(v11(2:end),v21_filt(2:end),'r');
% subplot(3,1,3);
% %we plot hist and extimate the 
% %gaussian mixture
% hist(v21,75);
% hold on
% % now estimate the parametes of the distribution
% % [mu_est, sigma_est, w_est, counter, difference] = gaussian_mixture_model(v21, 2, 1.0e-3);
% % % mu_est'
% % % sigma_est'
% % % w_est'
% % 
% % % compare empirical data to estimated distribution
% % p1_est = w_est(1) * norm_density(v11, mu_est(1), sigma_est(1));
% % p2_est = w_est(2) * norm_density(v11, mu_est(2), sigma_est(2));
% % 
% % % p1 = w(1) * norm_density(x, mu(1), sigma(1));
% % % p2 = w(2) * norm_density(x, mu(2), sigma(2));
% % 
% % % plot1 = plot(x, p1+p2, 'b-', 'linewidth', 2);
% % hold on
% % plot(v11, p1_est+p2_est, 'r--', 'linewidth', 2);
% % plot3 = plot(x, p1, 'g-.', 'linewidth', 2);
% % plot(x, p2, 'g-.', 'linewidth', 2);
% % set(gca,'linewidth', 2, 'fontsize', 16)
% % legend([plot3 plot1 plot2], 'components', 'mixture model', 'estimated model', ...
% %        'Location', 'NorthEast');
% 
% drawnow;

%plot(xchap(3,:),xchap(4,:))
% hold on;
% n1=length(vx);
% plot(1:n1,sqrt(vx+vy),'r');

    







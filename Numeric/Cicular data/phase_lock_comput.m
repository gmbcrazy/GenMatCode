function [pefer,mean_length,level,P,k]=phase_lock_comput(data)


%%the algorithm is according to the paper Neuron, Vol. 46,141¨C151,Prefrontal Phase Locking to Hippocampal Theta Oscillations,Matthew A.Wilson
%%data is a set of phase data (from 0 to 360 degree) 
%%level is used to test whether the data has pefered phase or phase locked properties(The Rayleigh statistic)
%%pefer is the phase that the data pefere to
%%P is p value


angle_data=(data-180)*pi/180;
or_data=exp(angle_data*i);
pefer_data=mean(or_data);
R=abs(pefer_data);
pefer=(angle(pefer_data)+pi)*180/pi;
mean_length=R;
level=length(data)*(R^2);
P=(exp(-level))*(1+(2*level-level*level)/4/length(data)-(24*level-132*level*level+76*level^3-9*level^4)/288/length(data)/length(data));


if R<0.999999
    k=fzero(inline([num2str(R) '*besseli(0,x)-besseli(1,x)']),0.5);
else
    k=0;
    'R should be less than 1'
end

% phase_sample=[-pi:0.1:pi];
% 
% plot(phase_sample,1/(2*pi*besseli(0,k))*exp(k*cos(phase_sample-angle(pefer_data))),'r.-');
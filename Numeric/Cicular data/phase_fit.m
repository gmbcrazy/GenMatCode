function [density,phase_sample]=phase_fit(k,n,prefer_data)

prefer_data=prefer_data*pi/180-pi;
period=2*pi/n;
phase_sample=[-pi:period:(n-1)*period-pi];
density=1/(2*pi*besseli(0,k))*exp(k*cos(phase_sample-prefer_data));
density=[density,density];
phase_sample=(phase_sample+pi)*180/pi;
phase_sample=[phase_sample,phase_sample+360];
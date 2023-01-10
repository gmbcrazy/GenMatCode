clear all
PathFileName='E:\my program\UPMC\filter\test\test.smr'   
ChanParameter.Hipp=[5 6 7 8];
FilterParamter.Delta=1;   %%%%2-4Hz
FilterParamter.Theta=1;   %%%%4-12Hz
% FilterParamter.Beta=1;    %%%%15-30Hz
FilterParamter.Gamma=1;   %%%%40-100Hz
FilterParamter.Ripple=1;  %%%%100-250Hz
% FilterParamter.Hi=1;      %%%%200-300Hz


FilterParamter.DeltaOrder=1000;   %%%%2-4Hz
FilterParamter.ThetaOrder=500;   %%%%4-12Hz
FilterParamter.GammaOrder=70;   %%%%2-4Hz
FilterParamter.RippleOrder=20;   %%%%2-4Hz


filter_SMR(PathFileName,ChanParameter,FilterParamter)

NEXData=filter_SMR('E:\my program\UPMC\filter\test\NaviReward-M09-100413002.smr',ChanParameter,FilterParamter)


[nexFile] = readNexFile('E:\my program\UPMC\filter\test\TestDataFileForNeuroshare.nex');

[nexFile] = readNexFile('E:\my program\UPMC\filter\test\test.nex')
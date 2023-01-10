function z=nanzscore(x)
%[z]=nanzscore(x),ignoringNaNs
%�����ڱ�׼������[z]=zscore(x),����NaNs
%Author:wuxuping,Date:2013-09-21

nm=nanmean(x);
ns=nanstd(x);

[xrow,xcolumn]=size(x);

if((xrow>1)&&(xcolumn>1))
%����Ƕ��ж��еľ���
z=zeros(size(x));
for m=1:xrow
for n=1:xcolumn
z(m,n)=(x(m,n)-nm(n))./ns(n);
end
end
else
%����ǵ��л��е�����
if(xrow==1)
for m=1:numel(x)
z(m)=(x(m)-nm)./ns;%������
end
else
for m=1:numel(x)
z(m,1)=(x(m)-nm)./ns;%������
end
end
end
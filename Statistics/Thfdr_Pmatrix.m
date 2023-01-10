function Pth=Thfdr_Pmatrix(P,q)


if length(size(P))==3
   Ptemp=[];
   for i=1:size(P,3)
       Px=squeeze(P(:,:,i));
       Px=triu(Px,1);
       a=triu(zeros(size(Px))+1,1);
       a=a(:);
       Px=Px(:);
       Px=Px(a==1);

       Ptemp=[Ptemp;Px(:)];
       
   end
   [~,Pth,tb]=fdr_bh(Ptemp,q,'pdep','no');
   if length(Ptemp)>20
   [fdr,~]=mafdr(Ptemp,'lambda',q);
   Pth=max(fdr(find(fdr<q)));
   end
   if isempty(Pth)
   Pth=0; 
end
   return
end


if size(P,1)~=size(P,2)
    Ptemp=P(:);
   [~,Pth,tb]=fdr_bh(Ptemp,q,'pdep','no');
   if length(Ptemp)>20
   [fdr,~]=mafdr(Ptemp,'lambda',q);
   Pth=max(fdr(find(fdr<q)));
   end
   if isempty(Pth)
   Pth=0; 
end
   return
end

if max(max(abs(P-P')))>0.00001
    Ptemp=P(:);
   [~,Pth,tb]=fdr_bh(Ptemp,q,'pdep','no');
   if length(Ptemp)>20
   [fdr,~]=mafdr(Ptemp,'lambda',q);
   Pth=max(fdr(find(fdr<q)));
   end

   if isempty(Pth)
   Pth=0; 
end
   return
end




P=triu(P,1);

a=triu(zeros(size(P))+1,1);

a=a(:);


P=P(:);
P=P(a==1);
   if length(P)>20
   [fdr,~]=mafdr(P,'lambda',q);
   Pth=max(fdr(find(fdr<q)));
   else
   [~,Pth,~]=fdr_bh(P,q,'pdep','no');

   end
if isempty(Pth)
   Pth=0; 
end

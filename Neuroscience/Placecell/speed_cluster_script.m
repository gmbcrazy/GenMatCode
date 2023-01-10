           %now we plot the kmeans
           figure;
           l=length(speed);
           IDX = kmeans(speed,2);
           scatter(PosX(1:l),PosY(1:l),2,IDX,'filled','Marker','o','SizeData',20);
           figure;
           hist(speed,100);
           hold on;hist(speed(IDX==1),100,'FaceColor','r');
           hold on;hist(speed(IDX==2),100,'FaceColor','b');
   
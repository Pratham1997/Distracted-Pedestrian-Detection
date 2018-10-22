
Clusters = csvread('Clusters.csv');

TestImg = csvread('Joints.csv');
Prob=TestImg(:,3:3:size(TestImg,2));
Prob=mean(Prob,2);
d1=TestImg(:,1:3:size(TestImg,2));
d2=TestImg(:,2:3:size(TestImg,2));
TestImg=[d1,d2];


image_file = fopen('Image_Names.txt');

image_names = textscan(image_file, '%s');

fileID = fopen('PoseProb.txt','w');


for i=1:size(TestImg,1)
%     figure;
        image=imread(strcat('OutputImage/',image_names{1}{i}));
%         imshow(image);
     
%     imshow(strcat('OutputImage/',image_names{1}{i}));
%     hold on;
%     
%      plotSkel(TestImg(i,:));
    
%     figure;
%     imshow(strcat('OutputImage/',image_names{1}{i}));
    CurrentDes=TestImg(i,:);
    
    dist=sum((Clusters-meshgrid(CurrentDes,1:size(Clusters,1))).^2,2);
    [val,clust]=min(dist);
    
        %hold on;
%         
   %plotSkel(Clusters(clust,:));
   
%    plot(TestImg(i,5),TestImg(i,13),'*');
%    hold on;
%     plot(TestImg(i,6),TestImg(i,14),'*');
%     hold on;
%     plot(TestImg(i,1),TestImg(i,9),'*');
%    hold on;
%     plot(TestImg(i,2),TestImg(i,10),'*');
%     
    if clust==2 || clust==3 || clust==4 || clust==5 || clust==11 || clust==14 || clust==15 || clust==26 || clust==27 || clust==28
        %fprintf(fileID,'%s %f\n',image_names{1}{i},0.0);
        continue;
        
    else
        xmin=min(TestImg(i,1),TestImg(i,2));
        ymin=min(TestImg(i,9),TestImg(i,10));
        xmax=max(TestImg(i,1),TestImg(i,2));
        ymax=max(TestImg(i,9),TestImg(i,10));
        
        %hold on;
        %rectangle('Position',[max(1,xmin-30) max(1,ymin-55) min(xmax+30,size(image,2))+30-xmin min(ymax+55,size(image,1))+55-ymin ]);

        im1=imcrop(image,[max(1,xmin-30) max(1,ymin-55) min(xmax+30,size(image,2))+30-xmin min(ymax+55,size(image,1))+55-ymin ]);

        temp=uint8(zeros(3*size(im1,1),3*size(im1,2),3));
        temp(size(im1,1)+1:2*size(im1,1),size(im1,2)+1:2*size(im1,2),:)=im1;
        im1=temp;
        imwrite(im1,strcat('CropHands/','im1-',image_names{1}{i}));
        
        
        xmin=min(TestImg(i,5),TestImg(i,6));
        ymin=min(TestImg(i,13),TestImg(i,14));
        xmax=max(TestImg(i,5),TestImg(i,6));
        ymax=max(TestImg(i,13),TestImg(i,14));
        im2=imcrop(image,[max(1,xmin-30) max(1,ymin-55) min(xmax+30,size(image,2))+30-xmin min(ymax+55,size(image,1))+55-ymin ]);
        %hold on;
        %rectangle('Position',[max(1,xmin-30) max(1,ymin-55) min(xmax+30,size(image,2))+30-xmin min(ymax+55,size(image,1))+55-ymin ]);
        temp=uint8(zeros(3*size(im2,1),3*size(im2,2),3));
        temp(size(im2,1)+1:2*size(im2,1),size(im2,2)+1:2*size(im2,2),:)=im2;
        im2=temp;


        imwrite(im2,strcat('CropHands/','im2-',image_names{1}{i}));
        
        fprintf(fileID,'%s %f\n',image_names{1}{i},Prob(i));

        %Prob(i);
        %figure;
        
        %imshow(im2);
        
        
    end
  
end

fclose(fileID);



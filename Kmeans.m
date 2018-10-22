


data = csvread('VisionProject/JointsTrain.csv');
%label = csvread('l4/label.txt');


d1=data(:,1:3:size(data,2));
d2=data(:,2:3:size(data,2));
prob = data(:, 3:3:size(data,2));
disp(mean(prob));
disp(std(prob))
data=[d1,d2];

featureSize=size(data,2);

K=32;


ClustCenter=zeros(K,featureSize);

rng(100000);
%Randomly sample an initial set of cluster centres.
for i=1:featureSize
    ClustCenter(:,i)=datasample(data(:,i),K);
end




% 
thresh=0.001;
% 

Iterations=0;

%Loop for new cluster centers till convergence.
while(1)
    Iterations=Iterations+1
    
    ClusterMean=zeros(K,featureSize+1);
        
    %Clusterlabel=zeros(K,10);
    
    for i=1:size(data,1)
        CurrentDes=data(i,1:featureSize);
        dist=sum((ClustCenter-meshgrid(CurrentDes,1:K)).^2,2);
        [val,clust]=min(dist);
        
        ClusterMean(clust,1:featureSize)=ClusterMean(clust,1:featureSize)+CurrentDes;
        ClusterMean(clust,featureSize+1)=ClusterMean(clust,featureSize+1)+1;
    end
    
    newClustCenter=zeros(K,featureSize);
    
    for k=1:K
        if(ClusterMean(k,featureSize+1)~=0)
            newClustCenter(k,:)=ClusterMean(k,1:featureSize)/ClusterMean(k,featureSize+1);
        end
    end
    
    diff=sum(sum((newClustCenter-ClustCenter).^2))^0.5;
    if(diff<=thresh)
        break;
    end
    ClustCenter=newClustCenter;

end

for i=1:K
    figure;
    for j=1:8
        plot(ClustCenter(i,j),ClustCenter(i,j+8),'*');
        hold on;
    end
    plot([ClustCenter(i,7),ClustCenter(i,8)],[ClustCenter(i,15),ClustCenter(i,16)])
    hold on;
    plot(ClustCenter(i,1:3),ClustCenter(i,9:11))
    hold on;
    plot([ClustCenter(i,3),ClustCenter(i,7)],[ClustCenter(i,11),ClustCenter(i,15)])
    hold on;
    plot(ClustCenter(i,4:6),ClustCenter(i,12:14))
    hold on;
    plot([ClustCenter(i,4),ClustCenter(i,7)],[ClustCenter(i,12),ClustCenter(i,15)])
    hold on;
    %title(num2str(vote_map(i)));
    h = gca;
    h.YDir = 'reverse';
end

csvwrite('Clusters.csv',ClustCenter);







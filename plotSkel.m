
function m=plotSkel(vect)

TestImg=vect;

for j=1:8
plot(TestImg(j),TestImg(j+8),'*');
hold on;
end
plot([TestImg(7),TestImg(8)],[TestImg(15),TestImg(16)])
hold on;
plot(TestImg(1:3),TestImg(9:11))
hold on;
plot([TestImg(3),TestImg(7)],[TestImg(11),TestImg(15)])
hold on;
plot(TestImg(4:6),TestImg(12:14))
hold on;
plot([TestImg(4),TestImg(7)],[TestImg(12),TestImg(15)])
hold on;
h = gca;
h.YDir = 'reverse';


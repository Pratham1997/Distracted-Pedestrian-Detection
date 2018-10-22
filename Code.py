
import os


import cv2
import numpy
import scipy
import sys
path=sys.argv

os.system("rm OutputImage/*.png")

#os.system("cd darknet")
os.chdir("darknet")

#os.system("./darknet detector test cfg/coco.data cfg/yolo.cfg yolo.weights hel.png")





import re
#os.system("cd ..")


files=os.listdir(path[1])
for pt in files:
    if pt[0] == '.':
        continue
    os.system("./darknet detector test cfg/voc.data cfg/tiny-yolo-voc.cfg tiny-yolo-voc.weights "+path[1]+pt +" > tmp.txt")
    f = open("tmp.txt", "r")

    img = cv2.imread(path[1]+pt)

    temp=0
    crop=[]
    s=0
    for line in f:
        wordList = re.sub("[^\w]", " ",  line).split()

        if temp==1:
            bbox=map(int, re.findall(r'\d+', line))
            crop_img = img[bbox[1]:bbox[3], bbox[0]:bbox[2]]
            crop_img=cv2.resize(crop_img, (140, 320))
            #crop.append(crop_img)
            s=s+1
            name='../OutputImage/'+pt[0:-4]+'-'+str(s)+'.png'
        
            cv2.imwrite(name,crop_img)
            
            temp=0
        if wordList[0]=="person" and int(wordList[1])>=50:
            temp=1

    #os.system("cd ..")

    #sys.path.append("OutputImage")

os.chdir("../pose_tensorflow")


print('------------------')
print ('Starting Part 2')

os.system("python3 part2Test.py")












import os
import re
import cv2

#Run this to detect pedestrains and crop them, and get pose estimates for these detected pedestrians.
os.system('python Code.py ~/Desktop/VisionProject/TestImage/ ')

#Delete previosly stored values
os.system("rm CropHands/*.png")

#Run matlab code to get cluster for all detected pedestrians and crop hands for the pedestrians classified in positive clusters
os.system("/Applications/MATLAB_R2015b.app/bin/./matlab -nodesktop -nodisplay -nosplash -r 'Test;exit;'")

os.chdir("darknet")

path="../CropHands/"


files=os.listdir(path)

imagenames=[]
imageprob=[]
myFile = open('../PhoneProb.txt', 'w')

#Detect cell phones in the hands of the cropped images
for pt in files:
    if pt[0] == '.':
        continue
    os.system("./darknet detector test cfg/coco.data cfg/yolo.cfg yolo.weights "+path+pt +" -thresh 0.15 > tmp1.txt")
    f = open("tmp1.txt", "r")
    
    img = cv2.imread(path+pt)

    temp=0
    
    for line in f:
        wordList = re.sub("[^\w]", " ",  line).split()

        if wordList[0]=="cell" :
            name1 = pt.split('-')[1:]
            name=""
            for i in name1:
                name=name+'-'+i
            name=name[1:]
            if name not in imagenames:
                imagenames.append(name)
                imageprob.append(float(wordList[2])/100)
                myFile.write(name+"  "+str(float(wordList[2])/100)  + '\n')
            temp=1
            break
    if(temp==0):
        name1 = pt.split('-')[1:]
        name=""
        for i in name1:
            name=name+'-'+i
        name=name[1:]
        if name not in imagenames:
            imagenames.append(name)
            imageprob.append(0.0)
            myFile.write(name+"  "+str(float(0))  + '\n')
myFile.close()


f = open("../PoseProb.txt", "r")
out = open('../FinalOutput.txt', 'w')
pos=0
neg=0
TotalNeg=0
TotalPos=0

#Calculate final score and threshhold it
for line in f:
    words=line.split(' ')
    if 'neg' in words[0]:
        TotalNeg=TotalNeg+1
    if 'pos' in words[0]:
        TotalPos=TotalPos+1
    p=imageprob[imagenames.index(words[0])]
    print words[0]
    print float(words[1])
    print p
    
    finalProbab=0.3*float(words[1]) + 0.7 * p
    print finalProbab
    print "\n"
    if finalProbab>0.23:
        out.write(words[0]+" Detection Percentage: "+str(finalProbab*100) +"% " + '\n')
        if 'pos' in words[0]:
            pos=pos+1
    else:
        out.write(words[0]+" Not Detected" + '\n')
        if 'neg' in words[0]:
            neg=neg+1


file=os.listdir("../OutputImage/")

Negpose=0
for i in file:
    if 'neg' in i:
        Negpose+=1


#Write final precision, recall and accuracy to the output file
out.write('\n'+ "Precision : "+ str(float(pos)/pos+TotalNeg-neg) )
out.write('\n'+ "Recall : "+ str(float(pos)/TotalPos ) )

out.write('\n'+ "Prediction Accuracy: "+ str((float(pos+neg+Negpose-TotalNeg)/len(file))*100) +"%")

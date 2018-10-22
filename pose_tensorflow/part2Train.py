
import os
import sys
import csv

from scipy.misc import imread

from config import load_config
from nnet import predict
from util import visualize
from dataset.pose_dataset import data_to_input
import numpy as np

sys.path.append(os.path.dirname(__file__))

path=sys.argv
cfg = load_config("demo/pose_cfg.yaml")

# Load and setup CNN part detector
sess, inputs, outputs = predict.setup_pose_prediction(cfg)

all_pivots = []
myFile = open('../Image_Names.txt', 'w')
# Read image from file
path = '../OutputImage/'
files=os.listdir(path)
for i in files:
    if i[0] == '.':
        continue
    image = imread(path+i, mode='RGB')
    image_batch = data_to_input(image)
    # Compute prediction with the CNN
    outputs_np = sess.run(outputs, feed_dict={inputs: image_batch})
    scmap, locref, _ = predict.extract_cnn_output(outputs_np, cfg)
    # Extract maximum scoring location from the heatmap, assume 1 person
    pose = predict.argmax_pose_predict(scmap, locref, cfg.stride)
    all_pivots.append(list(np.array(pose[6:]).flatten()))
    lst = i[0:-4].split('-')[0:-1]
    file_name = ''
    for j in lst:
        file_name = file_name + j + '-'
    file_name = file_name[0:-1] + '.jpg'
    myFile.write(file_name + '\n')
myFile.close()
myFile = open('../Joints.csv', 'w')
with myFile:
    writer = csv.writer(myFile)
    writer.writerows(all_pivots)
myFile.close()


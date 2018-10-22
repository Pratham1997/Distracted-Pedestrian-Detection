# Distracted-Pedestrian-Detection

1. Copy the testing image files to the Folder TestImage.
2. Add the pretrained yolo model(darknet) to the directory.
3. Run the file test.py<br>
	python test.py<br>
4. The final result i.e the prediction probability of the people using phones in the given image are stored in the FinalOutput.txt file. If it is empty then it does not have a pedestrian using phone.
5. The detected humans are in the OutputImage folder and the hands cropped from the correctly classified images(clustering) are in the CropHands folder.
6. The pretrained model is used in this step. The model can be retrained using the training data in JPEGImages folder. Some examples are shown in the directory. 

References for code:
1. https://pjreddie.com/darknet/yolo/
2. https://github.com/eldar/pose-tensorflow

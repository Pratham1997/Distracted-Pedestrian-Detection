# Distracted-Pedestrian-Detection

1. Copy the testing image files to the Folder TestImage
2. Add the pretrained yolo model(darknet) to the directory.
2. Run the file test.py
	python test.py
3. The final result i.e the prediction probability of the people using phones in the given image are stored in the FinalOutput.txt file. If it is empty then it does not have a pedestrian using phone.
4. The detected humans are in the OutputImage folder and the hands cropped from the correctly classified images(clustering) are in the CropHands folder.

References for code:
1. https://pjreddie.com/darknet/yolo/
2. https://github.com/eldar/pose-tensorflow

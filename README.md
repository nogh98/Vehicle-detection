# Vehicle-detection
This repository is for detecting vehicles from a highway surveillance camera footage project 

**This project is done in MATLAB and its image processing toolbox**

You should provide a video from a highway (at least 100 frames) for the algorithm to work

A sample video is already provided in the repository

# STEPS OF THE ALGORITHM:

**(IMAGE PROCESSING SECTION)**

First, the Background is calculated by the median filter over the temporal dimension of the video (across the frames)

![alt text](https://github.com/nogh98/Vehicle-detection/blob/main/Picture1.jpg?raw=true)

Then, by subtracting the Background from each frame, the foreground is calculated

![foreground](https://user-images.githubusercontent.com/61092649/131709545-5288295d-25e5-4501-ba6a-eb8d7bad424f.gif)



After that, using tresholding and some morphological operations, we are ready to detect vehicle

**(COMPUTER VISION SECTION)**

The black and white frames are fed into a Blob Analysis algorithm which returns the coordinates
of the detected vehicle

![Media1](https://user-images.githubusercontent.com/61092649/131709582-a840f7d9-282f-4bea-bef6-d2153b502751.gif)

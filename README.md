# Vehicle-detection
This repository is for detecting vehicles from a highway surveillance camera footage project 
**This project is done in MATLAB and its image processing toolbox**
You should provide a video from a highway (at least 100 frames) for the algorithm to work
A sample video is already provided in the repository

# STEPS OF THE ALGORITHM:
**(IMAGE PROCESSING SECTION)**
First, the Background is calculated by the median filter over the temporal dimension of the video (across the frames)
Then, by subtracting the Background from each frame, the foreground is calculated
After that, using tresholding and some morphological operations, we are ready to detect vehicle
**(COMPUTER VISION SECTION)**
The black and white frames are fed into a Blob Analysis algorithm which returns the coordinates
of the detected vehicle

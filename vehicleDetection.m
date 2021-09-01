clc;
clear vars;
close all;
videoObj = VideoReader('video2.mp4');
vidFrames = read(videoObj, [1 100]);
 
vidFrames = mat2gray(vidFrames);
%%Simple background
SimpleBackground = zeros(videoObj.Height, videoObj.Width, 3);
Temp = zeros(1,size(vidFrames, 4));
for h = 1:videoObj.Height
    for w = 1:videoObj.Width
        for c = 1:3
            for f = 1:size(vidFrames, 4)
                Temp(1, f) = vidFrames(h, w, c, f);
            end
            SimpleBackground(h, w, c) = median(Temp);
        end
    end
end
imshow(SimpleBackground);
title('background');
pause(10);
close all;
%% Adapative background:
%AdaptiveBackground = zeros(size(vidFrames));
% for h = 1:videoObj.Height
%     output = ['we are processing height: ', num2str(h)];
%     disp(output);
%     for w = 1:videoObj.Width
%         for c = 1:3
%             for f = 1:videoObj.NumFrames
% %                 output = ['we are at frame', num2str(f)];
% %                 disp(output)
%                 AdaTemp = zeros(1, f);
%                 f2 = f;
%                 while f2
% %                     output = ['  for frame ', num2str(f), 'frame ', num2str(f2),' is important'];
% %                     disp(output)
%                     AdaTemp(1, f2) = vidFrames(h, w, c, f2);
%                     f2 = f2 - 1;
% %                     
%                 end
% %                 pause(1)
%                 AdaptiveBackground(h, w, c, f) = median(AdaTemp);
%             end
% %             clc;
%         end
%     end
% end
%% viewing the Adaptive Background:
% for f = 1:118
%     BG = AdaptiveBackground(:,:,:,f);
%     imshow(BG);
%     title(['Background for Frame: ',num2str(f)])
%     pause(0.25)
% end
%% Foreground:
Fg = VideoWriter('foreground');
open(Fg);
SimpleForeGround = zeros(size(vidFrames));
    %% Simple foreground:
    for f = 1:size(vidFrames, 4)
        SimpleForeGround(:, :, :, f) = abs(vidFrames(:, :, :, f) - SimpleBackground(:, :, :));
        
%         imshow(SimpleForeGround(:, :, :, f));
%         title(['foreground for frame ',num2str(f)]);
%         pause(0.25)
    end 
    % Binary version:
     Threshold = .09;
    for f = 1:size(vidFrames, 4)   
        frame = mat2gray(SimpleForeGround(:, :, 1, f) > Threshold);
        imshow(frame);
        title(['Binary foreground for frame: ',num2str(f)]); 
        writeVideo(Fg, frame); 
        pause(0.25)
    end
    close(Fg);
    %% Computer Vision section:
    DetectedVehicles = VideoWriter('Detected');
    open(DetectedVehicles);
    player = vision.DeployableVideoPlayer;
    hblob = vision.BlobAnalysis('Connectivity',8,...
        'MinimumBlobArea',2,...
        'MaximumBlobArea', 100000);
    reader = vision.VideoFileReader('video2.mp4', ...
        'VideoOutputDataType', 'uint8');
    f = 1;
    se0 = strel('disk',0);
    se1 = strel('disk', 1);
    se2 = strel('disk', 2);
    se3 = strel('disk', 3);
    se4 = strel('disk', 4);
    while f<size(vidFrames, 4)
        frame = step(reader);
        fGmask = SimpleForeGround(:,:,1, f) > Threshold;
%           fGmask = imerode(fGmask, se);
          fGmask = imopen(fGmask, se1);
%          fGmask = imerode(fGmask, se);
%           fGmask = imclose(fGmask, se);
         fGmask = imdilate(fGmask, se1);
%         
%        imshow(fGmask);
        
        [area, ~, bbox] = step(hblob, fGmask);
        text = ['Number of Vehicles :', num2str(numel(area))];
        J = insertShape(frame, 'rectangle', bbox);
        J = insertText(J, [20 20; 20 20], text, 'BoxColor', 'red');
        writeVideo(DetectedVehicles, J);
        step(player, J);
        pause(0.25)
        f = f + 1;
    end
    release(reader)
    release(hblob)
    release(player)
    close(DetectedVehicles);
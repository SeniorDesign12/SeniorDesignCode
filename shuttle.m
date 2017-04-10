function shuttle()

workingDir = tempname;
mkdir(workingDir)
mkdir(workingDir,'images')

    function videoOut = convert2writer(videoIn)
        
        shuttleVideo = VideoReader(videoIn);
        
        ii = 1;

        while hasFrame(shuttleVideo)
           img = readFrame(shuttleVideo);
           filename = [sprintf('%03d',ii) '.jpg'];
           fullname = fullfile(workingDir,'images',filename);
           imwrite(img,fullname)    % Write out to a JPEG file (img1.jpg, img2.jpg, etc.)
           ii = ii+1;
        end
        
        
        
    end







end
function  shuttle(videoIn, low, high)
    disp(videoIn);
    disp(low);
    disp(high);
    workingDir = tempname;
    mkdir(workingDir)
    mkdir(workingDir,'images')
    convert2writer(videoIn);
    
    function videoOutOrig = convert2writer(videoIn)
        
       
        videoIn.CurrentTime =low;
        ii = 1;

        while  videoIn.CurrentTime< high
           img = readFrame(videoIn);
           filename = [sprintf('%03d',ii) '.jpg'];
           fullname = fullfile(workingDir,'images',filename);
           imwrite(img,fullname)    % Write out to a JPEG file (img1.jpg, img2.jpg, etc.)
           ii = ii+1;
           display(ii); 
        end
        imageNames = dir(fullfile(workingDir,'images','*.jpg'));
        imageNames = {imageNames.name}';
        outputVideo = VideoWriter(fullfile(workingDir,'shuttle_out.avi'));
        outputVideo.FrameRate = 24;
        open(outputVideo);
        
        for ii = 1:length(imageNames)
           img = imread(fullfile(workingDir,'images',imageNames{ii}));
           writeVideo(outputVideo,img)
        end
        close(outputVideo)
        videoOutOrig = VideoReader(fullfile(workingDir,'shuttle_out.avi'));
        
    end

end
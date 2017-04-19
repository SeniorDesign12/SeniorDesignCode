function PolypFrontEnd()

global augmentedVideo;
global videoSrc;
global frame;
global slider;
%% 
% Create a figure window and two axes to display the input video and the
% processed video.
[backPanel, vAxis] = createFigureAndAxes();
handles= create_buttons(backPanel);
movegui(gcf,'center');

 javaGuiComponents(backPanel);


%% Create Figure, Axes, Titles
% Create a figure window and two axes with titles to display two videos.
    function  [backPanel, vAxis] =  createFigureAndAxes()

        % Create new figure
        backPanel = figure('numbertitle', 'off', ...
               'name', 'Polyp Counter', ...
               'menubar','none', ...
               'toolbar','none', ...
               'resize', 'off', ...
               'renderer','painters', ...
               'HitTest','off',...
               'position',[150 60 1250 800]);
           
          set(gcf,'color',[0.6 0.8 1])

        % Create axes and titles
        vAxis.originalVideo = createPanelAxisTitle(backPanel,[0.02 0.5 0.36 0.4],'Original Video'); % [X Y W H]
        vAxis.augmentedVideo = createPanelAxisTitle(backPanel,[0.6 0.5 0.36 0.4],'Polyp Video');
        set(vAxis.augmentedVideo,'ButtonDownFcn','disp(''axis callback'')',...
            'HitTest','off');
    end

    function vAxis = createPanelAxisTitle(backPanel, pos, axisTitle)

        % Create panel
        hPanel = uipanel('parent',backPanel,'Position',pos,'Units','normalized');

        % Create axis
        vAxis = axes('position',[0 0 1 1],'Parent',hPanel);
        vAxis.XTick = [];
        vAxis.YTick = [];
        vAxis.XColor = [1 1 1];
        vAxis.YColor = [1 1 1];
        
        % Set video title using uicontrol. uicontrol is used so that text
        % can be positioned in the context of the figure, not the axis.
        titlePos = [pos(1)+0.02 pos(2)+pos(4)  0.3 0.05];
        uicontrol('style','text',...
            'FontSize', 13,...
            'FontWeight', 'bold',...
            'String', axisTitle,...
            'Units','normalized',...
            'Parent',backPanel,'Position', titlePos,...
            'BackgroundColor',backPanel.Color);
    end

    function  javaGuiComponents(backPanel)
               
    
        
        
        
        
    end

function sliderCallbackFunc(hObject,event,vAxis)
    
    videoSrc.CurrentTime = get(hObject,'LowValue');
     new_frame = readFrame(videoSrc);
 
    showFrameOnAxis(vAxis.originalVideo, new_frame);
  

   
    
    
    
end

%% Insert Buttons
% Insert buttons to play, pause, upload the videos.
    function handles = create_buttons(backPanel)  
                
       
        
        % Static text that identifies upload function
        uicontrol('Parent', backPanel,...
            'unit','normalized',...
            'style','text',...
            'FontSize', 11,...
            'FontWeight', 'bold',...
            'string','Select video file',...
            'BackgroundColor', 	[0.6 0.8 1],...
            'Position',[.02 .25 .12 .05],...
            'tag','static upload');
        
        % edit text that displays uploaded video name
        handles.fileNameDisplay =uicontrol('Parent', backPanel,...
            'unit','normalized',...
            'style','text',...
            'FontSize', 11,...
            'string','File Name',...
            'BackgroundColor', 	[0.9 1 0.1],...
            'position',[.03 .2 .25 .05],...
            'tag','filenamedisplay');
        % set callback for text button on gui
        set (handles.fileNameDisplay, 'callback', {@fileDisplayCallback,vAxis, handles});
        
        
        %push button for browsing
         handles.browse= uicontrol('Parent', backPanel,...
            'unit','normalized',...
            'style','pushbutton',...
            'FontSize', 11,...
            'string','Browse',...
            'BackgroundColor', 	[0.9 1 0.1],...
            'position',[.29 .2 .1 .05],...
            'callback', {@browseCallback,vAxis, handles});
       
%--------------------------Mutlimedia components----------------------------

       
        %Play Button
        handles.play = uicontrol('Parent', backPanel,...
            'unit', 'normalized',...
            'style','pushbutton',...
            'position',[.14 .35 .06 .06],...
            'callback', {@playCallback,vAxis, handles});
        
        %Pause Button
        handles.pause = uicontrol('Parent', backPanel,...
            'unit', 'normalized',...
            'style','pushbutton',...
            'tag','pause',...
            'position',[.2 .35 .06 .06],...
            'callback', {@pauseCallback,vAxis, handles});
        
        
        %Fastforward Button
        handles.fastForward = uicontrol('Parent', backPanel,...
            'unit', 'normalized',...
            'style','pushbutton',...
            'position',[.26 .35 .06 .06],...
            'callback', {@fastForwardCallback,vAxis, handles});
        
        %Next frame
        handles.nextFrame = uicontrol('Parent', backPanel,...
            'unit', 'normalized',...
            'style','pushbutton',...
            'position',[.32 .35 .06 .06]);
        
         %Rewind Button 
        handles.rewind = uicontrol('Parent', backPanel,...
            'unit', 'normalized',...
            'style','pushbutton',...
            'position',[.08 .35 .06 .06]);
            
        %Skip to Frame before (Reverse next Frame )(rNextFrame))
        handles.rNextFrame = uicontrol('Parent', backPanel,...
            'unit', 'normalized',...
            'style','pushbutton',...
            'position',[.02 .35 .06 .06]);
        add_images(handles);
    end



function add_images( handles)
% hObject    handle to mainGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%image and button list
    images={'PlayButton.jpg','FastForward.jpg', 'PauseButton.jpg', 'RewindButton.jpg', 'NextFrame.jpg', 'LastFrame.jpg'};
    buttons={'play','fastForward', 'pause', 'rewind', 'nextFrame', 'rNextFrame'};
    for i=1:length(images)
        %read the images
        if isempty(strfind(images{i},'png'))
            images{i}=imread(images{i});
        else
            images{i}=imread(images{i},'BackGroundColor',[0.961 0.98 0.98]);        
        end
          %get the button new button sizes and resize images accordingly
          handles.(buttons{i}).Units='pixels';
          images{i}=imresize(images{i},fliplr(handles.(buttons{i}).Position(1,3:4)));
          handles.(buttons{i}).Units='normalized';
          handles.(buttons{i}).CData=images{i};
    end
end
    % --- Executes on play button press 
    function playCallback(hObject,event, vAxis, handles)
  
        upper=get(slider, 'HighValue');
                display(upper);
                videoSrc.CurrentTime = get(slider,'LowValue');
        while  videoSrc.CurrentTime< upper 
            % Read input video frame
            frame = readFrame(videoSrc);
            frame2= readFrame(augmentedVideo);    
            % Display input video frame on axis
            axes(vAxis.augmentedVideo);
            imageHandle=imshow(frame);
            set(imageHandle,'ButtonDownFcn',{@ImageClickCallback, handles})
                
            showFrameOnAxis(vAxis.originalVideo,frame2);
        end
          set(handles.pause, 'Enable', 'on');
        


    end

    function pauseCallback(hObject,event, vAxis, handles)
        uiwait();
        set(handles.pause, 'Enable', 'off');

    end



 % --- Executes on fast forward button press 
    function fastForwardCallback(hObject,event,vAxis, handles)
        i= numFrames+10;
        j= i+1;     
  
        while hasFrame(videoSrc)
            fast_frame = read(videoSrc,[i,j]);
            
            % Display input video frame on axis
            showFrameOnAxis(vAxis.originalVideo, fast_frame);
            i=i+10;
            j=i+1;          
  
        end
    end


    %Executs on Click event on polyp axis
    function ImageClickCallback(hObject,eventData, handles)
        
        ii= videoSrc.CurrentTime;
        if(strcmp(get(handles.pause,'Enable'),'off'))
           img = readFrame(videoSrc);
           filename = [sprintf('%03d',ii) '.jpg'];
            imwrite(img,filename);
            disp(imwrite(img,filename));
            points=getpts(vAxis.augmentedVideo);
            disp(points);
           %newimage=insertMarker(
            
        end
        
    end
    % --- Executes on button press in 'browse'.
    function newVideo = browseCallback(hObject,event,vAxis, handles )
    % hObject    handle to browse pushbutton (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    [filename, pathname]= uigetfile({'*.mp4'}, 'File Selector');
    
   disp(handles);
    
    fullpathname = strcat(pathname, filename);
    videoSrc = VideoReader(fullpathname);
    augmentedVideo= VideoReader(fullpathname);
    disp(videoSrc);
    newVideo = VideoWriter('fullpathname', 'Uncompressed AVI');    
    set( handles.fileNameDisplay, 'String', filename); %Showing FullPathName
    frame = readFrame(videoSrc);
    showFrameOnAxis(vAxis.originalVideo, frame);
    
    axes(vAxis.augmentedVideo);
            imageHandle=imshow(frame);
    set(imageHandle,'ButtonDownFcn',{@ImageClickCallback, handles});
     % Create and initialize a JScrollBar object
        slider = com.jidesoft.swing.RangeSlider(0, videoSrc.Duration, 0, (videoSrc.Duration/8) );  % min,max,low,high
        javacomponent(slider, [30,335.89,435,55], backPanel);
        set(slider, 'MajorTickSpacing',(videoSrc.Duration/15),...
            'PaintTicks',true, 'PaintLabels',true, ...
            'Background',java.awt.Color.white, 'StateChangedCallback',{@sliderCallbackFunc,vAxis});
       
        %shuttle(videoSrc, get(slider,'LowValue'),get(slider, 'HighValue'));
    %here= get(slider,'HighValue');
 
    
    
    end

  
        
end
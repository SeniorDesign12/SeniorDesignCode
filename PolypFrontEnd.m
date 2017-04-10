function PolypFrontEnd()


global videoSrc;
global frame;
global slider;
%% 
% Create a figure window and two axes to display the input video and the
% processed video.
[backPanel, vAxis] = createFigureAndAxes();
handles= create_buttons(backPanel);


 javaGuiComponents(backPanel);

%load button images
play_image = imread('play_button.jpg');
f.forward= imread('fastfoward_image.jpg');


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
               'position',[150 60 1250 800]);

        % Create axes and titles
        vAxis.originalVideo = createPanelAxisTitle(backPanel,[0.02 0.5 0.36 0.4],'Original Video'); % [X Y W H]
        vAxis.augmentedVideo = createPanelAxisTitle(backPanel,[0.6 0.5 0.36 0.4],'Polyp Video');
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
            'BackgroundColor', 	'y',...
            'Position',[.02 .25 .12 .05],...
            'tag','static upload');
        
        % edit text that displays uploaded video name
        handles.fileNameDisplay =uicontrol('Parent', backPanel,...
            'unit','normalized',...
            'style','edit',...
            'FontSize', 11,...
            'string','File Name',...
            'BackgroundColor', 	'r',...
            'position',[.02 .2 .25 .05],...
            'tag','filenamedisplay');
        % set callback for text button on gui
        set (handles.fileNameDisplay, 'callback', {@fileDisplayCallback,vAxis, handles});
        
        
        %push button for browsing
         handles.browse= uicontrol('Parent', backPanel,...
            'unit','normalized',...
            'style','pushbutton',...
            'FontSize', 11,...
            'string','Browse',...
            'BackgroundColor', 	'y',...
            'position',[.27 .2 .1 .05],...
            'callback', {@browseCallback,vAxis, handles});
       
%--------------------------Mutlimedia components----------------------------

       
        %Play Button
        handles.play = uicontrol('Parent', backPanel,...
            'unit', 'normalized',...
            'style','pushbutton',...
            'position',[.16 .35 .06 .06],...
            'callback', {@playCallback,vAxis, handles});
        
        %Pause Button
        handles.pause = uicontrol('Parent', backPanel,...
            'unit', 'normalized',...
            'style','pushbutton',...
            'FontSize', 11,...
            'string','Pause',...
            'position',[.22 .35 .06 .06],...
            'callback', {@pauseCallback,vAxis, handles});
        
        
        %Fastforward Button
        handles.fastForward = uicontrol('Parent', backPanel,...
            'unit', 'normalized',...
            'style','pushbutton',...
            'FontSize', 11,...
            'string','F.Forward',...
            'BackgroundColor', 	'y',...
            'position',[.28 .35 .06 .06],...
            'callback', {@fastForwardCallback,vAxis, handles});
        
        %Next frame
        handles.nextFrame = uicontrol('Parent', backPanel,...
            'unit', 'normalized',...
            'style','pushbutton',...
            'FontSize', 11,...
            'string','nFrame',...
            'BackgroundColor', 	'y',...
            'position',[.34 .35 .06 .06]);
        
         %Rewind Button 
        handles.rewind = uicontrol('Parent', backPanel,...
            'unit', 'normalized',...
            'style','pushbutton',...
            'FontSize', 11,...
            'string','Rewind',...
            'BackgroundColor', 	'y',...
            'position',[.1 .35 .06 .06]);
            
        %Skip to Frame before (Reverse next Frame )(rNextFrame))
        handles.rNextFrame = uicontrol('Parent', backPanel,...
            'unit', 'normalized',...
            'style','pushbutton',...
            'FontSize', 11,...
            'string','RewindNF',...
            'BackgroundColor', 	'y',...
            'position',[.04 .35 .06 .06]);
        add_images(handles);
    end

function add_images( handles)
% hObject    handle to mainGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%image and button list
    images={'play-white-shawdows.png','fastfoward_image.jpg'};
    buttons={'play','fastForward'};
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
    function playCallback(hObject,event,vAxis, handles)
                upper=get(slider, 'HighValue');
                display(upper);
                videoSrc.CurrentTime = get(slider,'LowValue');
        while  videoSrc.CurrentTime< upper 
            % Read input video frame
            frame = readFrame(videoSrc);
    
            % Display input video frame on axis
            showFrameOnAxis(vAxis.originalVideo, frame);
       
        end
        
        


    end

    function pauseCallback(hObject,event,vAxis, handles)
        uiwait();
       

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

    % --- Executes on button press in 'browse'.
    function browseCallback(hObject,event,vAxis, handles )
    % hObject    handle to browse pushbutton (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    [filename, pathname]= uigetfile({'*.mp4'}, 'File Selector');
    
   
    
    fullpathname = strcat(pathname, filename);
    videoSrc = VideoReader(fullpathname);
        
    set( handles.fileNameDisplay, 'String', filename); %Showing FullPathName
    frame = readFrame(videoSrc);
    showFrameOnAxis(vAxis.originalVideo, frame);

     % Create and initialize a JScrollBar object
        slider = com.jidesoft.swing.RangeSlider(0, videoSrc.Duration, 0, (videoSrc.Duration/4) );  % min,max,low,high
        javacomponent(slider, [30,335.89,435,55], backPanel);
        set(slider, 'MajorTickSpacing',(videoSrc.Duration/15),...
            'PaintTicks',true, 'PaintLabels',true, ...
            'Background',java.awt.Color.white, 'StateChangedCallback',{@sliderCallbackFunc,vAxis});
      
    %here= get(slider,'HighValue');
 
    
    
    end

    
end
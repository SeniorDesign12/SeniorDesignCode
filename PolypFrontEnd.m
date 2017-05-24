function PolypFrontEnd()
workingDir = tempname;
mkdir(workingDir)
mkdir(workingDir,'images')

global augmentedVideo;
global videoSrc;
global frame;
global slider;
global A;
h =[0, 1];
count=2;
%% 
% Create a figure window and two axes to display the input video and the
% processed video.
[backPanel, vAxis] = createFigureAndAxes();
handles= create_buttons(backPanel);
A = {};
movegui(gcf,'center');

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
               'position',[150 60 1150 600],...
               'WindowKeyPressFcn',@keyPress);
           
          set(gcf,'color',[0.6 0.8 1])

        % Create axes and titles
        vAxis.originalVideo = createPanelAxisTitle(backPanel,[0.02 0.5 0.36 0.4],'Original Video'); % [X Y W H]
        vAxis.augmentedVideo = createPanelAxisTitle(backPanel,[0.5 0.5 0.36 0.4],'Polyp Video');
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
            'position',[.29 .2 .1 .05],...
            'callback', {@browseCallback,vAxis, handles});
        
%------------------------ Buttons under Augmented Video Panel--------------
        handles.countDisplay= uicontrol('Parent', backPanel,...
            'unit', 'normalized',...
            'style','text',...
            'FontSize', 15,...
            'position',[.75 .2 .06 .06],...
            'callback', {@playCallback,vAxis, handles});
        
        
        handles.countLabel= uicontrol('Parent', backPanel,...
            'unit', 'normalized',...
            'style','text',...
            'string', 'Polyp Count',...
            'position',[.55 .2 .15 .06],...
            'FontSize', 15,...
            'callback', {@playCallback,vAxis, handles});
        
        handles.save = uicontrol('Parent', backPanel,...
            'unit', 'normalized',...
            'style','pushbutton',...
            'string', 'Save',...
            'position',[.60 .35 .15 .06],...
            'FontSize', 15,...
            'callback', {@saveCallback,vAxis, handles});
       
%--------------------------Mutlimedia components----------------------------

       %Pause Button
        handles.pause = uicontrol('Parent', backPanel,...
            'unit', 'normalized',...
            'style','pushbutton',...
            'tag','pause',...
            'position',[.2 .35 .06 .06],...
            'callback', {@pauseCallback,vAxis, handles});
        
        %Play Button
        handles.play = uicontrol('Parent', backPanel,...
            'unit', 'normalized',...
            'style','pushbutton',...
            'position',[.14 .35 .06 .06],...
            'callback', {@playCallback,vAxis, handles});
        add_images(handles);
    end



function add_images( handles)
% hObject    handle to mainGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%image and button list
    images={'PlayButton.jpg', 'PauseButton.jpg'};
    buttons={'play', 'pause',};
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
        set(handles.pause, 'Enable', 'on');
        upper=get(slider, 'HighValue');
                display(upper);
                videoSrc.CurrentTime = get(slider,'LowValue');
                 augmentedVideo.CurrentTime = get(slider,'LowValue');
        while  videoSrc.CurrentTime< upper 
            % Read input video frame
            frame = readFrame(videoSrc);
            frame2= readFrame(augmentedVideo);    
            % Display input video frame on axis
            axes(vAxis.augmentedVideo);
            imageHandle=imshow(frame2);
            set(imageHandle,'ButtonDownFcn',{@ImageClickCallback, handles})
            showFrameOnAxis(vAxis.originalVideo,frame2);
        end
    end
    function keyPress(fig_obj,eventDat)
            if (strcmp(get(fig_obj, 'CurrentKey'),'delete')&& count>2)
                if (ishandle(h(count)))
                    delete(h(count));
                    count=count-1;
                    set(handles.countDisplay, 'String', count-2);
                    A = A(1:end-1);
                end;
            end
% or 
disp(eventDat) 
    end

    function pauseCallback(hObject,event, vAxis, handles)
         set(hObject, 'Enable', 'off');
        uiwait();
    end

    %Executes on Click event on polyp axis
    function ImageClickCallback(hObject,eventData, handles, imageHandle)
               ii= videoSrc.CurrentTime;
         if(strcmp(get(handles.pause,'Enable'),'off'))
           img = readFrame(videoSrc);
            filename = [sprintf('%03d',ii) '.jpg'];
            fullname = fullfile(workingDir,'images',filename);
             imwrite(img,fullname);
             [x,y, button]=ginput(1);
             B = [x y]
             A = cat(1, A, B);
             disp(button);
            % Prevent image from being blown away.
              if (button==1)
                count=count+1;
                disp('Count is ')
                disp(count);
                 hold on;
                 h(count)= plot(x,y,'b+', 'MarkerSize', 30);
                 set(handles.countDisplay, 'String', count-2);
              end 
         end
        clearvars button;   
    end

    % --- Executes on save button press
    function saveCallback(hObject,event, vAxis, handles)
        A = cell2mat(A);
        A = double(A);
        [filename, foldername] = uiputfile('Where do you want the file saved?');
        complete_name = fullfile(foldername, filename);
        newImage = readFrame(augmentedVideo);
        RGB = insertMarker(newImage, A, 'color','blue','size',30);
        imwrite(RGB,complete_name);
        A = {};
    end


    % --- Executes on button press in 'browse'.
    function [newVideo, imageHandle] = browseCallback(hObject,event,vAxis, handles )
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
    imageHandle=imshow(frame);
    set(vAxis.augmentedVideo,'ButtonDownFcn',{@ImageClickCallback, handles, imageHandle});

     % Create and initialize a JScrollBar object
        slider = com.jidesoft.swing.RangeSlider(0, videoSrc.Duration, 0, (videoSrc.Duration) );  % min,max,low,high
        javacomponent(slider, [28,255,420,40], backPanel);
        set(slider, 'MajorTickSpacing',(videoSrc.Duration/15),...
            'PaintTicks',true, 'PaintLabels',true, ...
            'Background',java.awt.Color.white, 'StateChangedCallback',{@sliderCallbackFunc,vAxis});
    end       
end
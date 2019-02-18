try
    clear all; close all
    %% Load Screen
    Screen('Preference', 'SkipSyncTests', 1);
    [window, rect] = Screen('OpenWindow', 0); % opening the screen
    Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA); % allowing transparency in the photos 

    HideCursor(); 
    window_w = rect(3); % defining size of screen
    window_h = rect(4);

    x_center = window_w/2;
    y_center = window_h/2;

    cd('Face_Stimuli')

    %% reading the transparency mask 

    Mask_Plain = imread('mask.png');
    Mask_Plain = 255-Mask_Plain(:,:,1); %use first layer % added

    %% loading the face stimuli 

    for i = 1:147
        tmp_bmp = imread([num2str(i) '.PNG']);
        tmp_bmp(:,:,4) = Mask_Plain;
        tid(i) = Screen('MakeTexture', window, tmp_bmp);
        Screen('DrawText', window, 'Loading...', x_center, y_center-25); % Write text to confirm loading of images
        Screen('DrawText', window, [int2str(int16(i*100/147)) '%'], x_center, y_center+25); % Write text to confirm percentage complete
        Screen('Flip', window); % Display text
    end

    w_img = size(tmp_bmp, 2) * 0.5; % width of pictures
    h_img = size(tmp_bmp, 1) * 0.5 ; % height of pictures

    face_number  = 1:147; % making an array of numbers 1-147 

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Calculating the Circle Locations

    num_pts = 8;
    radius = window_h/2-h_img/2;

    % Get a sequence of angles equally spaced around a circle using the
    % function "linspace"
    theta = linspace(360/num_pts, 360, num_pts);

    % Calculate coordinates of image locations centered along the circle
    % using basic trigonometry
    % Tips: function "cosd" and "sind"
    x_circle = window_w/2 + (cosd(theta) * radius);
    y_circle = window_h/2 + (sind(theta) * radius);

    xy_rect = [x_circle-w_img/2; y_circle-h_img/2; x_circle+w_img/2; y_circle+h_img/2]; % put all of the coordinates together and center the pictures

    %% choosing the faces to show
    % choose n faces randomly from the loaded faces 
    faces = randsample(1:147, num_pts); 


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



    %% Displaying the chosen faces in a circle 

    Screen('DrawTextures', window, tid(faces), [], xy_rect); % display the faces
    Screen('Flip', window);
    KbWait
    Screen('CloseAll');
catch
    Screen('CloseAll');
    rethrow(lasterror);
end;
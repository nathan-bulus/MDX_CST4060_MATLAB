classdef EdgeDetectionApp_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure               matlab.ui.Figure
        EdgeDetectionAppPanel  matlab.ui.container.Panel
        SelectImageButton      matlab.ui.control.Button
        Image                  matlab.ui.control.UIAxes
        SobelEdge              matlab.ui.control.UIAxes
        CustomEdge             matlab.ui.control.UIAxes
        RobertsEdge            matlab.ui.control.UIAxes
        CannyEdge              matlab.ui.control.UIAxes
    end

    
    properties (Access = private)
        grayImage % Description
        input_image
        filtered_image
    end
    
    methods (Access = private)
        
        function EdgeFunctions(app, ImageFile)
            % Input original image
            app.input_image = ImageFile;
            
            % Convert image to grayscale
            app.grayImage = im2gray(app.input_image);
            
            % Apply Guassian Blur filter to image
            app.filtered_image = imgaussfilt(app.grayImage, 2);
            
            % Apply matlab's edge function to image
            sobel_output = edge(app.filtered_image, 'sobel');
            roberts_output = edge(app.filtered_image, 'roberts');
            canny_output = edge(app.filtered_image, 'canny');
            
            %display image
            imshow(app.input_image, 'Parent', app.Image)
            
            % display the results of the edge operator
            imshow(sobel_output, 'Parent', app.SobelEdge);
            imshow(roberts_output, 'Parent', app.RobertsEdge);
            imshow(canny_output, 'Parent', app.CannyEdge);
                       
        end
        
        function customEdge(app)
           img = im2gray(app.input_image);
           img = double(img);
           % Convert the image to double
           %img = app.filtered_image;
            
           % Custom kernel
           % Extended sobel kernel 5x5
           K1 = [1, 1, 0, -1, -1;  0, 0, 0, 0, 0; 2, 2, 0, -2, -2; 0, 0, 0, 0, 0; 1, 1, 0, -1, -1];
           K2 = rot90(K1); %rotate K1 by 90 degrees
                      
           % Convolution using conv2 function
           Gx = conv2(img, K1);
           Gy = conv2(img, K2);
           
           % Magnitude of the Gradient
           output_image = sqrt(Gx.^2 + Gy.^2);
           
           
           % Calculate sum of all the gray level
           % pixel's value of the GrayScale Image
           [x, y, z] = size(img);
           sum = 0;
           for i=1:x
               for j=1:y
                   sum = sum + img(i, j);
               end
           end
           
           % Define a threshold value
           % Calculate By dividing sum of pixels
           % total number of pixels = row*columns (i.e x*y)
           threshold = sum/(x*y);
           output_image = round(max(output_image, threshold));
           output_image = uint8(output_image);
           output_image = imbinarize(output_image);
           
           % display result of custom edge function
           imshow(output_image, 'Parent', app.CustomEdge);
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: SelectImageButton
        function SelectImageButtonPushed(app, event)
            filterspec = {'*.; *.jpg; *.png; *.tif;'};
            [file_name, file_path] = uigetfile(filterspec);
            fname = strcat(file_path, file_name);
            
            % if user closes the dialog box
            if isequal(file_name,0)
                return
            end
            
            image_file = imread(fname);
            EdgeFunctions(app, image_file);
            customEdge(app)
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 1138 806];
            app.UIFigure.Name = 'MATLAB App';

            % Create EdgeDetectionAppPanel
            app.EdgeDetectionAppPanel = uipanel(app.UIFigure);
            app.EdgeDetectionAppPanel.TitlePosition = 'centertop';
            app.EdgeDetectionAppPanel.Title = 'Edge Detection App';
            app.EdgeDetectionAppPanel.Position = [1 1 1138 806];

            % Create SelectImageButton
            app.SelectImageButton = uibutton(app.EdgeDetectionAppPanel, 'push');
            app.SelectImageButton.ButtonPushedFcn = createCallbackFcn(app, @SelectImageButtonPushed, true);
            app.SelectImageButton.Position = [47 162 100 22];
            app.SelectImageButton.Text = 'Select Image';

            % Create Image
            app.Image = uiaxes(app.EdgeDetectionAppPanel);
            title(app.Image, 'Input Image')
            app.Image.XTick = [];
            app.Image.XTickLabel = '';
            app.Image.YTick = [];
            app.Image.Position = [20 226 352 305];

            % Create SobelEdge
            app.SobelEdge = uiaxes(app.EdgeDetectionAppPanel);
            title(app.SobelEdge, 'Sobel Function')
            app.SobelEdge.XTick = [];
            app.SobelEdge.XTickLabel = '';
            app.SobelEdge.YTick = [];
            app.SobelEdge.Position = [402 462 333 305];

            % Create CustomEdge
            app.CustomEdge = uiaxes(app.EdgeDetectionAppPanel);
            title(app.CustomEdge, 'Custom Function')
            app.CustomEdge.XTick = [];
            app.CustomEdge.XTickLabel = '';
            app.CustomEdge.YTick = [];
            app.CustomEdge.Position = [773 462 333 305];

            % Create RobertsEdge
            app.RobertsEdge = uiaxes(app.EdgeDetectionAppPanel);
            title(app.RobertsEdge, 'Roberts Function')
            app.RobertsEdge.XTick = [];
            app.RobertsEdge.XTickLabel = '';
            app.RobertsEdge.YTick = [];
            app.RobertsEdge.Position = [402 107 333 305];

            % Create CannyEdge
            app.CannyEdge = uiaxes(app.EdgeDetectionAppPanel);
            title(app.CannyEdge, 'Canny Function')
            app.CannyEdge.XTick = [];
            app.CannyEdge.XTickLabel = '';
            app.CannyEdge.YTick = [];
            app.CannyEdge.Position = [773 107 333 305];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = EdgeDetectionApp_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end
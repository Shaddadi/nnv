classdef AveragePooling2DLayer < handle
    % The convolutional 2D layer class
    %   Contain constructor and reachability analysis methods
    % Main references:
    % 1) An intuitive explanation of convolutional neural networks: 
    %    https://ujjwalkarn.me/2016/08/11/intuitive-explanation-convnets/
    % 2) More detail about mathematical background of CNN
    %    http://cs231n.github.io/convolutional-networks/
    % 3) Matlab implementation of Convolution2DLayer and AveragePooling2dLayer (for training and evaluating purpose)
    %    https://www.mathworks.com/help/deeplearning/ug/layers-of-a-convolutional-neural-network.html
    %    https://www.mathworks.com/help/deeplearning/ref/nnet.cnn.layer.convolution2dlayer.html
    %    https://www.mathworks.com/help/deeplearning/ref/nnet.cnn.layer.averagepooling2dlayer.html
    
    %   Dung Tran: 6/15/2019
    
    properties
        Name = 'average_pooling_2d_layer';
        % Hyperparameters
        PoolSize = [2 2];
        Stride = [1 1]; % step size for traversing input
        PaddingMode = 'manual'; 
        PaddingSize = [0 0 0 0]; % size of padding [t b l r] for nonnegative integers
        
    end
    
    
    % setting hyperparameters method
    methods
        
        % constructor of the class
        function obj = AveragePooling2DLayer(varargin)           
            % author: Dung Tran
            % date: 6/17/2019    
            % update: 
            
            switch nargin
                
                case 4
                    
                    name = varargin{1};
                    poolSize = varargin{2};
                    stride = varargin{3};
                    paddingSize = varargin{4};
                    
                    if ~ischar(name)
                        error('Name is not char');
                    else
                        obj.Name = name;
                    end                    
                    
                    if size(poolSize, 1) ~= 1 || size(poolSize, 2) ~= 2
                        error('Invalid pool size');
                    else
                        obj.PoolSize = poolSize;
                    end
                    
                    if size(stride, 1) ~= 1 || size(stride, 2) ~= 2
                        error('Invalid stride');
                    else 
                        obj.Stride = stride; 
                    end
                    
                    if size(paddingSize, 1) ~= 1 || size(paddingSize, 2) ~= 4
                        error('Invalide padding size');
                    else
                        obj.PaddingSize = paddingSize;
                    end
                
                case 3
                    
                    poolSize = varargin{1};
                    stride = varargin{2};
                    paddingSize = varargin{3};
                    
                    if size(poolSize, 1) ~= 1 || size(poolSize, 2) ~= 2
                        error('Invalid pool size');
                    else
                        obj.PoolSize = poolSize;
                    end
                    
                    if size(stride, 1) ~= 1 || size(stride, 2) ~= 2
                        error('Invalid stride');
                    else 
                        obj.Stride = stride; 
                    end
                    
                    if size(paddingSize, 1) ~= 1 || size(paddingSize, 2) ~= 4
                        error('Invalide padding size');
                    else
                        obj.PaddingSize = paddingSize;
                    end
                    
                case 0
                    
                    obj.Name = 'average_pooling_2d_layer';
                    % Hyperparameters
                    obj.PoolSize = [2 2];
                    obj.Stride = [1 1]; % step size for traversing input
                    obj.PaddingMode = 'manual'; 
                    obj.PaddingSize = [0 0 0 0]; % size of padding [t b l r] for nonnegative integers
                                    
                otherwise
                    error('Invalid number of inputs (should be 0, 3 or 4)');
                                 
            end 
             
        end
        
        % set poolsize method 
        function set_poolSize(obj, poolSize)
            % @stride: stride matrix
            % author: Dung Tran
            % date: 12/5/2018
            
            [n, m] = size(poolSize);
            
            if n ~= 1
                error('poolSize matrix shoule have one row');
            end
            
            if m == 1
                obj.PoolSize = [poolSize poolSize];
            elseif m == 2
                obj.PoolSize = [poolSize(1) poolSize(2)];
            elseif m ~=1 && m ~=2 
                error('Invalid poolSize matrix');
            end
            
        end
        
        % set stride method 
        function set_stride(obj, stride)
            % @stride: stride matrix
            % author: Dung Tran
            % date: 12/5/2018
            
            [n, m] = size(stride);
            
            if n ~= 1
                error('Stride matrix shoule have one row');
            end
            
            if m == 1
                obj.Stride = [stride stride];
            elseif m == 2
                obj.Stride = [stride(1) stride(2)];
            elseif m ~=1 && m ~=2 
                error('Invalid stride matrix');
            end
            
        end
        
        
        % set padding 
        function set_padding(obj, padding)
            % @padding: padding matrix
            % author: Dung Tran
            % date: 12/5/2018
            
            [n, m] = size(padding);
            
            if n ~= 1
                error('Padding matrix shoule have one row');
            end
            
            if m == 1
                obj.PaddingSize = [padding padding padding padding];
            elseif m == 4
                obj.PaddingSize = [padding(1) padding(2) padding(3) padding(4)];
            elseif m ~=1 && m ~=4 
                error('Invalid padding matrix');
            end
        end
        
        
    end
        
    % evaluation method
    methods
        
        function y = evaluate(obj, input)
            % @input: 2 or 3-dimensional array, for example, input(:, :, :), 
            % @y: 2 or 3-dimensional array, for example, y(:, :, :)
            
            % author: Dung Tran
            % date: 6/17/2019
            
            % @y: high-dimensional array (output volume), depth of output = number of filters
            
            % author: Dung Tran
            % date: 12/10/2018
            
            
            n = size(input);
            if length(n) == 3
                NumChannels = n(3);
            elseif length(n) == 2
                NumChannels = 1;
            else
                error('Invalid input');
            end
            
            [h, w] = obj.get_size_averageMap(input(:,:,1));   
            y(:,:,NumChannels) = zeros(h, w); % preallocate 3D matrix
            for i=1:NumChannels % number of channels
                % compute average map with i^th channels 
                y(:, :, i) = obj.compute_averageMap(input(:,:,i));
            end
            
                   
        end
        
        % parallel evaluation on an array of inputs
        function y = evaluate_parallel(obj, inputs)
            % @inputs: an array of inputs
            % @y: an array of outputs 
            
            % author: Dung Tran
            % date: 12/16/2018
            y = [];
            parfor i=1:length(inputs)
                y = [y obj.evaluate(inputs(i))];               
            end
            
            
        end
        
        
        
        % parse a trained averagePooling2dLayer from matlab
        function parse(obj, average_Pooling_2d_Layer)
            % @average_Pooling_2d_Layer: a average pooling 2d layer from matlab deep
            % neural network tool box
            % @L : a AveragePooling2DLayer obj for reachability analysis purpose
            
            % author: Dung Tran
            % date: 6/17/2019
            
            
            if ~isa(average_Pooling_2d_Layer, 'averagePooling2dLayer')
                error('Input is not a Matlab averagePooling2dLayer class');
            end
            
            obj.Name = average_Pooling_2d_Layer.Name;
            obj.PoolSize = average_Pooling_2d_Layer.PoolSize;
            obj.Stride = average_Pooling_2d_Layer.Stride;
            obj.PaddingSize = average_Pooling_2d_Layer.PaddingSize;
            fprintf('Parsing a Matlab average pooling 2d layer is done successfully');
            
        end
        
        % parse input image with padding
        function padded_I = get_zero_padding_input(obj, input)
            % @input: an array of input image
            % @paddingSize: paddingSize to construct the new input I
            % @padded_I: the new input array affer applying padding
            
            % author: Dung Tran
            % date: 6/17/2019
            
            n = size(input);        
                        
            t = obj.PaddingSize(1);
            b = obj.PaddingSize(2);
            l = obj.PaddingSize(3);
            r = obj.PaddingSize(4);
 
            
            if length(n) == 2 
                % input volume has only one channel                
                h = n(1); % height of input
                w = n(2); % width of input 
                      
                padded_I = zeros(t + h + b, l + w + r);
                padded_I(t+1:t+h,l+1:l+w) = input; % new constructed input volume
                
            elseif length(n) > 2
                % input volume may has more than one channel
                            
                h = n(1); % height of input
                w = n(2); % width of input 
                d = n(3); % depth of input (number of channel)
               
                padded_I = zeros(t + h + b, l + w + r, d); % preallocate 3D matrix
                for i=1:d
                    padded_I(t+1:t+h, l+1:l+w, i) = input(:, :, i); % new constructed input volume
                end              
                
                
            else
                error('Invalid input');
            end
                         
        end
        
        
        % compute feature map for specific input and weight
        function averageMap = compute_averageMap(obj, input)
            % @input: is input image 
            % @averageMap: averageMap of the input image
                        
            % author: Dung Tran
            % date: 6/17/2019
            
            % this averageMap computation work similar to the featureMap
            % computation in convolutional layer where the weight matrix is
            % W = ? with no dilation
            
            I = obj.get_zero_padding_input(input);          
            m = obj.PoolSize; % m(1) is height and m(2) is width of the filter            
            [h, w] = obj.get_size_averageMap(input);

            % a collection of start points (the top-left corner of a square) of the region of input that is filtered
            map = cell(h, w); 
            
            for i=1:h
                for j=1:w
                    map{i, j} = zeros(1, 2);

                    if i==1
                        map{i, j}(1) = 1;
                    end
                    if j==1
                        map{i, j}(2) = 1;
                    end

                    if i > 1
                        map{i, j}(1) = map{i - 1, j}(1) + obj.Stride(1);
                    end

                    if j > 1
                        map{i, j}(2) = map{i, j - 1}(2) + obj.Stride(2);
                    end

                end
            end
                        
            % compute feature map for each cell of map
            % do it in parallel using cpu or gpu
            % TODO: explore power of using GPU for this problem
            
            averageMap = zeros(1, h*w); % using single vector for parallel computation
           

            for l=1:h*w
                a = mod(l, w);
                if a == 0
                    i = floor(l/w);
                    j = w;
                else
                    j = a;
                    i = floor(l/w) + 1;
                end

                % get a filtered region
                val = 0;
                i0 = map{i, j}(1);
                j0 = map{i, j}(2);
                
                for i=i0:1:i0+m(1)-1
                    %display(i);
                    for j=j0:1:j0+m(2)-1
                        %display(j);
                        val = val + I(i,j);                       
                    end
                end
                
                averageMap(l) = val/(m(1)*m(2));               

            end

            averageMap = reshape(averageMap, [h, w]);
            averageMap = averageMap.';

        end
        
        
        % precompute height and width of average map
        function [h, w] = get_size_averageMap(obj, input)
            % @input: is input 
            % @[h, w]: height and width of average map
                    
            % author: Dung Tran
            % date: 6/17/2019
            
            % reference: http://cs231n.github.io/convolutional-networks/#pool
            
            I = obj.get_zero_padding_input(input);
            n = size(I); % n(1) is height and n(2) is width of input
            m = obj.PoolSize; % m(1) is height and m(2) is width of the pooling filter
            
            % I is assumed to be the input after zero padding
            % output size: 
            % (InputSize - FilterSize)/Stride + 1
            
            h = floor((n(1) - m(1) ) / obj.Stride(1) + 1);  % height of average map
            w = floor((n(2) - m(2)) / obj.Stride(2) + 1);  % width of average map

        end
        
    end
        
    % reachability analysis using star set
    methods
        % reachability analysis method using Stars
        % a star represent a set of images (2D matrix of h x w)
        function S = reach_star_single_input(obj, input)
            % @inputs: an ImageStar input set
            % @option: = 'single' single core for computation
            %          = 'parallel' multiple cores for parallel computation
            % @S: an imagestar with number of channels = obj.NumFilters
            
            % author: Dung Tran
            % date: 6/17/2019
            
            if ~isa(input, 'ImageStar')
                error('The input is not an ImageStar object');
            end
            
                       
            % compute output sets
            [h, w] = obj.get_size_averageMap(input.V(:,:,1,1));
            Y(:,:,input.numPred + 1, input.numChannel) = zeros(h, w); % output basis matrices            
            I(:, :, input.numChannel) = zeros(input.height, input.width); % pre-allocate memory
            for i=1:input.numPred + 1
                for j=1:input.numChannel
                    I(:,:,j) = input.V(:,:, i, j);
                end
                
                Z = obj.evaluate(I);
                                                
                for k=1:input.numChannel
                    Y(:,:,i, k) = Z(:, :, k);
                end
                                
            end 
            S = ImageStar(Y, input.C, input.d, input.pred_lb, input.pred_ub);
        end
    end
    
end


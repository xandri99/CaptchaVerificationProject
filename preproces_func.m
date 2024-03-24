function [seg1, seg2, seg3] = preproces_func(image)
    % Load 1 image
    %image = imread('imagedata/train_0008.png');
    
    % Low-pass filtering - Gaussian
    kernel_size = 7;
    filter = fspecial('gaussian', kernel_size, 2);
    lp_gaussian = imfilter(image, filter, 'same');
    
    % High-pass filtering
    hp_gaussian = image - lp_gaussian;
    
    % Band-pass filtering
    bp_gaussian = lp_gaussian .* hp_gaussian;
    
    % figure(1)
    % subplot(1,3,1), imshow(lp_gaussian), title('Low-pass filtering');
    % subplot(1,3,2), imshow(hp_gaussian), title('High-pass filtering');
    % subplot(1,3,3), imshow(bp_gaussian), title('Band-pass filtering');
    
    % Thresholding
    bin_image = ~imbinarize(lp_gaussian); 
    
    % Median Filtering
    bin_image = medfilt2(bin_image);
    
    % Erosion
    se = strel('disk', 3); 
    eroded_image = imerode(bin_image, se);

    % eroded_image = bwareaopen(eroded_image, 50);
    
    
    % figure(2)
    % subplot(1,3,1), imshow(lp_gaussian), title('After gaussian filtering');
    % subplot(1,3,2), imshow(bin_image), title('After median filtering');
    % subplot(1,3,3), imshow(eroded_image), title('After erosion');
    % 
    % figure(3)
    % subplot(1,3,1), imshow(extracted_digits(1).Image);
    % subplot(1,3,2), imshow(extracted_digits(2).Image);
    % subplot(1,3,3), imshow(extracted_digits(3).Image);

    % Without seperating overlaps
    cc = bwconncomp(eroded_image);
    extracted_digits = regionprops(cc, 'Image');

    % Crop and Save the Digits
    switch cc.NumObjects
    case 1
        seg1 = extracted_digits(1).Image(:, 1:round(end/3), :); % First half of the image
        seg2 = extracted_digits(1).Image(:, round(end/3+1):round(2*end/3), :); % Second half of the image
        seg3 = extracted_digits(1).Image(:, round(2*end/3+1):end, :); % Third half of the image
    case 2
        [~, width1] = size(extracted_digits(1).Image);
        [~, width2] = size(extracted_digits(2).Image);
        if(width1 > width2)
            seg1 = extracted_digits(1).Image(:, round(1:end/2), :); % First half of the image
            seg2 = extracted_digits(1).Image(:, round(end/2+1):end, :); % Second half of the image
            seg3 = extracted_digits(2).Image;
        else
            seg1 = extracted_digits(1).Image;
            seg2 = extracted_digits(2).Image(:, round(1:end/2), :); % First half of the image
            seg3 = extracted_digits(2).Image(:, round(end/2+1):end, :); % Second half of the image
        end
    case 3
        seg1 = extracted_digits(1).Image;
        seg2 = extracted_digits(2).Image;
        seg3 = extracted_digits(3).Image;
    otherwise
        % we will return only the 3 biggest segmented images, since the
        % other ones are noise.
        image_sizes = zeros(1, cc.NumObjects);
        for i = 1:cc.NumObjects
            [height, width] = size(extracted_digits(i).Image);
            image_sizes(i) = height * width;
        end
        sorted_sizes = sort(image_sizes, 'descend');
        sorted_sizes = sorted_sizes(1:3);
        
        extracted_digits_clean = extracted_digits;
        for i = 1:cc.NumObjects
            [height, width] = size(extracted_digits(i).Image);
            image_size = height * width;
            if ismember(image_size, sorted_sizes) == false
                extracted_digits_clean(i) = [];
            end
        end

        seg1 = extracted_digits_clean(1).Image;
        seg2 = extracted_digits_clean(2).Image;
        seg3 = extracted_digits_clean(3).Image;
    end
   
    % Padding and resizing
    % target size for padding to fit the input layer CNN
    target_size = 56;

    % call padding function to resize each image to 56x56
    seg1 = pad_to_size(seg1, target_size);
    seg2 = pad_to_size(seg2, target_size);
    seg3 = pad_to_size(seg3, target_size);
end





function padded_image = pad_to_size(image, target_size)
    [height, width, ~] = size(image);
    padding_height = target_size - height; % Calculate padding size on each side
    padding_width = target_size - width; % Calculate padding size on each side
    
    % Calculate padding for rows and columns
    pad_top = floor(padding_height / 2);
    pad_bottom = ceil(padding_height / 2);
    pad_left = floor(padding_width / 2);
    pad_right = ceil(padding_width / 2);

    % Pad the image
    padded_image = padarray(image, [pad_top, pad_left], 0, 'pre');
    padded_image = padarray(padded_image, [pad_bottom, pad_right], 0, 'post');
end



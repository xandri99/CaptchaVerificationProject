function counted_elem = count_elem_segmented(image)
   
    % Low-pass filtering - Gaussian
    kernel_size = 7;
    filter = fspecial('gaussian', kernel_size, 2);
    lp_gaussian = imfilter(image, filter, 'same');
    
    % High-pass filtering
    hp_gaussian = image - lp_gaussian;
    
    % Band-pass filtering
    bp_gaussian = lp_gaussian .* hp_gaussian;
    
    % Thresholding
    bin_image = ~imbinarize(lp_gaussian); 
    
    % Median Filtering
    bin_image = medfilt2(bin_image);
    
    % Erosion
    se = strel('disk', 3); 
    eroded_image = imerode(bin_image, se);
    eroded_image = bwareaopen(eroded_image, 50);


    % Without seperating overlaps
    cc = bwconncomp(eroded_image);
    
    % Without seperating overlaps, how many elements
    counted_elem = cc.NumObjects;
end

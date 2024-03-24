%data preparation for training

raw_images_dir = 'imagedata';
clean_images = 'splitted_images'; 

image_files = dir(fullfile(raw_images_dir, '*.png'));

% Loop through each image  in the input directory
for i = 1:length(image_files)
    input_image = imread(fullfile(raw_images_dir, image_files(i).name));
    
    % Call the preprocessing 
    [seg1, seg2, seg3] = preproces_func(input_image);
    
    % Define output file names
    seg_name1 = strcat(string(clean_images), '/train_', sprintf('%04da.png', i));
    seg_name2 = strcat(string(clean_images), '/train_', sprintf('%04db.png', i));
    seg_name3 = strcat(string(clean_images), '/train_', sprintf('%04dc.png', i));
    
    % Save the preprocessed images
    imwrite(seg1, seg_name1); 
    imwrite(seg2, seg_name2);
    imwrite(seg3, seg_name3);

end
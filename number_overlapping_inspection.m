%Checking how many pictures of the dataset have overlap, to decide if its
%worth trying to find a segmentation technique that works

raw_images_dir = 'imagedata';

image_files = dir(fullfile(raw_images_dir, '*.png'));

A = 0;
B = 0;
C = 0;
D = 0;


for i = 1:length(image_files)
    inputImage = imread(fullfile(raw_images_dir, image_files(i).name));
    
    segmented_elements = count_elem_segmented(inputImage);

    % Make the statistics:
    if(segmented_elements == 1)
        A = A + 1;
    elseif(segmented_elements == 2)
        B = B + 1;
    elseif(segmented_elements == 3)
        C = C + 1;
    else
        D = D + 1;
    end
end

fprintf('Num images segmented into 1 number: %d\n', A);
fprintf('Num images segmented into 2 number: %d\n', B);
fprintf('Num images segmented into 3 number: %d\n', C);
fprintf('Num images segmented into more than 3 number: %d\n', D);


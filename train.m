%% classification using CNN


%% Build the datasets to train and validate the model
tic;
clean_images = 'splitted_images'; 
labels = importdata('labels.txt');

image_files = dir(fullfile(clean_images, '*.png'));


% Build the feeder for the training and validation
dataset_df = table({}, {}, [], 'VariableNames', {'Image', 'Image_file_name', 'True_Label'});

% Build the dataframe
for i = 1:length(image_files)
    % Read the image
    input_image = imread(fullfile(clean_images, image_files(i).name));

    % Get the label from the txt
    if mod(i, 3) == 0
        trueLabel = labels(floor(i/3), 3);
    else
        trueLabel = labels(floor(i/3) + 1, mod(i, 3));
    end

    % Append the image and label to the dataset
    dataset_df = [dataset_df; {input_image, image_files(i).name, trueLabel}];
end
fprintf("Dataset created\n");


%% Split into train and validation
num_train_elem = round(height(dataset_df) * (60/100));
num_validate_elem = round(height(dataset_df) * (20/100));
num_unseen_test = round(height(dataset_df) * (20/100));

random_sampling_indx = randperm(height(dataset_df));

train_dataset = dataset_df(random_sampling_indx(1:num_train_elem), :);
validation_dataset = dataset_df(random_sampling_indx(num_train_elem + 1:num_train_elem + num_validate_elem), :);
test_dataset = dataset_df(random_sampling_indx(num_train_elem + num_validate_elem + 1:end), :);

fprintf("Dataset splitting done\n");


% %% VISUAL MANUAL INSPECTION OF THE DATASET
% for i = 1:3:50
%     image = train_data{i, 1};
%     name = train_data{i, 2};
% 
%     % DISPLAY
%     figure;
%     subplot(1,3,1), imshow(train_data{i, 1}{1}), title(train_data{i, 3});
%     subplot(1,3,2), imshow(train_data{i + 1, 1}{1}), title(train_data{i + 1, 3});
%     subplot(1,3,3), imshow(train_data{i + 2, 1}{1}), title(train_data{i + 2, 3});
% 
%     pause(3);
%     close(gcf);
% end


%% Train the model

% Create the imageDatastore to train and validate the model
imds_train = imageDatastore(strcat(clean_images, '/', train_dataset.Image_file_name));
imds_train.Labels = categorical(train_dataset.('True_Label'));


imds_validation = imageDatastore(strcat(clean_images, '/', validation_dataset.Image_file_name));
imds_validation.Labels = categorical(validation_dataset.('True_Label'));

imds_test = imageDatastore(strcat(clean_images, '/', test_dataset.Image_file_name));
imds_test.Labels = categorical(test_dataset.('True_Label'));



% Construct a network to classify the digit image data.
layers = [
    imageInputLayer([56 56 1])
    
    convolution2dLayer(3,8,Padding="same")
    batchNormalizationLayer
    reluLayer   
    maxPooling2dLayer(2,Stride=2)
    convolution2dLayer(3,16,Padding="same")
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer(2,Stride=2)
    convolution2dLayer(3,32,Padding="same")
    batchNormalizationLayer
    reluLayer
    fullyConnectedLayer(3)
    softmaxLayer
    classificationLayer];

% Options for the training
options = trainingOptions("sgdm", ...
    MaxEpochs=8, ...
    ValidationData=imds_validation, ...
    ValidationFrequency=30, ...
    Verbose=false, ...
    Plots="training-progress");

% Train the network.
CNN_model_trained = trainNetwork(imds_train,layers,options);


toc;


predictions = classify(CNN_model_trained, imds_test);
accuracy = sum(predictions == imds_test.Labels)/numel(imds_test.Labels);


save CNN_model_trained;
load CNN_model_trained;



# CAPTCHA_verification
Designed a deep learning model for CAPTCHA digit recognition task

## Dataset and Task Overview
The dataset consists of CAPTCHA images containing three digits each. The images are stored in the /imagedata directory, with corresponding labels provided in labels.txt. The goal is to preprocess these images, train a Convolutional Neural Network (CNN) classifier, and implement a decoder function to accurately predict the digits.

## Project Structure
Scripts:
- preproces_func.m: This script preprocesses the input image to enhance digit segmentation. It applies techniques like Gaussian filtering, thresholding, median filtering, and erosion to isolate individual digits.

- train.m: This script prepares the dataset, splits it into training, validation, and test sets, constructs a CNN model, and trains the model using the training data. The trained model is saved for later use.

- number_overlapping_inspection.m: This script provides insights into the dataset by counting the number of images segmented into different groups based on the number of elements detected. It aids in understanding the complexity of segmentation.

- file_prep.m: This script preprocesses the raw images by segmenting them into individual digits using the preprocessing techniques defined in preproces_func.m. It saves the segmented images for training.

- count_elem_segmented.m: This script counts the number of segmented elements in an image, assisting in understanding the segmentation quality and complexity.

## Results
The trained model achieved a precision of 99.12% on the test dataset, with an execution time of 54.21 seconds, exceeding the project requirements.

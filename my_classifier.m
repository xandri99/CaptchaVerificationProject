function S = my_classifier(im, parameters1, parameter2)
    % Output: S = a 1 x 3 vector of the three numbers in the image
    % Preproces the image
    [n1, n2, n3] = preproces_func(im);

    % Classify each number in the captcha
    prediction_n1 = classify(parameter2, n1);
    prediction_n2 = classify(parameter2, n2);
    prediction_n3 = classify(parameter2, n3);

    S = [string(prediction_n1), string(prediction_n2), string(prediction_n3)];
end


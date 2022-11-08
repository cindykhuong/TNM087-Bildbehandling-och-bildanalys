function out=RemoveSinusoidalNoise(in,D0)
%
% function out=RemoveSinusoidalNoise(in,D0)
%
%% Lab3, Task 3
%
%% Removes the most dominant sinusoidal noise
%
% Removes the most dominant sinusoidal noise by applying a Butterworth
% Notch Reject filter in the frequency domain
%
%% Who has done it
%
% Author: cinkh090
% Co-author: rebsj192
% the other member of the group
%
%% Syntax of the function
%      Input arguments:
%           in: the original input grayscale image (which is corrupted by
%           sinusoidal noises) of type double scaled between 0 and 1.
%           D0: The bandreject width of the Notch filter being constructed
%
%      Output argument:
%           out: the output image where the most dominant sinusoidal noise
%           is eliminated from the input image
%
% You MUST NEVER change the first line
%
%% Basic version control (in case you need more than one attempt)
%
% Version: 1
% Date: 2021-12-06
%
% Gives a history of your submission to Lisam.
% Version and date for this function have to be updated before each
% submission to Lisam (in case you need more than one attempt)
%
%% General rules
%
% 1) Don't change the structure of the template by removing %% lines
%
% 2) Document what you are doing using comments
%
% 3) Before submitting make the code readable by using automatic indentation
%       ctrl-a / ctrl-i
%
% 4) Often you must do something else between the given commands in the
%       template
%
%% Here starts your code.
% Write the appropriate MATLAB commands right after each comment below.
%
%% Localize the most dominant sinusoidal noise
% The peaks of sinusoidal noises come in pair. You are supposed to find
% the most dominant pair. Actually, it is enough if you locate one of these two.
% In the Notch filter, however, you will create notches at both of them.
% Read the pdf document related to this task for help.

F=fftshift(fft2(in)); % the Fourier transform of the image followed by fftshift

F2= abs(F); % The spectrum/magnitude of F
[m,n] = size(F); %storlek på bilden

% Set the pixel values at the center and a neighborhood around it in F2 to a small number (for example 0)
% and find the position of one of the dominant peaks.

center_row = floor(m/2)+1;
center_column = floor(n/2)+1;

F2([center_row-3:center_row+3], [center_column-3:center_column+3]) = 0; %6x6 neighborhood set to zero.

[a,b] = max(F2(:));
[b_row,b_column] = ind2sub(size(F2),b);
r= b_row; % the row number of one the two dominant peaks
c= b_column;% the column number of the same peak as above
    
%% Construct Notch filter
%
%% Find uk and vk to construct the Butterworth bandreject filter
% Use the position of one of the peaks to find uk and vk, which indicate the
% position of the found maximum relative the center of the spectrum.
%
% In the lecture notes for Chapter 5, you can find more explanation on what uk
% and vk are
%

uk = b_row - center_row; % uk and vk are the positions of the peaks relative the center of the spectrum
vk = b_column - center_column;
    

%% Construct the Butterworth Bandreject Notch filter
% If you want, you can write a separate function to construct the Notch filter.
% If you do so, don't forget to submit that MATLAB function as well.
%
% You have already created Gaussian filter transfer functions in Task2 of this lab.
% It is done similarly. In the lecture notes for Chapter 5, you can find
% good examples on how to create such a filter transfer function

k=2; % as specified in the task, the order should be 2
[x, y] = meshgrid(0:m-1, 0:n-1);
x = x'; y = y';
Dk = sqrt((x - floor(m/2) - uk).^2 + (y - floor(n/2) - vk).^2);
D_k = sqrt((x - floor(m/2) + uk).^2 + (y - floor(n/2) + vk).^2);
H =(1./(1+(D0./Dk).^k)).*(1./(1+(D0./D_k).^k)); % The filter transfer function of the Notch bandreject filter
    
%% Create the output image
% Apply the Notch filter on the input image in the frequency domain, and go
% back to the spatial domain to obtain the output image

% input =F.*H;
out = real(ifft2(ifftshift(F.*H))); % the final output image, where the most dominant sinusoidal noise is eliminated
    
imshow(in)
figure
imshow(out)
%% Test your code
% Test your code using at least five different test images as specified in
% the pdf document for this task
%
%% Answer this question:
% For image Einstein_sinus_1, What is the smallest D0 that removes the noise almost completely?

% Answer: The smallest D0 that removed the noise almost completely is 11.
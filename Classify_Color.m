function r_string = Classify_Color(in_im) 
    % The input for this function should be an image that only includes the
    % one card under classification
    
    % Colors to classify: Red, Green, Purple
    % Purple RGB Values: 113, 36, 140
    % Green RGB Values: 15, 183, 96
    % Red/Orange RGB Values: 249, 71, 87
    
    % Ideas: Set a threshold for each RGB Value and if it exceeds that,
    % then it is that color
    % If no values exceed 50, then it is black
    % If All values exceed 175, then it is white/card
    % If Green exceeds 150, then it is green
    % If Red exceeds 200, then it is red
    % Else, it is purple
    % Must filter our white and black to do that
    
    % Go through every image, count the number of red, purple, and green
    % pixels. Return the color with the highest number
    red = 0;
    purple = 0;
    green = 0;
    black = 0;
    white = 0;
    
    % Convert the image to int32 to allow for summation
    card_im = uint32(in_im);
    
    im_size = size(card_im);
    for i = 1:im_size(1)
        for j = 1:im_size(2)
            
            % Pixel is Black
            if card_im(i, j, 1) + card_im(i, j, 2) + card_im(i, j, 3) < 100
                black = black + 1;
                
             % Pixel is White
            elseif card_im(i, j, 1) + card_im(i, j, 2) + card_im(i, j, 3) > 500
                white = white + 1;
                
            % Pixel is green
            elseif card_im(i, j, 2) > 150
                green = green + 1;
            
            % Pixel is red
            elseif card_im(i, j, 1) > 175
                red = red + 1;

            % Pixel is purple
            elseif card_im(i, j, 1) > 100 && card_im(i, j, 3) > 100
                purple = purple + 1;
                
            % Pixel is unknown
            else
                continue
            end
        end
    end
    
    % r_string = [ red green purple black white ];
    
    
    if red > green && red > purple
        r_string =  'Red';
    elseif green > red && green > purple
        r_string =  'Green';
    else
        r_string = 'Purple';
    end
    
end
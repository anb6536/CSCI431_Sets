function r_shape = Classify_Shape( im )

    % get image into binary image
    gray_im = rgb2gray(im);
    bin_im = imbinarize(gray_im);
    se = strel('line', 5, 0);
    bin_im = imclose(bin_im, se);
    se = strel('disk', 5);
    bin_im = imopen(bin_im, se);
            
    % Edge detection
    edges = edge(bin_im, 'sobel');
    edges = imclose(edges, se);
    
    % Detect straight lines
    [H, T, R] = hough(edges);
    P = houghpeaks(H, 15);
    lines = houghlines(edges, T, R, P, 'FillGap', 10, 'MinLength', 100);
    
    % Code to plot out all the lines
    %{
    fprintf('Number of lines found: %d\n', length(lines));
    % Plot lines for dev purposes
    figure, imshow(edges), hold on
    max_len = 0;
    for k = 1:length(lines)
        xy = [lines(k).point1; lines(k).point2];
        plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

        % Plot beginnings and ends of lines
        plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
        plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

        % Determine the endpoints of the longest line segment
        len = norm(lines(k).point1 - lines(k).point2);
        if ( len > max_len)
            max_len = len;
            xy_long = xy;
        end
    end
    %}
    
    
    % Calculate slope of all lines, check if parallel
    slopeArray = zeros([1, length(lines)]);
    for k = 1:length(lines)
        x1 = lines(k).point1(1);
        y1 = lines(k).point1(2);
        x2 = lines(k).point2(1);
        y2 = lines(k).point2(2);
        slopeArray(k) = (y2 -y1) / (x2 - x1) ;
    end
    
    % disp(slopeArray);
    
    % If there are no lines, it's a squiggle
    if (length(lines) < 1)
        r_shape = "squiggle";
    else
        highest = 0;
        lowest = 0;
        for k = 1:length(slopeArray)
            if slopeArray(k) > highest
                highest = slopeArray(k);
            end
            if slopeArray(k) < lowest
               lowest = slopeArray(k);
            end
        end
        disp(highest);
        disp(lowest);
        if( ( highest > 0 && lowest < 0) && ( highest - lowest > 0.2))
            r_shape = "diamond"; 
        else
            r_shape = "oval";
        end
    end
end
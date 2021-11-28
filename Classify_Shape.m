function Classify_Shape( im )

    % get image into binary image
    gray_im = rgb2gray(im);
    bin_im = imbinarize(gray_im);
    se = strel('disk', 3);
    
    % dilate im
    bin_im = imopen(bin_im, se);
        
    % Edge detection
    se = strel('disk', 5);
    edges = edge(bin_im, 'sobel');
    edges = imclose(edges, se);
    
    % Detect straight lines
    [H, T, R] = hough(edges);
    P = houghpeaks(H, 15);
    lines = houghlines(edges, T, R, P, 'FillGap', 100, 'MinLength', 5);
    
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
    
    % Compare angles of lines to classify shapes
    
    
end
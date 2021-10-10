function Project_Sets()
    % Adding the image dir to the path
    addpath( './Set_Cards' );
    
    % Iterating over the list of images and calling the count function on
    % each of the image, creating a figure for each card
    file_list   = dir( './Set_Cards/*.jpg' );
    for counter = 1 : length( file_list )
        figure();
        find_card( file_list( counter ).name );
    end
end

% find_card function takes in the image filename and does processing on it
% to count the number of set cards in the image.
function find_card( fn_in )

    % Reading in the image and converting it to Double for all the
    % computations. 
    im      = im2double( imread( fn_in ) );
    
    % Using the red channel of the image to count the number of cards
    im      = im(:,:,1);
    
    % Creating a gaussian filter and using it on the image to remove noise
    fltr    = fspecial('Gauss', 25, 15);
    im      = imfilter( im, fltr );
    
    % Converting the image to binary to isolate the regions
    im_binary   = imbinarize( im );
    
    % Creating a structuring element and using it on the image so that we
    % isolate only the cards and remove all the black noise on the card or
    % the white noise on the background so that it is not counted as one of
    % the card regions
    str_elem    = strel( 'disk', 17);
    im_new      = imdilate( im_binary, str_elem );
    im_new      = imopen( im_new, str_elem );
    im_new      = imclose( im_new, str_elem );
    
    % Using bwlabel to number all the regions enabling us to iterate over
    % the regions and play with them
    im_sep      = bwlabel( im_new, 4 );
    
    % Reporting the total number of cards in an image
    fprintf( "Total number of cards: %d\n", max( im_sep, [], 'all' ) - 1 );
    
    % Storing the max region number
    max_num     = max( im_sep, [], 'all' );
    
    % Variable for storing the max region size and the region number for
    % the same.
    max_size_num    = 0;
    max_region  = 0;
    
    % Iterating over the image and finding out the largest region (which
    % could be the table) and storing the region number
    for idx = 1:max_num
        [sep_row,~]  = find( im_sep == idx );
        if size(sep_row) > max_region
            max_region = size(sep_row);
            max_size_num = idx;
        end
    end
    
    % Converting the largest area to 0s so that they are black and not
    % counted as a region
    for img_col = 1: size( im_sep, 2 )
        for img_row = 1: size( im_sep, 1 )
            if im_sep(img_row, img_col) == max_size_num
                im_sep( img_row, img_col ) = 0;
            end
        end
    end
   
    % Ploting the image with the regions
    ax(1) = subplot( 2, 2, 1 );
    imagesc( im_sep );
    axis image;
    colormap ( ax(1), hot );
    colorbar;
    
    % Iterating over the number of regions
    for idx = 1:max_num
        % Ignoring the largest region and processing all the other regions
        if idx ~= max_size_num
            % calculating the size of the image and creating a new image
            % with 0s 
            sz          = size( im_sep );
            solo_card    = zeros( sz );
            [sep_row, sep_col]  = find( im_sep == idx );
            rc      = [sep_col sep_row];
            % For all the rows and columns where an individual card is,
            % converting that to a 1 (white) and showing the cards on the
            % subplot one at a time
            for idx2 = 1:length(sep_row)
                solo_card( sep_row(idx2), sep_col(idx2) ) = 1;
            end
            
            % Plotting the second image (with one card at a time) and
            % displaying it on the 2x2 subplot at position 2.
            ax(2) = subplot( 2, 2, 2 );
            imagesc( solo_card );
            axis image;
            colormap( ax(2), gray );
            hold on;

            % Using convex hull to draw an outline around the card
            [k, ~]     = convhull(rc);
            plot( rc(k, 1), rc(k, 2), 'c-', 'LineWidth', 1 );
            hold off;

            % Adding a 1 sec pause between the images.
            pause(1);
        end
    end
end
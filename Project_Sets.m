function Project_Sets()
    % Adding the image dir to the path
    addpath( './Set_Cards' );
    
    % Iterating over the list of images and calling the count function on
    % each of the image, creating a figure for each card
    file_list   = dir( './Set_Cards/*.jpg' );
%     for counter = 1 : length( file_list )
%         figure();
%         find_card( file_list( counter ).name );
%     end
    find_card('IMG_7534.JPG');
end

% find_card function takes in the image filename and does processing on it
% to count the number of set cards in the image.
function find_card( fn_in )
    fprintf("\nFile Name: %s\n", fn_in);
    % Reading in the image and converting it to Double for all the
    % computations. 
    im_og      = imread( fn_in );
    im         = im2double( im_og );
    
    ax(1) = subplot( 2, 2, 1 );
    imagesc( im_og );
    axis image;
    
    % Using the red channel of the image to count the number of cards
    im   = im(:,:,1);
    
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
    
    % Storing the max region number
    max_num     = max( im_sep, [], 'all' );
    
    % Variable for storing the max region size and the region number for
    % the same.
    regions_to_ignore = {};
    cell_idx = 1;
    im_size = size(im_sep);
    
    % Iterating over the image and finding out the largest region (which
    % could be the table) and storing the region number
    for idx = 1:max_num
        [sep_row, sep_col]  = find( im_sep == idx );
        if (ismember(1, sep_row) || ismember(1, sep_col) || ismember(im_size(1), sep_row) || ismember(im_size(2), sep_col))
            regions_to_ignore{cell_idx} = idx;
            cell_idx = cell_idx + 1;
        end
    end
    
    % Reporting the total number of cards in an image
    fprintf( "Total number of cards: %d\n", max( im_sep, [], 'all' ) - size(regions_to_ignore, 2) );

    % Converting the largest area to 0s so that they are black and not
    % counted as a region
    for img_col = 1: size( im_sep, 2 )
        for img_row = 1: size( im_sep, 1 )
            for cell_count = 1:size(regions_to_ignore, 2)
                if im_sep(img_row, img_col) == regions_to_ignore{1, cell_count}
                    im_sep( img_row, img_col ) = 0;
                end
            end
        end
    end
   
    % Ploting the image with the regions
    ax(2) = subplot( 2, 2, 2 );
    imagesc( im_sep );
    axis image;
    colormap ( ax(2), hot );
    colorbar;
    
    card_num = 1;
    all_cards = {};
    % Iterating over the number of regions
    for idx = 1:max_num
        should_exec = true;
        % Ignoring the largest region and processing all the other regions
        for cell_count = 1:size(regions_to_ignore, 2)
            if(idx == regions_to_ignore{1, cell_count})
                should_exec = false;
            end
        end
        if should_exec
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
            
            [k, ~]     = convhull(rc);
            conv_xs    = rc(k, 1);
            conv_ys    = rc(k, 2);

            min_x      = min(conv_xs(:));
            max_x      = max(conv_xs(:));
            min_y      = min(conv_ys(:));
            max_y      = max(conv_ys(:));

            solo_card_color = im_og(min_y:max_y, min_x:max_x, :);

            shape_count = Count_Shape(solo_card_color);
            card_texture = Classify_Texture(solo_card_color);
            card_color = Classify_Color(solo_card_color);

            gray = rgb2gray(solo_card_color);
            gray = gray - 150;
           
            % Binarize the im
            bin_im = imbinarize(gray);
            bin_im = imcomplement(bin_im);
            regions = bwlabel(bin_im, 4);
            max_reg = max(regions(:));
            max_reg_ignore = 0;
            max_reg_id = -1;
            for reg = 1:max_reg
                [max_row, max_col]  = find( regions == reg );
                if(length(max_row) > max_reg_ignore)
                    max_reg_ignore = length(max_row);
                    max_reg_id = reg;
                end
            end
            
            new_img = zeros(size(solo_card_color, 1:2));
            for reg = 1:max_reg
                [max_row, max_col]  = find( regions == reg );
                if(reg ~= max_reg_id)
                    for px_idx = 1:length(max_row)
                        new_img(max_row(px_idx), max_col(px_idx)) = 1;
                    end
                end
            end

            card_shape = Classify_Shape(new_img);
            

            % Plotting the second image (with one card at a time) and
            % displaying it on the 2x2 subplot at position 2.
            ax(3) = subplot( 2, 2, 3 );
            imagesc( solo_card );
            axis image;
%             colormap( ax(3), gray );
            hold on;

            % Using convex hull to draw an outline around the card
            
            plot( rc(k, 1), rc(k, 2), 'c-', 'LineWidth', 1 );
            hold off;

            ax(4) = subplot( 2, 2, 4 );
            imagesc(solo_card_color);
            axis image;

            fprintf("Card Num: %d, Color: %s, Number: %d, Shape: %s, Shading: %s\n", card_num, card_color, shape_count, card_shape, card_texture);
            
            all_cards{card_num, 1} = card_num;
            all_cards{card_num, 2} = card_color;
            all_cards{card_num, 3} = shape_count;
            all_cards{card_num, 4} = card_shape;
            all_cards{card_num, 5} = card_texture;
            card_num = card_num + 1;

            % Adding a 1 sec pause between the images.
%             pause(1);
        end
    end
    
    Find_Sets(all_cards);

end
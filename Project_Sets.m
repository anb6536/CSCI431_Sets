function Project_Sets()
    addpath( './Set_Cards' );
%     find_card( 'IMG_7534.JPG' );
    
    file_list   = dir( './Set_Cards/*.jpg' );
    for counter = 1 : length( file_list )
        figure();
        find_card( file_list( counter ).name );
    end
end

function find_card( fn_in )
    im      = im2double( imread( fn_in ) );
    im      = im(:,:,1);
    fltr    = fspecial('Gauss', 25, 15);
    im      = imfilter( im, fltr );
    
    im_binary   = imbinarize( im );
    
    str_elem    = strel( 'disk', 17);
    im_new      = imdilate( im_binary, str_elem );
    im_new      = imopen( im_new, str_elem );
    im_new      = imclose( im_new, str_elem );
    im_sep      = bwlabel( im_new, 4 );
    
    fprintf( "Total number of cards: %d\n", max( im_sep, [], 'all' ) - 1 );
    
    max_num     = max( im_sep, [], 'all' );
    max_size_num    = 0;
    max_region  = 0;
    for idx = 1:max_num
        [r, c]  = find( im_sep == idx );
        if size(r) > max_region
            max_region = size(r);
            max_size_num = idx;
        end
    end
    
    for img_col = 1: size( im_sep, 2 )
        for img_row = 1: size( im_sep, 1 )
            if im_sep(img_row, img_col) == max_size_num
                im_sep( img_row, img_col ) = 0;
            end
        end
    end
   
    ax(1) = subplot( 2, 2, 1 );
    imagesc( im_sep );
    axis image;
    colormap ( ax(1), hot );
    colorbar;
    
    for idx = 1:max_num
        if idx ~= max_size_num
            sz          = size( im_sep );
            solo_card    = zeros( sz );
            [r, c]  = find( im_sep == idx );
            rc      = [c r];
            for idx2 = 1:length(r)
                solo_card( r(idx2), c(idx2) ) = 1;
            end
            ax(2) = subplot( 2, 2, 2 );
            imagesc( solo_card );
            axis image;
            colormap( ax(2), gray );
            hold on;

            [k, av]     = convhull(rc);
            plot( rc(k, 1), rc(k, 2), 'c-', 'LineWidth', 1 );
            hold off;

            pause(1);
        end
    end
end
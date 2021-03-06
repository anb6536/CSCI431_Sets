function shape_count = Count_Shape( fn_in )
    % fn_in is the image with only 1 card in it.
    shape_count = 0;

    % Look at only the red channel to begin with 
    im_bw   = fn_in(:,:,1);

    % Binarize the image and get rid of all the stripes inside the shape if
    % the shape texture is stripped. Thed divide the card into regions
    im_binary = imbinarize(im_bw);
    str_elem    = strel( 'disk', 7);
    im_new      = imerode( im_binary, str_elem );
    im_new      = imcomplement(im_new);

    im_sep      = bwlabel(im_new, 8);
    max_num     = max( im_sep, [], 'all' );
    
    % Number of shape in the card is the number of regions - 1 (for the
    % card region)
    shape_count = max_num - 1;

    % If the shape count turns out to be 0, then do the exact same
    % operations but this time using the green channel instead of the red
    % channel
    if shape_count == 0
        im_bw       = fn_in(:,:,3);
        im_binary   = imbinarize(im_bw);
        str_elem    = strel( 'disk', 7);
        im_new      = imerode( im_binary, str_elem );
        im_new      = imcomplement(im_new);
    
        im_sep      = bwlabel(im_new, 8);
        max_num     = max( im_sep, [], 'all' );

        shape_count = max_num - 1;
    end
end
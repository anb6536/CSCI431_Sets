function shape_count = Count_Shape( fn_in )
    % fn_in is the image with only 1 card in it.
    shape_count = 0;

    im_bw   = fn_in(:,:,1);

%     fltr    = fspecial('Gauss', 25, 15);
%     im      = imfilter(im_bw, fltr);

    im_binary = imbinarize(im_bw);
    str_elem    = strel( 'disk', 7);
    im_new      = imerode( im_binary, str_elem );
    im_new      = imcomplement(im_new);

    im_sep      = bwlabel(im_new, 8);
    max_num     = max( im_sep, [], 'all' );
    
    shape_count = max_num - 1;

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
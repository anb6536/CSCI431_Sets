function r_string = Classify_Texture( im_in )
   % Get in a rough picture of one card, and determine what the texture of
   % the shapes on the card are
   
   % Get black and white
   gray = rgb2gray(im_in);
   gray = gray - 150;
   
   % Binarize the im
   bin_im = imbinarize(gray);
   
   % Morphologically open for stripes
   SE = strel('disk', 25, 4);
   opened = imopen(bin_im, SE);
   
   % Morphologically close, calculate the difference with the original
   % image
   closed = imclose(bin_im, SE);
   
   % Calculating the difference between the binarized open and closed
   % If the shape is solid, the difference between the open and closed
   % images should be minimal. If it is striped, the open image should
   % appear solid, but the closed one should appear blank. If it is just
   % the outline, then the opened image should appear mostly the same but
   % the closed one should appear blank
   
   % Gives us the number of white pixels in each image
   ttl_px = numel(bin_im);
   closed_ones = sum(closed(:))/ttl_px;
   opened_ones = sum(opened(:))/ttl_px;
   bin_ones = sum(bin_im(:))/ttl_px;
   
   fprintf("closed ratio: %s\n", closed_ones);
   fprintf("opened ratio: %s\n", opened_ones);
   fprintf("normal ratio: %s\n", bin_ones);
   
   % Figure out the differences for each card type
   
   if opened_ones/closed_ones > 0.99
        r_string = "solid";
   elseif opened_ones/closed_ones > 0.93
       r_string = "outline";
   else
       r_string = "striped";
   end
   
   end
function r_string = Classify_Texture( im_in )
   % Get in a rough picture of one card, and determine what the texture of
   % the shapes on the card are
   
   % Get black and white
   gray = rgb2gray(im_in);
   gray = gray - 150;
   
   % Binarize the im
   bin_im = imbinarize(gray);

   % Divide the card into regions and find the number of regions found in
   % the image
   regions = bwlabel(bin_im, 4);
   max_reg = max(regions(:));
   
   % If region count is 1 i.e. the card is the only region then its a
   % solid. If it is not 1 but less than 7 i.e. the card is one of the
   % region and the other regions are the ones inside the shape outline
   % then the texture is outline, else it is stripped.
   if max_reg == 1
       r_string = "Solid";
   elseif max_reg < 7
       r_string = "Outline";
   else
       r_string = "Striped";
   end
end
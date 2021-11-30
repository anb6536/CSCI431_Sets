function r_string = Classify_Texture( im_in )
   % Get in a rough picture of one card, and determine what the texture of
   % the shapes on the card are
   
   % Get black and white
   gray = rgb2gray(im_in);
   gray = gray - 150;
   
   % Binarize the im
   bin_im = imbinarize(gray);

   regions = bwlabel(bin_im, 4);
   max_reg = max(regions(:));
   
   if max_reg == 1
       r_string = "Solid";
   elseif max_reg < 7
       r_string = "Outline";
   else
       r_string = "Striped";
   end
end
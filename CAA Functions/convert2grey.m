function grey = convert2grey(im) %#codegen
    %grey = (0.2989 * double(R) + 0.5870 * double(G) + 0.1140 * double(B))/255;
    grey = rgb2gray(im);

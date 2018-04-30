function img = MedianFilter(img)
    img = medfilt2(img);
    img = ordfilt2(img,5,ones(3,4));
function img = MeanFilter(img)
img = filter2(fspecial('average', 2),img);


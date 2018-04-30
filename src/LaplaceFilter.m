function img = LaplaceFilter(img)
    [n, m] = size(img);
	tmpI = zeros(n, m);
	for i = 2 : n-1
		for j = 2 : m-1
			tmpI(i,j) = (img(i,j)*4 - img(i+1, j) - img(i, j+1) - img(i-1, j) - img(i, j-1));
		end
	end
	img = tmpI;
function img = WindowFilter(img)
    [n, m] = size(img);
    img = fftshift(fft2(img));
    X = 2.7;
    for i = uint32(n / X) : uint32(n * (X - 1) / X)
        for j = uint32(m / X) : uint32(m * (X - 1) / X)
            img(i, j) = 0;
        end
    end
    img = ifft2(ifftshift(img));
function img = calculate(ori, lambda, dist, dx)
    ori = double(ori);
    [Ny, Nx] = size(ori);
    dy = dx;
    u = zeros(Ny, Nx);
    v = u;
    
    for i = 1 : Ny
        u(i,:) = (i - Nx / 2 - 0.5) * dy;
    end
    tmp = u.*u;
    for j = 1 : Nx
        v(:,j) = (j - Ny / 2 - 0.5) * dx;
    end
    tmp = tmp + v.*v;
    
    tmp = exp(-1i * pi / lambda / dist * tmp).*ori;
    tmp = fftshift(abs(fft2(tmp)));
    img = tmp / max(max(tmp)) * 0.5;
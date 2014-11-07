function img = reappear(filename, output, lamda, z, dx, ZERO, mul, show)
% reappear(filepath, output, lamda, z, dx, ZERO, mul, show)
% filepath: 全息图的文件名, output: 输出到的文件名
% lamda: 光的波长(nm), z: 衍射距离(mm), dx: CCD像元大小(um),
% ZERO: 去零级的方式（只能输入0，1,2之一）：0 => 不去零级
% 1 => 用拉普拉斯算符去零级，2 => 用频谱图中的窗函数去零级
% mul: 调整还原图的亮度
% show: 0 => 不显示结果， 1 => 用figure的窗口来显示再现结果
% 示例：reappear('0', '0', 532.8, 200, 5, 1, 10, 1)
% 作用：从当前目录读取'0.bmp'作为全息图，再现结果写入当前目录的'0_r1.bmp'，
% 波长设置为532.8nm，衍射距离200mm，CCD像元尺寸5um，
% 去零级方式采用拉普拉斯算符，再现结果的亮度提高10倍
% 把结果用matlab的figure弹窗显示出来
I=imread(filename);
%I=zeros(10,10);
if(size(size(I), 2) > 2) %如果是彩色图，转化为灰阶
    I=rgb2gray(I);
end
I=double(I);
%imwrite(real(I/max(max(I)))*2, 'filterb.bmp');
[Ny, Nx]=size(I);
dy=dx; %y方向像元大小认为与x方向相同
lamda=lamda/1000; %单位转换：nm -> um
u=zeros(Ny, Nx);
v=zeros(Ny, Nx);
z=z*1000; %单位转换：mm -> um

%根据ZERO选择去零级的方式
if (ZERO == 1) %拉普拉斯算符滤波
    [n, m] = size(I);
	tmpI = zeros(n, m);
	for i = 2 : n-1
		for j = 2 : m-1
			tmpI(i,j) = (I(i,j)*4 - I(i+1, j) - I(i, j+1) - I(i-1, j) - I(i, j-1));
		end
	end
	I = tmpI;
	clear tmpI;
elseif (ZERO == 2) %频谱图下窗函数滤波
    % I = filter_lowf(I, 2.3);
    [n, m] = size(I);
    I = fft2(I);
    I = fftshift(I);
    X = 2.7;
    for i = uint32(n/X) : uint32(n*(X-1)/X)
        for j = uint32(m/X) : uint32(m*(X-1)/X)
            I(i,j) = 0;
        end
    end
    I = ifftshift(I);
    I = ifft2(I);
end

%实现原理中的公式
for i = 1 : Ny
    u(i,:) = (i-Nx/2-0.5)*dy;
end
tmp = u.*u;
clear u;
for j = 1 : Nx
    v(:,j) = (j-Ny/2-0.5)*dx;
end
tmp = tmp + v.*v;
clear v;
tmp = exp(-1i * pi / lamda / z * tmp);
tmp = tmp .* I;
clear I;
tmp = abs(fft2(tmp));
tmp = fftshift(tmp);
% tmp = tmp .* tmp;
img = tmp /max(max(tmp)) * mul; %按照最大值归一化，然后调亮mul倍
clear tmp;
if (show)
    figure;
    imshow(img); %显示出来
end
if (output ~= 0) 
    imwrite(img, [output, '_r', num2str(ZERO), '.bmp']); %写入到文件中
end
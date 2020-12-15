function []=ImagePostProcess_gray(Ztres,r,c,m,n,minval,maxval)

vec = reshape(Ztres,8,8,1)
i = 10;
%% invert the reshaping operation
newZt = reshape(permute(vec, [1 3 2 4]), m,n);

%%%%%%%%%%%%%% IMAGE POST-PROCESSING %%%%%%%%%%%%%%%%
temp=im2double(newZt)*(maxval-minval)+minval;
fun=@idct2;
newZ=blkproc(temp,[8 8],fun);

figure;
imshow(newZ);

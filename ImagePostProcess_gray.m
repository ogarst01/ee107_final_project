function []=ImagePostProcess_gray(Ztres,r,c,m,n,minval,maxval)

vec = reshape(Ztres,8,8,r,c);
%% invert the reshaping operation
perMStep = permute(vec, [1 3 2 4]);

newZt = reshape(perMStep, m,n);

%%%%%%%%%%%%%% IMAGE POST-PROCESSING %%%%%%%%%%%%%%%%
temp=im2double(newZt)*(maxval-minval)+minval;
fun=@idct2;
newZ=blkproc(temp,[8 8],fun);

figure;
imshow(newZ);

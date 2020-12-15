clear;
close all

% read in image + preprocess it:
% converts into 8x8 DCT chunks:
qbits = 8;

[Ztres,r,c,m,n,minval,maxval]=ImagePreProcess_color(qbits);
inputSignal = reshape(Ztres, 1,)

ImagePostProcess_color(Ztres,r,c,m,n,minval,maxval)
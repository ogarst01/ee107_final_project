 % converts into 8x8 DCT chunks:
qbits = 8;
filename = 'image.jpg';
[Ztres,r,c,m,n,minval,maxval]=ImagePreProcess_gray(qbits);

% make into an array of binary:
bitsZ = de2bi(Ztres);
dimZ = size(bitsZ)
% grab only the first array of values in the first slice of data: 
lengthSigVec = dimZ(1)*dimZ(2);
% reshape into a row of points:

%%TODO: test whether can retreive the data too...

%%
% grab N chunks at a time:
N = 64;

currSlice = dimZ(:,1:N);

signalVec = rescale(reshape(currSlice, [1, N*dimZ(2)]));
signalVec2 = de2bi(rescale(signalVec));
%%
[m, n] = size(double(signalVec))
%%
% new dimensions of the image after making into inerval of 8:
r=1
c=1

ImagePostProcess_gray(signalVec,r,c,m,n,minval,maxval)


snr(newZ,X)
%%
max(max(abs(rescale(double(X)) - rescale(double(newZ)))))
min(min((rescale(double(X)) - rescale(double(newZ)))))
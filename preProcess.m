clear
close all
% converts into 8x8 DCT chunks:
qbits = 8;
filename = 'image.jpg';
[Ztres,r,c,m,n,minval,maxval]=ImagePreProcess_gray(qbits);

% only grab first slice: 
DCT_chunk = Ztres;
N = 64;
[bitStream] = convertToBitStream(DCT_chunk,N);
%%
bitsPerRow = 8;
numLayers = 1;
m = 8; n = 8;
decStream = bitStreamToChunk(bitStream, qbits, m, n, numLayers);
%%TODO: test whether can retreive the data too...

%% Next - feed this through the second part of the image processing
% pipeline: 


newZ = ImagePostProcess_gray(Ztres,r,c,m,n,minval,maxval)
% snr(newZ,X)
%%
max(max(abs(rescale(double(X)) - rescale(double(newZ)))))
min(min((rescale(double(X)) - rescale(double(newZ)))))
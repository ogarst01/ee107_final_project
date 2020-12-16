clear
close all
% converts into 8x8 DCT chunks:
qbits = 8;
[Ztres,r,c,m,n,minval,maxval]=ImagePreProcess_gray(qbits);

% define some dimensions for the system:
[L,W,H] = size(Ztres);

N = 64;
% only grab first slice: 
DCT_chunk = Ztres(:,:,(1:N));

[bitStream] = convertToBitStream(DCT_chunk,L,W,N);
%%
decStream = bitStreamToChunk(bitStream, qbits,L,W, N);
%%TODO: test whether can retreive the data too...

%% Next - feed this through the second part of the image processing
% pipeline: 

ImagePostProcess_gray(decStream,r,c,L,W,minval,maxval)

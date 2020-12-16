clear
close all
% converts into 8x8 DCT chunks:
qbits = 8;

[Ztres,r,c,m,n,minval,maxval]=ImagePreProcess_gray(qbits);

% define some dimensions for the system:
[L,W,H] = size(Ztres);

MM = r*c;
% only grab first slice: 
DCT_chunk = Ztres(:,:,(1:MM));

[bitStream] = convertToBitStream(DCT_chunk,L,W,MM);
%%

% break up image into 1000 bit sized chunks:
lengthChunk = 8*125;

numChunks = length(bitStream)/lengthChunk;

bitStreamHS = [];
bitStreamSRRC = [];

for i = 1:numChunks
    [HS, SRCC] = main(bitStream, 0.01);
    bitStreamHS = [bitStreamHS, HS];
    bitStreamSRRC = [bitStreamSRRC, SRRC]
end
% bitStreamHS = bitStream;

% num_pixels = ceil(length(bitStreamHS) / 8);
% hs_pixels = reshape(bitStreamHS, [8, num_pixels])';
% 
% num_pixels = ceil(length(bitStreamSRRC) / 8);
% srrc_pixels = reshape(bitStreamSRRC, [8, num_pixels])';

%%

decStream = bitStreamToChunk(bitStreamHS, qbits,L,W, MM);
%%TODO: test whether can retreive the data too...

%% Next - feed this through the second part of the image processing
% pipeline: 

ImagePostProcess_gray(decStream,r,c,m,n,minval,maxval)

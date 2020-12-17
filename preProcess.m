clear
close all
% converts into 8x8 DCT chunks:
qbits = 8;
[Ztres,r,c,m,n,minval,maxval]=ImagePreProcess_gray(qbits);

% define some dimensions for the system:
[L,W,H] = size(Ztres);
%%
MM = r*c;

[bitStream] = convertToBitStream(Ztres,L,W,MM);

%%
noiseLevel = 0.0;
% chose your desired equalizer:
% type = 'Z.F.';
type = 'MMSE';

%test_seq = randi([0 1], 1, 10);
%[bitStreamHS, bitStreamSRRC] = quickerMain(bitStream, noiseLevel, type);

[bitStreamHS, bitStreamSRRC] = main(bitStream, noiseLevel, type);


%%

decStream1 = bitStreamToChunk(bitStreamHS, qbits,L,W, MM);
ImagePostProcess_gray(decStream1,r,c,m,n,minval,maxval)

%%
decStream2 = bitStreamToChunk(bitStreamSRRC, qbits, L,W, MM);
ImagePostProcess_gray(decStream2,r,c,m,n,minval,maxval)


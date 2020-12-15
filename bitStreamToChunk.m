function decStream = bitStreamToChunk(bitStream, bitsPerRow, m, n, numLayers)
bitStream = uint8(bitStream);

bitsPerRow = 8;
sizeDec = m*n*numLayers; 

[x, sizeDec] = size(bitStream);

% grab and make into an 8x length matrix (opposite of before)
bitStreamMat = reshape(bitStream, bitsPerRow, sizeDec/bitsPerRow);

% Then, take from binary back to decimal:
decStreamVec = bi2de(bitStreamMat');

decStreamVec = decStreamVec(1:64);

% Lastly, throw back into the original image shape:
decStream = reshape(decStreamVec, 8, 8,1);
end
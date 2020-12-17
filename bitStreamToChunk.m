function decStream = bitStreamToChunk(bitStream, bitsPerRow, L,W,N)
bitStream = uint8(bitStream);

sizeDec = L*W*N; 

% grab and make into an 8x length matrix (opposite of before)
bitStreamMat = reshape(bitStream, 8, sizeDec);

% Then, take from binary back to decimal:
decStreamVec = bi2de(bitStreamMat');

% Lastly, throw back into the original image shape:
decStream = reshape(decStreamVec, 8, 8, N);
end
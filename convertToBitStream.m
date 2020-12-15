function [bitStream] = convertToBitStream(DCT_chunk,N)
% Inputs: m,n - size of the DCT chunk dimensions
%         specified number of bits to send. 
    
% DCT chunk - how many layers of the DCT 8x8 matrix we grab
sizeDCT = size(DCT_chunk)
m = sizeDCT(1);
n = sizeDCT(2);
if(length(sizeDCT) ~=2)
    numLayers = sizeDCT(3);
else
    numLayers = 1;
end

sizeDec = m*n*numLayers

% shape into a vector:
numVector = reshape(DCT_chunk, sizeDec, 1);

% turn to binary:
bitVector = de2bi(numVector,8);

% makes into the bitstream: 
% finds number elements in bitStream (should be 8x original size):
lengthStream = numel(bitVector);
bitStream = reshape(bitVector',1, sizeDec*8); 

end
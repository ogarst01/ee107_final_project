function [bitStream] = convertToBitStream(DCT_chunk,L,W,H)
% Inputs: m,n - size of the DCT chunk dimensions
%         specified number of bits to send. 
 
sizeDec = L*W*H;

% shape into a vector:
numVector = reshape(DCT_chunk, sizeDec, 1);

% turn to binary:
bitVector = de2bi(numVector,8);

% makes into the bitstream: 
% finds number elements in bitStream (should be 8x original size):
lengthStream = numel(bitVector);
bitStream = reshape(bitVector',1, sizeDec*8); 

end
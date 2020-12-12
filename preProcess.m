 % converts into 8x8 DCT chunks:
qbits = 8;

[Ztres,r,c,m,n,minval,maxval]=ImagePreProcess_color(qbits);

dimZtres = size(Ztres);

lengthSigVec = dimZtres(1)*dimZtres(2)*dimZtres(3);

% reshape into a row of points:
signalVec = reshape(Ztres, 1, lengthSigVec);
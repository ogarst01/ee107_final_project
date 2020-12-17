function [srrc_filtered_noisy,half_sine_filtered_noisy] = addNoise(half_sine_filtered, srrc_filtered, testing, sqrtNsPowr2, T_bit, fs)

% to be iterated through if testing is true:
sqrtNsPowr = [0.001,0.1,1,10,100];

% generate random numbers: 
noiseHS   = randn(1,length(half_sine_filtered));
noiseSRRC = randn(1,length(srrc_filtered));

if(testing == true)
% iterate throught different values: 
    for i = 1:length(sqrtNsPowr)
        noiseHS    = sqrt(sqrtNsPowr(i))*noiseHS;
        noiseSRRC  = sqrt(sqrtNsPowr(i))*noiseSRRC;

        half_sine_filtered_noisy = half_sine_filtered + noiseHS;
        srrc_filtered_noisy      = noiseSRRC + srrc_filtered;

        % labels for graphs: 
        strHS = sprintf('eye diagram half sine with noise level sigma = %g',sqrtNsPowr(i));
        strSRCC = sprintf('eye diagram SRRC with noise level sigma = %g',sqrtNsPowr(i));

        eyediagram(half_sine_filtered_noisy, T_bit*fs, 1, 16);
        title(strHS);

        eyediagram(srrc_filtered_noisy, T_bit*fs);
        title(strSRCC);

    end
else 
% use the specified noise power:
    noiseHS2    = sqrt(sqrtNsPowr2)*noiseHS;
    noiseSRRC2  = sqrt(sqrtNsPowr2)*noiseSRRC;
    
    % add additive noise to filtered signals:
    half_sine_filtered_noisy = half_sine_filtered + noiseHS2;
    srrc_filtered_noisy      = noiseSRRC2 + srrc_filtered;
    
%     % labels for graphs: 
%     strHS = sprintf('eye diagram half sine with noise level sigma = %g',sqrtNsPowr2);
%     strSRCC = sprintf('eye diagram SRRC with noise level sigma = %g',sqrtNsPowr2);
% 
%     eyediagram(half_sine_filtered_noisy, T_bit*fs, 1, 16);
%     title(strHS);
% 
%     eyediagram(srrc_filtered_noisy, T_bit*fs);
%     title(strSRCC);

end

end
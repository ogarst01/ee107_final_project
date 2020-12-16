function [srrc_filtered,half_sine_filtered, h] = channelDistortion(half_sine_modulated, srrc_modulated, channelType)
if (channelType == 'starter')
%% channel 1:  
    lenChannel = 4;
    N = 32;
    h = zeros(1,4);
    h(1) = 1;
    h(2) = 0.5;
    h(3) = 0.75;
    h(4) = -2/7;

    % pad with zeros:
    zeroPad = zeros(1,31);

    % concatenate with zeros (careful not to add 0's at the end (OH w Boriana))
    h = [h(1), zeroPad, h(2), zeroPad, h(3), zeroPad, h(4)];
elseif(channelType == 'outdoor')
    %% channel 2: outdoor channel
    h = [0.5 1 0 0.63 0 0 0 0 0.25 0 0 0 0.16 0 0 0 0 0 0 0 0 0 0 0 0 0.1];

    % pad with zeos:
    h = upsample(h,31);

    % TODO: investigate how to chop off the last zeros here - might be a 
    % problem
elseif(channelType == 'indoor ')
    %% channel 3: indoor channel
    h = [1, 0.4354, 0.1905, 0.0832, 0, 0.0158, 0, 0.003];

    h = upsample(h,31);
else
    sprintf('\n\nERROR: VALID CHANNEL TYPE NOT SPECIFIED \n\n')
    sprintf('please choose: indoor outdoor or startChannel + run again')
    return
end
% now send the modulated bit stream through the filter:
half_sine_filtered = conv(half_sine_modulated,h);
srrc_filtered = conv(srrc_modulated,h);
end
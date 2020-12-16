function [channel_impulse_response, post_channel_srrc, post_channel_hs] = channel(srrc,hs, channelType)

[post_channel_srrc,post_channel_hs, hs]  = channelDistortion(hs, srrc, channelType);
channel_impulse_response = hs;

end


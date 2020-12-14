function [channel_impulse_response, post_channel_srrc, post_channel_hs] = channel(srrc,hs)

[post_channel_srrc,post_channel_hs, h]  = channelDistortion(hs, srrc);
channel_impulse_response = h;
end


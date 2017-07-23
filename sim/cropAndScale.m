function [processed, figure_num] = cropAndScale(xfm, fft_scale, crop_scale_props, show_figure, figure_num, save_figure, save_name)

p = crop_scale_props;

% Take the log to roughly obtain a brightness
log_scaled = log_normalize(xfm);  % entries are nonpositive now 
% ld_bounds = (size(xfm) ./ fft_scale)' * [-0.5 0.5];  % the range of lambda/D shown over whole image

% Scale and crop the PSF to obtain a result without graph format or imagesc
processed = cropByLd(log_scaled, p.ld_lim, fft_scale);
processed = boundShades(processed, p.mag_lims);

if show_figure
    figure(figure_num);
    imshow(processed);
    figure_num = figure_num + 1;
end

if save_figure
    imwrite(processed, save_name);
end
    
end

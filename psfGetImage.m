% Generates a graphical representation of a point spread function encoded by a
% Psf object across a specified angle domain.
%
% psf                The Psf object representing the PSF to visualize
% new_ld_bounds      The angular bounds of the image in wavelengths per aperture
%                    diameter [umin,umax;vmin,vmax]
% log_10_mag_limits  Log-10 magnitude limits corresponding to black and white
%                    with intermediate values in grayscale [min,max]
%
% image              The generated PSF image as a matrix of grayscale values

function [image] = psfGetImage(psf, new_ld_bounds, log_10_mag_limits)

% Log-normalize the power spectrum.
image = log10(psf.data ./ max(max(psf.data)));

% Crop the spectrum as close as possible to ld_bounds.
upx_min = 1 + floor(psf.pixels_per_ld * (new_ld_bounds(1,1) - psf.ld_bounds(1,1)));
upx_max = 1 +  ceil(psf.pixels_per_ld * (new_ld_bounds(1,2) - psf.ld_bounds(1,1)));
vpx_min = 1 + floor(psf.pixels_per_ld * (new_ld_bounds(2,1) - psf.ld_bounds(2,1)));
vpx_max = 1 +  ceil(psf.pixels_per_ld * (new_ld_bounds(2,2) - psf.ld_bounds(2,1)));
image = image(upx_min:upx_max,vpx_min:vpx_max);

% Map the log-10 magnitude limits to [0, 1]. No clamping is applied.
mag_delta = log_10_mag_limits(2) - log_10_mag_limits(1);
image = (image - log_10_mag_limits(1)) / mag_delta;

% Rotate the image to same conventions as original aperture image.
image = rot90(image);

end

function [psf, scaled_aperture_size_px, fft_size_px] = ...
    getPsf(aperture, aperture_scale, fft_scale)

psf = Psf;

% Convert to grayscale if necessary.
if (size(aperture, 3) > 1)
    aperture = rgb2gray(aperture);
end

% Scale dims of the mask/aperture. Scaling down allows FFT to use less memory.
% We rotate the matrix such that we can store the PSF with (u, v) indices. 
scaled_aperture = imresize(rot90(aperture, 3), aperture_scale);
scaled_aperture_size_px = size(scaled_aperture);
fft_size_px = fft_scale * scaled_aperture_size_px;

% Find FFT of this mask/aperture (not power spectrum yet), padding the FFT
% to dimensions of fft_size and placing zero-frequency component in the
% center of the image.
psf.data = fftshift(fft2(scaled_aperture, fft_size_px(1), fft_size_px(2)));

% Power spectrum is the square of the complex amplitude.
psf.data = abs(psf.data) .^ 2;

% With unity FFT scale, 1.0 lambda/D is lowest resolvable frequency; larger
% FFT scales give better resolution.
psf.pixels_per_ld = fft_scale;

% Calculating bounds is slightly tricky because fftshift places
% zero-frequency to lower-right of center when dimension is even.
psf.ld_bounds(:,2) = floor((fft_size_px' - 1) / 2);
psf.ld_bounds(:,1) = psf.ld_bounds(:,2) - fft_size_px' + 1;
psf.ld_bounds = psf.ld_bounds / fft_scale;

end
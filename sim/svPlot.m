% Creates a formatted plot of a StarView object across a specified angular
% range.

% sv             The StarView object to plot
% imagesc_props  An ImagescProps object describing how to format the plot
% io_props       An IoProps object determining whether and where to save output
%
% figure_out     Handle to the figure generated by this function

function [figure_out] = svPlot(sv, imagesc_props, imagesc_io_props)
s = imagesc_props;
o = imagesc_io_props;

% Preformat the data within the StarView.
image = sv.data;
image = -2.5 * log10(image);
image = rot90(image);

% Create and reformat the StarView plot by using imagesc followod by
% formatImagescPlot with the arguments supplied to svPlot.
figure_out = figure;
imagesc(sv.as_bounds(1,:), fliplr(sv.as_bounds(2,:)), image);
formatImagescPlot(figure_out, s);

% Format the color axis appropriately.
caxis(fliplr(s.output_limits));
h = colorbar;
colormap(flipud(s.color_maps));
drawnow;  % MATLAB bug: colorbar colors don't update without this line.
% Reverse the colorbar axis because large magnitudes (dim objects) should appear
% lower in the scale.
set(h, 'YDir', 'reverse');
ylabel(h, 'apparent visual magnitude');

% Save the output if requested.
if o.save_eps
    print('-depsc', '-painters', o.eps_location);
end
if o.save_png
    print('-dpng', o.png_location);
end

end

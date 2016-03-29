function [ output_args ] = pcolorComplex( varargin )
% pcolorComplex(h, ...) plot into figure h, if not given plot onto gcf
% pcolorComplex(complex2Dfield)

warning('not finished');
%% handle input
if nargin == 0 % no inputs at all
    help(mfilename('fullpath')); % display help and exit
    return; 
end

% figure out whether a figure handle is given in the first input
if isscalar(varargin{1}) && ishandle(varargin{1}) 
    if strcmpi(get(varargin{1}, 'Type'), 'figure')
        [h_fig, varargin] = deal(varargin{1}, varargin(2:end));
    else
        error('input handle must point to figure'); % handle must be to figure or gcf is used
    end
else
    h_fig = gcf;
    set(h_fig, 'NextPlot', 'replace')
end

% defining defaults and possible parameters
defPlotMode = 'abs_ang'; % default plot mode 
suppPlotModes = { ... supported plot modes
    'abs_ang', ... amplitude on the left, phase on the right
    'logabs_ang', ... log10 of amplitude on the left, phase on the right
    'abs2_ang', ... power on the left, phase on the right
    'logabs2_ang', ... log10 of power on the left, phase on the right
    'real_imag'... real value plot on the left, phase on the right
    }; 

defPlotType = 'subplot'; % two plots left and right
suppPlotTypes = {'subplot','inset'}; % amp in big axes in the middle, and ang in the upper right corner

defColormap_abs = -1; % default colormap flag
defColormap_ang = -1; % default colormap flag 

% now we defune input parser
ip = inputParser;
ip.addRequired('cmplx_data', @isnumeric);
ip.addOptional('plot_mode', defPlotMode, @(u) any(validatestring(u, suppPlotModes)));
ip.addParameter('plot_type', defPlotType, @(u) any(validatestring(u, suppPlotTypes)));
ip.addParameter('colormap_abs', defColormap_abs, @(u) isa(u,'float') && ismatrix(u) && size(u,2) == 3 ) 
ip.addParameter('colormap_ang', defColormap_ang, @(u) isa(u,'float') && ismatrix(u) && size(u,2) == 3 ) 

% parse inputs 
ip.parse(varargin{:});
cmplx_data   = ip.Results.cmplx_data;
plot_mode    = ip.Results.plot_mode;
plot_type    = ip.Results.plot_type;
colormap_abs = ip.Results.colormap_abs;
colormap_ang = ip.Results.colormap_ang;

% check whether default colormaps are to be used and retrieve them if this
% is then case. I do not assign the colormaps before since it is a waste to
% initialize arrays if the user inputs colormaps. We generate default maps
% only if the default flags are tripped. 
if colormap_abs == -1, colormap_abs = hot(64); end
if colormap_ang == -1, colormap_ang = hsv(64); end

%% deal with data   
% eee = 1e-15; % colormap join threshold, used to make sure left and right colormaps are kept separate

% get the data according to plot mode
switch plot_mode
    case 'abs_ang'
        left_data = sqrt(cmplx_data.*conj(cmplx_data));
        right_data = angle(cmplx_data);
        [left_min, left_max] = deal(nanmin(left_data(:)), nanmax(left_data(:)));
        [right_min, right_max] = deal(nanmin(right_data(:)), nanmax(right_data(:)));
        scale_data('abs_ang');
        plot_data();
        
        
    case 'logabs_ang'
        left_data = log10(sqrt(cmplx_data.*conj(cmplx_data)));
        right_data = angle(cmplx_data);
        [left_min, left_max] = deal(nanmin(left_data(:)), nanmax(left_data(:)));
        [right_min, right_max] = deal(nanmin(right_data(:)), nanmax(right_data(:)));        
        scale_data('abs_ang');
        plot_data();
    case 'abs2_ang'
        left_data = cmplx_data.*conj(cmplx_data);
        right_data = angle(cmplx_data);
        [left_min, left_max] = deal(nanmin(left_data(:)), nanmax(left_data(:)));
        [right_min, right_max] = deal(nanmin(right_data(:)), nanmax(right_data(:)));        
        scale_data('abs_ang');
        plot_data();
    case 'logabs2_ang'
        left_data = log10(cmplx_data.*conj(cmplx_data));
        right_data = angle(cmplx_data);
        [left_min, left_max] = deal(nanmin(left_data(:)), nanmax(left_data(:)));
        [right_min, right_max] = deal(nanmin(right_data(:)), nanmax(right_data(:)));        
        scale_data('abs_ang');
        plot_data();
    case 'real_imag'
        left_data = real(cmplx_data);
        right_data = imag(cmplx_data);
        [left_min, left_max] = deal(nanmin(left_data(:)), nanmax(left_data(:)));
        [right_min, right_max] = deal(nanmin(right_data(:)), nanmax(right_data(:)));      
        scale_data('real_imag');
        plot_data();
    otherwise
        error('problems in ''plot_mode''');
end




     



% 
% % get complex data
% % [cmplx_data] = deal(varargin{:});
% amp_data = abs(cmplx_data); % get square amplitude (intensity) data
% [Imin, Imax] = deal(nanmin(amp_data(:)), nanmax(amp_data(:)));
% amp_data = amp_data/(Imax + eee); % scale into [0,1]
% ang_data = angle(cmplx_data); % get angle (phase) data
% ang_data = ang_data - nanmin(ang_data(:)) + eee; % translate phase to start at 0
% ang_data_ = ang_data/2/pi + 1; % scale phase to [1,2] (0 to 2*pi]
% [ang_min, ang_max] = deal(nanmin(ang_data_(:)), nanmax(ang_data_(:)));
% if ang_max == ang_min % then they're both actually zero, so we gotta hack this 
%     ang_max = 1 + 2*eee;
%     ang_data_(1,1) = ang_max;
% end

% combining colormaps to hack different colormaps in same figure - 
% don't ask, Matlab is stupid this way
colormap_fig = vertcat(colormap_abs, colormap_ang);
figure(h_fig) % focus on given figure (or open a new one)
set(h_fig,'Renderer', 'zbuffer') % this is to avoid weird graphics driver bug
colormap(colormap_fig); % apply colormap to figure

ax_left = subplot(121); 
p_left = pcolor(ax_left, left_data);
set(p_left, 'EdgeColor', 'none')
axis square;
cb_left = colorbar;%('Location','west');
% set(h_amp, 'CLim', [nanmin(ampsqr_data(:)), nanmax(ampsqr_data(:))]);

% ang_data_ = ang_data + nanmax(ampsqr_data(:));
ax_right = subplot(122); 
p_right = pcolor(ax_right, right_data);
set(p_right, 'EdgeColor', 'none')
axis square;
% set(h_amp, 'CLim', [nanmin(ang_data_(:)), nanmax(ang_data_(:))]);
cb_right = colorbar;%('Location','east')

% final adjustmens - must be done after all plots exist
ax = findobj(h_fig,'Type','axes');
set(ax, 'CLim', [0, 2])
set(cb_left, 'YLim', [0, 1], 'Ytick', [0, 0.5, 1]);
set(cb_left, 'YTickLabel', sprintf('%0.3g|%0.3g|%0.3g', left_min, 0.5*(left_min + left_max), left_max));
set(cb_right, 'Ylim', [1, 2], 'YTick', 1 + [0, 0.5, 1])
set(cb_right, 'YTickLabel', '0|p|2p','fontname', 'symbol');


    function scale_data(pm)
        % scales the data according to plot mode (pm) - used a lot as a
        % procedure - don't want to duplicate code too musch
        % pm can assume the following values:
        %   'abs_ang' for all amplitude/phase plot modes
        %   'real_imag' for all real/imaginary plot modes
        eee = 1e-10; % colormap join threshold, used to make sure left and right colormaps are kept separate
        switch pm
            case 'abs_ang' % amp ang plot modes
                left_data = (left_data - left_min)/(left_max - left_min + eee);
%                 left_data = left_data/(left_max + eee); % scale amplitude to [0,1)
                right_data = right_data - nanmin(right_data(:)) + eee; % translate phase to (0,2*pi]
                right_data = right_data/2/pi + 1; % scale phase to [1,2] (0 to 2*pi]
                if right_max == right_min % then they're both actually zero, so we gotta hack this
                    right_data(1,1) = 1 + 2*eee; % the above could actually be written like this
                end
            case 'real_imag' % real image mode
                left_data = left_data/(left_max + eee); % scale into [0,1)
                right_data = right_data/(right_max + eee); % scale into [0,1)
            otherwise
                error('problems in ''plot_mode''');
        end
    end



    function plot_data()
        % figure out the colormaps according to plot mode
%         switch plot_mode
%             case {'abs_ang', 'logabs_ang', 'abs2_ang', 'logabs2_ang' } % amp ang plot modes
%                 colormap_left = colormap_abs;
%             case 'real_imag' % real image mode
%         end  

    end



end




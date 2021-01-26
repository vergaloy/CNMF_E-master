function h=plot_heatmap_PV(datain,varargin)
% plot_heatmap_PV(a,'tit','Test','GridLines','none');
%% parser
inp = inputParser;
valid_v = @(x) isnumeric(x);
valid_c = @(x) ischar(x);
valid_l = @(x) islogical(x);
valid_s = @(x) isstring(x);
addRequired(inp,'datain',valid_v) 
addParameter(inp,'P_vals',[],valid_v)  %plot data
addParameter(inp,'tit',[],valid_c) 
addParameter(inp,'Colormap','parula') 
addParameter(inp,'ShowAllTicks',true,valid_l)
addParameter(inp,'FontSize',12,valid_v)
addParameter(inp,'GridLines','-',valid_c) % 'none' or :, -, -. or --
addParameter(inp,'percentages',false,valid_l) 
addParameter(inp,'y_labels',[]) 
addParameter(inp,'x_labels',[]) 
addParameter(inp,'ColorBar',[]) 

inp.KeepUnmatched = true;
parse(inp,datain,varargin{:});

%%
if (~isempty(inp.Results.P_vals))
    P_vals=inp.Results.P_vals;
    Tex=inp.Results.P_vals<0.05;
    Tex=num2cell(Tex);
    Tex(P_vals<0.001)={'***'};
    Tex(P_vals>0.001 & P_vals<0.01)={'**'};
    Tex(P_vals>0.01 & P_vals<0.05)={'*'};
    Tex(P_vals>=0.05)={''};
else
    Tex=[];
end

%% Plot stuff
h=heatmap_PV(datain, inp.Results.y_labels', inp.Results.x_labels, Tex,...
    'Colormap',inp.Results.Colormap,...
    'ShowAllTicks',inp.Results.ShowAllTicks,'ColorBar',inp.Results.ColorBar,...
    'FontSize',inp.Results.FontSize,'GridLines',inp.Results.GridLines);
if (inp.Results.percentages)
c.Ruler.TickLabelFormat='%g%%';
end
title(inp.Results.tit);

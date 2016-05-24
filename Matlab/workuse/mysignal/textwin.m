function fig = textwin(title,text)
% This is the machine-generated representation of a Handle Graphics object
% and its children.  Note that handle values may change when these objects
% are re-created. This may cause problems with any callbacks written to
% depend on the value of the handle at the time the object was saved.
% This problem is solved by saving the output as a FIG-file.
%
% To reopen this object, just type the name of the M-file at the MATLAB
% prompt. The M-file and its associated MAT-file must be on your path.
% 
% NOTE: certain newer features in MATLAB may not have been saved in this
% M-file due to limitations of this format, which has been superseded by
% FIG-files.  Figures which have been annotated using the plot editor tools
% are incompatible with the M-file/MAT-file format, and should be saved as
% FIG-files.

load textwin

h0 = figure('Units','normalized', ...
	'Color',[0.8 0.8 0.8], ...
	'Colormap',mat0, ...
	'FileName','D:\MATLABR11\work\mysignal\textwin.m', ...
	'MenuBar','none', ...
	'Name','卷积结果——数值表示', ...
	'NumberTitle','off', ...
	'PaperPosition',[18 180 576 432], ...
	'PaperUnits','points', ...
	'Position',[0.15 0.3 0.6 0.4], ...
	'Resize','on', ...
	'Tag','TextWin', ...
	'ToolBar','none', ...
	'DefaultuicontrolFontSize',10, ...
	'DefaultuicontrolUnits','normalized', ...
	'DefaultuicontrolHorizontalAlignment','left');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'Enable','inactive', ...
	'FontSize',10, ...
	'HorizontalAlignment','left', ...
	'Max',2, ...
	'Position',[0.005 0.01 0.99 0.98], ...
	'String',' ', ...
	'Style','listbox', ...
	'Tag','Listbox1', ...
   'Value',[]);
set(gcf,'defaultuicontrolfontsize',10);
set(gcf,'defaultuicontrolunits','normalized');
set(gcf,'defaultuicontrolhorizontal','left');
set(h1,'string',text);
set(h0,'name',title);

if nargout > 0, fig = h0; end

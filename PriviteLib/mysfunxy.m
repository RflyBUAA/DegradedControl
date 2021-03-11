function [sys, x0, str, ts, simStateCompliance] = sfunxy(t,x,u,flag,ax,varargin)
%SFUNXY S-function that acts as an X-Y scope using MATLAB plotting functions.
%   This MATLAB file is designed to be used in a Simulink S-function block.
%   It draws a line from the previous input point, which is stored using
%   discrete states, and the current point.  It then stores the current
%   point for use in the next invocation.
%
%   See also SFUNXYS, LORENZS.

%   Copyright 1990-2014 The MathWorks, Inc.
%   
%   Andrew Grace 5-30-91.
%   Revised Wes Wang 4-28-93, 8-17-93, 12-15-93
%   Revised Craig Santos 10-28-96

% Store the block handle and check if it's valid
blockHandle = gcbh;
IsValidBlock(blockHandle, flag);

switch flag

  %%%%%%%%%%%%%%%%%%
  % Initialization %
  %%%%%%%%%%%%%%%%%%
  case 0
    [sys,x0,str,ts,simStateCompliance] = mdlInitializeSizes(ax,varargin{:});
    SetBlockCallbacks(blockHandle);

  %%%%%%%%%%
  % Update %
  %%%%%%%%%%
  case 2
    sys = mdlUpdate(t,x,u,flag,ax,blockHandle,varargin{:});

  %%%%%%%%%
  % Start %
  %%%%%%%%%
  case 'Start'
    LocalBlockStartFcn(blockHandle)

  %%%%%%%%
  % Stop %
  %%%%%%%%
  case 'Stop'
    LocalBlockStopFcn(blockHandle)

  %%%%%%%%%%%%%%
  % NameChange %
  %%%%%%%%%%%%%%
  case 'NameChange'
    LocalBlockNameChangeFcn(blockHandle)

  %%%%%%%%%%%%%%%%%%%%%%%%
  % CopyBlock, LoadBlock %
  %%%%%%%%%%%%%%%%%%%%%%%%
  case { 'CopyBlock', 'LoadBlock' }
    LocalBlockLoadCopyFcn(blockHandle)

  %%%%%%%%%%%%%%%
  % DeleteBlock %
  %%%%%%%%%%%%%%%
  case 'DeleteBlock'
    LocalBlockDeleteFcn(blockHandle)

  %%%%%%%%%%%%%%%%
  % DeleteFigure %
  %%%%%%%%%%%%%%%%
  case 'DeleteFigure'
    LocalFigureDeleteFcn

  %%%%%%%%%%%%%%%%
  % Unused flags %
  %%%%%%%%%%%%%%%%
  case { 3, 9 }
    sys = [];

  %%%%%%%%%%%%%%%%%%%%
  % Unexpected flags %
  %%%%%%%%%%%%%%%%%%%%
  otherwise
    if ischar(flag),
      DAStudio.error('Simulink:blocks:unhandledFlag', flag);
    else
      DAStudio.error('Simulink:blocks:unhandledFlag', num2str(flag));
    end

end

% end sfunxy

%
%=============================================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the S-function.
%=============================================================================
%
function [sys,x0,str,ts,simStateCompliance] = mdlInitializeSizes(ax,varargin)

if length (ax)~=4
  DAStudio.error('Simulink:blocks:axisLimitsMustBeDefined');
end

sizes = simsizes;
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 0;
sizes.NumInputs      = 2;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;

sys = simsizes(sizes);

x0 = [];

str = [];

%
% initialize the array of sample times, note that in earlier
% versions of this scope, a sample time was not one of the input
% arguments, the varargin checks for this and if not present, assigns
% the sample time to -1 (inherited)
%
if ~isempty(varargin) > 0
  ts = [varargin{1} 0];
else
  ts = [-1 0];
end

% specify that the simState for this s-function is same as the default
 simStateCompliance = 'DefaultSimState';
% end mdlInitializeSizes

%
%=============================================================================
% mdlUpdate
% Handle discrete state updates, sample time hits, and major time step
% requirements.
%=============================================================================
%
function sys=mdlUpdate(t,x,u,flag,ax,block,varargin)%#ok

%
% always return empty, there are no states...
%
sys = [];

%
% Locate the figure window associated with this block.  If it's not a valid
% handle (it may have been closed by the user), then return.
%
FigHandle=GetSfunXYFigure(block);
if ~ishandle(FigHandle),
   return
end

%
% Get UserData of the figure.
%
ud = FigHandle.UserData;
if isempty(ud.XData),
  x_data = [u(1) u(1)];
  y_data = [u(2) u(2)];
else
  x_data = [ud.XData(end) u(1)];
  y_data = [ud.YData(end) u(2)];
end

% plot the input lines
if ~isequal(ax(1:2), ud.XLim)
    ud.XYAxes.XLim(1:2) = ax(1:2);
    ud.XLim = ax(1:2);
end
if ~isequal(ax(3:4), ud.YLim)
    ud.XYAxes.YLim(1:2) = ax(3:4);
    ud.YLim = ax(3:4);
end

set_line_data(ud.XYLine,...
    x_data,...
    y_data); % XData, YData

%
% update the X/Y stored data points
%
ud.XData(end+1) = u(1);
ud.YData(end+1) = u(2);
FigHandle.UserData = ud;

drawnow limitrate;

% end mdlUpdate

%
%=============================================================================
% LocalBlockStartFcn
% Function that is called when the simulation starts.  Initialize the
% XY Graph scope figure.
%=============================================================================
%
function LocalBlockStartFcn(block)

%
% get the figure associated with this block, create a figure if it doesn't
% exist
%
FigHandle = GetSfunXYFigure(block);
if ~ishandle(FigHandle),
  FigHandle = CreateSfunXYFigure(block);
end

ud = get(FigHandle,'UserData');
set_line_data(ud.XYLine,[],[]);   % XData, YData
ud.XLim  = [];
ud.YLim  = [];
ud.XData = [];
ud.YData = [];
set(FigHandle,'UserData',ud);

% end LocalBlockStartFcn

%
%=============================================================================
% LocalBlockStopFcn
% At the end of the simulation, set the line's X and Y data to contain
% the complete set of points that were acquire during the simulation.
% Recall that during the simulation, the lines are only small segments from
% the last time step to the current one.
%=============================================================================
%
function LocalBlockStopFcn(block)

FigHandle=GetSfunXYFigure(block);
if ishandle(FigHandle),
  %
  % Get UserData of the figure.
  %
  ud = get(FigHandle,'UserData');
  set(ud.XYLine, 'LineStyle','-');
      
end

% end LocalBlockStopFcn

%
%=============================================================================
% LocalBlockNameChangeFcn
% Function that handles name changes on the Graph scope block.
%=============================================================================
%
function LocalBlockNameChangeFcn(block)

%
% get the figure associated with this block, if it's valid, change
% the name of the figure
%
FigHandle = GetSfunXYFigure(block);
if ishandle(FigHandle),
  set(FigHandle,'Name',BlockFigureTitle(block));
end

% end LocalBlockNameChangeFcn

%
%=============================================================================
% LocalBlockLoadCopyFcn
% This is the XYGraph block's LoadFcn and CopyFcn.  Initialize the block's
% UserData such that a figure is not associated with the block.
%=============================================================================
%
function LocalBlockLoadCopyFcn(block)

SetSfunXYFigure(block,-1);

% end LocalBlockLoadCopyFcn

%
%=============================================================================
% LocalBlockDeleteFcn
% This is the XY Graph block DeleteFcn.  Delete the block's figure window,
% if present, upon deletion of the block.
%=============================================================================
%
function LocalBlockDeleteFcn(block)

%
% Get the figure handle associated with the block, if it exists, delete
% the figure.
%
FigHandle=GetSfunXYFigure(block);
if ishandle(FigHandle),
  delete(FigHandle);
  SetSfunXYFigure(block,-1);
end

% end LocalBlockDeleteFcn

%
%=============================================================================
% LocalFigureDeleteFcn
% This is the XY Graph figure window's DeleteFcn.  The figure window is
% being deleted, update the XY Graph block's UserData to reflect the change.
%=============================================================================
%
function LocalFigureDeleteFcn

%
% Get the block associated with this figure and set it's figure to -1
%
ud=get(gcbf,'UserData');
SetSfunXYFigure(ud.Block,-1)

% end LocalFigureDeleteFcn

%
%=============================================================================
% GetSfunXYFigure
% Retrieves the figure window associated with this S-function XY Graph block
% from the block's parent subsystem's UserData.
%=============================================================================
%
function FigHandle=GetSfunXYFigure(block)

if strcmp(get_param(block,'BlockType'),'S-Function'),
  block=get_param(block,'Parent');
end

FigHandle=get_param(block,'UserData');
if isempty(FigHandle),
  FigHandle=-1;
end

% end GetSfunXYFigure

%
%=============================================================================
% SetSfunXYFigure
% Stores the figure window associated with this S-function XY Graph block
% in the block's parent subsystem's UserData.
%=============================================================================
%
function SetSfunXYFigure(block,FigHandle)

if strcmp(get_param(bdroot,'BlockDiagramType'),'model'),
  if strcmp(get_param(block,'BlockType'),'S-Function'),
    block=get_param(block,'Parent');
  end

  set_param(block,'UserData',FigHandle);
end

% end SetSfunXYFigure

%
%=============================================================================
% CreateSfunXYFigure
% Creates the figure window associated with this S-function XY Graph block.
%=============================================================================
%
function FigHandle=CreateSfunXYFigure(block)

%
% the figure doesn't exist, create one
%
screenLoc = get(0,'ScreenSize');

if screenLoc(1) < 0
    left  = -screenLoc(1) + 100;
else
    left  = 100;
end

if screenLoc(2) < 0
    bottom = -screenLoc(2) + 100;
else
    bottom = 100;
end

FigHandle = figure('Units',          'pixel',...
                   'Position',       [left bottom  400 300],...
                   'Name',           BlockFigureTitle(block),...
                   'Tag',            'SIMULINK_XYGRAPH_FIGURE',...
                   'NumberTitle',    'off',...
                   'IntegerHandle',  'off',...
                   'Toolbar',        'none',...
                   'Menubar',        'none',...
                   'DeleteFcn',      'sfunxy([],[],[],''DeleteFigure'')');
%
% store the block's handle in the figure's UserData
%
ud.Block=block;

%
% create various objects in the figure
%
ud.XYAxes   = axes;
new_line = feval(@()matlab.graphics.animation.ScopeLineAnimator('maxNumVertices',100));
new_line.Parent = ud.XYAxes;
ud.XYLine   = new_line;
ud.XYXlabel = xlabel('X Axis');
ud.XYYlabel = ylabel('Y Axis');
ud.XData    = [];
ud.YData    = [];
ud.XYAxes.Title.String = 'X Y Plot';
grid on

%
% Associate the figure with the block, and set the figure's UserData.
%
SetSfunXYFigure(block,FigHandle);
set(FigHandle,'HandleVisibility','callback','UserData',ud);

% end CreateSfunXYFigure

%
%=============================================================================
% set_line_data
% local function to set the line data
%=============================================================================
%
function set_line_data(lineobj, xdata, ydata)
% Utility function to set line data for the Line Animator & the built-in line.
    
if iscell(lineobj) && length(lineobj)==1
    lineobj = lineobj{1};
end

if isa(lineobj,'matlab.graphics.animation.ScopeLineAnimator')
    if isempty(xdata) || isempty(ydata)
        % clear figure
        lineobj.reset;
    else % add data to line animator
        xydata = [xdata; ydata];
        lineobj.addXY(xydata);
    end
end

%
%=============================================================================
% BlockFigureTitle
% String to display for figure window title
%=============================================================================
%
function title = BlockFigureTitle(block)
  iotype = get_param(block,'iotype');
  if strcmp(iotype,'viewer')
    title = viewertitle(block,false);
  else
    title = get_param(block,'Name');
  end
%end BlockFigureTitle

%
%=============================================================================
% IsValidBlock
% Check if this is a valid block
%=============================================================================
%
function IsValidBlock(block, flag)

if strcmp(get_param(block,'BlockType'),'S-Function'),
  thisBlock = get_param(block,'Parent');
else
  thisBlock = block;
end

if(~strcmp(flag,'DeleteFigure'))
  if(~strcmp(get_param(thisBlock,'MaskType'), 'XY scope.'))
    DAStudio.error('Simulink:blocks:invalidBlock');
  end
end
%end IsValidBlock

%
%=============================================================================
% SetBlockCallbacks
% This sets the callbacks of the block if it is not a reference.
%=============================================================================
%
function SetBlockCallbacks(block)

%
% the actual source of the block is the parent subsystem
%
block=get_param(block,'Parent');

%
% if the block isn't linked, issue a warning, and then set the callbacks
% for the block so that it has the proper operation
%
if strcmp(get_param(block,'LinkStatus'),'none'),
  warnmsg = DAStudio.message('Simulink:blocks:ReplaceBlock',block);
  warning(warnmsg);

  callbacks={
    'CopyFcn',       'sfunxy([],[],[],''CopyBlock'')' ;
    'DeleteFcn',     'sfunxy([],[],[],''DeleteBlock'')' ;
    'LoadFcn',       'sfunxy([],[],[],''LoadBlock'')' ;
    'StartFcn',      'sfunxy([],[],[],''Start'')' ;
    'StopFcn'        'sfunxy([],[],[],''Stop'')' 
    'NameChangeFcn', 'sfunxy([],[],[],''NameChange'')' ;
  };

  for i=1:length(callbacks),
    if ~strcmp(get_param(block,callbacks{i,1}),callbacks{i,2}),
      set_param(block,callbacks{i,1},callbacks{i,2})
    end
  end
end

% end SetBlockCallbacks

% LocalWords:  LORENZS Sfun XYGRAPH ud iotype



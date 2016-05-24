function ctrldems
%CTRLDEMS Set up Control System demos for The MATLAB Expo.

%   Ned Gulley, 6-21-93
%   Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%   $Revision: 1.5 $  $Date: 1999/01/05 15:20:42 $

labelList=str2mat( ...
        'Introduction', ...
        'LQG design', ...
        'Digital Controller', ...
        'Kalman Filtering');

nameList=str2mat( ...
        'ctrldemo', ...
        'milldemo', ...
        'diskdemo', ...
        'kalmdemo');

cmdlnwin(labelList,nameList);

%-------------------------------------------------------------------------
%
% This file was created  while carrying out the lab exercise, following the
% lab guide.
%
% Updated by : Alonso Herreros <alonso.herreros.c@gmail.com>
%       Date : november 2024
%
%-------------------------------------------------------------------------

%% Experiment definition

%% 1.0. Init

M = 4;                  % Orden de la constelación (Constellation order)
nSimb = 2e5;            % Number of symbols in the simulation
tAssign = 'gray';        % Type of binary assignement ('gray', 'bin')
a = 1/9;
d = arrayfun(@(m) a^m, 0:50);

%% 1.1 Using x0

N = 11;
x0 = ones(1, N);

exp = Experiment1(M, nSimb, tAssign, a);


%% 1.2 Using sequences x1-x3

[x1, x2, x3] = sequences11;

p = DSSS_p(x, d);


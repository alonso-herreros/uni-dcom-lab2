%-------------------------------------------------------------------------
%
% This file was created  while carrying out the lab exercise, following the
% lab guide.
%
% Updated by : Alonso Herreros <alonso.herreros.c@gmail.com>
%       Date : november 2024
%
%-------------------------------------------------------------------------

%% -- Init

set(groot,'defaulttextinterpreter','latex');
set(groot, 'defaultLegendInterpreter', 'latex');


%% Some functions

function E = energy(x)
    E = sum(abs(x).^2);
end

%% Experiment runs

% == Run experiment ==
function [Ep, corr, BERs, SERs] = run(exp, variances)
    init(exp);
    % disp(['x[n]: ', num2str(exp.x)]);
    % disp(['p[n]: ', num2str(exp.p)]);

    Ep = energy(exp.p);
    % disp(['  Energy of p[m]: ', num2str(Ep)]);
    
    corr = xcorr(exp.x);
    % disp(['  Correlation of x[n]: ', num2str(corr)]);

    BERs = zeros(size(variances));
    SERs = zeros(size(variances));
    for i=1:numel(variances)
        nVar = variances(i);
        [BERs(i), SERs(i)] = exec1(exp, nVar);
        % disp(['Noise variance = ', num2str(nVar)]);
        % disp(['  Pe:  ', num2str(SERs(i))]);
        % disp(['  BER: ', num2str(BERs(i))]);
    end
    % disp(' ');

    % Pretty print in a table row
    fprintf('| %.1f | %.4f | %.4f | %.4f | %.4f |\n', ...
        Ep, SERs(1), SERs(2), BERs(1), BERs(2));
end

function init(exp)
    exp.gen();
    exp.encode();
end

function [BER, SER] = exec1(exp, nVar)
    exp.spread();
    exp.transmit(nVar);
    exp.despread();
    exp.decode();
    [BER, SER] = exp.evalErrors();
end



%% 1.0. Init

M = 4;                  % Orden de la constelación (Constellation order)
nSimb = 2e5;            % Number of symbols in the simulation
tAssig = 'gray';        % Type of binary assignement ('gray', 'bin')
a = 9/10;
d = arrayfun(@(m) a^m, 0:50);

%% 1. One user

disp(['d[n]: ', num2str(d)]);

% 1.1. Energy of d[m]

E = energy(d);
disp(['Energy of d[m]: ', num2str(E)]);
disp(' ');

%% 1.2. p[n] energy and error probilities

variances = [0, 1];

% 1.2.1. Using x0
N = 11;
x0 = ones(1, N);

exp = Experiment1(M, nSimb, tAssig, d, x0);
[~, corrs(1,:)] = run(exp, variances);

% 1.2.2. Using sequences x1-x3

load('sequences11.mat');
x = sequences11;

for i=1:size(x,1)
    exp = Experiment1(M, nSimb, tAssig, d, x(i,:));
    [~, corrs(i+1,:)] = run(exp, variances);
end

%% 1.3. Plot correlation functions
fdir = '../figures';

figure(1); clf; hold on;
for i=1:size(corrs,1)
    plot(corrs(i,:), DisplayName=['x', num2str(i-1)]);
end
grid on;
title('Correlation functions of spreading sequences');
xlabel('Discrete-time index m');
ylabel('Time correlation');
legend('show');
 
print(sprintf('%s/1.3-corrs.png', fdir), '-dpng');

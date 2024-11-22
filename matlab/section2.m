%-------------------------------------------------------------------------
%
% This file was created  while carrying out the lab exercise, following the
% lab guide.
%
% Updated by : Alonso Herreros <alonso.herreros.c@gmail.com>
%       Date : november 2024
%
%-------------------------------------------------------------------------

%-------------------------------------------------------------------------
% LAB SECTION 2: Two users
%-------------------------------------------------------------------------

%% -- Init

set(groot,'defaulttextinterpreter','latex');
set(groot, 'defaultLegendInterpreter', 'latex');


%% Experiment runs

% == Run experiment ==
function [dp, corr, BERs_A, SERs_A, BERs_B, SERs_B] = run(expA, expB, variances)
    init(expA, expB);

    dp = dot(expA.x, expB.x);
    
    corr = xcorr(expA.x, expB.x);

    BERs_A = zeros(size(variances)); SERs_A = zeros(size(variances));
    BERs_B = zeros(size(variances)); SERs_B = zeros(size(variances));
    for i=1:numel(variances)
        nVar = variances(i);
        exec1(expA, expB, nVar);

        [BERs_A(i), SERs_A(i)] = exec2(expA);
        [BERs_B(i), SERs_B(i)] = exec2(expB);
        % disp(['Noise variance = ', num2str(nVar)]);
        % disp(['  Pe:  ', num2str(SERs(i))]);
        % disp(['  BER: ', num2str(BERs(i))]);
    end
    % disp(' ');

    % Pretty print in a table row. Don't worry, I know what it means.
    error_rates = sprintf('| %.4f $\\Bigg\\vert$ %.4f', ...
        SERs_A(1), SERs_B(1), SERs_A(2), SERs_B(2), BERs_A(1), BERs_B(1), BERs_A(2), BERs_B(2));
    fprintf('| %.1f %s |\n', dp, error_rates);
end

function init(expA, expB)
    expA.gen();
    expA.encode();
    expB.gen();
    expB.encode();
end

function exec1(expA, expB, nVar)
    expA.spread();
    expB.spread();
    expB.v = expA.transmit(nVar, expA.s+expB.s);
end

function [BER, SER] = exec2(exp)
    exp.despread();
    exp.decode();
    [BER, SER] = exp.evalErrors();
end

%% 2.0. Definitions

M = 4;                  % Orden de la constelación (Constellation order)
nSimb = 2e5;            % Number of symbols in the simulation
tAssig = 'gray';        % Type of binary assignement ('gray', 'bin')
d = [1]; %#ok<NBRAK2>   % Ideal channel

variances = [0, 1];
load('sequences11.mat'); x = sequences11;

%% 2.1.1. Ideal channel

combos = [1, 2; 1, 3; 2, 3; 2, 2];
corrs = zeros(size(combos,1)+1, 2*length(x(1,:))-1);

for i=1:size(combos,1)
    xA = x(combos(i,1),:);
    xB = x(combos(i,2),:);
    expA = Experiment1(M, nSimb, tAssig, d, xA);
    expB = Experiment1(M, nSimb, tAssig, d, xB);
    [~, corrs(i+1,:)] = run(expA, expB, variances);
end
disp(' ');

%% 2.1.2. Bad channel

a = 9/10;
d = arrayfun(@(m) a^m, 0:50);
combos2 = [1, 2; 1, 3; 2, 3];

for i=1:size(combos2,1)
    xA = x(combos2(i,1),:);
    xB = x(combos2(i,2),:);
    expA = Experiment1(M, nSimb, tAssig, d, xA);
    expB = Experiment1(M, nSimb, tAssig, d, xB);
    run(expA, expB, variances);
end
disp(' ');

%% 2.2. Correlations

fdir = '../figures';


figure(1); clf; hold on;
for i=1:size(combos,1)
    plot(corrs(i,:), DisplayName=sprintf('$Corr(x_%d, x_%d)$', combos(i,1), combos(i,2)));
end
grid on;
title('Correlation functions of spreading sequence combinations');
ylabel('Correlation');
legend('show');
print(sprintf('%s/2.2.0-corrs.png', fdir), '-dpng');

figure(2); clf; hold on;
for i=1:size(combos,1)
    plot(abs(corrs(i,:)), DisplayName=sprintf('$Corr(x_%d, x_%d)$', combos(i,1), combos(i,2)));
end
grid on;
title('Correlation functions of spreading sequence combinations');
ylabel('Correlation');
legend('show');
print(sprintf('%s/2.2.0b-corrs-abs.png', fdir), '-dpng');
 
figure(3);
for i=1:size(combos,1)
    xA_n = combos(i,1);
    xB_n = combos(i,2);
    plot(corrs(i,:));
    grid on;
    title(sprintf('Correlation function of $x_%d, x_%d$', xA_n, xB_n));
    ylabel('Correlation');
     
    print(sprintf('%s/2.2.%d-corr-x%d-x%d.png', fdir, i, xA_n, xB_n), '-dpng');
end

% Retrieve Alpha and Gamma Personalized frequencies with just one click
% Author: Robbie SG.

clear all
clc

% TO BE CHANGED EVERY RUN WITH THE PROPER FILE NAME
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
eeg_file = '../../Matlab/RS_P03_S2_0001.eeg';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

raw = ft_read_data(eeg_file);

cfg = [];
cfg.dataset                 = eeg_file;
% cfg.headerfile              = 'P01_RS_1.vhdr';
cfg.trialdef.eventtype      = '?';
cfg.trialdef.ntrials        = 1;
cfg.trialdef.triallength    = 210; % 3min + 30s
cfg.continuous              = 'yes';
cfg.trialfun                = 'ft_trialfun_general';
cfg.channel                 = {'O1' 'O2' 'Oz' 'P7' 'P3' 'Pz' 'P4' 'P8' 'PO7' 'PO3' 'POZ' 'PO8' 'PO4'};
cfg                         = ft_definetrial(cfg);

cfg.preproc.demean          = 'yes';
cfg.preproc.bpfilter        = 'yes';
cfg.preproc.bpfreq          = [1 45]; % [low high] in Hz 
cfg.preproc.bpfiltord       = 3;      % bandpass filter order
cfg.preproc.reref           = 'yes';
cfg.preproc.refchannel      = 'all';

prepro = ft_preprocessing(cfg);

sample_freq         = 5000;
resample_freq       = 250;
t_recording         = (size(raw,2)/sample_freq); % time in secs
new_sampling        = t_recording*resample_freq;
cfg.resamplefs      = resample_freq;

resamp = ft_resampledata(cfg, prepro);

avg = mean(resamp.trial{1},1);

n       = size(avg,2);      % length of the signal
k       = 1:n;
T       = n/resample_freq;
frq     = k/T;              % two sides frequency range
freq    = frq(1:(n/2));     % one side frequency range

Y       = fft(avg)/n;       % fft computing and normalization
Y       = abs(Y(1:n/2));

upper_limit   = T*45;
lower_limit   = T*2;

figure(1)
plot(freq(:,lower_limit:upper_limit),Y(:,lower_limit:upper_limit),'r') 
title('Spectrum')

alpha_max = find(Y == max(Y(:,T*7:T*13)));
gamma_max = find(Y == max(Y(:,T*30:T*45)));

display(freq(:,alpha_max));
display(freq(:,gamma_max));


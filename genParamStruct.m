% Save all potentially calibrated parameters into structure
function [paramsAll] = genParamStruct()

numParams = 34;
paramsAll = cell(numParams,1);
% partnersM, [3:age x risk], (hr 0.5 to 60, mr 1-99% of hr, lr 1-99% of mr)
paramsAll{1}.name = 'partnersM'; paramsAll{1}.length = 8; ... %1 %24;
    paramsAll{1}.lb = ones(paramsAll{1}.length,1).*0.01; %ones(paramsAll{1}.length,1).*0.2; 
        %[ones(paramsAll{1}.length*(1/3),1).*0.01; ones(paramsAll{1}.length*(1/3),1).*0.01; ...
		% ones(paramsAll{1}.length*(1/3),1).*0.5]; ... %0.1;
    paramsAll{1}.ub = ones(paramsAll{1}.length,1).*60; %ones(paramsAll{1}.length,1).*5.0; 
        %[ones(paramsAll{1}.length*(1/3),1).*0.99; ones(paramsAll{1}.length*(1/3),1).*0.99; ...
        % ones(paramsAll{1}.length*(1/3),1).*60.0]; %15;

% partnersF, [3:age x risk], (hr 0.5 to 60, mr 1-99% of hr, lr 1-99% of mr)
paramsAll{2}.name = 'partnersF'; paramsAll{2}.length = 8; ... %1 %24;
    paramsAll{2}.lb = ones(paramsAll{2}.length,1).*0.01; %ones(paramsAll{2}.length,1).*0.2; 
        %[ones(paramsAll{2}.length*(1/3),1).*0.01; ones(paramsAll{2}.length*(1/3),1).*0.01; ...
        % ones(paramsAll{2}.length*(1/3),1).*0.5]; ... %0.1;
    paramsAll{2}.ub = ones(paramsAll{2}.length,1).*60; %ones(paramsAll{2}.length,1).*5.0; 
        %[ones(paramsAll{2}.length*(1/3),1).*0.99; ones(paramsAll{2}.length*(1/3),1).*0.99; ...
        % ones(paramsAll{2}.length*(1/3),1).*60.0]; %15;

% % riskDistM, [3:age x risk], (0 to 1)
% paramsAll{3}.name = 'riskDistM'; paramsAll{3}.length = 42; ...
%     paramsAll{3}.lb = [ones(paramsAll{3}.length*(1/3),1).*0.5; ones(paramsAll{3}.length*(2/3),1).*0.001]; ...
%     paramsAll{3}.ub = ones(paramsAll{3}.length,1);

% % riskDistF, [3:age x risk], (0 to 1)
% paramsAll{4}.name = 'riskDistF'; paramsAll{4}.length = 42; ...
%     paramsAll{4}.lb = [ones(paramsAll{4}.length*(1/3),1).*0.5; ones(paramsAll{4}.length*(2/3),1).*0.001]; ...
%     paramsAll{4}.ub = ones(paramsAll{4}.length,1);

% condUse, [1 x 1], (0.01 to 0.9)
paramsAll{5}.name = 'condUse'; paramsAll{5}.length = 1; ...
    paramsAll{5}.lb = 0.11; ...
    paramsAll{5}.ub = 0.85;

% epsA, [1 x 3], (0.1 to 1)
paramsAll{6}.name = 'epsA'; paramsAll{6}.length = 1; ... %3
    paramsAll{6}.lb = ones(paramsAll{6}.length,1).*0.1; ...
    paramsAll{6}.ub = ones(paramsAll{6}.length,1);

% epsR, [1 x 3], (0.1 to 1)
paramsAll{7}.name = 'epsR'; paramsAll{7}.length = 1; ... %3
    paramsAll{7}.lb = ones(paramsAll{7}.length,1).*0.1; ...
    paramsAll{7}.ub = ones(paramsAll{7}.length,1);

% maleActs, [3:age x risk], (lr 1 to 90, mr 1-99% of lr, hr 1-99% of mr) 
paramsAll{8}.name = 'maleActs'; paramsAll{8}.length = 1; ... %42; 
    paramsAll{8}.lb = ones(paramsAll{8}.length,1).*0.2; %[ones(paramsAll{8}.length*(1/3),1).*1.0; ones(paramsAll{8}.length*(1/3),1).*0.01; ...
                    % ones(paramsAll{8}.length*(1/3),1).*0.01]; ... %0.1;
    paramsAll{8}.ub = ones(paramsAll{8}.length,1).*2.0; %[ones(paramsAll{8}.length*(1/3),1).*90.0; ones(paramsAll{8}.length*(1/3),1).*0.99; ...
                    % ones(paramsAll{8}.length*(1/3),1).*0.99]; %15;

% femaleActs, [3:age x risk], (lr 1 to 90, mr 1-99% of lr, hr 1-99% of mr)
paramsAll{9}.name = 'femaleActs'; paramsAll{9}.length = 1; ... %42; ...
    paramsAll{9}.lb = ones(paramsAll{9}.length,1).*0.2; %[ones(paramsAll{9}.length*(1/3),1).*1.0; ones(paramsAll{9}.length*(1/3),1).*0.01; ...
                    % ones(paramsAll{9}.length*(1/3),1).*0.01]; ... %0.1;
    paramsAll{9}.ub = ones(paramsAll{9}.length,1).*2.0; %[ones(paramsAll{9}.length*(1/3),1).*90.0; ones(paramsAll{9}.length*(1/3),1).*0.99; ...
                    % ones(paramsAll{9}.length*(1/3),1).*0.99]; %15;

% perPartnerHpv_vax, [1 x 1], (0.001 to 1.0)
paramsAll{10}.name = 'perPartnerHpv_vax'; paramsAll{10}.length = 1; ...
    paramsAll{10}.lb = 0.001; ...
    paramsAll{10}.ub = 1.0;

% perPartnerHpv_nonV, [1 x 1], (0.001 to 1.0)
paramsAll{11}.name = 'perPartnerHpv_nonV'; paramsAll{11}.length = 1; ...
    paramsAll{11}.lb = 0.001; ...
    paramsAll{11}.ub = 1.0;

% % hpv_hivMult, [dec CD4 x --hrHPV type--], (0.25x to 4x)
% paramsAll{12}.name = 'hpv_hivMult'; paramsAll{12}.length = 4; ...
%     paramsAll{12}.lb = ones(paramsAll{12}.length,1).*0.25; ...
%     paramsAll{12}.ub = ones(paramsAll{12}.length,1).*4.0;

% hpv_hivClear, [dec CD4], (0.25x to 4x)
paramsAll{14}.name = 'hpv_hivClear'; paramsAll{14}.length = 4; ...
    paramsAll{14}.lb = [0.5 ; 0.01; 0.01; 0.01]; ... %ones(paramsAll{15}.length,1).*0.25;
    paramsAll{14}.ub = [1.0; 0.99; 0.99; 0.99]; %ones(paramsAll{15}.length,1).*4.0;

% c3c2Mults, [dec CD4], (0.25x to 4x)
paramsAll{15}.name = 'c3c2Mults'; paramsAll{15}.length = 3; ... %4;
    paramsAll{15}.lb = [0.01; 0.01; 2.0]; ... %ones(paramsAll{16}.length,1).*0.25;
    paramsAll{15}.ub = [0.99; 0.99; 10.0]; %ones(paramsAll{16}.length,1).*4.0;

% c2c1Mults, [dec CD4], (0.25x to 4x)
paramsAll{16}.name = 'c2c1Mults'; paramsAll{16}.length = 3; ... %4
    paramsAll{16}.lb = [0.01; 0.01; 2.0]; ... %ones(paramsAll{17}.length,1).*0.25;
    paramsAll{16}.ub = [0.99; 0.99; 10.0]; %ones(paramsAll{17}.length,1).*4.0;

% lambdaMultImm, [age x 1], (0.001 to 1)
paramsAll{18}.name = 'lambdaMultImm'; paramsAll{18}.length = 1; ... %16;
    paramsAll{18}.lb = ones(paramsAll{18}.length,1).*0.5; ...
    paramsAll{18}.ub = ones(paramsAll{18}.length,1).*(1.0/0.99);

% % maxRateM_vec, [1 x 2], (0.2 to 0.7)
% paramsAll{19}.name = 'maxRateM_vec'; paramsAll{19}.length = 2; ...
%     paramsAll{19}.lb = ones(paramsAll{19}.length,1).*0.2; ...
%     paramsAll{19}.ub = ones(paramsAll{19}.length,1).*0.7;

% % maxRateF_vec, [1 x 2], (0.2 to 0.7)
% paramsAll{20}.name = 'maxRateF_vec'; paramsAll{20}.length = 2; ...
%     paramsAll{20}.lb = ones(paramsAll{20}.length,1).*0.2; ...
%     paramsAll{20}.ub = ones(paramsAll{20}.length,1).*0.7;

% artHpvMult, [1 x 1], (1 to 2.32)
paramsAll{21}.name = 'artHpvMult'; paramsAll{21}.length = 1; ...
    paramsAll{21}.lb = ones(paramsAll{21}.length,1).*1.0; ...
    paramsAll{21}.ub = ones(paramsAll{21}.length,1).*2.32;

% % kCD4, [g x vl x CD4], (0.01 to 10) --> ??constraints
% paramsAll{22}.name = 'kCD4'; paramsAll{22}.length = 40; ...
%     paramsAll{22}.lb = ones(paramsAll{22}.length,1).*0.01; ...
%     paramsAll{22}.ub = ones(paramsAll{22}.length,1).*10.0;

% % kVL, [g x vl x CD4], (0.01 to 10) --> ??constraints
% paramsAll{23}.name = 'kVL'; paramsAll{23}.length = 40; ...
%     paramsAll{23}.lb = ones(paramsAll{23}.length,1).*0.01; ...
%     paramsAll{23}.ub = ones(paramsAll{23}.length,1).*10.0;

% %kProgrsMult , [1 x 1]
% paramsAll{25}.name = 'kProgrsMult'; paramsAll{25}.length = 1; ...
%     paramsAll{25}.lb = ones(paramsAll{25}.length,1).*0.2; ...
%     paramsAll{25}.ub = ones(paramsAll{25}.length,1).*1.0;

% %kRegrsMult , [1 x 1]
% paramsAll{26}.name = 'kRegrsMult'; paramsAll{26}.length = 1; ...
%     paramsAll{26}.lb = ones(paramsAll{26}.length,1).*1.0; ...
%     paramsAll{26}.ub = ones(paramsAll{26}.length,1).*5.0;

% kCin1_InfMult , [1 , hpvTypeGroups]
paramsAll{27}.name = 'kCin1_InfMult'; paramsAll{27}.length = 2; ...
    paramsAll{27}.lb = [0.2 ; 0.2]; ...
    paramsAll{27}.ub = [1.8 ; 1.8];

% kCin2_Cin1Mult , [1 , hpvTypeGroups]
paramsAll{28}.name = 'kCin2_Cin1Mult'; paramsAll{28}.length = 2; ...
    paramsAll{28}.lb = [0.2 ; 0.2]; ...
    paramsAll{28}.ub = [1.8 ; 1.8];

% kCin3_Cin2Mult , [1 , hpvTypeGroups]
paramsAll{29}.name = 'kCin3_Cin2Mult'; paramsAll{29}.length = 2; ...
    paramsAll{29}.lb = [0.2 ; 0.2]; ...
    paramsAll{29}.ub = [1.8 ; 1.8];

% kCC_Cin3Mult , [1 , hpvTypeGroups]
paramsAll{30}.name = 'kCC_Cin3Mult'; paramsAll{30}.length = 2; ...
    paramsAll{30}.lb = [0.2 ; 0.2]; ...
    paramsAll{30}.ub = [1.8 ; 1.8];

% rNormal_InfMult , [1 , hpvTypeGroups]
paramsAll{31}.name = 'rNormal_InfMult'; paramsAll{31}.length = 2; ...
    paramsAll{31}.lb = [0.2 ; 0.2]; ...
    paramsAll{31}.ub = [1.8 ; 1.8];

% kInf_Cin1Mult , [1 , hpvTypeGroups]
paramsAll{32}.name = 'kInf_Cin1Mult'; paramsAll{32}.length = 2; ...
    paramsAll{32}.lb = [0.2 ; 0.2]; ...
    paramsAll{32}.ub = [1.8 ; 1.8];

% kCin1_Cin2Mult , [1 , hpvTypeGroups]
paramsAll{33}.name = 'kCin1_Cin2Mult'; paramsAll{33}.length = 2; ...
    paramsAll{33}.lb = [0.2 ; 0.2]; ...
    paramsAll{33}.ub = [1.8 ; 1.8];

% kCin2_Cin3Mult , [1 , hpvTypeGroups]
paramsAll{34}.name = 'kCin2_Cin3Mult'; paramsAll{34}.length = 2; ...
    paramsAll{34}.lb = [0.2 ; 0.2]; ...
    paramsAll{34}.ub = [1.8 ; 1.8];

function negSumLogL = likeFun(popVec , cinPos2008_obs , cinNeg2008_obs ,...
    hpv_hiv_2008_obs , hpv_hivNeg_2008_obs , hpv_hiv_obs , hpv_hivNeg_obs , ...
    hivPrevM_obs , hivPrevF_obs , disease , viral , gender , age , risk , ...
    hpvTypes , hpvStates , periods , startYear , stepsPerYear)
toInd = @(x)(x(:,8)-1)*k(7)+(x(:,7)-1)*k(6)+(x(:,6)-1)*k(5)+(x(:,5)-1)*k(4)+(x(:,4)-1)*k(3)+(x(:,3)-1)*k(2)+(x(:,2)-1)*k(1)+x(:,1);
%% CIN2/3 prevalence by HIV status
cinPos2008 = zeros(10 , 1);
cinNeg2008 = cinPos2008;
load('general')
for a = 4 : 13 % 15-19 -> 60-64
    % HIV+
    cinInds = toInd(allcomb(2 : 6 , 1 : viral , 1 : hpvTypes , 3 : 4, ...
        1 : periods , 2 , a , 1 : risk));
    ageInds = toInd(allcomb(2 : 6 , 1 : viral , 1 : hpvTypes , 1 : hpvStates , 1 : periods , ...
        2 , a , 1 : risk));
    cinPos2008(a - 3) = (sum(popVec((2008 - startYear) * stepsPerYear , cinInds)))...
        ./ sum(popVec((2008 - startYear) * stepsPerYear , ageInds)) * 100;
    % HIV-
    cinNegInds = toInd(allcomb(1, 1 : viral , 1 : hpvTypes , 3 : 4, ...
        1 : periods , 2 , a , 1 : risk));
    cinNeg2Inds = toInd(allcomb(7 : disease , 1 : viral , 1 : hpvTypes , 3 : 4, ...
        1 : periods , 2 , a , 1 : risk));
    ageNegInds = toInd(allcomb(1 , 1 : viral , 1 : hpvTypes , 1 : hpvStates , 1 : periods , ...
        2 , a , 1 : risk));
    ageNeg2Inds = toInd(allcomb(7 : disease , 1 : viral , 1 : hpvTypes , 1 : hpvStates , 1 : periods , ...
        2 , a , 1 : risk));
    cinNeg2008(a - 3) = (sum(popVec((2008 - startYear) * stepsPerYear , cinNegInds))...
        + sum(popVec((2008 - startYear) * stepsPerYear , cinNeg2Inds)))...
        ./ (sum(popVec((2008 - startYear) * stepsPerYear , ageNegInds)) +...
        sum(popVec((2008 - startYear) * stepsPerYear , ageNeg2Inds))) * 100;
end

pPos = [cinPos2008; cinNeg2008];
N = [cinPos2008_obs(: , 3) ; cinNeg2008_obs(: , 3)];
nPos = [cinPos2008_obs(: , 2) ; cinNeg2008_obs(: , 2)];

%% General HPV Prevalence by Age in 2008 (no CIN2/3)
% hpv2008 = zeros(10 , 1);
%
% for a = 4 : age
%     hpvInds = toInd(allcomb(1 : disease , 1 : viral , 2 : 4 , 1 : 2, ...
%         1 : periods , 2 , a , 1 : risk));
%     ageInds = toInd(allcomb(1 : disease , 1 : viral , 1 : hpvTypes , 1 : hpvStates , 1 : periods , ...
%         2 , a , 1 : risk));
%     hpv2008(a - 3) = sum(popVec((2008 - startYear) * stepsPerYear , hpvInds))...
%         ./ sum(popVec((2008 - startYear) * stepsPerYear , ageInds)) * 100;
% end
%
% pPos = [pPos ; hpv2008];
% N = [N ; hpv2008_obs];

%% HPV Prevalence in HIV+ Women in 2008 (no CIN2/3)
% hpv_hiv_2008 = zeros(10 , 1);
% for a = 4 : 13 % 15-19 -> 60-64
% hpvInds = toInd(allcomb(2 : 6 , 1 : viral , 2 : 4 , 1 : 2, ...
% 1 : periods , 2 , a , 1 : risk));
% ageInds = toInd(allcomb(2 : 6 , 1 : viral , 1 : hpvTypes , 1 : hpvStates , 1 : periods , ...
% 2 , a , 1 : risk));
% hpv_hiv_2008(a - 3) = sum(popVec((2008 - startYear) * stepsPerYear , hpvInds))...
% ./ sum(popVec((2008 - startYear) * stepsPerYear , ageInds)) * 100;
% end

% pPos = [pPos ; hpv_hiv_2008];
% N = [N ; hpv_hiv_2008_obs(: , 3)];
% nPos = [nPos ; hpv_hiv_2008_obs(: , 2)];

% %% HPV Prevalence in HIV- Women in 2008 (no CIN2/3)
% hpv_hivNeg_2008 = zeros(10 , 1);
% dVec = [1 10];
% for a = 4 : 13 % 15-19 -> 60-64
% for d = 1 : length(dVec)
% hpvInds = toInd(allcomb(dVec(d) , 1 : viral , 2 : 4 , 1 : 2, ...
% 1 : periods , 2 , a , 1 : risk));
% ageInds = toInd(allcomb(dVec(d) , 1 : viral , 1 : hpvTypes , 1 : hpvStates , 1 : periods , ...
% 2 , a , 1 : risk));
% hpv_hivNeg_2008(a - 3) = hpv_hivNeg_2008(a - 3) + sum(popVec((2008 - startYear) * stepsPerYear , hpvInds))...
% ./ sum(popVec((2008 - startYear) * stepsPerYear , ageInds)) * 100;
% end
% end

% pPos = [pPos ; hpv_hiv_2008];
% N = [N ; hpv_hivNeg_2008_obs(: , 3)];
% nPos = [nPos ; hpv_hivNeg_2008_obs(: , 2)];

%% HPV prevalence in HIV- women (including CIN)
yr = 2013;
hpv_hivNeg = zeros(9 , 1);

for a = 4 : 11 % 15-19 ->  50-54
    hpvInds = toInd(allcomb(1 , 1 : viral , 2 : 4 , 1 : 8, ...
        1 : periods , 2 , a , 1 : risk));
    ageInds = toInd(allcomb(1 , 1 : viral , 1 : hpvTypes , 1 : hpvStates , 1 : periods , ...
        2 , a , 1 : risk));
    hpv_hivNeg(a - 3) = hpv_hivNeg(a - 3) + sum(popVec((yr - startYear) * stepsPerYear , hpvInds))...
        ./ sum(popVec((yr - startYear) * stepsPerYear , ageInds)) * 100;
end
hpvInds = toInd(allcomb(1 , 1 : viral , 2 : 4 , 1 : 8, ...
    1 : periods , 2 , 12 : 13 , 1 : risk));
ageInds = toInd(allcomb(1 , 1 : viral , 1 : hpvTypes , 1 : hpvStates , 1 : periods , ...
    2 , 12 : 13, 1 : risk));
hpv_hivNeg(end) = hpv_hivNeg(end) + sum(popVec((yr - startYear) * stepsPerYear , hpvInds))...
    ./ sum(popVec((yr - startYear) * stepsPerYear , ageInds)) * 100;


pPos = [pPos ; hpv_hivNeg];
N = [N ; hpv_hivNeg_obs(: , 3)];
nPos = [nPos ; hpv_hivNeg_obs(: , 2)];


hpv_hiv = zeros(9 , 1);
%% HPV prevalence in HIV+ women (including CIN)
for a = 4 : 11 % 15-19 -> 50-54
    hpvInds = [toInd(allcomb(2 : 6 , 1 : viral , 2 : 4 , 1 : 8, ...
        1 : periods , 2 , a , 1 : risk)); toInd(allcomb(10 , 6 , 2 : 4 , 1 : 8, ...
        1 : periods , 2 , a , 1 : risk))];
    ageInds = [toInd(allcomb(2 : 6 , 1 : viral , 1 : hpvTypes , 1 : hpvStates , 1 : periods , ...
        2 , a , 1 : risk)); toInd(allcomb(10 , 6 , 1 : hpvTypes ,...
        1 : hpvStates , 1 : periods , 2 , a , 1 : risk))];
    hpv_hiv(a - 3) = sum(popVec((yr - startYear) * stepsPerYear , hpvInds))...
        ./ sum(popVec((yr - startYear) * stepsPerYear , ageInds)) * 100;
end

% 55-65
hpvInds = toInd(allcomb(2 : 6 , 1 : viral , 2 : 4 , 1 : 8, ...
    1 : periods , 2 , 12 : 13 , 1 : risk)); toInd(allcomb(10 , 6 , ...
    2 : 4 , 1 : 8, 1 : periods , 2 , a , 1 : risk));
ageInds = [toInd(allcomb(2 : 6 , 1 : viral , 1 : hpvTypes , 1 : hpvStates , 1 : periods , ...
    2 , 12 : 13 , 1 : risk)); toInd(allcomb(10 , 6 , 1 : hpvTypes , 1 : hpvStates , 1 : periods , ...
    2 , 12 : 13 , 1 : risk))];
hpv_hiv(end) = sum(popVec((yr - startYear) * stepsPerYear , hpvInds))...
    ./ sum(popVec((yr - startYear) * stepsPerYear , ageInds)) * 100;

pPos = [pPos ; hpv_hiv];
N = [N ; hpv_hiv_obs(: , 3)];
nPos = [nPos ; hpv_hiv_obs(: , 2)];

%% HR HPV Prevalence in HIV+ men
% hpv_hivM2008 = zeros(10 , 1);
% for a = 4 : age %
%     hpvInds = toInd(allcomb(2 : 6 , 1 : viral , 2 : 4 , 1, ...
%         1 : periods , 1 , a , 1 : risk));
%     ageInds = toInd(allcomb(2 : 6 , 1 : viral , 1 : hpvTypes , 1 : hpvStates , 1 : periods , ...
%         1 , a , 1 : risk));
%     hpv_hivM2008(a - 3) = hpv_hivM2008(a - 3) + sum(popVec((2008 - startYear) * stepsPerYear , hpvInds))...
%         ./ sum(popVec((2008 - startYear) * stepsPerYear , ageInds)) * 100;
% end
% %% HR HPV Prevalence in HIV- men
% hpv_hivM2008 = zeros(age - 4 + 1 , 1);
% dVec = [1 , 7 : 10];
% for a = 4 : age
%     for d = 1 : length(dVec)
%     hpvInds = toInd(allcomb(dVec(d) , 1 : viral , 2 : 4 , 1, ...
%         1 : periods , 1 , a , 1 : risk));
%     ageInds = toInd(allcomb(dVec(d) , 1 : viral , 1 : hpvTypes , 1 : hpvStates , 1 : periods , ...
%         1 , a , 1 : risk));
%     hpv_hivM2008(a - 3) = hpv_hivM2008(a - 3) + sum(popVec((2008 - startYear) * stepsPerYear , hpvInds))...
%         ./ sum(popVec((2008 - startYear) * stepsPerYear , ageInds)) * 100;
%     end
% end

%% HIV
% hivYearVec = unique(hivPrevM_obs(: ,1));
% hivAgeM = zeros(7 , length(hivYearVec));
% hivAgeF = hivAgeM;
% for t = 1 : length(hivYearVec)
%     for a = 4 : 10
%         hivMInds = toInd(allcomb(2 : 6 , 1 : viral , 1 : hpvTypes , 1 : hpvStates , ...
%             1 : periods , 1 , a , 1 : risk));
%         artMInds = toInd(allcomb(10 , 6 , 1 : hpvTypes , 1 : hpvStates , ...
%             1 : periods , 1 , a , 1 : risk));
%         totMInds = toInd(allcomb(1 : disease , 1 : viral , 1 : hpvTypes , 1 : hpvStates , ...
%             1 : periods , 1 , a , 1 : risk));
%         hivFInds = toInd(allcomb(2 : 6 , 1 : viral , 1 : hpvTypes , 1 : hpvStates , ...
%             1 : periods , 2 , a , 1 : risk));
%         artFInds = toInd(allcomb(10 , 6 , 1 : hpvTypes , 1 : hpvStates , ...
%             1 : periods , 2 , a , 1 : risk));
%         totFInds = toInd(allcomb(1 : disease , 1 : viral , 1 : hpvTypes , 1 : hpvStates , ...
%             1 : periods , 2 , a , 1 : risk));
%         hivAgeM(a - 3 , t) =  (sum(popVec((hivYearVec(t) - startYear) * stepsPerYear , hivMInds)) ...
%             + sum(popVec((hivYearVec(t) - startYear) * stepsPerYear , artMInds))) ...
%             / sum(popVec((hivYearVec(t) - startYear) * stepsPerYear , totMInds));
%         hivAgeF(a - 3 , t) =  (sum(popVec((hivYearVec(t) - startYear) * stepsPerYear , hivFInds)) ...
%             + sum(popVec((hivYearVec(t) - startYear) * stepsPerYear , artFInds))) ...
%             / sum(popVec((hivYearVec(t) - startYear) * stepsPerYear , totFInds));
%     end
% end
% pPos = [pPos; hivAgeM(:) ; hivAgeF(:)];
% nPos = [nPos ; hivPrevM_obs(: , 2) ; hivPrevF_obs(: , 2)];
% N =  [N ;  hivPrevM_obs(: , 3) ; hivPrevF_obs(: , 3)];
%% Likelihood function
pPos = pPos ./ 100; % scale percent probabilities to decimals
logL = nPos .* log(pPos) + (N - nPos) .* log(1 - pPos); % log likelihoods for binomial events
negSumLogL = - sum(logL); % negative logL to be minimized

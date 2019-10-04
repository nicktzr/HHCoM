function[dPopCum , extraOut] = diffEqs(t , pop , ...
    dim , hpvOn , hivOn , immuneInds , infInds , cin1Inds , cin2Inds , ...
    cin3Inds , normalInds , ccInds , ccRegInds , ccDistInds , ...
    ccTreatedInds , ccLocDetInds , ccRegDetInds , ccDistDetInds , ...
    kInf_Cin1 , kCin1_Cin2 , kCin2_Cin3 , kCin2_Cin1 , kCin3_Cin2 , ...
    kCC_Cin3 , kCin1_Inf , rNormal_Inf , hpv_hivClear , c3c2Mults , ...
    c2c1Mults , fImm , kRL , kDR , muCC , muCC_det , kCCDet , ...
    disease , viral , age , gender , hpvTypes , hpvStates , risk , ...
    periods , gar , rImmuneHiv , hyst , hystInds , hystSusInds , ...
    OMEGA , year , stepsPerYear , startYear , currYear , hpvScreenStartYear , ...
    hivStartYear , vaxStartYear , screenYrs , screenAlgs , screenAgeAll , ...
    screenAgeS , noVaxNoScreen , noVaxToScreen , vaxNoScreen , vaxToScreen , ...
    noVaxToScreenTreatImm , vaxToScreenTreatImm , noVaxToScreenTreatHpv , ...
    vaxToScreenTreatHpv , noVaxToScreenHyst , vaxToScreenHyst , screenAlgorithm , ...
    perPartnerHpv , perPartnerHpv_lr , perPartnerHpv_nonV , maleActs , ...
    femaleActs , lambdaMultImm , lambdaMultVax , artHpvMult , epsA_vec , ...
    epsR_vec , yr , circProtect , condProtect , condUse , actsPer , ...
    partnersM , partnersF , hpv_hivMult , hpvSus , hpvImm , hpvVaxd , ...
    hpvVaxdScreen , hpvVaxd2 , hpvImmVaxd2 , toHpv , toHpv_Imm , toHpv_Vax , ...
    toHpv_VaxScreen , toHpv_VaxNonV , toHpv_VaxNonVScreen , hivSus , toHiv , ...
    mCurr , fCurr , mCurrArt , fCurrArt , betaHIVF2M , betaHIVM2F , hrInds , lrInds , ...
    hrlrInds , vlAdvancer , artDist , muHIV , kCD4 ,  maxRateM1 , ...
    maxRateM2 , maxRateF1 , maxRateF2 , k , hivInds , fertility , ...
    fertMat , fertMat2 , hivFertPosBirth , hivFertNegBirth , ...
    hivFertPosBirth2 , hivFertNegBirth2 , deathMat , circMat , circMat2 , ...
    MTCTRate , circStartYear , ageInd , riskInd , riskDist , ...
    noVaxScreen , noVaxXscreen , vaxScreen , vaxXscreen , vaxG , ...
    vaxAge , vaxRate , agesComb , artDistList , timeStep)

dPopCum = spalloc(1 , prod(dim) , 10 ^ 8);
if size(pop , 1) ~= size(dPopCum , 1)
    pop = pop';
end
extraOut{1} = zeros(disease , hpvTypes , age);
extraOut{2} = zeros(disease , hpvTypes , age);
extraOut{3} = zeros(disease , hpvTypes , age , 3);
extraOut{4} = zeros(disease , viral , hpvTypes , hpvStates , risk , 2);
extraOut{5} = zeros(disease , viral , hpvTypes , hpvStates , risk , 2);
extraOut{6} = zeros(disease , viral , hpvTypes , hpvStates , risk , 2);
extraOut{7} = zeros(disease , viral , hpvTypes , hpvStates , risk , 2);
extraOut{8} = zeros(gender , disease , age , risk);
extraOut{9} = zeros(gender , disease , age , risk);
extraOut{10} = zeros(gender , disease , age , risk);
extraOut{11} = zeros(gender , age , risk);
extraOut{12} = zeros(gender , age);
extraOut{13} = zeros(disease , viral , gender , age , risk);
extraOut{14} = zeros(disease , viral , gender , age , risk);
extraOut{15} = dPopCum;
extraOut{16} = zeros(1);

if hpvOn
    % Progression/regression from initial HPV infection to
    % precancer stages and cervical cancer. Differential CC
    % detection by CC stage and HIV status/CD4 count.
    [dPop , newCC , ccDeath , ccTreated] ...
        = hpvCCdet(pop , immuneInds , infInds , cin1Inds , cin2Inds , ...
            cin3Inds , normalInds , ccInds , ccRegInds , ccDistInds , ...
            ccTreatedInds , ccLocDetInds , ccRegDetInds , ccDistDetInds , ...
            kInf_Cin1 , kCin1_Cin2 , kCin2_Cin3 , kCin2_Cin1 , kCin3_Cin2 , ...
            kCC_Cin3 , kCin1_Inf , rNormal_Inf , hpv_hivClear , c3c2Mults , ...
            c2c1Mults , fImm , kRL , kDR , muCC , muCC_det , kCCDet , ...
            disease , age , hpvTypes , rImmuneHiv , hyst , hystInds , ...
            hystSusInds , OMEGA);
    dPopCum = dPopCum + dPop; % for next module
    extraOut{1} = newCC;
    extraOut{2} = ccDeath;
    extraOut{3} = ccTreated;
    if any((pop + dPopCum.*timeStep) < 0.0)
        error(['Breaking out of function after hpvCCdet:' , num2str(year)]);
    end

    if (year >= hpvScreenStartYear)
        [dPop , newScreen , newTreatImm , newTreatHpv , newTreatHyst] ...
            = hpvScreen(pop , disease , viral , hpvTypes , hpvStates , ...
            risk , screenYrs , screenAlgs , year , stepsPerYear , ...
            screenAgeAll , screenAgeS , noVaxNoScreen , noVaxToScreen , ...
            vaxNoScreen , vaxToScreen , noVaxToScreenTreatImm , ...
            vaxToScreenTreatImm , noVaxToScreenTreatHpv , vaxToScreenTreatHpv , ...
            noVaxToScreenHyst , vaxToScreenHyst , screenAlgorithm , ...
            numScreenAge);
        dPopCum = dPopCum + dPop; % for next module
        extraOut{4} = newScreen;
        extraOut{5} = newTreatImm;
        extraOut{6} = newTreatHpv;
        extraOut{7} = newTreatHyst;
        if any((pop + dPopCum) < 0.0)
            error(['Breaking out of function after hpvScreen:' , num2str(year)]);
        end
    end
end

% HIV and HPV mixing and infection module. Protective effects of condom
% coverage, circumcision, ART, PrEP (not currently used) are accounted for.
[dPop , newHpv , newImmHpv , newVaxHpv , newHiv] = mixInfect(pop , ...
    gar , perPartnerHpv , perPartnerHpv_lr , perPartnerHpv_nonV , maleActs , ...
    femaleActs , lambdaMultImm , lambdaMultVax , artHpvMult , epsA_vec , ...
    epsR_vec , yr , circProtect , condProtect , condUse , actsPer , ...
    partnersM , partnersF , hpv_hivMult , hpvSus , hpvImm , hpvVaxd , ...
    hpvVaxdScreen , hpvVaxd2 , hpvImmVaxd2 , toHpv , toHpv_Imm , toHpv_Vax , ...
    toHpv_VaxScreen , toHpv_VaxNonV , toHpv_VaxNonVScreen , hivSus , toHiv , ...
    mCurr , fCurr , mCurrArt , fCurrArt , betaHIVF2M , betaHIVM2F , disease , ...
    viral , gender , age , risk , hpvStates , hpvTypes , hrInds , lrInds , ...
    hrlrInds , periods , startYear , stepsPerYear , year);
dPopCum = dPopCum + dPop; % for next module
extraOut{8} = newHpv;
extraOut{9} = newImmHpv;
extraOut{10} = newVaxHpv;
extraOut{11} = newHiv;
if any((pop + dPopCum.*timeStep) < 0.0)
    error(['Breaking out of function after mixInfect:' , num2str(year)]);
end

% HIV module, CD4 Progression, VL progression, ART initiation/dropout,
% excess HIV mortality
if (hivOn && (year >= hivStartYear))
    [dPop , hivDeaths , artTreat] = hiv2a(pop , vlAdvancer , artDist , muHIV , ...
        kCD4 ,  maxRateM1 , maxRateM2 , maxRateF1 , maxRateF2 , disease , ...
        viral , gender , age , risk , k , hivInds , ...
        stepsPerYear , year , dPopCum , timeStep);
    dPopCum = dPopCum + dPop;
    extraOut{12} = hivDeaths;
%     extraOut{13} = artTreatTracker;
    extraOut{14} = artTreat;
    if any((pop + dPopCum.*timeStep) < 0.0)
        error(['Breaking out of function after hiv2a' , num2str(year)]);
    end
end

% Birth, aging, risk redistribution module
[dPop , deaths] = bornAgeDieRisk(pop , year , ...
    gender , age , fertility , fertMat , fertMat2 , hivFertPosBirth ,...
    hivFertNegBirth , hivFertPosBirth2 , hivFertNegBirth2 , deathMat , ...
    circMat , circMat2 , MTCTRate , circStartYear , ageInd , riskInd , ...
    riskDist , stepsPerYear , currYear , agesComb , noVaxScreen , ...
    noVaxXscreen , vaxScreen , vaxXscreen , hpvScreenStartYear);
if size(dPop , 1) ~= size(dPopCum , 1)
    dPop = dPop';
end
dPopCum = dPopCum + dPop;
extraOut{15} = deaths;
if any((pop + dPopCum.*timeStep) < 0.0)
    error(['Breaking out of function after bornAgeDieRisk' , num2str(year)]);
end

if ((year >= vaxStartYear) && (vaxRate > 0))
    % HPV vaccination module- school-based vaccination regimen
    [dPop , vaxdSchool] = hpvVaxSchool(pop , k , ...
        disease , viral , risk , hpvTypes , hpvStates , ...
        periods , vaxG , vaxAge , vaxRate);
    dPopCum = dPopCum + dPop;
    extraOut{16} = vaxdSchool;
    if any((pop + dPopCum.*timeStep) < 0.0)
        error(['Breaking out of function after hpvVaxSchool' , num2str(year)]);
    end
end

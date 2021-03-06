% Parameter estimation and sensitivity analysis

% Calculates the negative log likelihood of a sample of potential parameter sets
% Accepts:
% 1) paramSetIdx (index in larger sample matrix to start selection of sub-set)
% Saves:
% 1) File: negSumLogL_calib_[date].dat (negative log likelihood for each parameter set in sub-set)

function sensitivityAnalysis3_prt2(paramSetIdx , tstep_abc , date_abc)

%delete(gcp('nocreate'));

t_curr = tstep_abc;
date = date_abc;

%% Load parameters
paramDir = [pwd ,'/Params/'];
load([paramDir,'settings']);
load([paramDir,'general']);
paramSetMatrix = load([paramDir,'paramSets_calib_' , date , '_' , num2str(t_curr) , '.dat']);
nPrlSets = 16;
subMatrixInds = [paramSetIdx : (paramSetIdx + nPrlSets - 1)];
pIdx = load([paramDir,'pIdx_calib_' , date , '_0.dat']);

[paramsAll] = genParamStruct();
paramsSub = cell(length(pIdx),1);
startIdx = 1;
for s = 1 : length(pIdx)
    paramsSub{s}.length = paramsAll{pIdx(s)}.length;
    paramsSub{s}.inds = (startIdx : (startIdx + paramsSub{s}.length - 1));
    startIdx = startIdx + paramsSub{s}.length;
end

%% Cluster information
pc = parcluster('local');    % create a local cluster object
pc.JobStorageLocation = strcat('/gscratch/csde/carajb' , '/' , getenv('SLURM_JOB_ID'))    % explicitly set the JobStorageLocation to the temp directory that was created in the sbatch script
parpool(pc , str2num(getenv('SLURM_CPUS_ON_NODE')))    % start the pool with max number workers

%% Obtain model output for each set of sampled parameters
%ccIncSet = zeros(nSets,1);
negSumLogLSet = zeros(nPrlSets,1);
parfor n = 1 : nPrlSets
    paramSet = paramSetMatrix(:,subMatrixInds(n));
    [negSumLogL] = historicalSim(pIdx , paramsSub , paramSet , paramSetIdx , tstep_abc , date_abc , 1);
    negSumLogLSet(n,1) = negSumLogL;
end

%% Save parameter sets and negSumLogL values
file = ['negSumLogL_calib_' , date , '_' , num2str(t_curr) , '.dat'];
paramDir = [pwd , '/Params/'];
dlmwrite([paramDir, file] , [paramSetIdx; negSumLogLSet] , 'delimiter' , ',' , 'roffset' , 1 , 'coffset' , 0 , '-append')

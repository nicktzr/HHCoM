function parsave(fname, fivYrAgeGrpsOn , tVec , popVec , newHiv ,...
    newHpvVax , newImmHpvVax , newHpvNonVax , newImmHpvNonVax , ...
    hivDeaths , deaths , ccDeath , ...
    newCC , menCirc , vaxdLmtd , vaxdSchool , vaxdCU , newScreen , ...
    artDist , artDistList , artTreatTracker , artDiscont , ...
    currYear , lastYear , vaxRate , vaxEff , popLast , pathModifier)

savDir = [pwd , '/HHCoM_Results/' , pathModifier, '/'];

save(fullfile(savDir , fname) , 'fivYrAgeGrpsOn' , 'tVec' ,  'popVec' , 'newHiv' ,...
    'newHpvVax' , 'newImmHpvVax' , 'newHpvNonVax' , 'newImmHpvNonVax' , ...
    'hivDeaths' , 'deaths' , 'ccDeath' , ...
    'newCC' , 'menCirc' , 'vaxdLmtd' , 'vaxdSchool' , 'vaxdCU' , 'newScreen' , ...
    'artDist' , 'artDistList' , 'artTreatTracker' , 'artDiscont' , ...
    'currYear' , 'lastYear' , 'vaxRate' , 'vaxEff' , 'popLast' , '-v7.3') 
end

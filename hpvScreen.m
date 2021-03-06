% HPV screening and treatment
function[dPop , ccScreen] = hpvScreen(pop , ...
    disease , viral , hpvVaxStates , hpvNonVaxStates , endpoints , risk , ...
    screenYrs , screenAlgs , year , stepsPerYear , screenAgeAll , screenAgeS , ...
    noVaxNoScreen , noVaxToScreen , vaxNoScreen , vaxToScreen , noVaxToScreenTreatImm , ...
    vaxToScreenTreatImm , noVaxToScreenTreatImmVaxHpv , vaxToScreenTreatImmVaxHpv , ...
    noVaxToScreenTreatImmNonVaxHpv , vaxToScreenTreatImmNonVaxHpv , ...        
    noVaxToScreenTreatHpv , vaxToScreenTreatHpv , noVaxToScreenTreatVaxHpv , ...
    vaxToScreenTreatVaxHpv , noVaxToScreenTreatNonVaxHpv , vaxToScreenTreatNonVaxHpv , ...
    noVaxToScreenHyst , vaxToScreenHyst , numScreenAge)

%% Initialize dPop and output vectors
dPop = zeros(size(pop));
ccScreen = zeros(disease , hpvVaxStates , hpvNonVaxStates , endpoints , numScreenAge , 2);
%ccTreatImm = ccScreen;
%ccTreatHpv = ccScreen;
%ccTreatHyst = ccScreen;

%% Run screening algorithm
for i = 1 : length(screenAlgs.screenHivGrps)
    prevAL = 0;
    if i > 1
        for j = 1 : i-1
            prevAL = prevAL + length(screenAlgs.screenAge{i-1});
        end
    end

    % Screening level
    dataYr1 = screenYrs(1);
    dataYrLast = screenYrs(size(screenYrs , 1));
    baseYrInd = max(find(year >= screenYrs , 1, 'last') , 1); % get index of first year <= current year
    baseYr = screenYrs(baseYrInd);
    screenRate = screenAlgs.screenCover_vec{1}(1); % screening coverage up to 1st year
    if year < dataYrLast && year > dataYr1 % screening coverage between 1st and last year
        screenRate = screenAlgs.screenCover_vec{baseYrInd}(round((year - baseYr) * stepsPerYear) + 1);
    elseif year >= dataYrLast % screening coverage last year and after
        lastInd = size(screenAlgs.screenCover_vec , 1);
        screenRate = screenAlgs.screenCover_vec{lastInd}(size(screenAlgs.screenCover_vec{lastInd} , 2));
    end

    for aS = (prevAL + 1) : (prevAL + length(screenAlgs.screenAge{i}))
        screenRateAge = screenRate;
        for dS = 1 : length(screenAlgs.screenHivGrps{i})
            d = screenAlgs.screenHivGrps{i}(dS);
            for v = 1 : viral
                for h = 1 : hpvVaxStates
                    for s = 1 : hpvNonVaxStates
                        for x = 1 : endpoints
                            for r = 1 : risk
                                fracScreend = (sumall(pop(screenAgeS(d,v,aS,r,:))) / sumall(pop(screenAgeAll(d,v,aS,r,:)))); % find proportion of population that is currently screened
                                if screenRateAge - fracScreend > 10 ^ -6 % when proportion screened is below target screening level
                                    screenCover = max(0 , (screenRateAge - fracScreend) ./ (1 - fracScreend)); % screen enough people in each compartment to reach target

                                    % Apply selected screening algorithm(s)
                                    % if you're susceptible/immune to both HPV types or have had a hysterectomy
                                    if [( ((h==1) || (h==7)) && ((s==1) || (s==7)) && (x==1) )] || (x==4) || [(screenAlgs.genTypBool && ((h==1) || (h==7)) && (((s>=2) && (s<=5)) || ((s==6) && (x<=3))))]
                                        toScreenMult = 1.0;
                                        toScreenTreatImmMult = 0.0;
                                        toScreenTreatHpvMult = 0.0;
                                        toScreenTreatHystMult = 0.0;
                                    % if you're infected with either HPV type
                                    elseif [( ((h==2) && ((s<=2) || (s==7))) || (((h<=2) || (h==7)) && (s==2)) ) && (x==1)] && [(~screenAlgs.genTypBool) || (screenAlgs.genTypBool && (h==2))]
                                        toScreenMult = ((1-screenAlgs.testSens(d,2)) + (screenAlgs.testSens(d,2) * (1 - screenAlgs.colpoRetain)) + ...
                                            (screenAlgs.testSens(d,2) * screenAlgs.colpoRetain * (1 - screenAlgs.treatRetain(1))) + ...
                                            (screenAlgs.testSens(d,2) * screenAlgs.colpoRetain * screenAlgs.treatRetain(1) * screenAlgs.cinTreatHpvPersistHivNeg(1)));
                                        toScreenTreatImmMult = screenAlgs.testSens(d,2) * screenAlgs.colpoRetain * screenAlgs.treatRetain(1) * ...
                                            (1.0-screenAlgs.cinTreatHpvPersistHivNeg(1));
                                        toScreenTreatHpvMult = 0.0;
                                        toScreenTreatHystMult = 0.0;
                                    % if you have CIN1 of either HPV type
                                    elseif [( ((h==3) && ((s<=3) || (s==7))) || (((h<=3) || (h==7)) && (s==3)) ) && (x==1)] && [(~screenAlgs.genTypBool) || (screenAlgs.genTypBool && (h==3))]
                                        toScreenMult = ((1-screenAlgs.testSens(d,2)) + (screenAlgs.testSens(d,2) * (1 - screenAlgs.colpoRetain)) + ...
                                            (screenAlgs.testSens(d,2) * screenAlgs.colpoRetain * (1 - screenAlgs.treatRetain(1))) + ...
                                            (screenAlgs.testSens(d,2) * screenAlgs.colpoRetain * screenAlgs.treatRetain(1) * (1-screenAlgs.cinTreatEff(d))));
                                        toScreenTreatImmMult = screenAlgs.testSens(d,2) * screenAlgs.colpoRetain * screenAlgs.treatRetain(1) * screenAlgs.cinTreatEff(d) * ...
                                            (1.0-(screenAlgs.cinTreatHpvPersistHivNeg(2)/screenAlgs.cinTreatEff(d)));
                                        toScreenTreatHpvMult = screenAlgs.testSens(d,2) * screenAlgs.colpoRetain * screenAlgs.treatRetain(1) * screenAlgs.cinTreatEff(d) * ...
                                            (screenAlgs.cinTreatHpvPersistHivNeg(2)/screenAlgs.cinTreatEff(d));
                                        toScreenTreatHystMult = 0.0;    
                                    % if you have CIN2 of either HPV type
                                    elseif [( ((h==4) && ((s<=4) || (s==7))) || (((h<=4) || (h==7)) && (s==4)) ) && (x==1)] && [(~screenAlgs.genTypBool) || (screenAlgs.genTypBool && (h==4))]
                                        toScreenMult = ((1-screenAlgs.testSens(d,3)) + (screenAlgs.testSens(d,3) * (1 - screenAlgs.colpoRetain)) + ...
                                            (screenAlgs.testSens(d,3) * screenAlgs.colpoRetain * (1 - screenAlgs.treatRetain(2))) + ...
                                            (screenAlgs.testSens(d,3) * screenAlgs.colpoRetain * screenAlgs.treatRetain(2) * (1-screenAlgs.cinTreatEff(d))));
                                        toScreenTreatImmMult = screenAlgs.testSens(d,3) * screenAlgs.colpoRetain * screenAlgs.treatRetain(2) * screenAlgs.cinTreatEff(d) * ...
                                            (1.0-(screenAlgs.cinTreatHpvPersistHivNeg(3)/screenAlgs.cinTreatEff(d)));
                                        toScreenTreatHpvMult = screenAlgs.testSens(d,3) * screenAlgs.colpoRetain * screenAlgs.treatRetain(2) * screenAlgs.cinTreatEff(d) * ...
                                            (screenAlgs.cinTreatHpvPersistHivNeg(3)/screenAlgs.cinTreatEff(d));
                                        toScreenTreatHystMult = 0.0;
                                    % if you have CIN3 of either HPV type
                                    elseif [( ((h==5) && ((s<=5) || (s==7))) || (((h<=5) || (h==7)) && (s==5)) ) && (x==1)] && [(~screenAlgs.genTypBool) || (screenAlgs.genTypBool && (h==5))]
                                        toScreenMult = ((1-screenAlgs.testSens(d,4)) + (screenAlgs.testSens(d,4) * (1 - screenAlgs.colpoRetain)) + ...
                                            (screenAlgs.testSens(d,4) * screenAlgs.colpoRetain * (1 - screenAlgs.treatRetain(3))) + ...
                                            (screenAlgs.testSens(d,4) * screenAlgs.colpoRetain * screenAlgs.treatRetain(3) * (1-screenAlgs.cinTreatEff(d))));
                                        toScreenTreatImmMult = screenAlgs.testSens(d,4) * screenAlgs.colpoRetain * screenAlgs.treatRetain(3) * screenAlgs.cinTreatEff(d) * ...
                                            (1.0-(screenAlgs.cinTreatHpvPersistHivNeg(4)/screenAlgs.cinTreatEff(d)));
                                        toScreenTreatHpvMult = screenAlgs.testSens(d,4) * screenAlgs.colpoRetain * screenAlgs.treatRetain(3) * screenAlgs.cinTreatEff(d) * ...
                                            (screenAlgs.cinTreatHpvPersistHivNeg(4)/screenAlgs.cinTreatEff(d));
                                        toScreenTreatHystMult = 0.0;
                                    % if you have cervical cancer
                                    elseif [( (x==1) && ((h==6) || (s==6)) ) || (x==2) || (x==3)] && [(~screenAlgs.genTypBool) || (screenAlgs.genTypBool && (h==6) && (x<=3))]
                                        toScreenMult = ((1-screenAlgs.testSens(d,4)) + (screenAlgs.testSens(d,4) * (1 - screenAlgs.colpoRetain)) + ...
                                            (screenAlgs.testSens(d,4) * screenAlgs.colpoRetain * (1 - screenAlgs.treatRetain(4))));
                                        toScreenTreatImmMult = 0.0;
                                        toScreenTreatHpvMult = 0.0;
                                        toScreenTreatHystMult = screenAlgs.testSens(d,4) * screenAlgs.colpoRetain * screenAlgs.treatRetain(4);
                                    end
                                
                                    noVaxScreend = screenCover .* pop(noVaxNoScreen(d,v,h,s,x,aS,r));
                                    dPop(noVaxNoScreen(d,v,h,s,x,aS,r)) = dPop(noVaxNoScreen(d,v,h,s,x,aS,r)) - noVaxScreend;
                                    dPop(noVaxToScreen(d,v,h,s,x,aS,r)) = dPop(noVaxToScreen(d,v,h,s,x,aS,r)) + toScreenMult .* noVaxScreend;
                                    dPop(noVaxToScreenHyst(d,v,aS,r)) = dPop(noVaxToScreenHyst(d,v,aS,r)) + toScreenTreatHystMult .* noVaxScreend;
                                    
                                    vaxScreend = screenCover .* pop(vaxNoScreen(d,v,h,s,x,aS,r));
                                    dPop(vaxNoScreen(d,v,h,s,x,aS,r)) = dPop(vaxNoScreen(d,v,h,s,x,aS,r)) - vaxScreend;
                                    dPop(vaxToScreen(d,v,h,s,x,aS,r)) = dPop(vaxToScreen(d,v,h,s,x,aS,r)) + toScreenMult .* vaxScreend;
                                    dPop(vaxToScreenHyst(d,v,aS,r)) = dPop(vaxToScreenHyst(d,v,aS,r)) + toScreenTreatHystMult .* vaxScreend;
                                            
                                    % If you have CIN1+ of either HPV type and are susceptible or immune to the other HPV type, don't want 
                                    % to move individuals susceptible/immune to the other HPV type falsely into an HPV infected compartment. 
                                    % Also if you have HPV or CIN1+ of either HPV type and are susceptible to the other HPV type, don't want 
                                    % to move susceptible individuals of the other HPV type falsely into an HPV immune compartment.
                                    if ( (((h>=2) && (h<=5)) && (((s==1) || (s==7)))) || ((((h==1) || (h==7))) && ((s>=2) && (s<=5))) ) && (x==1)
                                        if ((h>=2) && (h<=5))
                                            dPop(noVaxToScreenTreatVaxHpv(d,v,s,aS,r)) = dPop(noVaxToScreenTreatVaxHpv(d,v,s,aS,r)) + toScreenTreatHpvMult .* noVaxScreend;
                                            dPop(vaxToScreenTreatVaxHpv(d,v,s,aS,r)) = dPop(vaxToScreenTreatVaxHpv(d,v,s,aS,r)) + toScreenTreatHpvMult .* vaxScreend;
                                            if (s==1)
                                                dPop(noVaxToScreenTreatImmVaxHpv(d,v,s,aS,r)) = dPop(noVaxToScreenTreatImmVaxHpv(d,v,s,aS,r)) + toScreenTreatImmMult .* noVaxScreend;
                                                dPop(vaxToScreenTreatImmVaxHpv(d,v,s,aS,r)) = dPop(vaxToScreenTreatImmVaxHpv(d,v,s,aS,r)) + toScreenTreatImmMult .* vaxScreend;
                                            elseif (s==7)
                                                dPop(noVaxToScreenTreatImm(d,v,aS,r)) = dPop(noVaxToScreenTreatImm(d,v,aS,r)) + toScreenTreatImmMult .* noVaxScreend;
                                                dPop(vaxToScreenTreatImm(d,v,aS,r)) = dPop(vaxToScreenTreatImm(d,v,aS,r)) + toScreenTreatImmMult .* vaxScreend;
                                            end
                                        elseif ((s>=2) && (s<=5))    
                                            dPop(noVaxToScreenTreatNonVaxHpv(d,v,h,aS,r)) = dPop(noVaxToScreenTreatNonVaxHpv(d,v,h,aS,r)) + toScreenTreatHpvMult .* noVaxScreend;
                                            dPop(vaxToScreenTreatNonVaxHpv(d,v,h,aS,r)) = dPop(vaxToScreenTreatNonVaxHpv(d,v,h,aS,r)) + toScreenTreatHpvMult .* vaxScreend;
                                            if (h==1)
                                                dPop(noVaxToScreenTreatImmNonVaxHpv(d,v,h,aS,r)) = dPop(noVaxToScreenTreatImmNonVaxHpv(d,v,h,aS,r)) + toScreenTreatImmMult .* noVaxScreend;
                                                dPop(vaxToScreenTreatImmNonVaxHpv(d,v,h,aS,r)) = dPop(vaxToScreenTreatImmNonVaxHpv(d,v,h,aS,r)) + toScreenTreatImmMult .* vaxScreend;
                                            elseif (h==7)
                                                dPop(noVaxToScreenTreatImm(d,v,aS,r)) = dPop(noVaxToScreenTreatImm(d,v,aS,r)) + toScreenTreatImmMult .* noVaxScreend;
                                                dPop(vaxToScreenTreatImm(d,v,aS,r)) = dPop(vaxToScreenTreatImm(d,v,aS,r)) + toScreenTreatImmMult .* vaxScreend;
                                            end
                                        end
                                    % if you have any other combination of HPV types and states
                                    else     
                                        dPop(noVaxToScreenTreatHpv(d,v,aS,r)) = dPop(noVaxToScreenTreatHpv(d,v,aS,r)) + toScreenTreatHpvMult .* noVaxScreend;
                                        dPop(vaxToScreenTreatHpv(d,v,aS,r)) = dPop(vaxToScreenTreatHpv(d,v,aS,r)) + toScreenTreatHpvMult .* vaxScreend;
                                        
                                        dPop(noVaxToScreenTreatImm(d,v,aS,r)) = dPop(noVaxToScreenTreatImm(d,v,aS,r)) + toScreenTreatImmMult .* noVaxScreend;
                                        dPop(vaxToScreenTreatImm(d,v,aS,r)) = dPop(vaxToScreenTreatImm(d,v,aS,r)) + toScreenTreatImmMult .* vaxScreend;
                                    end    
                                        
                                    ccScreen(d , h , s , x , aS , 1) = ccScreen(d , h , s , x , aS , 1) + sumall(noVaxScreend);
                                    %ccTreatImm(d , h , s , x , aS , 1) = ccTreatImm(d , h , s , x , aS , 1) + sumall(toScreenTreatImmMult .* noVaxScreend);
                                    %ccTreatHpv(d , h , s , x , aS , 1) = ccTreatHpv(d , h , s , x , aS , 1) + sumall(toScreenTreatHpvMult .* noVaxScreend);
                                    %ccTreatHyst(d , h , s , x , aS , 1) = ccTreatHyst(d , h , s , x , aS , 1) + sumall(toScreenTreatHystMult .* noVaxScreend);

                                    ccScreen(d , h , s , x , aS , 2) = ccScreen(d , h , s , x , aS , 2) + sumall(vaxScreend);
                                    %ccTreatImm(d , h , s , x , aS , 2) = ccTreatImm(d , h , s , x , aS , 2) + sumall(toScreenTreatImmMult .* vaxScreend);
                                    %ccTreatHpv(d , h , s , x , aS , 2) = ccTreatHpv(d , h , s , x , aS , 2) + sumall(toScreenTreatHpvMult .* vaxScreend);
                                    %ccTreatHyst(d , h , s , x , aS , 2) = ccTreatHyst(d , h , s , x , aS , 2) + sumall(toScreenTreatHystMult .* vaxScreend);
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

%% Convert dPop to a column vector for output to ODE solver
dPop = sparse(dPop);

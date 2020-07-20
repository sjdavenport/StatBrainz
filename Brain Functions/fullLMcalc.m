Sex = bbvars('Sex');
nsubj = length(Sex);

subs4mean = loaddata('subs4mean');

global stdsize

blocksize = 10000;
nblocks = ceil(prod(stdsize)/blocksize);

alphahat = zeros(stdsize);
betahat = zeros(stdsize);

sigma2 = zeros(stdsize);
% tsex = zeros(stdsize);
R2 = zeros(stdsize);

%No Jblock as we're the whole image!
for Iblock = 0:12
    Ilimits = 7*Iblock+1:7*Iblock+7;
    for Jblock = 0:10
        if Jblock < 10
            Jlimits = 10*Jblock + 1: 10*Jblock + 10;
        else
            Jlimits = 101:109;
        end
        Jsize = length(Jlimits);
        for Kblock = 0:12
            fprintf('Iblock: %i, Kblock = %i\n', Iblock, Kblock)
            Klimits = 7*Kblock+1:7*Kblock+7;
            
            Yblock = zeros(nsubj,7,Jsize,7);
            combined_mask = zeros(nsubj,7,Jsize,7);
            for subj = 1:nsubj
                subject_image = readimg(subs4mean(subj),'copes', 1);
                masked_image  = readimg(subs4mean(subj),'mask', 1);
                Yblock(subj,:,:,:) = subject_image(Ilimits, Jlimits, Klimits);
                combined_mask(subj,:,:,:) = masked_image(Ilimits, Jlimits, Klimits);
                disp(subj)
            end
            for I = 1:7
                for J = 1:Jsize
                    for K = 1:7
                        fprintf('%i,%i,%i\n', I,J,K)
                        available_subjects = find(combined_mask(:,I,J,K) == 1);
                        Yav = Yblock(available_subjects, I,J,K);
                        Sexav = Sex(available_subjects);
                        fit = fitlm(Sexav, Yav);
                        coeffs = fit.Coefficients.Estimate;
                        
                        Idex = Ilimits(I);
                        Jdex = Jlimits(J);
                        Kdex = Klimits(K);
                        
                        alphahat(Idex, Jdex, Kdex) = coeffs(1);
                        betahat(Idex, Jdex, Kdex) = coeffs(2);
                        sigma2(Idex, Jdex, Kdex) = fit.RMSE;
                        R2(Idex, J, Kdex) = fit.Rsquared.Ordinary;
                    end
                end
            end
        end
    end
end

imgsave(alphahat,'full_sexlm_intercept',CSI);
imgsave(betahat,'full_sexlm_sexcoeff',CSI);
imgsave(sigma2,'full_sexlm_sigma2',CSI);
imgsave(R2,'full_sexlm_R2sex',CSI);
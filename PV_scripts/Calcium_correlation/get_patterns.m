% # (JM) MODIFIED FROM ORIGINAL FUNCTION 'assembly_patterns'

function NumberOfAssemblies = get_patterns(S)
S = S';
S(:,sum(S,1)==0)=[];
CorrMatrix = corr(S);
CorrMatrix(isnan(CorrMatrix))=0;
[~,d] = eig(CorrMatrix);
d=real(d);
eigenvalues=diag(d);


%Marchenko–Pastur
lambda_max = prctile(circular_shift(S',500),95);
NumberOfAssemblies = sum(eigenvalues>lambda_max);
end



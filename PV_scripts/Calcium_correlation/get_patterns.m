% # (JM) MODIFIED FROM ORIGINAL FUNCTION 'assembly_patterns'

function NumberOfAssemblies = get_patterns(SpikeCount)

zSpikeCount = zscore(SpikeCount');

CorrMatrix = corr(zSpikeCount);
CorrMatrix(isnan(CorrMatrix))=0;
[~,d] = eig(CorrMatrix);
eigenvalues=diag(d);
q = size(zSpikeCount,1)/size(zSpikeCount,2);
if q<1
    fprintf('Error: Number of time bins must be larger than number of neurons \n')
    return
end
%Marchenko–Pastur
lambda_max = prctile(circular_shift(SpikeCount,1000),95);
NumberOfAssemblies = sum(eigenvalues>lambda_max);



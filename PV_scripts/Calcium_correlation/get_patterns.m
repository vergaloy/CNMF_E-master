% # (JM) MODIFIED FROM ORIGINAL FUNCTION 'assembly_patterns'

function NumberOfAssemblies = get_patterns(SpikeCount)

%zSpikeCount = zscore(SpikeCount');
zSpikeCount = SpikeCount';
CorrMatrix = corr(zSpikeCount);
CorrMatrix(isnan(CorrMatrix))=0;
[~,d] = eig(CorrMatrix);
eigenvalues=diag(d);
q = size(zSpikeCount,1)/size(zSpikeCount,2);
%if q<1
%    fprintf('Error: Number of time bins must be larger than number of neurons \n')
%    return
%end
%Marchenko–Pastur
lambda_max = prctile(circular_shift(zSpikeCount',500),95);
NumberOfAssemblies = sum(eigenvalues>lambda_max);



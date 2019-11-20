function [ output_args ] = findICAAssemblies( deltaFoF , KS_significance )
%FINDICAASSEMBLIES( deltaFoF , KS_significance )
%
%
%   === Jan Moelter, The University of Queensland, 2018 ===================
%

narginchk(1,2);
if( nargin == 1 )
    KS_significance = 0.1;
end

if( size( deltaFoF , 1 ) >= size( deltaFoF , 2 ) )
    
    X = transpose( deltaFoF );
    
    
    opts.threshold.method = 'circularshift';
    opts.threshold.permutations_percentile = 95;
    opts.threshold.number_of_permutations = 1000;
    opts.Patterns.method = 'ICA';
    opts.Patterns.number_of_iterations = 1000;
    
    ica_assembly_patterns = assembly_patterns( X , opts );
    
    mp_assembly_vectors = cellfun( @(a) largest_positive( a ) , num2cell( ica_assembly_patterns , 1 ) , 'UniformOutput' , false );
    
    
    opts.threshold.method = 'circularshift';
    opts.threshold.permutations_percentile = 95;
    opts.threshold.number_of_permutations = 1000;
    opts.Patterns.method = 'ICA';
    opts.Patterns.number_of_iterations = 1000;
    
    ica_assembly_patterns = assembly_patterns( X , opts );
    
    cs_assembly_vectors = cellfun( @(a) largest_positive( a ) , num2cell( ica_assembly_patterns , 1 ) , 'UniformOutput' , false );
    
    
    
    for i = 1:numel( KS_significance )
        
        output_args(i).cs_assembly_vectors = cs_assembly_vectors;
        W=get_pattern_cells_from_NMF(cell2mat(cs_assembly_vectors),5);
        
        for j=1:size(W,2)
          output_args(i).cs_assemblies{j, 1}  =find(W(:,j)>0);
        end
    end
    
else
    
    error( [ 'Error :: N > T' ] );
end

end

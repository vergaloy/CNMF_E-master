function out=get_distance(in,distance,m)
    out=squareform(1-pdist(in,distance,m))+diag(ones(1,size(in,1)));
    out(isnan(out))=0;
end
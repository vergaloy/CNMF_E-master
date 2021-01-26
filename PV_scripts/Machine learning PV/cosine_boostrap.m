function cosine_boostrap(A,B)
% cosine_boostrap(at(:,4),at(:,[1,2,3,8]));
c=get_sims(A,B)



end

function c=get_sims(A,B)
for i=1:size(B,2)
c(i)=get_cosine(A,B(:,i));
end


end


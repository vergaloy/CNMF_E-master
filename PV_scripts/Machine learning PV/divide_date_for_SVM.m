function D=divide_date_for_SVM(mice_sleep,varargin)  %this only work for DK REMid experimental desing

% EXAMPLES
%===================================
% D=divide_date_for_SVM(mice_sleep);
% D=divide_date_for_SVM(mice_sleep,'replicates',[1,2,6,7,8,9],'random_shifts',[1,2,3,4,5,6,7,8,9]);
% D=divide_date_for_SVM(mice_sleep,'D',D);


%% DEFAULT PARAMETERS
p = inputParser;
valid_v = @(x) isnumeric(x);
valid_c = @(x) iscell(x);
addRequired(p,'mice_sleep',valid_c)  %input_data. Cell array. columns are sessions, rows are mices.
addParameter(p,'bin',2,valid_v )  % Bin size
addParameter(p,'sf',5,valid_v )  % Sampling frequency
addParameter(p,'random_shifts',[4,5,6,7],valid_v)  %data from different mices will be randomly shift. default=(rem, high-theta, low-theta,nrem). 
addParameter(p,'replicates',[],valid_v)  %  include replicates. default []. 
addParameter(p,'w_size',145,valid_v)   %  window size for replicate. default==140.
addParameter(p,'no_skip',[],valid_v)    %  Don't update specific sessions. default= [];  (update all session).
addParameter(p,'D',[],valid_c)  %  Used along no_skip. Previous D values to use.
p.KeepUnmatched = true;
parse(p,mice_sleep,varargin{:});
%%

n=size(mice_sleep,2)+size(p.Results.replicates,2);
D=cell(1,n);
t=1;
for i=1:size(mice_sleep,2)
    % Update session?
    if (~ismember(i,p.Results.no_skip))
        temp=mice_sleep(:,i);
        % Randomly shift mice in session?
        if (ismember(i,p.Results.random_shifts  ))
            temp=shift_sleep(temp);
        end
        % Bin data
        temp=bin_data(catpad(1,temp{:}),p.Results.sf,p.Results.bin);
        % Include replicates?
        if (ismember(i,p.Results.replicates))
            D{t}=temp(:,1:p.Results.w_size);
            t=t+1;
            D{t}=temp(:,p.Results.w_size+1:p.Results.w_size*2);
            t=t+1;
        else
            D{t}=temp(:,1:p.Results.w_size);
            t=t+1;
        end
    else
        D(1,i)=p.Results.D{1, i};
    end
    
end


function out=shift_sleep(in)
out=cell(size(in,1),1);
for i=1:size(in,1)
    t=circshift_columns((1:size(in{i,1},2))');
    temp=in{i,1};
    out{i,1}=temp(:,t);
end






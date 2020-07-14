% 'numIterations' is an integer with the total number of iterations in the loop. 
% Feel free to increase this even higher and see other progress monitors fail.
numIterations = 1000;

% Then construct a ParforProgressbar object:
ppm = ParforProgressbar(numIterations,'showWorkerProgress', true, 'title', 'my fancy title');

dummy=1
parfor i = 1:numIterations
    i/numIterations
   % do some parallel computation
   pause(10000/numIterations);
   % increment counter to track progress
   ppm.increment();
end

% Delete the progress handle when the parfor loop is done (otherwise the timer that keeps updating the progress might not stop).
delete(ppm);
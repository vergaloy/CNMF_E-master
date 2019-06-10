%%function avi_filename = show_demixed_video(obj,save_avi, kt, frame_range, amp_ac, range_ac, range_Y, multi_factor)
%% save the final results of source extraction.
%% inputs:
%   kt:  scalar, the number of frames to be skipped
obj=neuron
kt=1
amp_ac = 5;
range_ac = [0, amp_ac];
multi_factor = 50;
range_Y = [0, amp_ac*multi_factor];
save_avi= false;
frame_range=[1 1000];
clear total totalraw
if ~exist('kt', 'var')||isempty(kt)
    kt = 1;
end
%% load data
if ~exist('frame_range', 'var')||isempty(frame_range)
    frame_range = obj.frame_range;
end
t_begin = frame_range(1);
t_end = frame_range(2);

tmp_range = [t_begin, min(t_begin+2000*kt-1, t_end)];
Y = obj.load_patch_data([], tmp_range);
Ybg = obj.reconstruct_background(tmp_range);
figure('position', [0,0, 600, 400]);

%%
if ~exist('amp_ac', 'var') || isempty(amp_ac)
    amp_ac = median(max(obj.A,[],1)'.*max(obj.C,[],2))*2;
end
if ~exist('range_ac', 'var') || isempty(range_ac)
    range_ac = amp_ac*[0.01, 1.01];
end
range_res = range_ac - mean(range_ac); 
if ~exist('range_Y', 'var') || isempty(range_Y)
    if ~exist('multi_factor', 'var') || isempty(multiple_factor)
        temp = quantile(double(Y(randi(numel(Y), 10000,1))), [0.01, 0.98]);
        multi_factor = ceil(diff(temp)/diff(range_ac));
    else
        temp = quantile(Y(randi(numel(Y), 10000,1)), 0.01);
    end
    center_Y = temp(1) + multi_factor*amp_ac;
    range_Y = center_Y + range_res*multi_factor;
end

if ~exist('multi_factor', 'var')
    multi_factor = round(diff(range_Y)/diff(range_ac)); 
    range_Y = (range_res-range_res(1)) * multi_factor +range_Y(1); 
end
%% create avi file
if save_avi
    avi_filename =[obj.P.log_folder, 'demixed.avi'];
    avi_file = VideoWriter(avi_filename);
    if ~isnan(obj.Fs)
        avi_file.FrameRate= obj.Fs/kt;
    end
    avi_file.open();
else
    avi_filename = [];
end

%% add pseudo color to denoised signals
[K, ~]=size(obj.C);
% draw random color for each neuron
% tmp = mod((1:K)', 6)+1;
Y_mixed = zeros(obj.options.d1*obj.options.d2, diff(tmp_range)+1, 3);
temp = prism;
% temp = bsxfun(@times, temp, 1./sum(temp,2));
col = temp(randi(64, K,1), :);
for m=1:3
    Y_mixed(:, :, m) = obj.A* (diag(col(:,m))*obj.C(:, tmp_range(1):tmp_range(2)));
end
Y_mixed = uint16(Y_mixed/(1*amp_ac)*250);
%% play and save
ax_y =   axes('position', [0.015, 0.51, 0.3, 0.42]);
ax_bg=   axes('position', [0.015, 0.01, 0.3, 0.42]);
ax_signal=    axes('position', [0.345, 0.51, 0.3, 0.42]);
ax_denoised =    axes('position', [0.345, 0.01, 0.3, 0.42]);
ax_res =    axes('position', [0.675, 0.51, 0.3, 0.42]);
ax_mix =     axes('position', [0.675, 0.01, 0.3, 0.42]);
tt0 = (t_begin-1);
i0=1;
for tt=t_begin:kt:t_end
    m = tt-tt0;
    
    
    
    rawtemp=Y(:, :,m);
    totalraw(:,:,i0)=rawtemp(:,:,1);
    

    


    
  
    imagen=obj.reshape(Y_mixed(:, m,:),2);
    total(:,:,i0)=imagen(:,:,1);

i0=i0+1;
    

    
    %% save more data
    if tt== tt0+kt*99+1
        tt0 = tt0+kt*100;
        % load data
        tmp_range = [tt0+1, min(tt0+100*kt, t_end)];
        if isempty(tmp_range) || diff(tmp_range)<1
            break;
        end
        Y = obj.load_patch_data([], tmp_range);
        
        Ybg = obj.reconstruct_background(tmp_range);
        
        %% add pseudo color to denoised signals
        [d1, d2, Tp]=size(Y);
        % draw random color for each neuron
        % tmp = mod((1:K)', 6)+1;
        Y_mixed = zeros(d1*d2, Tp, 3);
        tmp_C = obj.C(:, tt0+(1:Tp));
        temp = prism;
        col = temp(randi(64, K,1), :);
        for m=1:3
            Y_mixed(:, :, m) = obj.A* (diag(col(:,m))*tmp_C);
        end
        Y_mixed = uint16(Y_mixed/(1*amp_ac)*65536);
    end
end

totalraw=mat2gray(totalraw);
total=mat2gray(total);
background = imgaussfilt3(totalraw,10);
total=imgaussfilt3(total,2);
totalraw=totalraw-background;

final=mat2gray(totalraw+total*0.7);
final=final*256;
for k = 1 : size(final,3)
 final2(:,:,k)= kron(final(:,:,k), ones(3));  
end
final2=uint8(final2);

v = VideoWriter('newfile.mp4','MPEG-4');
colormap(gray(256))
v.FrameRate = 60;
open(v)

for k = 1:size(final2,3)
   frame = final2(:,:,k);
   writeVideo(v,frame);
end

close(v);





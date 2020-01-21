function show_demixed_video_PV(obj,tmp_range)
%avi_filename = show_demixed_video_PV(neuron,[1 1000]);
amp_ac=3;

Y = mat2gray(obj.load_patch_data([], tmp_range));
Ybg=Y-imgaussfilt(Y,25);
Ybg=mat2gray(Y-mean(Y,3));
mg_ac = mat2gray(obj.reshape(obj.A*obj.C(:, tmp_range(1):tmp_range(2)), 2));
t=[Y,Ybg,mg_ac*1.5];
implay(t);


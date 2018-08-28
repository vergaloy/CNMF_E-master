%% This code is to convert .adtich file into .txt
clear all


%User defined inputs 
%==================================
a=('C:\Users\SSG Lab\Desktop\adicht\') % files directory
separator=','; %choose separato e.g.  ' ' --> space  ';'--> ;  '.' --> .

%end of user defined inputs
%==================================

cd(a)
adi.convert(a)
files=dir('*.mat');
loopend=size(files);
loopend=loopend(1);

for loop=1:loopend   
b=files(loop).name;
c=strcat(a,b);
load(c)
%test=whos('data__chan_1*');
%[max_num,max_idx] = max(test(:));

vsize=size(data__chan_1_rec_1); %CHECK if this is correct!! in some files it might be _rec_2
fprintf(1, 'the size is %f\n',vsize)
vsize=vsize(1);
vtxt(1:vsize,1)=data__chan_1_rec_1(1:vsize);
vtxt(1:vsize,2)=data__chan_2_rec_1(1:vsize);
dlmwrite(strcat(b,'.txt'),vtxt,separator); 
clear vtxt
end

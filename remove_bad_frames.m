folder='C:\Users\SSG Lab\Desktop\motion corrected\batch4\'  %% check name!!!!!!
filename='20171116_101717.corrected.h5'
location=strcat(folder,filename);
vid=h5read(location,'/DS1');
fprintf(1, ' Video %s successfully loaded into memory\n',filename);

%%
fprintf(1, 'Creating filtered video\n');
vid=cast(vid,'int16');
artifact=zeros(1,size(vid,3));
m=zeros(1,size(vid,3));
badmovie=zeros(size(vid,1),size(vid,2),size(vid,3));
sample=zeros(size(vid,1),size(vid,2),size(vid,3));
parfor i=1:size(vid,3)
 sample(:,:,i)=vid(:,:,i)-imgaussfilt(vid(:,:,i),10); 
end       
 
fprintf(1, 'Filtered sampled video has been created\n');
fprintf(1, 'Detecting blurry frames\n');

f=1;
g=1;
%%
for i=2:size(vid,3)
    if (i>5000*f)
        f=f+1;
        fprintf(1, ' Calculating m: %.0f %% complete \n',i/size(vid,3)*100);
    end
    
    m(i)=mean2(sample(:,:,i));
end 
bleach=medfilt1(m,300);
bleach(1)=bleach(2);
m = m-bleach;
%%
for i=2:size(vid,3)
    if (i>5000*f)
        f=f+1;
        fprintf(1, ' removing artifacts: %.0f %% complete \n',i/size(vid,3)*100);
    end
    if (m(i)<-2.5)
        badmovie(:,:,g)= vid(:,:,i);
        g=g+1;
        vid(:,:,i)=vid(:,:,i-1);
        artifact(i)=1;
    end
end



vid=cast(vid,'uint16');
saveash5(vid, strcat(folder,'20180221_115108_artifact_corrected_final.h5'))


artifact=transpose(artifact);
dlmwrite(strcat(folder,'20180221_115108_artifact_final.txt'),artifacts,' ');
% BIN2DECIMAL Function convert binary string to decimal equivalent.
% This program also works for fractional binary numbers.
% Input: Binary string
% Output: Decimal equivalent of input Binary string
%
% NOTE: keep format as long for high floating point precision
% >>format long 
%
% A white space is assumed to be . (point)
% >>bin2decimal('10101')  returns 21
% >>bin2decimal('10.101') returns 2.625000000000000
% >>bin2decimal('10 101') returns 2.625000000000000
% >>bin2decimal('.10101') returns 0.656250000000000
% >>bin2decimal(' 10101') returns 0.656250000000000
% G. Ravi Teja (06-Oct-2011)
% Indian Institute of Technology Guwahati, India.
function DEC_VAL=bin2decimal(bin_num)
if ~ischar(bin_num) 
    error(message('MATLAB:bin2dec:InvalidInputClass')); 
end
if isempty(bin_num)
    DEC_VAL = []; 
    return, 
end
if size(bin_num,2)>52
    error(message('MATLAB:bin2dec:InputOutOfRange')); 
end
bin_num=bin_num-'0';
dec=0;
PNT=0;
%% Finding Decimal part
for i1=1:length(bin_num)
    if(bin_num(i1)<0)
        PNT=i1;
        break;
    end
    dec(i1)=bin_num(i1);    
end
D_DEC=sum(dec.*(2.^(length(dec)-1:-1:0)));
%% Finding Fractional part
D_FRACT=0;
fract=zeros(1,length(bin_num)-PNT);
if (PNT>0)
    for i2=PNT+1:length(bin_num)
     fract(i2-PNT)=bin_num(i2);
    end        
    D_FRACT=sum(fract.*(2.^-(1:length(fract))));
end
%% Retrun Decimal equivalent
DEC_VAL=D_DEC+D_FRACT;
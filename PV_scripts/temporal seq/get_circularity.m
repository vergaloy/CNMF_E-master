function [circ,P]=get_circularity(obj)
% [circ,P]=get_circularity(neuron);

obj.Coor=[];
 Coor = get_contours(obj, 0.8);
 
 for i=1:size(Coor,1)
  polyin = polyshape(Coor{i, 1}');  
  P(i) = perimeter(polyin);
  A(i) = area(polyin);
  circ(i) = P(i)^2/ (4 * pi* A(i));
 end
 circ=circ';
 P=P';
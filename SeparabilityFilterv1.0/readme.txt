This folder contains the source codes (Vers.1.0) for the following papers:

[1] Y. Ohkawa, C. H. Suryanto, K. Fukui, "Fast Combined Separability Filter for Detecting Circular Objects", The twelfth IAPR conference on Machine Vision Applications (MVA) pp.99-103, 2011.

[2] K. Fukui, O. Yamaguchi, "Facial feature point extraction method based on combination of shape extraction  and pattern matching", Systems and Computers in Japan 29 (6), pp.49-58, 1998.

Please cite the above papers if you use the codes.

A demonstration video can be found at https://youtu.be/NB6AZvOYxC0

The codes in this folder are distributed under BSD License.

Computer Vision Laboratory (CVLAB)
Graduate school of Systems and Information Engineering
University of Tsukuba
2016

Email: tsukuba.cvlab@gmail.com
HP: http://www.cvlab.cs.tsukuba.ac.jp/



Contents:
-----------------------------------
testimages/
contains test images:
testimages/cheek.jpg 
testimages/sample1.png
testimages/YaleSample.gif

cvtCirculeSepFilter.m:
A function to compute a separability map using circular separability filter.

cvtCombSimpRectFilter.m:
A function to compute two separability maps using vertical and horizontal filters.

cvtCombSimpRectFilter45.m:
A function to compute two separability maps using diagonal filters (left and right).

cvtFindLocalPeakX.m:
A function to find local peaks from a separability map.

cvtIntegralImage.m:
A function to generate an integral image.

cvtIntegralImage45.m:
A function to generate a 45 degrees rotated integral image. 

cvtDrawCircle.m:
A function to draw a circle.

cvtDrawCross.m:
A function to draw a cross shape.

sample1.m:
Sample code for detecting pupils and nostrils on a CG face image using the fast combined separability filter.

sample2.m:
Sample code for detecting pupils on a face image from Yale dataset using the fast combined separability filter.

sample3.m:
Sample code for detecting micro features on a face image using the fast combined separability filter.

sample4.m:
Sample code for detecting micro features on a face image using the original circular separability filter. Note that this code requres high computational cost comparing with the other codes.


# PPrep
Pippin Prep Analysis from Matlab

Can process Pippin Prep XML data files to plot traces, determine cut points, etc

Example usage:

p=PPrep('PX01807_PX01807_2016-05-02_12-40-15_20160502.txt');
p.verify();
p.plotall();

% AUTHOR: 
%  Brayan Espinoza 01/10/2020
% DESCRIPTION: 
%  This function computes the skew-symmetric matrix of a given vector.
%  The skew-symmetric matrix is often used in cross product calculations.
%  Note: This function is provided for compatibility with MATLAB 2017.
%
% INPUT:
%  vector - A 3-element vector [x, y, z].
%
% OUTPUT:
%  skewsim - The 3x3 skew-symmetric matrix of the input vector.

function [skewsim] = skew(vector)
    skewsim = [  0,        -vector(3),  vector(2);
              vector(3),     0,       -vector(1);
             -vector(2),  vector(1),      0];
end

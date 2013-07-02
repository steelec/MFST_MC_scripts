function out = gen13()
%function to generate all the possible sequences of 13 elements consisting
%of the numbers 1,2,3,4 and following the criteria: no trills, no repeats,
%use all fundamental transitions (12).
%
%Written by Roger Stafford at the request of Chris Steele
% Explanation:
% Since I have more patience today, I have worked out a recursive solution 
% to your problem which I include below.  It consists of a main program and 
% a recursive function with some globals floating around.  (My version is 
% the ancient 4a.)  I checked it with the earlier twelve-deep nested 
% for-loop method and their results are in complete agreement. 
% 
%   The truth is that both algorithms are very much alike.  They use the 
% notion that you expressed originally in seeking permutations among the 12 
% allowed pairs of successive numbers: [1,2], [1,3], [1,4], [2,1], [2,3], 
% [2,4], [3,1], [3,2], [3,4], [4,1], [4,2], and [4,3].  Call these pairs 
% p12, p13, p14, p21, p23, p24, p31, p32, p34, p41, p42, and p43 for short. 
% 
% 
%   Table T expresses the allowed succession of such pairs.  The rows and 
% columns of T are sequentially ordered in accordance with the above pair 
% ordering.  T(i,j) is equal to 1 if the i-th pair above can be followed by 
% the j-th pair above, and 0 elsewhere.  For example, T(1,4) and T(1,6) are 
% 1's and the rest of the T(1,:) row are 0's, corresponding to the fact that 
% p12 (the 1st pair) can only be followed by p21 and p24 (the 4th and 6th 
% pairs.)  (p23 is forbidden to follow by your "trill" constraint.) 
% 
% 
%   In a call to recursive routine, tetsuc(k,c,n), (pardon the use of your 
% name), the variable k is a row of indices of the successive pairs that 
% have so far been used and which cannot be used again.  For example, if k = 
% [5,7,2], that means pairs p23, p31, and p13 have been successively 
% selected up to that point.  Vector c is 12 elements long and consists of 
% 1's and 0's.  The 0's indicate the corresponding pair has been selected 
% and 1's mean it is yet to be used.  The above example would have c = 
% [1,0,1,1,0,1,0,1,1,1,1,1].  (I could have computed c from k instead of 
% passing it as an argument.)  Vector n contains the indices of the pair or 
% pairs that are eligible to be selected next among those that remain 
% unselected and are allowed by T from the last selection.  In the above 
% case we would have n = [8,9], since only p31, p32, and p34 are allowed to 
% follow p13 but p31 has already been used, so only p32 and p34 remain 
% possible next. 
% 
% 
%   The recursive routine tries each possible pair whose index, i, is listed 
% in the n it receives using a for loop, and in each case calculates a new 
% ki, ci, and ni to pass along recursively to itself at the next deeper 
% step.  Note that if tetsuc receives an empty n, it immediately returns to 
% its caller above without any calls to a greater depth, which saves a great 
% amount of wasted processing time. 
% 
% 
%   Only when all 12 pairs have been successfully selected does it enter the 
% results into the global D.  As it turns out, this happens only 496 times. 
% Globals B and E assist in this task by being lists of the first and second 
% elements, respectively, of the pair sequence given by k. 




global D M T B E 
D = zeros(1,13); 
M = 0; 
T = [ ... 
     0  0  0  1  0  1  0  0  0  0  0  0; ... 
     0  0  0  0  0  0  1  1  1  0  0  0; ... 
     0  0  0  0  0  0  0  0  0  1  1  1; ... 
     1  1  1  0  0  0  0  0  0  0  0  0; ... 
     0  0  0  0  0  0  1  1  0  0  0  0; ... 
     0  0  0  0  0  0  0  0  0  1  1  1; ... 
     1  1  1  0  0  0  0  0  0  0  0  0; ... 
     0  0  0  0  1  1  0  0  0  0  0  0; ... 
     0  0  0  0  0  0  0  0  0  1  1  1; ... 
     1  1  1  0  0  0  0  0  0  0  0  0; ... 
     0  0  0  1  1  1  0  0  0  0  0  0; ... 
     0  0  0  0  0  0  1  0  1  0  0  0]; 
B = [1 1 1 2 2 2 3 3 3 4 4 4]; 
E = [2 3 4 1 3 4 1 2 4 1 2 3]; 
k = []; 
n = 1:12; 
c = ones(1,12); 
tetsuc(k,c,n); 
out = D;
% ------------------------------------------ 
function tetsuc(k,c,n) 
global D M T B E 
if length(k) < 12 
 for i = n 
  ni = find(T(i,:) & c); 
  ci = c; ci(i) = 0; 
  ki = [k,i]; 
  tetsuc(ki,ci,ni); 
 end 
else 
 M = M + 1; 
 D(M,:) = [B(k),E(k(12))]; 
end 

% ------------------------------------------ 
% The first non-recursive pass by Roger Stafford
% T = [ ... 
%      0  0  0  1  0  1  0  0  0  0  0  0; ... 
%      0  0  0  0  0  0  1  1  1  0  0  0; ... 
%      0  0  0  0  0  0  0  0  0  1  1  1; ... 
%      1  1  1  0  0  0  0  0  0  0  0  0; ... 
%      0  0  0  0  0  0  1  1  0  0  0  0; ... 
%      0  0  0  0  0  0  0  0  0  1  1  1; ... 
%      1  1  1  0  0  0  0  0  0  0  0  0; ... 
%      0  0  0  0  1  1  0  0  0  0  0  0; ... 
%      0  0  0  0  0  0  0  0  0  1  1  1; ... 
%      1  1  1  0  0  0  0  0  0  0  0  0; ... 
%      0  0  0  1  1  1  0  0  0  0  0  0; ... 
%      0  0  0  0  0  0  1  0  1  0  0  0]; 
% b = [1 1 1 2 2 2 3 3 3 4 4 4]; 
% e = [2 3 4 1 3 4 1 2 4 1 2 3]; 
% D = zeros(496,13); % The 496 added after after the fact 
% k = 0; 
% n1 = 1:12; 
% c1 = ones(1,12); 
% for  k1 = n1 
%  n2 =  find(T( k1,:)); 
%  c2  =  c1;  c2( k1) = 0; 
% for  k2 = n2 
%  n3 =  find(T( k2,:) & c2); 
%  c3  =  c2;  c3( k2) = 0; 
% for  k3 = n3 
%  n4 =  find(T( k3,:) & c3); 
%  c4  =  c3;  c4( k3) = 0; 
% for  k4 = n4 
%  n5 =  find(T( k4,:) & c4); 
%  c5  =  c4;  c5( k4) = 0; 
% for  k5 = n5 
%  n6 =  find(T( k5,:) & c5); 
%  c6  =  c5;  c6( k5) = 0; 
% for  k6 = n6 
%  n7 =  find(T( k6,:) & c6); 
%  c7  =  c6;  c7( k6) = 0; 
% for  k7 = n7 
%  n8 =  find(T( k7,:) & c7); 
%  c8  =  c7;  c8( k7) = 0; 
% for  k8 = n8 
%  n9 =  find(T( k8,:) & c8); 
%  c9  =  c8;  c9( k8) = 0; 
% for  k9 = n9 
%  n10 = find(T( k9,:) & c9); 
%  c10 =  c9; c10( k9) = 0; 
% for k10 = n10 
%  n11 = find(T(k10,:) & c10); 
%  c11 = c10; c11(k10) = 0; 
% for k11 = n11 
%  n12 = find(T(k11,:) & c11); 
%  c12 = c11; c12(k11) = 0; 
% for k12 = n12 
%  k = k + 1; 
%  D(k,:) = [b([k1 k2 k3 k4 k5 k6 k7 k8 k9 k10 k11 k12]),e(k12)]; 
%  fprintf('%d %d %d %d %d %d %d %d %d %d %d %d %d\n',D(k,:)) 
% end,end,end,end,end,end 
% end,end,end,end,end,end 

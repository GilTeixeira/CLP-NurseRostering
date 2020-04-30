% length_list(+N, -List)
% Creates List of size N
length_(Length, List) :- length(List, Length).


% gen_matrix(+N, +Len, -List)
% Generates Matrix of Size (N x Len), Create N lists of Length Len
gen_matrix(N, Len, List) :- length(List, N), maplist(length_(Len), List).

v1= {'a','b','c';'1','2','3';'alpha','beta','gamma'}.';
v2= {'c','d','e';'3','4','5';'gamma','delta','eta'}.';
[u]=unionrows_cellstr_v2(v1, v2)



v1= {'alpha','beta','gamma'}.';
v2= {'gamma','delta','eta'}.';
[U, Iv1, Iv2] = union(v1,v2)

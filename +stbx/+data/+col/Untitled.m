% ooo = cumsum(cumsum(cumsum(ones(3,4,5), 1),2),3);
% ooo = randi(100, [3,4,5])
% ooo_ = permute(ooo, [ndims(ooo), 1:ndims(ooo)-1]);
% reshape(ooo_, size(ooo_,1), [])




DATA = repmat({[1,2,3].',{{1,2,3},{'a','b','c'},{'one','two','three'}}.'}.', [100,1]); 
TYPE = repmat([stbx.data.col.COLTYPE.NUM,stbx.data.col.COLTYPE.ANY].',[100,1]); 

ddd = stbx.data.col.column(DATA,TYPE)



return
ccc = stbx.data.col.cell2col(DATA,TYPE);
% ccc = stbx.data.col.cell2col(DATA);

numcols = stbx.data.col.column({magic(5),magic(5)})
anycols = stbx.data.col.col_any({num2cell(magic(5),2)})

[anycols, numcols]
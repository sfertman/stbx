clear all

myMap = stbx.data.aliasmap({'abc','doremi'}, {123, 456});
myMap.alias({'abc'}, {{'aaa','bbb'}});
myMap.alias({'abc'}, {{'hello','world'}});
myMap.alias({'doremi'}, {{'hello_sir','have_a_nice_world'}});


% myMap.keyAliasMap

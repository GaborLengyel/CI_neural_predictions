function y=betaprrnd(alp,bet,sz)
y=betarnd(alp,bet,sz);
y=y./(1-y);
end
function y=betaprinv(x,alp,bet)
y=betainv(x,alp,bet);
y=y./(1-y);
end
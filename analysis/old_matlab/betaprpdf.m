function y=betaprpdf(x,alp,bet)
y=(x.^(alp-1)).*((1+x).^(-alp-bet))./beta(alp,bet);
end
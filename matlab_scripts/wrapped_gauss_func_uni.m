function z = wrapped_gauss_func_uni(q, x)
    %z = q(1)*exp(-2*(1-cos((px - q(2))))/q(3).^2) + q(4);
    z = q(1) * exp(q(3) * cosd(x - q(2))) + q(4);
end
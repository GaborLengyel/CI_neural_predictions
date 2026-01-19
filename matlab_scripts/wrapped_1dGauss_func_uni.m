function z = wrapped_1dGauss_func_uni(q, D)
    z = q(1) * exp(q(3) * cosd(D - q(2))) + q(4);
end
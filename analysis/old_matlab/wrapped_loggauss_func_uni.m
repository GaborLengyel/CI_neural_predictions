function z = wrapped_loggauss_func_uni(q, x)
    z = q(1) .* exp(-((log(x) - q(2)).^2) ./ (2*q(3))) + q(4);
end
function s = logsumexp_signed(a, dim,signs)
% Returns log(sum(signs*exp(a),dim)) while avoiding numerical underflow.


if nargin < 2
  dim = 1;
end

if any(size(a)~=size(signs))
    warning('dimensions of signs and matrix dont match');
end

% subtract the largest in each column
y = max(a,[],dim);
dims = ones(1,ndims(a));
dims(dim) = size(a,dim);
a = a - repmat(y, dims);
s = y + log(sum(signs.*exp(a),dim));
i = find(~isfinite(y));
if ~isempty(i)
  s(i) = y(i);
end


end
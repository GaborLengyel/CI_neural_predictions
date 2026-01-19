function theta=get_full_params(samps,model)
theta = zeros(size(samps,1), model.num_params);

theta(:,model.set_default) = repmat(model.default_values,size(samps,1),1);
theta(:,setdiff([1:model.num_params], model.set_default)) = samps;
end
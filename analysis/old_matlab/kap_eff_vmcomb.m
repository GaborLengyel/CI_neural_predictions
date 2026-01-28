function log_kap_s=kap_eff_vmcomb(log_kap1,log_kap2,cosdiff)
% kap_s=sqrt(motor_noise.^2+pred_resp_kap.^2+2*motor_noise*pred_resp_kap.*cosdiff);



if numel(log_kap1)==1 &&numel(log_kap2)>1
    log_kap1=log_kap1*ones(size(log_kap2));
elseif numel(log_kap2)==1 &&numel(log_kap1)>1
    log_kap2=log_kap2*ones(size(log_kap1));
end


sz=size(log_kap1);
log_kap1=log_kap1(:);
log_kap2=log_kap2(:);
cosdiff=cosdiff(:);


log_kap_s=nan(size(log_kap1));
rs=log_kap1-log_kap2;
id=rs<-6;
if any(id)
log_kap_s(id)=log_kap2(id);%+0.5*logsumexp_signed([zeros(sum(id),1),2*rs(id),log(2)+rs(id)+log(abs(cosdiff(id)))],2,[ones(sum(id),2),sign(cosdiff(id))]);
end
id=rs>6;
if any(id)
log_kap_s(id)=log_kap1(id);%+0.5*logsumexp_signed([zeros(sum(id),1),-2*rs(id),log(2)-rs(id)+log(abs(cosdiff(id)))],2,[ones(sum(id),2),sign(cosdiff(id))]);
end
id=(rs>=-6) & (rs<=6);
if any(id)
ktmp=[];
sn_ktmp=[];
ktmp(:,1)=2*log_kap1(id);
ktmp(:,2)=2*log_kap2(id);
ktmp(:,3)=log(2)+log_kap1(id)+log_kap2(id)+log(abs(cosdiff(id)));
sn_ktmp(:,1)=ones(size(log_kap1(id)));
sn_ktmp(:,2)=ones(size(log_kap1(id)));
sn_ktmp(:,3)=sign(cosdiff(id));
log_kap_s(id)=(0.5*logsumexp_signed(ktmp,2,sn_ktmp));
end

log_kap_s=reshape(log_kap_s,sz);


end
[masters]
%{ for ip in masters ~}
${ip} ansible_user=admin
%{ endfor ~}

[workers]
%{ for ip in workers ~}
${ip} ansible_user=admin
%{ endfor ~}

[masters:vars]
master_nlb=${master-lb}:6443
cluster_name=${cluster}

[workers:vars]
master_nlb=${master-lb}:6443
cluster_name=${cluster}
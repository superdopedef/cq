[masters]
%{ for ip in masters ~}
${ip} ansible_user=admin ansible_python_interpreter=/usr/bin/python3
%{ endfor ~}

[workers]
%{ for ip in workers ~}
${ip} ansible_user=admin ansible_python_interpreter=/usr/bin/python3
%{ endfor ~}

[masters:vars]
master_nlb=${master-lb}:6443
cluster_name=${cluster}
domain_name=${domain_name}
ingress_class=${ingress_class}
grafana_password=${grafana_password}

[workers:vars]
master_nlb=${master-lb}:6443
cluster_name=${cluster}
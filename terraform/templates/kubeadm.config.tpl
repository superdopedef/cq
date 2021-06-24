---
apiVersion: kubeadm.k8s.io/v1beta2
kind: ClusterConfiguration
apiServer:
  extraArgs:
    cloud-provider: aws
clusterName: ${cluster}
controlPlaneEndpoint: "${master-lb}:6443"
controllerManager:
  extraArgs:
    bind-address: 0.0.0.0
    cloud-provider: aws
    configure-cloud-routes: "false"
kubernetesVersion: stable
networking:
  podSubnet: 10.244.0.0/16
scheduler:
  extraArgs:
    bind-address: 0.0.0.0
---
apiVersion: kubeadm.k8s.io/v1beta2
kind: InitConfiguration
nodeRegistration:
  kubeletExtraArgs:
    cloud-provider: aws
---
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
cgroupDriver: systemd

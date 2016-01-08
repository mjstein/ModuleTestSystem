yum install -y docker docker-registry etcd kubernetes flannel || 0
for SERVICES in docker.service docker-registry etcd kube-apiserver kube-controller-manager kube-scheduler flanneld
do systemctl start $SERVICES
done
echo INSECURE_REGISTRY='--insecure-registry master.kubernetes.com:5000' > /etc/sysconfig/docker
#vi /etc/kubernetes/apiserver
echo -e KUBE_API_ADDRESS="--address=0.0.0.0"\\n KUBE_API_PORT="--port=8080"\\n KUBE_ETCD_SERVERS="--etcd_servers=http://master.kubernetes.com:4001" > /etc/kubernetes/apiserver
echo KUBE_MASTER="--master=http://master.kubernetes.com:8080" > /etc/kubernetes/config
echo KUBELET_ADDRESSES="--machines=minion.kubernetes.com" > /etc/kubernetes/controller-manager
echo -e ETCD_LISTEN_PEER_URLS="http://localhost:2380,http://localhost:7001"\\nETCD_LISTEN_CLIENT_URLS="http://0.0.0.0:4001,http://0.0.0.0:2379" >/etc/etcd/etcd.conf
systemctl restart etcd
#vi /etc/sysconfig/flanneld
echo -e FLANNEL_ETCD="http://master.kubernetes.com:4001"\\nFLANNEL_ETCD_KEY="/flannel/network"\\nFLANNEL_OPTIONS="eth0" > /etc/sysconfig/flanneld
#vi /root/flannel-config.json
echo -e {\\n   \"Network\": \"10.100.0.0/16\",\\n   \"SubnetLen\": 24,\\n   \"SubnetMin\": \"10.100.50.0\",\\n   \"SubnetMax\": \"10.100.199.0\",\\n   \"Backend\": {\\n   \"Type\": \"vxlan\",\\n   \"VNI\": 1\\n   }\\n} > /root/flannel-config.json
curl -L http://master.kubernetes.com:4001/v2/keys/flannel/network/config -XPUT --data-urlencode value@/root/flannel-config.json
systemctl start docker docker-registry
for IMAGE in rhel6 rhel7  kubernetes/kube2sky:1.1 kubernetes/pause:go
do docker pull $IMAGE
  docker tag $IMAGE master.kubernetes.com:5000/$IMAGE
  docker push master.kubernetes.com:5000/$IMAGES
done
echo INSECURE_REGISTRY='--insecure-registry kube-master.lab.com:5000' > /etc/sysconfig/docker

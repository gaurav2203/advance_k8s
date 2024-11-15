wget https://github.com/istio/istio/releases/download/1.24.0/istio-1.24.0-linux-amd64.tar.gz
tar -xvzf istio-1.24.0-linux-amd64.tar.gz
cd istio-1.24.0
cp ./bin/istioctl /usr/bin
istioctl install
kubectl  apply -f ./samples/addons/


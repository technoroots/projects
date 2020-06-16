<h1> Helm Charts </h1>

<a name="k8s"/>
<h4> # 1. K8S </h4>

Helm Charts directory to deploy different applications on kubernetes cluster

<a name="maintainer"/>
<h4> # 2. Maintainer </h4>

- @mankuuuuu  - <myan2007@gmail.com>

<a name="content"/>
<h4> # 3. Table of contents </h4>

- [1. K8S](#k8s)
- [2. Maintainers](#maintainer)
- [3. Table of contents](#content)
- [4. Prerequisites](#prerequisites)
- [5. Deploy](#deploy)

<a name="prerequisites"/>
<h4> # 4. Prerequisites </h4>

1. Helm 3
2. Kubectl
3. awscli

<h3>mongodb-replicaset</h3>

- Generate keyfilesecret 

```bash
$ openssl rand -base64 756 > key.txt
$ chmod 0400 key.txt
$ kubectl create secret generic keyfilesecret --from-file=key.txt
$ rm -f key.txt
```

- Generate username and password for mongo

```bash
# Username
$ echo -n 'admin' | base64

# Password
$ echo -n 'admin' | base64

# add above command outputs in secrets.yaml and add secret
$ kubectl create -f secret.yaml
```

<h3>nodeapp</h3>

- Need to add docker pull image secret
  kubectl create secret docker-registry regsecret --docker-server=$DOCKER_REGISTRY_RUL --docker-username=$USERNAME --docker-password=$PASSWORD --docker-email=$EMAIL
  
- ENV variables has been added for mongodb and in charts also

```
const {
  MONGO_USERNAME,
  MONGO_PASSWORD,
  MONGO_HOSTNAME,
  MONGO_PORT,
  MONGO_DB,
  MONGO_REPLICASET
} = process.env;

```
Please update the port values according to the node.js application listening port.

<h3>traefik</h3>

- By default host based routing is disabled
- Endpoint addition
- Traefik will get deployed in kube-system namespace

```bash
# Edit endpoints.yaml file to add multiple application endpoints
# If application is in another namespace, please specify namespace in the endpoints.yaml
kubectl apply -f endpoints.yaml
```


<a name="deploy"/>
<h4> # 5. Deploy </h4>

Configure your AWS credentials
- Generate your AWS access keys from the console based on the environment if you have multiple AWS account

```bash
# Enter your access key and secret
$ aws configure

# Generate .kubeconfig file
$ aws eks --region region update-kubeconfig --name <cluster_name>

# Verify
$ kubectl get pods --all-namespaces
```

Deploy helm charts
```bash
# Edit values.yaml

# Install chart
$ helm install <name> k8s/nodeapp --namespace <namespace>
```

<h1>Solution</h1>
  <p>
    API to get configuration details based on mongodb
  </p>
</div>

<p align="center">
    <img src="https://img.shields.io/pypi/pyversions/3?sanitize=true">
</p>


## Table of Contents

1. [Prerequisites](#Prerequisites)
2. [Install](#install)
3. [Introduction](#introduction)
4. [Concepts](#concepts)
5. [Bugs/Improvements](#Bugs/Improvements)


<h2 align="center">Prerequisites</h2>

At the bare minimum you'll need the following for your environment:

1. Ubuntu:16.04 >

2. [get-pip](https://bootstrap.pypa.io/get-pip.py)
``` bash
python3 get-pip.py
```

3. Install virtualenv
```bash
pip3 install virtualenv
```
4. Install docker-ce

https://docs.docker.com/install/linux/docker-ce/ubuntu/

5. Install kubectl:

https://kubernetes.io/docs/tasks/tools/install-kubectl/

6. Install minikube:

https://kubernetes.io/docs/tasks/tools/install-minikube/

** Please stop any service which is listening on port 80 before moving ahead **
 
<h2 align="center">Install</h2>

Start your minikube cluster:

```bash
sudo minikube start --vm-drive=none (if your doing this on your local system)
```

Enable your ingress controller

```bash
sudo minikube addons enable ingress
```
Clone the repo:

```bash
git clone git@github.com:hellofreshdevtests/MANKUUUUU-DEVOPS-TEST.git
```

Run
```bash
bash go.sh
```

## Please check all pods are up before running test cases and loading the data ##

Run test cases (Will run unittest cases when you run go.sh if you manually want to run it)
```bash
POD=$(kubectl get pod -l app=sample-app -o jsonpath="{.items[0].metadata.name}")
sudo kubectl exec -it $POD python test.py
```

Load Test data
```bash
bash load_test_data.sh
```

<h2 align="center">Introduction</h2>

This will start a python flask application in the local kubernetes cluster which is interactiong with mongodb to store, fetch, update, delete configurations.

**TL;DR**

* Deployment strategy is used for flask application to scale and deploy in a zero downtime manner.
* Alpine python image has been used to build containers with minimal os size and libraries.
* Replication controller has been used for mongodb to scale load.
* Divisionl structure has been used in the flask application so that work has been divided on the basis of URL in the team.
* Logs can be found in the sample-app container flask.log or kubectl logs <pod name> (no log shipping mechanism/local mount not working in case vm-driver=none)


Below are the details about the files:

| File/Directory   | Description
| ---    | ---         
| `app` | Directory contains all application code       
| `config.py` | Configuration variables for different environments      
| `app/database.py` | Database configuration and methods      
| `configs/views.py` | /configs url methods 
| `search/views.py` | /search url methods  
| `run.py` | flask initialization file       
| `.env` | set env variables for (Flask server port, env, etc.)

<h2 align="center">Bugs/Improvements</h2>

- PUT requests are little bit buggy it is just deleting the record and inerting the new record
- Please run go.sh from cloned directory only
- If you are running go.sh again then already created resource will through error but it will work
- Last unittest case will fail because it was done intentionally to check if it is failing for /search

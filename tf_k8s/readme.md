![Docker Image CI](https://github.com/mankuuuuu/travis/workflows/Docker%20Image%20CI/badge.svg?branch=master)

Directory Structure
================

Motivations
-----------

- Reusability
- Modularity

Directories description:


```
.
├── app.js
├── config
├── k8s
│   ├── mongodb-replicaset
│   ├── nodeapp
│   └── traefik
├── readme.md
└── terraform
    ├── dev
    └── module_terraform
├── Dockerfile
├── helpers
├── LICENSE
├── models
├── package.json
├── public
├── readme.md
├── routes
├── views
└── yarn.lock
```

- Directory `devops` container terraform code and helm charts to easily deploy your infrastructure on AWS and helm charts to deploy application to the EKS cluster.
- Files and directories other than `devops` directory are used for building your node.js application

<h3> How to build application ?</h3>

```
1. Clone this repository
2. Make your changes in the application code
3. Test your changes
4. Push your code to a branch
5. Raise pull request with successfull test cases and build output
```

<h2> Build Process </h2>
Github actions will trigger build on every push to the master with added tag and timestamp which will be pushed to docker registry.

<h3> How to build Infrastructure on AWS using terraform ? </h3>
 Please switch to devops directory for further instructions
 
<h3> How to deploy your application using helm charts ? </h3>
 Please switch to devops directory for further instructions

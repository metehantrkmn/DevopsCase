# 2048 Deployment Case Study

First, the 2048 game was cloned locally using Git. Upon reviewing the game's code, it was observed that it was written in JavaScript, HTML, and CSS, so it was containerized using **nginx:alpine** without requiring any library installations. It was then tested in a browser to check if it was functioning correctly. Once the application was confirmed to work, it was deployed and tested in a Kubernetes environment using the necessary Deployment, Service, and Ingress resources. Initially, an attempt was made to access it locally using a LoadBalancer resource with **ClusterIP** and **MetalLB**, but this was unsuccessful. Consequently, the deployment proceeded with an **Ingress Controller**.

To access the game via the browser, the following commands should be executed in order:

- docker build -t 2048:v1.0 .
- cd kubernetes
- kind create cluster --config prod-cluster-conf.yaml
- kind load docker-image 2048:v1.0
- kubectl apply -f deploymnet.yaml
- kubectl apply -f [https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml](https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml)
- kubectl apply -f ingress.yaml

Access from browser using localhost/

![localhost/](2048%20Deployment%20Case%20Study%2017f6d1db3b1880b2928ad6cd2942c1ca/Screenshot_2025-01-19_at_17.20.56.png)

localhost/

To create an environment where development teams can work in an organized and collaborative manner, efforts were made to automate the deployment process. In this context, clusters named **dev**, **test**, and **production** were planned to be created to provide teams with independent environments where they could conduct development, testing, and deployment processes incrementally. Although various isolation levels such as **namespaces** or **worker nodes** were considered, it was decided to use separate **clusters** for each environment, especially taking into account the isolation and resources required for production environments.

For **push** operations to the **dev** and **test** branches, deployments were planned to be executed directly in their respective environments. Additionally, the product would be moved between environments for branch merges.

To implement the approach described above, **GitHub Actions** and **Jenkins** were used separately. However, due to some issues encountered with both solutions, a complete implementation could not be achieved. A locally created cluster was made accessible over the web using **ngrok** which is a tool that allows you to expose a local server or application to the internet securely via a publicly accessible URL. A workflow was created using **GitHub Actions**, but during the flow, communication with the Kubernetes control plane failed due to improper authentication, causing the flow to stop at the deployment stage.

To address this issue, the /.kube/config file was added as a secret in GitHub, and various configurations were tested. However, no successful results were obtained.

![Build and push succesfuly completed but deploy fails due to authentication problems](2048%20Deployment%20Case%20Study%2017f6d1db3b1880b2928ad6cd2942c1ca/Screenshot_2025-01-19_at_18.10.01.png)

Build and push succesfuly completed but deploy fails due to authentication problems

![secrets added to repository](2048%20Deployment%20Case%20Study%2017f6d1db3b1880b2928ad6cd2942c1ca/Screenshot_2025-01-19_at_18.11.46.png)

secrets added to repository

Using **Jenkins**, a method was tested where deployment could be triggered locally, both directly and by deploying Jenkins within the Kubernetes cluster. However, in the scenario where Jenkins was deployed on Kubernetes, a **"docker not found"** error occurred. To resolve this issue, a custom image was created with Docker installed in the Jenkins environment. However, due to an error encountered during the image build process, this approach was abandoned.

In the scenario where Jenkins was used locally, the process failed at the deployment stage due to unsuccessful authentication, similar to the issue encountered with GitHub Actions.

![Screenshot 2025-01-19 at 18.13.57.png](2048%20Deployment%20Case%20Study%2017f6d1db3b1880b2928ad6cd2942c1ca/Screenshot_2025-01-19_at_18.13.57.png)
![Screenshot 2025-01-19 at 19.16.18.png](https://github.com/metehantrkmn/DevopsCase/blob/e8c40ce2ed3399f57ea17fcfef66747ab144e5c9/2048%20Deployment%20Case%20Study%2017f6d1db3b1880b2928ad6cd2942c1ca/Screenshot%202025-01-19%20at%2019.16.18.png)




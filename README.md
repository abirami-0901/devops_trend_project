# Trend – Production Deployment (Docker, Terraform, EKS, Jenkins)

Deployment of the Trendify React app (prebuilt `dist/`) served by Nginx on port 3000.

## Architecture
GitHub push -> webhook -> Jenkins (EC2) -> docker build -> DockerHub -> kubectl -> EKS -> LoadBalancer

## Setup
1. **Local Docker test**
   `docker build -t trend-app . && docker run -p 3000:3000 trend-app` -> http://localhost:3000
2. **DockerHub**: create a public repo `trend-app`.
3. **Infrastructure**
   `cd terraform && terraform init && terraform apply -var my_ip_cidr=<ip>/32 -var key_name=<keypair>`
4. **Jenkins**: open the `jenkins_url` output, unlock with
   `sudo cat /var/lib/jenkins/secrets/initialAdminPassword`, install plugins
   (Docker Pipeline, Git, GitHub, Kubernetes CLI, Pipeline), add credential `dockerhub-creds`.
5. **Pipeline job**: Pipeline from SCM -> this repo -> `Jenkinsfile`; enable "GitHub hook trigger".
6. **Webhook**: GitHub repo -> Settings -> Webhooks -> `http://<jenkins-ip>:8080/github-webhook/` (push events).
7. **Monitoring**: `./monitoring/install.sh` (Prometheus + Grafana).
8. **Get the Load Balancer**: `kubectl get svc trend-service`

## Screenshots
Add to `screenshots/`: local app, DockerHub repo, terraform apply, EKS nodes, Jenkins pipeline run,
webhook delivery, `kubectl get pods,svc`, app via LB, Grafana dashboard.

## Load Balancer ARN
`aws elbv2 describe-load-balancers` (Classic ELB: use `aws elb describe-load-balancers`; see note below).


<h1 align="center">FORTSTAK-TODO-LIST-DEVOPS-ASSESSMENT</h1>

<p align="center"><i>Transforming Tasks into Seamless Success Stories</i></p>

<p align="center">
  <img src="https://img.shields.io/badge/last%20commit-today-blue?style=flat-square" />
  <img src="https://img.shields.io/badge/ejs-71.6%25-lightgrey?style=flat-square" />
  <img src="https://img.shields.io/badge/languages-4-blue?style=flat-square" />
</p>

<p align="center"><i>Built with the tools and technologies:</i></p>

<p align="center">
  <img src="https://img.shields.io/badge/Express-black?logo=express&style=flat-square&logoColor=white" />
  <img src="https://img.shields.io/badge/JSON-black?logo=json&style=flat-square" />
  <img src="https://img.shields.io/badge/Markdown-black?logo=markdown&style=flat-square" />
  <img src="https://img.shields.io/badge/npm-red?logo=npm&style=flat-square&logoColor=white" />
  <img src="https://img.shields.io/badge/Mongoose-red?logo=mongoose&style=flat-square&logoColor=white" />
  <img src="https://img.shields.io/badge/.ENV-yellow?style=flat-square" />
  <img src="https://img.shields.io/badge/JavaScript-yellow?logo=javascript&style=flat-square&logoColor=black" />
  <br />
  <img src="https://img.shields.io/badge/EJS-green?style=flat-square" />
  <img src="https://img.shields.io/badge/Nodemon-green?style=flat-square" />
  <img src="https://img.shields.io/badge/Watchtower-lightblue?style=flat-square" />
  <img src="https://img.shields.io/badge/Docker-blue?logo=docker&style=flat-square&logoColor=white" />
  <img src="https://img.shields.io/badge/GitHub%20Actions-blue?logo=githubactions&style=flat-square&logoColor=white" />
  <img src="https://img.shields.io/badge/YAML-red?style=flat-square&logo=yaml" />
</p>


This repository contains the implementation of a DevOps project for the **Fortstak Internship Assessment**, deploying a Todo-List application across a multi-node environment. The project covers:

- CI/CD with GitHub Actions
- Infrastructure automation with Ansible
- Application deployment with Docker Compose
- Kubernetes orchestration with k3s
- GitOps using ArgoCD

---

## 🗂️ Project Overview

| Item                  | Details                                  |
|-----------------------|------------------------------------------|
| **Control Node**      | `ubuntu-master-node` (192.168.44.149)    |
| **Worker Nodes**      | `ubuntu-worker-node-1` (192.168.44.147) <br> `ubuntu-worker-node-2` (192.168.44.148) |
| **App Image**         | `marmohamed/fortstak-todo-list-devops-assessment:latest` |
| **Database**          | MongoDB Atlas (connected via `MONGO_DB_URL`) |
| **Registry**          | [DockerHub](https://hub.docker.com/u/0marmohamed) |

---

## 📁 Project Structure

```

fortstak-todo-list-devops-assessment/
├── .github/
│   └── workflows/
│       └── ci-cd.yml
├── ansible/
│   └── deploy-docker.yml
├── inventory.ini
├── ubuntu-worker-node-1/
│   └── fortstak-todo-list/
│       ├── docker-compose.yml
│       └── .env
├── k8s-manifests/
│   ├── deployment.yml
│   ├── service.yml
│   ├── secret.yml
│   └── argocd-app.yml
├── screenshots/
│   ├── ci-cd-pipeline-run.png
│   ├── ansible-execution.png
│   ├── docker-compose-up.png
│   ├── app-access.png
│   ├── k3s-nodes.png
│   └── argocd-ui.png
└── README.md

```

> `.env` contains sensitive variables and is **excluded via `.gitignore`**.

---

## Part 1: CI/CD Pipeline

### 🔧 Setup
- GitHub Actions triggered on push to `main`.
- Docker image built and pushed to DockerHub.
- Secrets (`DOCKER_USERNAME`, `DOCKER_PASSWORD`) stored securely.

### Verification
- [x] Docker image: `0marmohamed/fortstak-todo-list-devops-assessment:latest`
- **Screenshot**: ![CI Pipeline](screenshots/ci-cd-pipeline-run.png)

---

## Part 2: Ansible Configuration

### Setup
- SSH keys configured manually (`~/.ssh/ansible_key`).
- Ansible installed on control node and local WSL.
- `deploy-docker.yml` used to install Docker + compose plugin.

### Best Practices
- Strict permissions: 600 for private keys.
- Password auth disabled, SSH via key only.
- Idempotent tasks (`state: present`).

### Verification
- Docker v28.3.3 installed
- `omar` in `docker` group
- 📸 **Screenshot**: ![Ansible Output](screenshots/ansible-execution.png)

---

## Part 3: Docker Compose Deployment

### Setup
- Deployed on: `ubuntu-worker-node-1 (192.168.44.147)`
- Services: `todo-app` & `watchtower`
- Env variables (in `.env`): `MONGO_DB_URL`

### Verification
- App running at: http://192.168.44.147:5000
- Watchtower scheduled at 4:00 AM
- **Screenshot**: 
  - ![Compose](screenshots/docker-compose-up.png)
  - ![App Access](screenshots/app-access.png)

---

## Part 4 (Bonus): Kubernetes & ArgoCD

### 🔧 Setup
- Cluster: k3s on worker-node-1 (master), joined by worker-node-2
- Deployed using:
  - `deployment.yml` (app)
  - `service.yml` (NodePort)
  - `secret.yml` (MongoDB URI)
- ArgoCD manages deployments via GitOps.

### ArgoCD Automation
- Syncs from: `k8s-manifests/` path in this repo
- Auto sync, prune, and self-heal enabled

### Verification
- `kubectl get nodes` shows both nodes
- App accessible at exposed NodePort
- ArgoCD UI at: https://192.168.44.147:30443
- **Screenshots**:
  - ![K3s Nodes](screenshots/k3s-nodes.png)
  - ![ArgoCD UI](screenshots/argocd-ui.png)

---

## Troubleshooting

| Issue                       | Fix/Explanation                                      |
|----------------------------|------------------------------------------------------|
| SSH Permission Denied      | Regenerated and copied SSH key manually              |
| Docker Compose missing     | Installed plugin manually with `apt`                |
| MongoDB Connection         | Whitelisted public IP in MongoDB Atlas              |
| CrashLoopBackOff (Pod)     | Ensured secrets injected correctly; Atlas IP open   |
| ArgoCD sync failure        | Fixed repo URL, secret mismatch, or pod health check|

---

## Best Practices Summary

| Category      | Applied Practices                                                  |
|---------------|---------------------------------------------------------------------|
| Security      | SSH keys, `.env`, K8s secrets, minimum port exposure                |
| Idempotency   | Ansible `state: present`, Compose `restart: unless-stopped`, K8s strategies |
| CI/CD         | GitHub Secrets, retries, cache layers                              |
| Documentation | Comments, markdown structure, screenshot evidence                  |

---

## 🎯 Next Steps

- 📊 Monitoring (e.g., Prometheus, Grafana)

---

## Acknowledgments

- **Fortstak** for the DevOps internship opportunity.

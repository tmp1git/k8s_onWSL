# Kubernetes on WSL2: Jupyter + Selenium GUI Environment

This repository provides a reproducible Kubernetes environment running on WSL2 using kind (Kubernetes in Docker).  
It includes a fully working setup of **JupyterLab** and **Selenium (GUI-enabled via noVNC)**, allowing you to run browser automation directly from Jupyter notebooks and visually inspect the browser through a VNC viewer.

👉 **[日本語版 READMEはこちら](README_ja.md)**

---

## 📂 Directory Structure
```
myk8s/
├─ jupyter/        # Deployment and Service for JupyterLab
├─ selenium/       # Deployment and Service for Selenium Grid (Chrome + noVNC)
├─ ingress/        # Ingress configuration (Jupyter only)
├─ kind/           # kind cluster configuration
├─ create.cluster.sh    # Script to create the kind cluster
└─ README.md
```
---

## 🚀 Setup Instructions

### 1. Create the kind cluster

Run the setup script inside WSL2:

```bash
./create.cluster.sh
This creates a Kubernetes cluster and installs the ingress-nginx controller automatically.
```

2. Deploy Kubernetes resources
```bash
kubectl apply -f jupyter/
kubectl apply -f selenium/
kubectl apply -f ingress/
```

🧪 Usage
1. Access JupyterLab
Open your browser and navigate to:

```
http://localhost:8080/jupyter
```
You will be redirected to /jupyter/lab automatically.

2. Connect to Selenium from Jupyter
Install Selenium inside Jupyter:

```python
!pip install selenium
Run a simple test:
```
```python
from selenium import webdriver
from selenium.webdriver.chrome.options import Options

options = Options()  # GUI mode (no headless)

driver = webdriver.Remote(
    command_executor="http://selenium:4444/wd/hub",
    options=options
)

driver.get("https://www.google.com")
print(driver.title)

driver.quit()
```
This confirms that Jupyter can communicate with Selenium inside the cluster.

🖥 Viewing the Browser GUI (noVNC)
Selenium provides a built-in noVNC server on port 7900.

1. Port-forward the VNC port
```bash
kubectl port-forward svc/selenium 7900:7900
```

2. Open noVNC in your browser
```
http://localhost:7900
When prompted for a password, enter:
secret
```
You will see the live Chrome browser session controlled by Selenium.

---

🔧 Notes on Session Timeout
Selenium Grid automatically closes idle browser sessions.

Default timeout:
```
SE_NODE_SESSION_TIMEOUT = 300 seconds (5 minutes)
To extend it, modify the Selenium Deployment:
```

```yaml
env:
  - name: SE_NODE_SESSION_TIMEOUT
    value: "3600"   # 1 hour
```
---

📌 Future Improvements
Persist Jupyter notebooks using PVC

Expose Selenium VNC via Ingress (with authentication)

Convert manifests into Helm charts

Automate deployment using GitHub Actions

---

📝 License
This repository is free to use and modify.
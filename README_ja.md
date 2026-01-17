# Kubernetes on WSL2: Jupyter + Selenium GUI 環境構築

このリポジトリは、WSL2 上で kind（Kubernetes in Docker）を使って構築した  
**JupyterLab + Selenium（GUI / noVNC 対応）環境**の再現手順と構成ファイルをまとめたものです。

Jupyter Notebook から Selenium Grid に接続し、  
GUI 付きブラウザを noVNC で確認しながら自動操作できます。

👉 **[English README is here](README.md)**

---

## 📂 ディレクトリ構成

myk8s/
├─ jupyter/        # JupyterLab の Deployment / Service
├─ selenium/       # Selenium Grid（Chrome + noVNC）の Deployment / Service
├─ ingress/        # Ingress（Jupyter のみ外部公開）
├─ kind/           # kind クラスタ設定
├─ create.cluster.sh    # kind クラスタ作成スクリプト
└─ README.ja.md


---

## 🚀 セットアップ手順

### 1. kind クラスタを作成

WSL2 上で以下を実行：

```bash
./create.cluster.sh
ingress-nginx コントローラも自動でセットアップされます。

2. Kubernetes リソースをデプロイ
bash
kubectl apply -f jupyter/
kubectl apply -f selenium/
kubectl apply -f ingress/
🧪 動作確認
1. JupyterLab にアクセス
ブラウザで以下へアクセス：

コード
http://localhost:8080/jupyter
自動的に /jupyter/lab にリダイレクトされます。

2. Jupyter から Selenium に接続
Jupyter Notebook で Selenium をインストール：

python
!pip install selenium
接続テスト：

python
from selenium import webdriver
from selenium.webdriver.chrome.options import Options

options = Options()  # GUI モード（headless 無し）

driver = webdriver.Remote(
    command_executor="http://selenium:4444/wd/hub",
    options=options
)

driver.get("https://www.google.com")
print(driver.title)

driver.quit()
🖥 GUI（noVNC）でブラウザを確認する
Selenium はポート 7900 で noVNC を提供しています。

1. ポートフォワード
bash
kubectl port-forward svc/selenium 7900:7900
2. ブラウザでアクセス
コード
http://localhost:7900
パスワードは：

コード
secret
Selenium が起動した Chrome の画面がリアルタイムで表示されます。

🔧 セッションタイムアウトについて
Selenium Grid は一定時間操作がないセッションを自動終了します。

デフォルト：

コード
SE_NODE_SESSION_TIMEOUT = 300秒（5分）
延長したい場合は Deployment に以下を追加：

yaml
env:
  - name: SE_NODE_SESSION_TIMEOUT
    value: "3600"   # 1時間
📌 今後の改善案
Jupyter のノートブックを PVC で永続化

Selenium VNC を Ingress で安全に公開

Helm チャート化

GitHub Actions による CI/CD 化

📝 ライセンス
このリポジトリは自由に利用・改変できます。
# k8s_onWSL
# Kubernetes on WSL2: Jupyter + Selenium GUI Environment

WSL2 上に kind（Kubernetes in Docker）で構築した  
**JupyterLab + Selenium（GUI / noVNC）環境**のセットアップ手順と構成ファイルです。

Jupyter から Selenium Grid に接続し、  
GUI 付きブラウザを noVNC で確認できる開発環境を再現できます。

---

## 📂 ディレクトリ構成

myk8s/
├─ jupyter/        # JupyterLab の Deployment / Service
├─ selenium/       # Selenium Grid の Deployment / Service
├─ ingress/        # Ingress（Jupyter のみ外部公開）
├─ kind/           # kind 用クラスタ設定
├─ create.cluster.sh    # kind クラスタ作成スクリプト
└─ README.md

コード

---

## 🚀 セットアップ手順

### 1. kind クラスタを作成

WSL2 上で実行：

```bash
./create.cluster.sh
クラスタ作成後、Ingress コントローラ（ingress-nginx）が自動で起動します。

2. Kubernetes リソースをデプロイ
bash
kubectl apply -f jupyter/
kubectl apply -f selenium/
kubectl apply -f ingress/
🧪 動作確認
1. JupyterLab にアクセス
ブラウザで：

コード
http://localhost:8080/jupyter
初回アクセス時に /jupyter/lab にリダイレクトされます。

2. Jupyter から Selenium に接続
Jupyter Notebook で Selenium をインストール：

python
!pip install selenium
Selenium Grid に接続してブラウザを起動：

python
from selenium import webdriver
from selenium.webdriver.chrome.options import Options

options = Options()  # headless を外すと GUI が見える

driver = webdriver.Remote(
    command_executor="http://selenium:4444/wd/hub",
    options=options
)

driver.get("https://www.google.com")
print(driver.title)

driver.quit()
🖥 GUI（noVNC）でブラウザを確認する
Selenium の GUI は VNC（ポート 7900）で確認できます。

1. ポートフォワード
bash
kubectl port-forward svc/selenium 7900:7900
2. ブラウザでアクセス
コード
http://localhost:7900
noVNC が表示されるので、
パスワード secret を入力して接続します。

Jupyter から起動した Chrome の画面がリアルタイムで見えます。

🔧 補足：Selenium のセッションタイムアウト
Selenium Grid はデフォルトで 5 分間操作がないとブラウザを自動終了します。

変更したい場合は Deployment に以下を追加：

yaml
env:
  - name: SE_NODE_SESSION_TIMEOUT
    value: "3600"   # 1時間
📌 今後の拡張案
Firefox ノードの追加

Selenium Grid のスケールアウト

Jupyter からの自動テストスクリプト化

Ingress で Selenium VNC を安全に公開

Helm 化 / GitHub Actions で CI/CD 化

📝 ライセンス
このリポジトリは自由に利用・改変できます。

from flask import Flask, render_template, request
import subprocess

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/configure', methods=['POST'])
def configure_network():
    ssid = request.form['ssid']
    password = request.form['password']

    # 关闭热点
    subprocess.run(['nmcli', 'd', 'disconnect', 'wlan0'])
    
    # 配置网络
    subprocess.run(['nmcli', 'device', 'wifi', 'connect', ssid, 'password', password])
        
    return 'Network configured successfully!'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
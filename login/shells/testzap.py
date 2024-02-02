from zapv2 import ZAPv2

# Spécifiez l'adresse IP et le port de votre instance ZAP
zap_address = '127.0.0.1'
zap_port = '8080'

# Créez une instance ZAP
zap = ZAPv2(apikey='om20plpu9vr5rqnicb73l0lrl', proxies={'http': f'http://{zap_address}:{zap_port}', 'https': f'http://{zap_address}:{zap_port}'})

# Démarrez le scan de l'application web
print('Starting ZAP spider...')
zap.spider.scan(url='http://172.20.10.2:80')

# Attendez que le scan soit terminé
while int(zap.spider.status()) < 100:
    print(f'Scanning progress: {zap.spider.status}%')

print('Spider scan completed!')

# Générez un rapport HTML
print('Generating HTML report...')
report_html = zap.core.htmlreport(apikey='om20plpu9vr5rqnicb73l0lrl')

# Enregistrez le rapport sur le disque
with open('zap_reportfront.html', 'w') as file:
    file.write(report_html)
    print('HTML report saved as zap_reportfront.html')

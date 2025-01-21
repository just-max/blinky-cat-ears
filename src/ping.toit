import http
import net
import certificate-roots
import system.assets

ping:
  certificate-roots.install-common-trusted-roots

  network := net.open
  client := http.Client.tls network

  request := client.post "haiiiiii".to-byte-array --host="pingback.example.com" --path="/ping"
  print request.body.read-string

main:
  ping

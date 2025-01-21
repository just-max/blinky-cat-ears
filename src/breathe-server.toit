import http
import net
import encoding.url

import .breathe

DURATION_ZERO ::= Duration --ns=0

run-server:
  t := task:: breathe

  network := net.open
  server-socket := network.tcp-listen 8080
  print network.address
  // port := server-socket.local-address.port
  // print "Listening on http://localhost:$port/"

  clients := []
  server := http.Server
  task::
    server.listen server-socket:: | request/http.RequestIncoming writer/http.ResponseWriter |
      // q ::= request.query
      writer.headers.set "Content-Type" "text/plain"
      if request.method == "POST" and request.query.resource == "/breathe":
        q ::= url.QueryString.parse ("?" + request.body.read-string)
        // print "parameters: $q.parameters"

        ok := true
        e := catch:
          min-brightness ::= float.parse (q.parameters.get "min_brightness")
          max-brightness ::= float.parse (q.parameters.get "max_brightness")
          period ::= Duration
            --ns=((float.parse (q.parameters.get "period")) * Duration.NANOSECONDS-PER-SECOND).round
          delta ::= Duration
            --ns=((float.parse (q.parameters.get "delta")) * Duration.NANOSECONDS-PER-MILLISECOND).round
          
          // print "min: $min-brightness, max: $max-brightness, period: $period, delta: $delta"
          if 0 <= min-brightness
              and min-brightness < max-brightness
              and max-brightness <= 1
              and DURATION_ZERO < period
              and DURATION_ZERO < delta:
            t.cancel
            t = task:: breathe
              --min-brightness=min-brightness
              --max-brightness=max-brightness
              --period=period
              --delta=delta
          else: ok = false

        if e or not ok:
          if e: print "Exception handling request: $e"
          else if not ok: "Error handling request"
          writer.write-headers 400
          writer.out.write "request failed\n"
        else:
          writer.write-headers 200
          writer.out.write "OK\n"
      else:
        writer.write-headers 404
        writer.out.write "Not found\n"
      writer.close

main:
  run-server

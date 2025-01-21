import gpio
import gpio.pwm
import math

pin := gpio.Pin 8
generator := pwm.Pwm --frequency=5000
channel := generator.start pin

class Counter:
  start/int
  constructor:
    start = Time.monotonic-us
  count -> Duration:
    return Duration --us=(Time.monotonic-us - start)

interp --from1/float=0.0 --to1/float=1.0 --from2/float=0.0 --to2/float=1.0 x/float -> float:
  return (x - from1) * (to2 - from2) / (to1 - from1) + from2

breath t/float -> float:
  upper := math.E
  lower := 1 / math.E
  period := 2 * math.PI
  return interp (math.exp (math.sin (t * period))) --from1=lower --to1=upper

breathe
    --period/Duration=(Duration --s=5) --delta/Duration=(Duration --ms=10)
    --min-brightness/float=0.05 --max-brightness/float=1.0:
  c ::= Counter
  delta.periodic:
    r ::= (c.count.in-ns % period.in-ns).to-float / period.in-ns
    v ::= interp (breath r) --from2=min-brightness --to2=max-brightness
    channel.set-duty-factor v

main:
  breathe --period=(Duration --s=3) --min-brightness=0.005 --max-brightness=0.01

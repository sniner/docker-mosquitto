# [Eclipse Mosquitto][2] for Docker

There is an [offical Docker image][3] for Mosquitto, but I dislike the fact
that it does not accept configuration via environment variables. On the other
hand, the Dockerfile looks pretty complicated and not like something I want to
duplicate. Therefore my Docker image is based on the original, although
I would have liked to have the log volume removed.

To have a look at the well commented original configuration file:

```
$ docker run --rm eclipse-mosquitto cat /mosquitto/config/mosquitto.conf
```

Per default logging is redirected to `stderr` and persistence is disabled.

To set a configuration value, [lookup the name][4] and prefix it with `MQTT_`
(case matters). Examples: `MQTT_PERSISTENCE=true`, `MQTT_MAX_KEEPALIVE=600`.

## Docker swarm

Example stack file with TLS:

```
version: '3.6'

services:
  mqtt:
    image: hub.example.org/sniner/mosquitto
    ports:
        - 8883:8883
    environment:
        MQTT_PERSISTENCE: "false"
        MQTT_PORT: 8883
        MQTT_CAFILE: /run/secrets/example.org.ca.cer
        MQTT_KEYFILE: /run/secrets/example.org.key
        MQTT_CERTFILE: /run/secrets/example.org.cer
    secrets:
      - example.org.ca.cer
      - example.org.cer
      - example.org.key
    deploy:
      replicas: 1
      placement:
        constraints:
          - node.role == worker

secrets:
  example.org.ca.cer:
    external: true
  example.org.cer:
    external: true
  example.org.key:
    external: true
```

[1]: https://mqtt.org/
[2]: https://github.com/eclipse/mosquitto/
[3]: https://hub.docker.com/_/eclipse-mosquitto
[4]: https://mosquitto.org/man/mosquitto-conf-5.html

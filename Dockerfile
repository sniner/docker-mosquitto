FROM eclipse-mosquitto:1.6

RUN apk add --update --no-cache bash
 
COPY docker-entrypoint.sh /

EXPOSE 1883

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD []

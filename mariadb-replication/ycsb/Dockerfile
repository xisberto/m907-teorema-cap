FROM amazoncorretto:22-alpine

ARG VERSION=0.17.0

RUN apk update && apk add curl mariadb-client &&\
    rm -rf /var/cache/apk/*

RUN mkdir /app &&\
    curl -O --location https://github.com/brianfrankcooper/YCSB/releases/download/${VERSION}/ycsb-${VERSION}.tar.gz &&\
    tar xfvz ycsb-${VERSION}.tar.gz -C /app &&\
    rm ycsb-${VERSION}.tar.gz

WORKDIR /app/ycsb-${VERSION}

RUN curl -O --location https://repo1.maven.org/maven2/org/mariadb/jdbc/mariadb-java-client/3.3.3/mariadb-java-client-3.3.3.jar --output-dir lib/

COPY entrypoint.sh ./bin/

ENTRYPOINT ["/app/ycsb-0.17.0/bin/entrypoint.sh"]

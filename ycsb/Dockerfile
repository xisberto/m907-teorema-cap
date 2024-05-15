FROM amazoncorretto:22-alpine

ARG VERSION=0.17.0

RUN apk update && apk add curl mongodb-tools python3 &&\
    rm -rf /var/cache/apk/*

RUN mkdir /app &&\
    curl -O --location https://github.com/brianfrankcooper/YCSB/releases/download/${VERSION}/ycsb-${VERSION}.tar.gz &&\
    tar xfvz ycsb-${VERSION}.tar.gz -C /app &&\
    rm ycsb-${VERSION}.tar.gz

WORKDIR /app/ycsb-${VERSION}

COPY entrypoint.sh ./bin/

# Adicionar permissões de execução ao script de entrada
RUN chmod +x ./bin/entrypoint.sh

# Criar e ativar o virtual environment
RUN python3 -m venv /venv && \
    /venv/bin/pip install --upgrade pip && \
    /venv/bin/pip install pymongo

ENTRYPOINT ["/app/ycsb-0.17.0/bin/entrypoint.sh"]

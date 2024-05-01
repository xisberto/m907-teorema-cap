# Teorema CAP

O objetivo deste trabalho é investigar a consistência, a disponibilidade e a tolerância à partição da rede de diferentes modelos de banco de dados distribuídos, utilizando a ferramenta Docker Compose para implantação dos bancos de dados e simulação de falhas de rede, e o benchmark YCSB para geração de carga sobre os bancos.

## Garantia CA: MariaDB Replication

### Configuração do cluster

No diretório `mariadb-replication` é construído um cluster contendo três servidores MariaDB (host01, host02 e host03) e um servidor MaxScale (um load balancer para MariaDB).

Um dos três hosts (host01) é configurado como *primary* e os outros dois como *secondary*. Esta configuração se dá usando diretórios específicos da imagem docker utilizada (mariadb), a saber:

- `/etc/mysql/conf.d`: diretório contendo arquivos de configuração do servidor
- `/docker-entrpoint-initdb.d`: diretório que pode conter arquivos .sql ou .sh que serão executados no momento da inicialização do banco de dados

### Configuração do YCSB

No `docker-compose.yaml` também estão configurados três contêineres do YCSB, configurados para conexão com o MaxScale (chamado endpoint) através do arquivo db.properties. Cada réplica do YCSB tem um arquivo de configuração próprio (`replica{01,02,03}.properties`) que aumenta o número de records a serem inseridos na carga e divide os records em faixas entre as três réplicas (conforme descrito em https://github.com/brianfrankcooper/YCSB/wiki/Running-a-Workload-in-Parallel).

O script `entrypoint.sh` espera pelo MaxScale ficar pronto, o que demora cerca de 1 minuto, antes de carregar e iniciar o workload do YCSB.

### Iniciando o Workload

Para iniciar este Workload, basta iniciar o docker compose com a opção de build para a imagem do YCSB:

```
docker compose up --build
```

As informações sobre a execução dos workloads podem ser verificadas na saída do comando acima, e os resultados serão gravados no diretório `results`.

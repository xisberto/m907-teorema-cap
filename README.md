# Teorema CAP

O objetivo deste trabalho é investigar a consistência, a disponibilidade e a tolerância à partição da rede de diferentes modelos de banco de dados distribuídos, utilizando a ferramenta Docker Compose para implantação dos bancos de dados e simulação de falhas de rede, e o benchmark YCSB para geração de carga sobre os bancos.

## Garantia CA: MariaDB Replication

No diretório `mariadb-replication` é construído um cluster contendo três servidores MariaDB (host01, host02 e host03) e um servidor MaxScale (um load balancer para MariaDB).

Um dos três hosts (host01) é configurado como *primary* e os outros dois como *secondary*. Esta configuração se dá usando diretórios específicos da imagem docker utilizada (mariadb), a saber:

- /etc/mysql/conf.d: diretório contendo arquivos de configuração do servidor
- /docker-entrpoint-initdb.d: diretório que pode conter arquivos .sql ou .sh que serão executados no momento da inicialização do banco de dados


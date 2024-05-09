# Use uma imagem Python oficial
FROM python:3.9-slim

# Copie o script Python para dentro do contêiner
COPY init_cassandra.py /init_cassandra.py

# Instale as dependências do script Python
RUN pip install cassandra-driver

# Defina o comando padrão para executar o script Python
CMD ["python", "/init_cassandra.py"]

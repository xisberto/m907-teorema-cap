#!/bin/bash

# Função para aguardar o Cassandra estar pronto para aceitar conexões
function wait_for_cassandra {
    echo "Waiting for Cassandra to start..."
    # Lista de nós Cassandra
    cassandra_nodes=("cassandra_node01" "cassandra_node02" "cassandra_node03")
    
    # Esperar até que todos os nós respondam positivamente
    until check_all_nodes_available "${cassandra_nodes[@]}"; do
        echo "$(date) - Cassandra is unavailable - sleeping"
        sleep 20
    done
    
    echo "Cassandra is up - executing command"
    python3 /etc/cassandra/init_cassandra.py
}

# Função para verificar a disponibilidade de todos os nós
function check_all_nodes_available {
    local nodes=("$@")
    local all_available=true
    
    # Iterar sobre todos os nós
    for node in "${nodes[@]}"; do
        # Verificar se o nó está disponível
        if ! cqlsh --cqlshrc=/etc/cassandra/cassandra.credentials -e "describe keyspaces" "$node" 9042 &> /dev/null; then
            all_available=false
            break
        fi
    done
    
    # Retorna verdadeiro se todos os nós estiverem disponíveis, falso caso contrário
    $all_available
}

# Esperar que o Cassandra esteja pronto em todos os nós
wait_for_cassandra
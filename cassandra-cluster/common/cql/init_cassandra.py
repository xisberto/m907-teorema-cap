from cassandra.cluster import Cluster
from cassandra.auth import PlainTextAuthProvider

def connect_to_cassandra():
    # Configurações de autenticação
    auth_provider = PlainTextAuthProvider(username='cassandra', password='cassandra')

    # Conexão com o cluster Cassandra
    cluster = Cluster(['cassandra_node01', 'cassandra_node02', 'cassandra_node03'], auth_provider=auth_provider)

    # Conecta-se a uma sessão
    session = cluster.connect()

    return session

def create_keyspace_and_table(session):
    # Criação do keyspace e da tabela se não existirem
    session.execute("""
    CREATE KEYSPACE IF NOT EXISTS ycsb_keypace_node
    WITH REPLICATION = {'class': 'NetworkTopologyStrategy', 'replication_factor': 3}
    """)
    
    session.execute("USE ycsb_keypace_node")
    
    session.execute("""
    CREATE TABLE IF NOT EXISTS usertable (
        y_id varchar PRIMARY KEY,
        field0 varchar,
        field1 varchar,
        field2 varchar,
        field3 varchar,
        field4 varchar,
        field5 varchar,
        field6 varchar,
        field7 varchar,
        field8 varchar,
        field9 varchar
    )
    """)

def create_users_and_grant_permissions(session):
    # Cria usuários se não existirem
    session.execute("CREATE ROLE IF NOT EXISTS admin WITH PASSWORD = 'cassandra' AND SUPERUSER = true AND LOGIN = true")
    session.execute("CREATE ROLE IF NOT EXISTS appuser WITH PASSWORD = 'cassandra' AND LOGIN = true")
    
    # Verifica se o keyspace existe antes de conceder permissões
    if 'ycsb_keypace_node' not in session.cluster.metadata.keyspaces:
        print("Keyspace 'ycsb_keypace_node' não foi criado corretamente.")
        return
    
    # Concede permissões específicas para appuser no keyspace criado
    try:
        session.execute("GRANT SELECT ON KEYSPACE ycsb_keypace_node TO appuser")
        session.execute("GRANT INSERT ON KEYSPACE ycsb_keypace_node TO appuser")
        session.execute("GRANT UPDATE ON KEYSPACE ycsb_keypace_node TO appuser")
        session.execute("GRANT DELETE ON KEYSPACE ycsb_keypace_node TO appuser")
    except Exception as e:
        print("Error granting permissions:", e)

    # Concede permissões gerais de leitura em todos os keyspaces
    try:
        session.execute("GRANT SELECT ON ALL KEYSPACES TO appuser")
    except Exception as e:
        print("Error granting general permissions:", e)


def main():
    # Conectar-se ao cluster Cassandra
    session = connect_to_cassandra()

    # Criar o keyspace e a tabela
    create_keyspace_and_table(session)

    # Criar usuários e conceder permissões
    create_users_and_grant_permissions(session)

if __name__ == "__main__":
    main()

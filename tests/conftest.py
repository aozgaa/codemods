import pytest

import psycopg
from psycopg.rows import dict_row

ADMIN_DSN = "postgresql://codemods@localhost:5499/postgres"
TEST_DSN = "postgresql://codemods@localhost:5499/codemods_test"


@pytest.fixture(scope="session")
def test_database():
    try:
        admin = psycopg.connect(ADMIN_DSN, autocommit=True)
    except psycopg.OperationalError as e:
        pytest.skip(f"postgres not running (pixi run db-start): {e}")
    admin.execute("DROP DATABASE IF EXISTS codemods_test")
    admin.execute("CREATE DATABASE codemods_test")
    admin.close()
    yield TEST_DSN


@pytest.fixture
def conn(test_database):
    from codemods import db

    with db.connect(test_database) as c:
        db.init_db(c)
        for table in ("notifications", "events", "subtasks", "codemods"):
            c.execute(f"TRUNCATE {table} CASCADE")
        yield c

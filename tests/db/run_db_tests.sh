#!/bin/bash
# =============================================================================
# 🚀 TECDA MANIQUÍ - DB TEST RUNNER
# =============================================================================

CONTAINER_NAME="tecda-mysql"
DB_NAME="tecda_maniqui"

echo "----------------------------------------------------"
echo "🧪 Iniciando Pruebas de Base de Datos (Motor SQL)"
echo "----------------------------------------------------"

# 1. Copiar tests al contenedor
docker cp . $CONTAINER_NAME:/db_tests

# 2. Ejecutar tests en orden
run_sql_test() {
    local file=$1
    echo -e "\n📂 Ejecutando: $file"
    docker exec -i $CONTAINER_NAME mysql -uroot -proot $DB_NAME < "$file"
}

run_sql_test "db_tests/unit/test_triggers.sql"
run_sql_test "db_tests/unit/test_constraints.sql"
run_sql_test "db_tests/integration/test_analytics.sql"
run_sql_test "db_tests/integration/test_logic.sql"

echo -e "\n----------------------------------------------------"
echo "✅ Fin de la suite de pruebas SQL."
echo "----------------------------------------------------"

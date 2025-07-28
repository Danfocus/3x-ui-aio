#!/bin/sh
set -e

DB_FILE="/etc/x-ui/x-ui.db"
INIT_SQL="/tmp/init.sql"

if [ -f "$DB_FILE" ]; then
  echo "Database already exists at $DB_FILE, skipping initialization."
  exit 0
fi

echo "Installing required packages..."
apk add --no-cache curl sqlite gettext bash coreutils python3 py3-bcrypt

echo "Installing xray-core..."
curl -L https://github.com/XTLS/Xray-core/releases/latest/download/xray-linux-64.zip -o /tmp/xray.zip
unzip /tmp/xray.zip -d /tmp/xray
mv /tmp/xray/xray /usr/local/bin/xray
chmod +x /usr/local/bin/xray

# Установим дефолтные значения окружения, если не заданы
: ${WEB_PORT:=2053}; export WEB_PORT
: ${WEB_BASE_PATH:=/}; export WEB_BASE_PATH
: ${SESSION_MAX_AGE:=60}; export SESSION_MAX_AGE
: ${PAGE_SIZE:=50}; export PAGE_SIZE
: ${EXPIRE_DIFF:=0}; export EXPIRE_DIFF
: ${TRAFFIC_DIFF:=0}; export TRAFFIC_DIFF
: ${REMARK_MODEL:=-ieo}; export REMARK_MODEL
: ${TG_BOT_ENABLE:=false}; export TG_BOT_ENABLE
: ${TG_RUN_TIME:=@daily}; export TG_RUN_TIME
: ${TG_BOT_BACKUP:=false}; export TG_BOT_BACKUP
: ${TG_BOT_LOGIN_NOTIFY:=true}; export TG_BOT_LOGIN_NOTIFY
: ${TG_CPU:=80}; export TG_CPU
: ${TG_LANG:=en-US}; export TG_LANG
: ${TIME_LOCATION:=Local}; export TIME_LOCATION
: ${TWO_FACTOR_ENABLE:=false}; export TWO_FACTOR_ENABLE
: ${SUB_ENABLE:=false}; export SUB_ENABLE
: ${SUB_PORT:=2096}; export SUB_PORT
: ${SUB_PATH:=/sub/}; export SUB_PATH
: ${SUB_UPDATES:=12}; export SUB_UPDATES
: ${EXT_TRAFFIC_INFORM_ENABLE:=false}; export EXT_TRAFFIC_INFORM_ENABLE
: ${SUB_ENCRYPT:=true}; export SUB_ENCRYPT
: ${SUB_SHOW_INFO:=true}; export SUB_SHOW_INFO
: ${SUB_JSON_PATH:=/json/}; export SUB_JSON_PATH
: ${DATEPICKER:=gregorian}; export DATEPICKER
: ${ADMIN_USER:=admin}; export ADMIN_USER
: ${DEFAULT_INBOUND_REMARK:=VLESS-TCP-VISION-REALITY}; export DEFAULT_INBOUND_REMARK

SECRET=$(tr -dc 'a-zA-Z0-9' < /dev/urandom | head -c32); export SECRET

# Проверка наличия пароля администратора
if [ -z "$ADMIN_PASS" ]; then
  echo "ERROR: ADMIN_PASS environment variable is not set."
  exit 1
fi

# Генерация bcrypt-хэша через Python
ADMIN_PASS_HASH=$(python3 - <<EOF
import bcrypt
pw = b"$ADMIN_PASS"
hashed = bcrypt.hashpw(pw, bcrypt.gensalt())
print(hashed.decode())
EOF
)

export ADMIN_PASS_HASH SECRET

# Заполнение URI
if [[ "$SUB_ENABLE" == "true" && -z "$SUB_URI" ]]; then
    SUB_URI="https://${XRAY_DOMAIN}${SUB_PATH}"; export SUB_URI
fi
if [[ "$SUB_ENABLE" == "true" && -z "$SUB_JSON_URI" ]]; then
    SUB_JSON_URI="https://${XRAY_DOMAIN}${SUB_JSON_PATH}"; export SUB_JSON_URI
fi

XRAY_PIK=$(/usr/local/bin/xray x25519 | head -n1 | cut -d' ' -f 3); export XRAY_PIK
XRAY_PBK=$(/usr/local/bin/xray x25519 -i $XRAY_PIK | tail -1 | cut -d' ' -f 3); export XRAY_PBK
XRAY_SID=$(head -c 8 /dev/urandom | xxd -p); export XRAY_SID

# Генерация init.sql из шаблона с подстановкой переменных окружения
envsubst < /init.sql.template > "$INIT_SQL"

# Создание базы
echo "Initializing database at $DB_FILE..."
sqlite3 "$DB_FILE" < "$INIT_SQL"

echo "Database initialized successfully."

# Экспорт переменных для angie
cat <<EOF > /etc/x-ui/.env.generated
WEB_PORT=$WEB_PORT
WEB_BASE_PATH=$WEB_BASE_PATH
SUB_ENABLE=$SUB_ENABLE
SUB_PORT=$SUB_PORT
SUB_PATH=$SUB_PATH
SUB_JSON_PATH=$SUB_JSON_PATH
EOF

echo "Initialization complete."
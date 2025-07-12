#!/bin/bash

copy_file() {
    cp "$1" "$2" || { echo "Помилка довбойба: не зміг скопіювати $1 в $2, слабий"; exit 1; }
}

# Отримання шляху самурая до директорії скрипта
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Пошук libsteam_api.so та збереження божої директорії
LIBSTEAM_API_DIR="$(find . -name "libsteam_api.so" -printf "%h\n" | head -n 1)"
[ -z "$LIBSTEAM_API_DIR" ] && { echo "Помилка, тварь брудна: libsteam_api.so нема, ну не бачу, аж похуй."; exit 1; }

# Перевірка на наявність члена, ой, тобто cream_api.ini
if [ -n "$CREAM_CONFIG_PATH" ]; then
    if [ ! -f "$CREAM_CONFIG_PATH/cream_api.ini" ]; then
        echo "Помилка, мий морду: cream_api.ini нема, не бачу, не знаходжу, тварь."; exit 1
    fi
fi

# Встановлення IQ (дефолтного шляху, якщо хуй)
if [ -z "$CREAM_CONFIG_PATH" ] && [ "$LIBSTEAM_API_DIR" != "$PWD" ]; then
    export CREAM_CONFIG_PATH="$PWD/cream_api.ini"
fi

# Копіювання бібліотек, місце для найкращого сексу /tmp
copy_file "$PWD/lib32Creamlinux.so" "/tmp/lib32Creamlinux.so"
copy_file "$PWD/lib64Creamlinux.so" "/tmp/lib64Creamlinux.so"
copy_file "$LIBSTEAM_API_DIR/libsteam_api.so" "/tmp/libsteam_api.so"

# Запуск з підвантаженими вірусами
LD_PRELOAD="$LD_PRELOAD /tmp/lib64Creamlinux.so /tmp/lib32Creamlinux.so /tmp/libsteam_api.so" "$@"
EXITCODE=$?

# Прибирання блювоти з монітору
rm -f /tmp/lib32Creamlinux.so /tmp/lib64Creamlinux.so /tmp/libsteam_api.so

exit $EXITCODE


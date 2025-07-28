
# 3x-ui-aio

## Запуск

### 1. Создайте один поддомен:
Например:
- `cloud.example.com` - xray/сайт-заглушка

A-запись этого поддомена должна содержать IP вашего VPS

### 2. Установите Docker

Инструкции по установке Docker: [https://docs.docker.com/engine/install/](https://docs.docker.com/engine/install/)

### 3. Клонируйте репозиторий

```bash
git clone -b one-domain https://github.com/Danfocus/3x-ui-aio.git && cd 3x-ui-aio
```

### 4. Отредактируйте файл `.env`

Замените:
- `<your_xray_domain>` на поддомен для xray (например, `cloud.example.com`)

### 5. Поместите свой сайт-заглушку в `./web-stub/`

Варианты можно взять из архивов:
- [https://codeload.github.com/eGamesAPI/simple-web-templates/zip/refs/heads/main](https://codeload.github.com/eGamesAPI/simple-web-templates/zip/refs/heads/main)
- [https://codeload.github.com/SmallPoppa/sni-templates/zip/refs/heads/main](https://codeload.github.com/SmallPoppa/sni-templates/zip/refs/heads/main)
- [https://codeload.github.com/GFW4Fun/randomfakehtml/zip/refs/heads/master](https://codeload.github.com/GFW4Fun/randomfakehtml/zip/refs/heads/master)

### 6. Запустите Docker Compose

```bash
docker compose up -d
```

### 7. Перейдите в панель

Откройте браузер и перейдите по адресу: [https://cloud.example.com/panel/](https://cloud.example.com/panel/)

> [!NOTE]
> Получение сертификата сайта может занять некоторое время, поэтому панель может открыться не сразу.

**Дефолтные данные для авторизации:**
- Логин: `admin`
- Пароль: `admin` (если не изменен в .env)

> [!CAUTION]
> Обязательно измените дефолтный логин и пароль в разделе **Panel Settings -> Authentication**, если не изменен в .env


# 3x-ui-aio

## Запуск

### 1. Создайте два поддомена:
Например:
- `panel.example.com` - панель 3x-ui
- `cloud.example.com` - xray/сайт-заглушка

A-записи этих поддоменов должны содержать IP вашего VPS

### 2. Установите Docker

Инструкции по установке Docker: [https://docs.docker.com/engine/install/](https://docs.docker.com/engine/install/)

### 3. Клонируйте репозиторий

```bash
git clone https://github.com/Danfocus/3x-ui-aio.git && cd 3x-ui-aio
```

### 4. Отредактируйте файл `angie.conf`

Замените:
- `<your_panel_domain>` на поддомен для панели (например, `panel.example.com`)
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

Откройте браузер и перейдите по адресу: [https://panel.example.com](https://panel.example.com)

> [!NOTE]
> Получение сертификата сайта может занять некоторое время, поэтому панель может открыться не сразу.

**Дефолтные данные для авторизации:**
- Логин: `admin`
- Пароль: `admin`

> [!CAUTION]
> Обязательно измените дефолтный логин и пароль в разделе **Panel Settings -> Authentication**.

> [!WARNING]
> Для повышения безопасности рекомендуется изменить путь до панели в разделе **Panel Settings -> URI Path**.
>
> Например, при изменении URI Path на `/my-secret-panel-path/` панель будет доступна только по адресу [https://panel.example.com/my-secret-panel-path/](https://panel.example.com/my-secret-panel-path/)

### 8. Добавьте inbound в панели 3x-ui

При добавлении inbound настройте следующие обязательные параметры:

- **Protocol:** vless
- **Port:** 443
- **Proxy Protocol:** Enabled
- **External Proxy:** cloud.example.com:443
- **Security:** Reality
- **Xver:** 2
- **Dest (Target):** angie:2443
- **SNI:** cloud.example.com

![inbound](https://github.com/user-attachments/assets/dd85f07f-e627-4d88-b5b8-e918419e67e2)

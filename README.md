## Подготовка к запуску
Публичный ключ должен находиться по пути: ```~/.ssh/id_rsa.pub```

В системе должны быть установлены ansible и terraform. Тестировалось на версиях:
- ansible [core 2.13.8]
  - community.mysql 3.6.0
- terraform v1.5.5
  
## Настройка и запуск
### Настройка Proxmox
Действия выполняются в консоли сервера Proxmox:
- Создать пользователя: ```pveum user add otus@pve```
- Добавить пользователю токен: ```pveum user token add otus@pve terraform```
  - В выводе запомнить ```full-tokenid``` и ```value```.
- Создать роль: 
```
pveum role add TerraformProv -privs "Datastore.AllocateSpace Datastore.Audit Pool.Allocate Sys.Audit Sys.Console \
                                   Sys.Modify VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.Cloudinit \
                                   VM.Config.CPU VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network \
                                   VM.Config.Options VM.Migrate VM.Monitor VM.PowerMgmt"
```
- Назначить роль созданному пользователю: ```pveum aclmod / -user otus@pve -role TerraformProv```

### Настройка подключения

- склонировать репозиторий;
- настроить подключение к proxmox. Для этого перейти в каталог ```terraform``` создать файл ```proxmox.auto.tfvars``` с содержимым (подставить свои данные):
```
pm_api_url          = "<адрес proxmox>/api2/json"
pm_api_token_id     = "full-tokenid"     # полученный при создании токена
pm_api_token_secret = "value"            # полученный при создании токена  
```

### Запуск
- инициализировать терраформ: ```terraform init```
- запустить создание инфраструктуры: ```terraform apply```
- после создания инфраструктуры дождаться запуска контейнеров
- перейти в каталог ```ansible``` и запустить плейбук: ```ansible-playbook setup.yaml```

## Схема проекта
```
                ┌───────── app0 ─────────┐
client <─────> lb0                      db0
                └───────── app1 ─────────┘
```

## Пояснения
Инфраструктура разворачивается на домашнем сервере Proxmox 7.4. 

В качестве виртуальных серверов используются lxc контейнеры для экономии ресурсов.

IP-адреса задаются статически, в плейбуке настраивается маршрут по умолчанию.

# opm
[![GitHub release](https://img.shields.io/github/release/oscript-library/opm.svg)](https://github.com/oscript-library/opm/releases)

OneScript Package Manager

Возможные команды:
- build    - Собрать пакет из исходников
- run      - Выполнить произвольную задачу
- test     - Выполнить тестирование проекта
- prepare  - Подготовить новый каталог разрабатываемого пакета
- install  - Выполнить установку. Если указано имя пакета, происходит установка из хаба или из файла. В обратном случае устанавливаются зависимости текущего пакета по файлу packagedef.
- update   - Обновить пакет
- app      - Создать bat-файл для запуска скрипта в указанном каталоге
- config   - Задать пользовательские настройки
- list     - Вывести список пакетов
- help     - Справка по командам
 
Наберите *opm <команда> --help*, чтобы вывести справку по команде

Справка из википедии: [Система управления пакетами](https://ru.wikipedia.org/wiki/%D0%A1%D0%B8%D1%81%D1%82%D0%B5%D0%BC%D0%B0_%D1%83%D0%BF%D1%80%D0%B0%D0%B2%D0%BB%D0%B5%D0%BD%D0%B8%D1%8F_%D0%BF%D0%B0%D0%BA%D0%B5%D1%82%D0%B0%D0%BC%D0%B8)

# Сервера
В настоящее время пакеты хранятся на двух серверах:
- [hub.oscript.io](http://hub.oscript.io/download) - основной хаб пакетов
- [hub.oscript.ru](http://hub.oscript.ru/download) - вторичный хаб пакетов. Используется, когда не удаётся получить данные с основного хаба

# Особенности обновления версий 

## с 0.14.х на 0.15.х и выше

* Изменена строка использования (вызова) приложения - теперь соответствует стандарту POSIX. 
* Все параметры вызова разделены на опции и аргументы. Для коротких (1 символ) опций обязательно использование `-`, для длинных опций (2 символа и более) - использование двойного тире `--`
* Сначала необходимо указывать опции, а потом аргументы

Пример изменений использования для команды `build`
```sh
# версия 0.14.х и младше

opm build . -mf ./packagedef

# версия 0.15.x и старше

opm build --mf ./packagedef .

```

# Настройка

## Настройка путей установки скриптов
Переменная окружения ```OSCRIPTBIN``` отвечает за переопределение пути установки скриптов при глобальной установке. По умолчанию для linux считается "/usr/bin", а для windows КаталогПрограммы(). 
При указании данной переменной можно переназначить путь для создания скриптов запуска различных пакетов. Возможно скачать архив, распаковать его и запуская oscript с указанием этих переменных тестировать работу автономной установки. 
- **linux** 
```
OSCRIPTBIN=~/.local/bin opm update -all
```
- **windows** 
```
set OSCRIPTBIN=c:\temp\ 
opm update -all
```

## Настройка прокси-сервера для скачивания пакетов

Настройка производится с помощью создания служебного файла [opm.cfg](./tests/fixtures/opm.cfg) данный файл настроек можно расположить по таким путям (список приведен в порядке убывания приоритета):
 - ```./opm.cfg``` - текущий каталог запуска + /opm.cfg
 - каталог настроек пользователя
    - linux: ```~/.opm.cfg```, **внимание файла должен называться с точкой ```.opm.cfg```**
    - windows: ```%USERPROFILE%\opm.cfg```
 - системная настройка:
    - linux: ```/etc/opm.cfg```
    - windows: ```c:\ProgramData\opm.cfg```
- OSCRIPT/lib/opm/opm.cfg - каталог установки opm, для совместимости.

## Обновление

Пакетный менеджер обновляется вместе с oscript'ом, необходимую версию можно вручную скачать со страницы https://oscript.io/downloads/ или с помощью choco: 
```
choco install onescript
```

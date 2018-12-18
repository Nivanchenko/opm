///////////////////////////////////////////////////////////////////////////
//
// OneScript Package Manager
// Установщик пакетов для OneScript
// Выполняется, как os-приложение в командной строке:
//
// opm install my-package.ospx
//
////////////////////////////////////////////////////////////////////////

#Использовать "../core"
#Использовать "."
#Использовать cli

Перем ЭтоWindows;

///////////////////////////////////////////////////////////////////////////////

Процедура ВыполнитьПриложение()

    Приложение = Новый КонсольноеПриложение("opm", "Пакетный менеджер для OneScript");
    Приложение.Версия("v version", КонстантыOpm.ВерсияПродукта);

    Приложение.ДобавитьКоманду("a app", "Создать " + ?(ЭтоWindows, "bat", "sh") + "-файл для запуска скрипта в указанном каталоге", Новый КомандаOpm_App);
    Приложение.ДобавитьКоманду("b build", "Собрать пакет из исходников", Новый КомандаOpm_Build);
    Приложение.ДобавитьКоманду("c config", "Задать пользовательские настройки", Новый КомандаOpm_Config);
    Приложение.ДобавитьКоманду("i install", "Выполнить установку пакета. 
                                        |                Если указано имя пакета, происходит установка из хаба или из файла. 
                                        |                В обратном случае устанавливаются зависимости текущего пакета по файлу packagedef.",
                                        Новый КомандаOpm_Install);
    Приложение.ДобавитьКоманду("ls list", "Вывести список пакетов", Новый КомандаOpm_List);
    Приложение.ДобавитьКоманду("pre prepare", "Подготовить новый каталог разрабатываемого пакета", Новый КомандаOpm_Prepare);
    Приложение.ДобавитьКоманду("p push", "Отправить пакет в хаб пакетов", Новый КомандаOpm_Push);
    Приложение.ДобавитьКоманду("r run", "Выполнить произвольную задачу", Новый КомандаOpm_Run);
    Приложение.ДобавитьКоманду("test", "Выполнить тестирование проекта", Новый КомандаOpm_Test);
    Приложение.ДобавитьКоманду("u update", "Обновить пакет", Новый КомандаOpm_Update);
    Приложение.ДобавитьКоманду("version", "Вывести версию продукта", Новый КомандаOpm_Version);
   
    Приложение.Запустить(АргументыКоманднойСтроки);

КонецПроцедуры

///////////////////////////////////////////////////////

СистемнаяИнформация = Новый СистемнаяИнформация;
ЭтоWindows = Найти(НРег(СистемнаяИнформация.ВерсияОС), "windows") > 0;

Попытка

    ВыполнитьПриложение();

Исключение
    Сообщить(ОписаниеОшибки());
КонецПопытки;
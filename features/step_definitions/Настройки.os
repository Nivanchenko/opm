﻿// Реализация шагов BDD-фич/сценариев c помощью фреймворка https://github.com/artbear/1bdd
#Использовать asserts

#Использовать "../../src/core"

Перем БДД; //контекст фреймворка 1bdd

// Метод выдает список шагов, реализованных в данном файле-шагов
Функция ПолучитьСписокШагов(КонтекстФреймворкаBDD) Экспорт
	БДД = КонтекстФреймворкаBDD;

	ВсеШаги = Новый Массив;

	ВсеШаги.Добавить("ЯЧитаюНастройкиИзФайла");
	ВсеШаги.Добавить("ЗначениеНастройкиРавно");

	Возврат ВсеШаги;
КонецФункции

// Реализация шагов

// Процедура выполняется перед запуском каждого сценария
Процедура ПередЗапускомСценария(Знач Узел) Экспорт
	
КонецПроцедуры

// Процедура выполняется после завершения каждого сценария
Процедура ПослеЗапускаСценария(Знач Узел) Экспорт
	
КонецПроцедуры

//я читаю настройки из файла "opm.cfg"
Процедура ЯЧитаюНастройкиИзФайла(Знач ПутьФайла) Экспорт
	Файл = Новый Файл(ОбъединитьПути(ТекущийКаталог(), ПутьФайла));
	НастройкиOpm.СброситьНастройки();
	НастроитьOpmИзФайла(Файл.ПолноеИмя);

	Настройки = НастройкиOpm.ПолучитьНастройки();
	БДД.СохранитьВКонтекст(КлючКонтекста(), Настройки);
КонецПроцедуры

//значение настройки "СоздаватьShСкриптЗапуска" равно "false"
Процедура ЗначениеНастройкиРавно(Знач КлючНастройки, Знач ЗначениеНастройки) Экспорт
	Настройки = БДД.ПолучитьИзКонтекста(КлючКонтекста());

	Ожидаем.Что(КлючНастройки, "Ключ настройки не заполнен").Заполнено();

	Значение = ЗначениеНастройки(Настройки, КлючНастройки);

	ЗначениеНастройки = КонвертироватьЗначениеПриНеобходимости(ЗначениеНастройки);

	Ожидаем.Что(Значение, СтрШаблон("Не совпадает значение настройки с именем <%1>", КлючНастройки)).Равно(ЗначениеНастройки);
КонецПроцедуры

// учитываются простые (СоздаватьShСкриптЗапуска) и иерархические ключи (Прокси.ИспользоватьПрокси)
Функция ЗначениеНастройки(Знач Настройки, Знач КлючНастройки)
	МассивИерархии = СтрРазделить(КлючНастройки, ".", Ложь);
	ПутьКлюча = "";
	ТекущиеНастройки = настройки;
	Для Счетчик = 0 По МассивИерархии.ВГраница() Цикл
		ТекущийКлюч = МассивИерархии[Счетчик];
		Если ПустаяСтрока(ПутьКлюча) Тогда
			ПутьКлюча  = ТекущийКлюч; 
		Иначе
			ПутьКлюча  = СтрШаблон("%1.%2", ПутьКлюча, ТекущийКлюч); 
		КонецЕсли;

		Значение = Неопределено;
		ЕстьНастройка = ТекущиеНастройки.Свойство(ТекущийКлюч, Значение);
		Ожидаем.Что(ЕстьНастройка, СтрШаблон("Не удалось получить настройку с именем <%1>", ПутьКлюча)).ЭтоИстина();
		ТекущиеНастройки = Значение;
	КонецЦикла;

	Возврат Значение;
КонецФункции

Процедура НастроитьOpmИзФайла(ПутьКФайлуНастроек)

	НастройкиOpmИзФайлов = ПрочитатьФайлНастроек(ПутьКФайлуНастроек);

	Если НастройкиOpmИзФайлов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	НастройкиПроксиЕсть = ПолучитьЗначение(НастройкиOpmИзФайлов,"Прокси", Неопределено);
		
	Если Не НастройкиПроксиЕсть = Неопределено  Тогда

		НастройкиПрокси = НастройкиКакСтруктура(НастройкиOpmИзФайлов.Прокси);

		Сервер = ПолучитьЗначение(НастройкиПрокси, "Сервер", "");
		Порт = Число(ПолучитьЗначение(НастройкиПрокси, "Порт", 0));
		Пользователь = ПолучитьЗначение(НастройкиПрокси, "Пользователь", "");
		Пароль = ПолучитьЗначение(НастройкиПрокси, "Пароль", "");

		НастройкиOpm.УстановитьНастройкиПроксиСервера(Сервер, Порт, Пользователь, Пароль);

		ПроксиПоУмолчанию = ПолучитьЗначение(НастройкиПрокси,"ПроксиПоУмолчанию", Неопределено);
		
		Если Не ПроксиПоУмолчанию = Неопределено Тогда

			НастройкиOpm.УстановитьСистемныеНастройкиПроксиСервера(ПроксиПоУмолчанию);

		КонецЕсли;

		ИспользованиеПрокси = ПолучитьЗначение(НастройкиПрокси,"ИспользованиеПрокси", Неопределено);

		Если Не ИспользованиеПрокси = Неопределено Тогда

			НастройкиOpm.УстановитьИспользованиеПрокси(ИспользованиеПрокси);

		КонецЕсли;
	
	КонецЕсли;

	СоздаватьShСкриптЗапуска = ПолучитьЗначение(НастройкиOpmИзФайлов,"СоздаватьShСкриптЗапуска", Неопределено);
		
	Если Не СоздаватьShСкриптЗапуска = Неопределено Тогда

		НастройкиOpm.УстановитьСозданиеShСкриптЗапуска(СоздаватьShСкриптЗапуска);

	КонецЕсли;

	СервераПакетов = ПолучитьЗначение(НастройкиOpmИзФайлов,"СервераПакетов", Неопределено);
	
	Если Не СервераПакетов = Неопределено Тогда
		Индекс = 1;

		Для каждого ТекущийСерверПакетов Из СервераПакетов Цикл

			Попытка
				СерверПакетов = СерверыПакетов.ИзНастроек(НастройкиКакСтруктура(ТекущийСерверПакетов), Индекс);
			Исключение
				Продолжить;
			КонецПопытки;
			
			НастройкиOpm.ДобавитьСерверПакетов(СерверПакетов);
			Индекс = Индекс + 1;

		КонецЦикла;

	КонецЕсли;

КонецПроцедуры

Функция ПрочитатьФайлНастроек(Знач ПутьФайлаНастроек)

	Если НЕ Новый Файл(ПутьФайлаНастроек).Существует() Тогда
		Возврат Новый Структура;
	КонецЕсли;

	Текст = ПрочитатьФайл(ПутьФайлаНастроек);

	ЧтениеJSON = Новый ЧтениеJSON();
	ЧтениеJSON.УстановитьСтроку(Текст);
	НастройкиКакСоответствие = ПрочитатьJSON(ЧтениеJSON, Истина);
	ЧтениеJSON.Закрыть();

	Возврат НастройкиКакСтруктура(НастройкиКакСоответствие);

КонецФункции

Функция НастройкиКакСтруктура(Знач НастройкиКакСоответствие)
	
	Перем Настройки;

	Настройки = Новый Структура;
	Для Каждого мЭлемент Из НастройкиКакСоответствие Цикл
		Настройки.Вставить(мЭлемент.Ключ, мЭлемент.Значение);
	КонецЦикла;

	Возврат Настройки;

КонецФункции

Функция ПрочитатьФайл(Знач Путь)

	Чтение = Новый ЧтениеТекста(Путь);
	Текст = Чтение.Прочитать();
	Чтение.Закрыть();

	Возврат Текст;

КонецФункции

Функция ПолучитьЗначение(ВходящаяСтруктура, Ключ, ЗначениеПоУмолчанию)

	Перем ЗначениеКлюча;

	Если Не ВходящаяСтруктура.Свойство(Ключ, ЗначениеКлюча) Тогда
		
		Возврат ЗначениеПоУмолчанию;
	
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(ЗначениеКлюча) Тогда
		Возврат ЗначениеПоУмолчанию;
	КонецЕсли;

	Возврат ЗначениеКлюча;

КонецФункции

Функция КонвертироватьЗначениеПриНеобходимости(Знач ЗначениеНастройки)
	Если ТипЗнч(ЗначениеНастройки) = Тип("Строка") Тогда
		ЗначениеНастройки = НРег(ЗначениеНастройки);
		Если ЗначениеНастройки = "false" или ЗначениеНастройки = "ложь" Тогда
			ЗначениеНастройки = Ложь;
		ИначеЕсли ЗначениеНастройки = "true" или ЗначениеНастройки = "истина" Тогда
			ЗначениеНастройки = Истина;
		ИначеЕсли ЗначениеНастройки = "неопределено" Тогда
			ЗначениеНастройки = Неопределено;
		КонецЕсли;
	КонецЕсли;
	Возврат ЗначениеНастройки;
КонецФункции

Функция КлючКонтекста()
	Возврат "ТестовыеНастройкиПриложенияОМП";
КонецФункции // КлючКонтекста()

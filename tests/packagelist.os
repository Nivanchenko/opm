﻿#Использовать asserts
#Использовать "../src/core"

Перем юТест;

Функция ПолучитьСписокТестов(Знач Тестирование) Экспорт
	
	юТест = Тестирование;
	
	СписокТестов = Новый Массив;
	
	СписокТестов.Добавить("ТестДолжен_ПолучитьПакетыХаба");
	СписокТестов.Добавить("ТестДолжен_ПроверитьРегистроНезависимостьПакетовХаба");

	Возврат СписокТестов;
	
КонецФункции

Процедура ПередЗапускомТеста() Экспорт
	// Завязаны на основной хаб.
	НастройкиOpm.СброситьНастройки();
	НастройкиOpm.ДобавитьСерверПакетов(СерверыПакетов.ОсновнойСервер());
КонецПроцедуры

Процедура ПослеЗапускаТеста() Экспорт
КонецПроцедуры

Функция ТестДолжен_ПолучитьПакетыХаба() Экспорт
	
	МенеджерПолучения = Новый МенеджерПолученияПакетов();
	СписокПакетовХаба = МенеджерПолучения.ПолучитьДоступныеПакеты();
	
	Ожидаем.Что(СписокПакетовХаба.Количество()).Больше(1);
	
	НайденПакет_gitsync = МенеджерПолучения.ПакетДоступен("gitsync");
	НайденПакет_opm = МенеджерПолучения.ПакетДоступен("opm");
	НайденНесуществующийПакет = МенеджерПолучения.ПакетДоступен("someelsepackadge");
	
	Ожидаем.Что(НайденПакет_gitsync).Равно(Истина);
	Ожидаем.Что(НайденПакет_opm).Равно(Истина);
	Ожидаем.Что(НайденНесуществующийПакет).Равно(Ложь);
	
КонецФункции

Функция ТестДолжен_ПроверитьРегистроНезависимостьПакетовХаба() Экспорт
	
	ИзмененноеИмяПакета = "PARSERFileV8i";

	МенеджерПолучения = Новый МенеджерПолученияПакетов();
	ПакетДоступен = МенеджерПолучения.ПакетДоступен(ИзмененноеИмяПакета);
	
	Ожидаем.Что(ПакетДоступен).Равно(Истина);

КонецФункции

﻿
#Область ПрограммныйИнтерфейс

// Возвращает все активные ПравилаЗаполнения, ПравилаПроверкиЗаполнения
// 
// Возвращаемое значение:
//  Массив - Массив ссылок Справочник.кзоПравилаЗаполнения, Справочник.кзоПравилаПроверкиЗаполнения
//
Функция ПолучитьВсеПравила() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПравилаЗаполнения.Ссылка КАК Правило
		|ИЗ
		|	Справочник.кзоПравилаЗаполнения КАК ПравилаЗаполнения
		|ГДЕ
		|	ПравилаЗаполнения.Активно
		|	И НЕ ПравилаЗаполнения.ПометкаУдаления
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ПравилаПроверкиЗаполнения.Ссылка
		|ИЗ
		|	Справочник.кзоПравилаПроверкиЗаполнения КАК ПравилаПроверкиЗаполнения
		|ГДЕ
		|	ПравилаПроверкиЗаполнения.Активно
		|	И НЕ ПравилаПроверкиЗаполнения.ПометкаУдаления";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Правило");
		
КонецФункции

// Выгружает массив ссылок в двоичные данные для сохранения в файл
//
// Параметры:
//  МассивСсылок - Массив	 - Массив ссылок Справочник.кзоПравилаЗаполнения, Справочник.кзоПравилаПроверкиЗаполнения
// 
// Возвращаемое значение:
//  ДвоичныеДанные - Данные для сохранения в файл методом ДвоичныеДанные.Записать(ИмяФайла)
//
Функция ВыгрузитьВДвоичныеДанные(МассивСсылок) Экспорт
	
	Поток = Новый ПотокВПамяти;
	
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.ОткрытьПоток(Поток);
	ЗаписьXML.ЗаписатьОбъявлениеXML();
	ЗаписьXML.ЗаписатьНачалоЭлемента("ПравилаЗаполнения");
	
	Для каждого Ссылка Из МассивСсылок Цикл
		СериализаторXDTO.ЗаписатьXML(ЗаписьXML, Ссылка.ПолучитьОбъект(), НазначениеТипаXML.Явное);
		
		Если ТипЗнч(Ссылка) = Тип("СправочникСсылка.кзоПравилаЗаполнения") Тогда			
			Для каждого Событие Из Ссылка.СобытияЭлементовФорм Цикл
				СериализаторXDTO.ЗаписатьXML(ЗаписьXML, Событие.СобытиеЭлементаФормы.ПолучитьОбъект(), НазначениеТипаXML.Явное);		
			КонецЦикла;			
		КонецЕсли;
	КонецЦикла;
	
	ЗаписьXML.ЗаписатьКонецЭлемента();
	ЗаписьXML.Закрыть();
	
	ДвоичныеДанные = Поток.ЗакрытьИПолучитьДвоичныеДанные();
	
	Возврат ДвоичныеДанные;
	
КонецФункции

// Загружает правила из двоичных данных и возвращает массив ссылок загруженных правил
//
// Параметры:
//  ДвоичныеДанные		 - ДвоичныеДанные	 - Двоичные данные файла с правилами, например ДвоичныеДанные = Новый ДвоичныеДанные(ИмяФайла)
//  ЗагружатьНеАктивными - Булево			 - Загружает правила и деактивирует их. Значение по-умолчанию: Ложь
// 
// Возвращаемое значение:
//  Массив - Массив ссылок загруженных правил Справочник.кзоПравилаЗаполнения, Справочник.кзоПравилаПроверкиЗаполнения
//
Функция ЗагрузитьИзДвоичныхДанных(ДвоичныеДанные, ЗагружатьНеАктивными = Ложь) Экспорт
	
	Поток = ДвоичныеДанные.ОткрытьПотокДляЧтения(); 
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.ОткрытьПоток(Поток);
	ЧтениеXML.Прочитать();
	
	Если ЧтениеXML.Имя <> "ПравилаЗаполнения" Тогда
		ВызватьИсключение "Не корректный файл";	
	КонецЕсли;
	
	МассивСсылок = Новый Массив;
	
	ЧтениеXML.Прочитать();
	Пока ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Цикл
		
		Если ЧтениеXML.Имя = "CatalogObject.кзоПравилаЗаполнения" 
			ИЛИ ЧтениеXML.Имя = "CatalogObject.кзоПравилаПроверкиЗаполнения"
			Тогда
			СправочникОбъект = СериализаторXDTO.ПрочитатьXML(ЧтениеXML);
			Если ЗагружатьНеАктивными Тогда
				СправочникОбъект.Активно = Ложь;
			КонецЕсли;
			
			СправочникОбъект.ОбменДанными.Загрузка = Истина;
			СправочникОбъект.Записать();
			
		ИначеЕсли ЧтениеXML.Имя = "CatalogObject.кзоСобытияЭлементовФорм" Тогда
			СправочникОбъект = СериализаторXDTO.ПрочитатьXML(ЧтениеXML);
			СправочникОбъект.ОбменДанными.Загрузка = Истина;
			СправочникОбъект.Записать();
			
		КонецЕсли;
		
		МассивСсылок.Добавить(СправочникОбъект.Ссылка);
	КонецЦикла;
	
	ЧтениеXML.Закрыть();
	
	Возврат МассивСсылок;
	
КонецФункции

#КонецОбласти

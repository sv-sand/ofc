﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

#Область ВыгрузкаДанныхДляСопоставления

// Параметры:
//   НастройкиВыгрузки - Структура - описание настроек выполнения операции.
//   ПараметрыОбработчика - Структура - вспомогательные параметры:
//     * ДополнительныеПараметры - Структура - произвольные дополнительные параметры.
//   ПродолжитьОжидание - Булево - Истина, если запущена длительная операция.
//
Процедура ПриНачалеВыгрузкиДанныхДляСопоставления(НастройкиВыгрузки, ПараметрыОбработчика, ПродолжитьОжидание) Экспорт
	
	КлючФоновогоЗадания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Выгрузка данных для сопоставления (%1)'"),
		НастройкиВыгрузки.Корреспондент);

	Если ЕстьАктивныеФоновыеЗадания(КлючФоновогоЗадания) Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Выгрузка данных для сопоставления для ""%1"" уже выполняется.'"),
			НастройкиВыгрузки.Корреспондент);
	КонецЕсли;
		
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("НастройкиВыгрузки", НастройкиВыгрузки);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(Новый УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Выгрузка данных для сопоставления (%1).'"),
		НастройкиВыгрузки.Корреспондент);
	ПараметрыВыполнения.КлючФоновогоЗадания = КлючФоновогоЗадания;
	ПараметрыВыполнения.ЗапуститьНеВФоне    = Ложь;
	ПараметрыВыполнения.ЗапуститьВФоне      = Истина;
	
	ФоновоеЗадание = ДлительныеОперации.ВыполнитьВФоне(
		"Обработки.ПомощникИнтерактивногоОбменаДаннымиВМоделиСервиса.ВыгрузитьДанныеДляСопоставления",
		ПараметрыПроцедуры,
		ПараметрыВыполнения);
		
	ПриНачалеДлительнойОперации(ФоновоеЗадание, ПараметрыОбработчика, ПродолжитьОжидание);
	
	Если Не ПродолжитьОжидание
		И Не ПараметрыОбработчика.Отказ Тогда
		ПараметрыОбработчика.ДополнительныеПараметры.Вставить("ФоновоеЗаданиеВыполнено");
		ПродолжитьОжидание = Истина;
	КонецЕсли;
	
	ПараметрыОбработчика.ДополнительныеПараметры.Вставить("НастройкиВыгрузки", НастройкиВыгрузки);
	
КонецПроцедуры

// Параметры:
//   ПараметрыОбработчика - Структура - вспомогательные параметры:
//     * ДополнительныеПараметры - Структура - произвольные дополнительные параметры.
//   ПродолжитьОжидание - Булево - Истина, если длительная операция еще не завершена.
// 
Процедура ПриОжиданииВыгрузкиДанныхДляСопоставления(ПараметрыОбработчика, ПродолжитьОжидание) Экспорт
	
	Если ПараметрыОбработчика.ДополнительныеПараметры.Свойство("ОжиданиеСессииПомещенияДанныхДляСопоставления") Тогда
		
		ПриОжиданииСессииОбменаСообщениямиСистемы(
			ПараметрыОбработчика.ДополнительныеПараметры.ПараметрыОбработчикаСессии, ПродолжитьОжидание);
			
	Иначе
		ЗаданиеВыполнено = Ложь;
		
		Если ПараметрыОбработчика.ДополнительныеПараметры.Свойство("ФоновоеЗаданиеВыполнено") Тогда
			ЗаданиеВыполнено = Истина;
		Иначе
			ПриОжиданииДлительнойОперации(ПараметрыОбработчика, ПродолжитьОжидание);
			
			ЗаданиеВыполнено = Не ПродолжитьОжидание И Не ПараметрыОбработчика.Отказ;
		КонецЕсли;
		
		Если ЗаданиеВыполнено Тогда
			
			Результат = ПолучитьИзВременногоХранилища(ПараметрыОбработчика.АдресРезультата);
	
			Если Результат.ДанныеВыгружены Тогда
				
				ПараметрыОбработчика.ДополнительныеПараметры.Вставить("ОжиданиеСессииПомещенияДанныхДляСопоставления");
				ПараметрыОбработчика.ДополнительныеПараметры.Вставить("ПараметрыОбработчикаСессии");
				
				ПриНачалеПомещенияДанныхДляСопоставления(ПараметрыОбработчика.ДополнительныеПараметры.НастройкиВыгрузки,
					ПараметрыОбработчика.ДополнительныеПараметры.ПараметрыОбработчикаСессии, ПродолжитьОжидание);
			Иначе
				
				ПараметрыОбработчика.Отказ = Истина;
				ПараметрыОбработчика.СообщениеОбОшибке = Результат.СообщениеОбОшибке;
				ПродолжитьОжидание = Ложь;
				
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Параметры:
//   ПараметрыОбработчика - Структура - вспомогательные параметры:
//     * ДополнительныеПараметры - Структура - произвольные дополнительные параметры.
//   СтатусЗавершения - Структура - описание результата выполнения операции.
//
Процедура ПриЗавершенииВыгрузкиДанныхДляСопоставления(ПараметрыОбработчика, СтатусЗавершения) Экспорт
	
	ИнициализироватьСтатусЗавершенияДлительнойОперации(СтатусЗавершения);
	
	Если ПараметрыОбработчика.Отказ Тогда
		ЗаполнитьЗначенияСвойств(СтатусЗавершения, ПараметрыОбработчика, "Отказ, СообщениеОбОшибке");
	Иначе
		ПараметрыОбработчикаСессии = ПараметрыОбработчика.ДополнительныеПараметры.ПараметрыОбработчикаСессии;
		
		Результат = Новый Структура;
		Результат.Вставить("ДанныеВыгружены",   Истина);
		Результат.Вставить("СообщениеОбОшибке", "");
		
		Если ПараметрыОбработчикаСессии.Отказ Тогда
			Результат.ДанныеВыгружены   = Ложь;
			Результат.СообщениеОбОшибке = ПараметрыОбработчикаСессии.СообщениеОбОшибке;
		КонецЕсли;
		
		СтатусЗавершения.Результат = Результат;
		
	КонецЕсли;
	
	ПараметрыОбработчика = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#Область ВыгрузкаЗагрузкаДанных

// Параметры:
//   НастройкиВыгрузки - Структура - описание настроек выполнения операции.
//   ПараметрыОбработчика - Структура - вспомогательные параметры:
//     * ДополнительныеПараметры - Структура - произвольные дополнительные параметры.
//   ПродолжитьОжидание - Булево - Истина, если запущена длительная операция.
//
Процедура ПриНачалеВыгрузкиДанных(НастройкиВыгрузки, ПараметрыОбработчика, ПродолжитьОжидание) Экспорт
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса") Тогда
		Возврат;
	КонецЕсли;
		
	МодульСообщенияВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("СообщенияВМоделиСервиса");
	
	ИнициализироватьПараметрыОбработчикаДлительнойОперации(ПараметрыОбработчика, Неопределено);
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	Попытка
		Сообщение = МодульСообщенияВМоделиСервиса.НовоеСообщение(
			СообщенияОбменаДаннымиУправлениеИнтерфейс.СообщениеПолучитьПараметрыУчетаКорреспондента());
			
		Сообщение.Body.ExchangePlan      = ОбменДаннымиПовтИсп.ПолучитьИмяПланаОбмена(НастройкиВыгрузки.Корреспондент);
		Сообщение.Body.CorrespondentCode = ОбменДаннымиСервер.ИдентификаторЭтогоУзлаДляОбмена(НастройкиВыгрузки.Корреспондент);
		
		Сообщение.Body.CorrespondentZone = НастройкиВыгрузки.ОбластьДанныхКорреспондента;
		
		ДополнительныеСвойства = Новый Структура;
		ДополнительныеСвойства.Вставить("Интерфейс", "3.0.1.1");
		
		Сообщение.AdditionalInfo = СериализаторXDTO.ЗаписатьXDTO(ДополнительныеСвойства);
	
		ПараметрыОбработчика.ИдентификаторОперации = ОбменДаннымиВМоделиСервиса.ОтправитьСообщение(Сообщение);
			
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		
		Информация = ИнформацияОбОшибке();
		
		ЗаписьЖурналаРегистрации(ОбменДаннымиВМоделиСервиса.СобытиеЖурналаРегистрацииМониторСинхронизацииДанных(),
			УровеньЖурналаРегистрации.Ошибка, , , ОбработкаОшибок.ПодробноеПредставлениеОшибки(Информация));
			
		ПараметрыОбработчика.Отказ = Истина;
		ПараметрыОбработчика.СообщениеОбОшибке = ОбработкаОшибок.КраткоеПредставлениеОшибки(Информация);
		ПараметрыОбработчика.ИдентификаторОперации = Неопределено;
	КонецПопытки;

	Если Не ПараметрыОбработчика.Отказ Тогда
		МодульСообщенияВМоделиСервиса.ДоставитьБыстрыеСообщения();
		ПараметрыОбработчика.ДополнительныеПараметры.Вставить("НастройкиВыгрузки",
			Новый ХранилищеЗначения(НастройкиВыгрузки, Новый СжатиеДанных));
		ПродолжитьОжидание = Истина;
	Иначе
		ПродолжитьОжидание = Ложь;
	КонецЕсли;
	
КонецПроцедуры

// Параметры:
//   ПараметрыОбработчика - Структура - вспомогательные параметры:
//     * ДополнительныеПараметры - Структура - произвольные дополнительные параметры.
//   ПродолжитьОжидание - Булево - Истина, если длительная операция еще не завершена.
//
Процедура ПриОжиданииВыгрузкиДанных(ПараметрыОбработчика, ПродолжитьОжидание) Экспорт
	
	Если ПараметрыОбработчика.ДополнительныеПараметры.Свойство("ОжиданиеСессииВыгрузкиЗагрузкиДанных") Тогда
		
		ПриОжиданииСессииОбменаСообщениямиСистемы(
			ПараметрыОбработчика.ДополнительныеПараметры.ПараметрыОбработчикаСессии, ПродолжитьОжидание);
	
	ИначеЕсли ПараметрыОбработчика.ДополнительныеПараметры.Свойство("ОжиданиеДлительнойОперацииВыгрузкиЗагрузкиДанных") Тогда
		
		ПараметрыОбработчикаДлительнойОперации = ПараметрыОбработчика.ДополнительныеПараметры.ПараметрыОбработчикаДлительнойОперации;
		
		ЗаданиеВыполнено = Ложь;
		
		Если ПараметрыОбработчика.ДополнительныеПараметры.Свойство("ФоновоеЗаданиеВыполнено") Тогда
			ЗаданиеВыполнено = Истина;
		Иначе
			ПриОжиданииДлительнойОперации(ПараметрыОбработчикаДлительнойОперации, ПродолжитьОжидание);
			
			ЗаданиеВыполнено = Не ПродолжитьОжидание И Не ПараметрыОбработчикаДлительнойОперации.Отказ;
		КонецЕсли;
		
		Если ЗаданиеВыполнено Тогда
			
			Результат = ПолучитьИзВременногоХранилища(ПараметрыОбработчикаДлительнойОперации.АдресРезультата);
			
			Если Результат.Свойство("ПараметрыОбработчикаСессии") Тогда
				
				ПараметрыОбработчика.ДополнительныеПараметры.Вставить("ОжиданиеСессииВыгрузкиЗагрузкиДанных");
				ПараметрыОбработчика.ДополнительныеПараметры.Вставить("ПараметрыОбработчикаСессии", Результат.ПараметрыОбработчикаСессии);
				
				ПродолжитьОжидание = Истина;
				
			Иначе
				
				ПродолжитьОжидание = Ложь;
				
			КонецЕсли;
			
		КонецЕсли;
			
	Иначе
			
		ПриОжиданииСессииОбменаСообщениямиСистемы(ПараметрыОбработчика, ПродолжитьОжидание);
		
		Если Не ПродолжитьОжидание
			И Не ПараметрыОбработчика.Отказ Тогда
			
			НастройкиВыгрузкиХранилище = Неопределено;
			ПараметрыОбработчика.ДополнительныеПараметры.Свойство("НастройкиВыгрузки", НастройкиВыгрузкиХранилище);
			НастройкиВыгрузки = НастройкиВыгрузкиХранилище.Получить();
			
			ПараметрыКорреспондента = Неопределено;
			
			УстановитьПривилегированныйРежим(Истина);
			Попытка
				ПараметрыКорреспондента = РегистрыСведений.СессииОбменаСообщениямиСистемы.ПолучитьДанныеСессии(
					ПараметрыОбработчика.ИдентификаторОперации).Получить();
			Исключение
				ПараметрыОбработчика.Отказ = Истина;
				ПараметрыОбработчика.СообщениеОбОшибке = ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
				ПараметрыОбработчика.ИдентификаторОперации = Неопределено;
				
				ЗаписьЖурналаРегистрации(ОбменДаннымиВМоделиСервиса.СобытиеЖурналаРегистрацииСинхронизацииДанных(),
					УровеньЖурналаРегистрации.Ошибка, , , ПараметрыОбработчика.СообщениеОбОшибке);
					
				ПродолжитьОжидание = Ложь;
				Возврат;
			КонецПопытки;
				
			ПараметрыИнформационнойБазы = Неопределено;	
			Если ПараметрыКорреспондента.Свойство("ПараметрыИнформационнойБазы", ПараметрыИнформационнойБазы) Тогда
				Если ПараметрыИнформационнойБазы.УзелСуществует Тогда
					Если ПараметрыИнформационнойБазы.Свойство("НастройкаСинхронизацииДанныхЗавершена")
						И Не ПараметрыИнформационнойБазы.НастройкаСинхронизацииДанныхЗавершена Тогда
						ПараметрыОбработчика.Отказ = Истина;
						ПараметрыОбработчика.СообщениеОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru = 'Перед запуском обмена данными завершите настройку синхронизации в программе ""%1"".'"),
							Строка(НастройкиВыгрузки.Корреспондент));
						ПродолжитьОжидание = Ложь;
						Возврат;
					КонецЕсли;
					
					Если ПараметрыИнформационнойБазы.Свойство("ПолученоСообщениеДляСопоставленияДанных")
						И ПараметрыИнформационнойБазы.ПолученоСообщениеДляСопоставленияДанных Тогда
						ПараметрыОбработчика.Отказ = Истина;
						ПараметрыОбработчика.СообщениеОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru = 'Перед запуском обмена данными завершите сопоставление данных в программе ""%1"".'"),
							Строка(НастройкиВыгрузки.Корреспондент));
						ПродолжитьОжидание = Ложь;
						Возврат;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			
			КлючФоновогоЗадания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Обмен данными (%1)'"),
				НастройкиВыгрузки.Корреспондент);

			Если ЕстьАктивныеФоновыеЗадания(КлючФоновогоЗадания) Тогда
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Обмен данными с ""%1"" уже выполняется.'"),
					НастройкиВыгрузки.Корреспондент);
			КонецЕсли;
				
			ПараметрыПроцедуры = Новый Структура;
			ПараметрыПроцедуры.Вставить("НастройкиВыгрузки", НастройкиВыгрузки);
			
			ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(Новый УникальныйИдентификатор);
			ПараметрыВыполнения.НаименованиеФоновогоЗадания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Обмен данными (%1).'"),
				НастройкиВыгрузки.Корреспондент);
			ПараметрыВыполнения.КлючФоновогоЗадания = КлючФоновогоЗадания;
			ПараметрыВыполнения.ЗапуститьНеВФоне    = Ложь;
			ПараметрыВыполнения.ЗапуститьВФоне      = Истина;
			
			ФоновоеЗадание = ДлительныеОперации.ВыполнитьВФоне(
				"Обработки.ПомощникИнтерактивногоОбменаДаннымиВМоделиСервиса.ВыгрузитьЗагрузитьДанныеПоТребованию",
				ПараметрыПроцедуры,
				ПараметрыВыполнения);
				
			ПараметрыОбработчикаДлительнойОперации = Неопределено;
			ПриНачалеДлительнойОперации(ФоновоеЗадание, ПараметрыОбработчикаДлительнойОперации, ПродолжитьОжидание);
				
			ПараметрыОбработчика.ДополнительныеПараметры.Вставить("ОжиданиеДлительнойОперацииВыгрузкиЗагрузкиДанных");
			ПараметрыОбработчика.ДополнительныеПараметры.Вставить("ПараметрыОбработчикаДлительнойОперации", ПараметрыОбработчикаДлительнойОперации);
			
			Если Не ПродолжитьОжидание
				И Не ПараметрыОбработчика.Отказ Тогда
				ПараметрыОбработчика.ДополнительныеПараметры.Вставить("ФоновоеЗаданиеВыполнено");
				ПродолжитьОжидание = Истина;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Параметры:
//   ПараметрыОбработчика - Структура - вспомогательные параметры:
//     * ДополнительныеПараметры - Структура - произвольные дополнительные параметры.
//   СтатусЗавершения - Структура - описание результата выполнения операции.
//
Процедура ПриЗавершенииВыгрузкиДанных(ПараметрыОбработчика, СтатусЗавершения) Экспорт
	
	ИнициализироватьСтатусЗавершенияДлительнойОперации(СтатусЗавершения);
	
	Если ПараметрыОбработчика.Отказ Тогда
		ЗаполнитьЗначенияСвойств(СтатусЗавершения, ПараметрыОбработчика, "Отказ, СообщениеОбОшибке");
	Иначе
		ПараметрыОбработчикаСессии = ПараметрыОбработчика.ДополнительныеПараметры.ПараметрыОбработчикаСессии;
		
		Результат = Новый Структура;
		Результат.Вставить("ДанныеВыгружены",   Истина);
		Результат.Вставить("СообщениеОбОшибке", "");
		
		Если ПараметрыОбработчикаСессии.Отказ Тогда
			Результат.ДанныеВыгружены   = Ложь;
			Результат.СообщениеОбОшибке = ПараметрыОбработчикаСессии.СообщениеОбОшибке;
		КонецЕсли;
		
		СтатусЗавершения.Результат = Результат;
		
	КонецЕсли;
	
	ПараметрыОбработчика = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область СессииОбменаСообщениями

Процедура ПриОжиданииСессииОбменаСообщениямиСистемы(ПараметрыОбработчика, ПродолжитьОжидание)
	
	СтатусСессии = "";
	Попытка
		СтатусСессии = СтатусСессии(ПараметрыОбработчика.ИдентификаторОперации);
	Исключение
		СообщениеОбОшибке = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ЗаписьЖурналаРегистрации(ОбменДаннымиВМоделиСервиса.СобытиеЖурналаРегистрацииМониторСинхронизацииДанных(),
			УровеньЖурналаРегистрации.Ошибка, , , СообщениеОбОшибке);
			
		ПараметрыОбработчика.Отказ = Истина;
		ПараметрыОбработчика.СообщениеОбОшибке = СообщениеОбОшибке;
		ПараметрыОбработчика.ИдентификаторОперации = Неопределено;
		
		ПродолжитьОжидание  = Ложь;
		Возврат;
	КонецПопытки;
	
	Если СтатусСессии = "Успешно" Тогда
		
		ПродолжитьОжидание = Ложь;
		
	ИначеЕсли СтатусСессии = "Ошибка" Тогда
		
		ПараметрыОбработчика.Отказ = Истина;
		ПараметрыОбработчика.ИдентификаторОперации = Неопределено;
		ПродолжитьОжидание  = Ложь;
		
	Иначе
		
		ПродолжитьОжидание = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

Функция СтатусСессии(Знач Сессия)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат РегистрыСведений.СессииОбменаСообщениямиСистемы.СтатусСессии(Сессия);
	
КонецФункции

#КонецОбласти

#Область РаботаСДлительнымиОперациями

// Для внутреннего использования.
//
Процедура ПриНачалеДлительнойОперации(ФоновоеЗадание, ПараметрыОбработчика, ПродолжитьОжидание = Истина)
	
	ИнициализироватьПараметрыОбработчикаДлительнойОперации(ПараметрыОбработчика, ФоновоеЗадание);
	
	Если ФоновоеЗадание.Статус = "Выполняется" Тогда
		ПараметрыОбработчика.АдресРезультата       = ФоновоеЗадание.АдресРезультата;
		ПараметрыОбработчика.ИдентификаторОперации = ФоновоеЗадание.ИдентификаторЗадания;
		ПараметрыОбработчика.ДлительнаяОперация    = Истина;
		
		ПродолжитьОжидание = Истина;
		Возврат;
	ИначеЕсли ФоновоеЗадание.Статус = "Выполнено" Тогда
		ПараметрыОбработчика.АдресРезультата    = ФоновоеЗадание.АдресРезультата;
		ПараметрыОбработчика.ДлительнаяОперация = Ложь;
		
		ПродолжитьОжидание = Ложь;
		Возврат;
	Иначе
		ПараметрыОбработчика.СообщениеОбОшибке = ФоновоеЗадание.КраткоеПредставлениеОшибки;
		Если ЗначениеЗаполнено(ФоновоеЗадание.ПодробноеПредставлениеОшибки) Тогда
			ПараметрыОбработчика.СообщениеОбОшибке = ФоновоеЗадание.ПодробноеПредставлениеОшибки;
		КонецЕсли;
		
		ПараметрыОбработчика.Отказ = Истина;
		ПараметрыОбработчика.ДлительнаяОперация = Ложь;
		
		ПродолжитьОжидание = Ложь;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

// Для внутреннего использования.
//
Процедура ПриОжиданииДлительнойОперации(ПараметрыОбработчика, ПродолжитьОжидание = Истина)
	
	Если ПараметрыОбработчика.Отказ
		Или Не ПараметрыОбработчика.ДлительнаяОперация Тогда
		ПродолжитьОжидание = Ложь;
		Возврат;
	КонецЕсли;
	
	ЗаданиеВыполнено = Ложь;
	Попытка
		ЗаданиеВыполнено = ДлительныеОперации.ЗаданиеВыполнено(ПараметрыОбработчика.ИдентификаторОперации);
	Исключение
		ПараметрыОбработчика.Отказ             = Истина;
		ПараметрыОбработчика.СообщениеОбОшибке = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ЗаписьЖурналаРегистрации(ОбменДаннымиСервер.СобытиеЖурналаРегистрацииСозданиеОбменаДанными(),
			УровеньЖурналаРегистрации.Ошибка, , , ПараметрыОбработчика.СообщениеОбОшибке);
	КонецПопытки;
		
	Если ПараметрыОбработчика.Отказ Тогда
		ПродолжитьОжидание = Ложь;
		Возврат;
	КонецЕсли;
	
	ПродолжитьОжидание = Не ЗаданиеВыполнено;
	
КонецПроцедуры

Процедура ИнициализироватьПараметрыОбработчикаДлительнойОперации(ПараметрыОбработчика, ФоновоеЗадание)
	
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("ФоновоеЗадание",          ФоновоеЗадание);
	ПараметрыОбработчика.Вставить("Отказ",                   Ложь);
	ПараметрыОбработчика.Вставить("СообщениеОбОшибке",       "");
	ПараметрыОбработчика.Вставить("ДлительнаяОперация",      Ложь);
	ПараметрыОбработчика.Вставить("ИдентификаторОперации",   Неопределено);
	ПараметрыОбработчика.Вставить("АдресРезультата",         Неопределено);
	ПараметрыОбработчика.Вставить("ДополнительныеПараметры", Новый Структура);
	
КонецПроцедуры

Функция ЕстьАктивныеФоновыеЗадания(КлючФоновогоЗадания)
	
	Отбор = Новый Структура;
	Отбор.Вставить("Ключ",      КлючФоновогоЗадания);
	Отбор.Вставить("Состояние", СостояниеФоновогоЗадания.Активно);
	
	АктивныеФоновыеЗадания = ФоновыеЗадания.ПолучитьФоновыеЗадания(Отбор);
	
	Возврат (АктивныеФоновыеЗадания.Количество() > 0);
	
КонецФункции

Процедура ИнициализироватьСтатусЗавершенияДлительнойОперации(СтатусЗавершения)
	
	СтатусЗавершения = Новый Структура;
	СтатусЗавершения.Вставить("Отказ",             Ложь);
	СтатусЗавершения.Вставить("СообщениеОбОшибке", "");
	СтатусЗавершения.Вставить("Результат",         Неопределено);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиФоновыхЗаданий

Процедура ВыгрузитьДанныеДляСопоставления(Параметры, АдресРезультата) Экспорт
	
	НастройкиВыгрузки = Неопределено;
	Параметры.Свойство("НастройкиВыгрузки", НастройкиВыгрузки);
	
	Результат = Новый Структура;
	Результат.Вставить("ДанныеВыгружены",   Истина);
	Результат.Вставить("СообщениеОбОшибке", "");
	
	Отказ = Ложь;
	Попытка
		ОбменДаннымиВМоделиСервиса.ВыполнитьВыгрузкуДанных(Отказ, НастройкиВыгрузки.Корреспондент);
	Исключение
		Результат.ДанныеВыгружены = Ложь;
		Результат.СообщениеОбОшибке = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ЗаписьЖурналаРегистрации(ОбменДаннымиВМоделиСервиса.СобытиеЖурналаРегистрацииНастройкаСинхронизацииДанных(),
			УровеньЖурналаРегистрации.Ошибка, , , Результат.СообщениеОбОшибке);
	КонецПопытки;
		
	Результат.ДанныеВыгружены = Результат.ДанныеВыгружены И Не Отказ;
	
	Если Не Результат.ДанныеВыгружены
		И ПустаяСтрока(Результат.СообщениеОбОшибке) Тогда
		Результат.СообщениеОбОшибке = НСтр("ru = 'При выполнении выгрузки данных для сопоставления возникли ошибки (см. Журнал регистрации).'");
	КонецЕсли;
	
	ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	
КонецПроцедуры

Процедура ВыгрузитьЗагрузитьДанныеПоТребованию(Параметры, АдресРезультата) Экспорт
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса") Тогда
		Возврат;
	КонецЕсли;
		
	МодульСообщенияВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("СообщенияВМоделиСервиса");
	
	НастройкиВыгрузки = Неопределено;
	Параметры.Свойство("НастройкиВыгрузки", НастройкиВыгрузки);
	
	ПараметрыОбработчикаСессии = Неопределено;
	ИнициализироватьПараметрыОбработчикаДлительнойОперации(ПараметрыОбработчикаСессии, Неопределено);
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	Попытка
		Если НастройкиВыгрузки.Свойство("ДополнениеВыгрузки") Тогда
			ЗарегистрироватьДанныеДополненияВыгрузки(НастройкиВыгрузки.ДополнениеВыгрузки);
		КонецЕсли;
		
		Сообщение = МодульСообщенияВМоделиСервиса.НовоеСообщение(
			СообщенияАдминистрированиеОбменаДаннымиУправлениеИнтерфейс.СообщениеПротолкнутьСинхронизациюДвухПриложений());
			
		Сообщение.Body.CorrespondentZone = НастройкиВыгрузки.ОбластьДанныхКорреспондента;
		
		ПараметрыОбработчикаСессии.ИдентификаторОперации = ОбменДаннымиВМоделиСервиса.ОтправитьСообщение(Сообщение);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		
		ПараметрыОбработчикаСессии.Отказ = Истина;
		ПараметрыОбработчикаСессии.СообщениеОбОшибке = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ЗаписьЖурналаРегистрации(ОбменДаннымиВМоделиСервиса.СобытиеЖурналаРегистрацииСинхронизацииДанных(),
			УровеньЖурналаРегистрации.Ошибка, , , ПараметрыОбработчикаСессии.СообщениеОбОшибке);
	КонецПопытки;
	
	Если Не ПараметрыОбработчикаСессии.Отказ Тогда
		МодульСообщенияВМоделиСервиса.ДоставитьБыстрыеСообщения();
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("ПараметрыОбработчикаСессии", ПараметрыОбработчикаСессии);
	
	ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	
КонецПроцедуры

#КонецОбласти

// Регистрирует дополнительные данные по настройкам
//
// Параметры:
//     ОбработкаВыгрузки - Структура
//                       - ОбработкаОбъект.ИнтерактивноеИзменениеВыгрузки - инициализированный объект.
//
Процедура ЗарегистрироватьДанныеДополненияВыгрузки(Знач ОбработкаВыгрузки)
	
	Если ТипЗнч(ОбработкаВыгрузки) = Тип("Структура") Тогда
		Обработка = Обработки.ИнтерактивноеИзменениеВыгрузки.Создать();
		ЗаполнитьЗначенияСвойств(Обработка, ОбработкаВыгрузки, , "ДополнительнаяРегистрация, ДополнительнаяРегистрацияСценарияУзла");
		
		Обработка.КомпоновщикОтбораВсехДокументов.ЗагрузитьНастройки(ОбработкаВыгрузки.КомпоновщикОтбораВсехДокументовНастройки);
	Иначе
		Обработка = ОбработкаВыгрузки;
	КонецЕсли;
	
	Если Обработка.ВариантВыгрузки <= 0 Тогда
		// Не добавлять
		Возврат;
		
	ИначеЕсли Обработка.ВариантВыгрузки = 1 Тогда
		// За период с отбором, очищаем дополнительную
		Обработка.ДополнительнаяРегистрация.Очистить();
		
	ИначеЕсли Обработка.ВариантВыгрузки = 2 Тогда
		// Детально настроено, очищаем общее
		Обработка.КомпоновщикОтбораВсехДокументов = Неопределено;
		Обработка.ПериодОтбораВсехДокументов      = Неопределено;
		
		ОбменДаннымиСервер.ЗаполнитьТаблицуЗначений(Обработка.ДополнительнаяРегистрация, ОбработкаВыгрузки.ДополнительнаяРегистрация);
		
	ИначеЕсли Обработка.ВариантВыгрузки = 3 Тогда
		// По сценарию узла, имитируем детальное.
		Обработка.ВариантВыгрузки = 2;
		
		Обработка.КомпоновщикОтбораВсехДокументов = Неопределено;
		Обработка.ПериодОтбораВсехДокументов      = Неопределено;
		
		ОбменДаннымиСервер.ЗаполнитьТаблицуЗначений(Обработка.ДополнительнаяРегистрация, ОбработкаВыгрузки.ДополнительнаяРегистрацияСценарияУзла);
		
	КонецЕсли;
	
	Обработка.ЗарегистрироватьДополнительныеИзменения();
	
КонецПроцедуры

Процедура ПриНачалеПомещенияДанныхДляСопоставления(НастройкиВыгрузки, ПараметрыОбработчика, ПродолжитьОжидание)
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса") Тогда
		Возврат;
	КонецЕсли;
		
	МодульСообщенияВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("СообщенияВМоделиСервиса");
	
	ИнициализироватьПараметрыОбработчикаДлительнойОперации(ПараметрыОбработчика, Неопределено);
	
	УстановитьПривилегированныйРежим(Истина);
	
	ИмяПланаОбмена = ОбменДаннымиПовтИсп.ПолучитьИмяПланаОбмена(НастройкиВыгрузки.Корреспондент);
	
	Если ОбменДаннымиПовтИсп.ЭтоПланОбменаXDTO(ИмяПланаОбмена) Тогда
		ПсевдонимПредопределенногоУзла = ОбменДаннымиСервер.ПсевдонимПредопределенногоУзла(НастройкиВыгрузки.Корреспондент);
	
		Если ЗначениеЗаполнено(ПсевдонимПредопределенногоУзла) Тогда
			// Требуется корректировка кода узла отправителя.
			КодЭтогоПриложения = СокрЛП(ПсевдонимПредопределенногоУзла);
		Иначе
			КодЭтогоПриложения = ОбменДаннымиСервер.ИдентификаторЭтогоУзлаДляОбмена(НастройкиВыгрузки.Корреспондент);
		КонецЕсли;
	Иначе
		КодЭтогоПриложения = ОбменДаннымиПовтИсп.ПолучитьКодЭтогоУзлаДляПланаОбмена(ИмяПланаОбмена);
	КонецЕсли;
	
	НачатьТранзакцию();
	Попытка
		// Отправляем сообщение корреспонденту.
		Сообщение = МодульСообщенияВМоделиСервиса.НовоеСообщение(
			СообщенияОбменаДаннымиУправлениеИнтерфейс.СообщениеЗагрузитьСообщениеОбмена());
			
		Сообщение.Body.CorrespondentZone = НастройкиВыгрузки.ОбластьДанныхКорреспондента;
		Сообщение.Body.ExchangePlan      = ИмяПланаОбмена;
		Сообщение.Body.CorrespondentCode = КодЭтогоПриложения;
		
		Сообщение.Body.MessageForDataMatching = Истина;
		
		ДополнительныеСвойства = Новый Структура;
		ДополнительныеСвойства.Вставить("Интерфейс", "3.0.1.1");
		ДополнительныеСвойства.Вставить("СообщениеДляСопоставленияДанных", Истина);
		
		Сообщение.AdditionalInfo = СериализаторXDTO.ЗаписатьXDTO(ДополнительныеСвойства);
		
		ПараметрыОбработчика.ИдентификаторОперации = ОбменДаннымиВМоделиСервиса.ОтправитьСообщение(Сообщение);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		
		Информация = ИнформацияОбОшибке();
		
		ЗаписьЖурналаРегистрации(ОбменДаннымиВМоделиСервиса.СобытиеЖурналаРегистрацииНастройкаСинхронизацииДанных(),
			УровеньЖурналаРегистрации.Ошибка, , , ОбработкаОшибок.ПодробноеПредставлениеОшибки(Информация));
			
		ПараметрыОбработчика.Отказ = Истина;
		ПараметрыОбработчика.СообщениеОбОшибке = ОбработкаОшибок.КраткоеПредставлениеОшибки(Информация);
		ПараметрыОбработчика.ИдентификаторОперации = Неопределено;
		
		ПродолжитьОжидание = Ложь;
		Возврат;
	КонецПопытки;
	
	МодульСообщенияВМоделиСервиса.ДоставитьБыстрыеСообщения();
	ПродолжитьОжидание = Истина;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
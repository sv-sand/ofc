﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем ПрограммноеЗакрытие;

&НаКлиенте
Перем НовыйЭлемент;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Администратор = Пользователи.ЭтоПолноправныйПользователь(, Истина);
	
	ПриСозданииЧтенииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриСозданииЧтенииНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СервисКриптографииDSSСлужебныйКлиент.ПриОткрытииФормы(ЭтотОбъект, ПрограммноеЗакрытие);
	НовыйЭлемент = НЕ ЗначениеЗаполнено(Объект.Ссылка);
	
	ИспользоватьДлительнуюОперацию();
	СформироватьНаименование();
	ЗаполнитьАдресаСервисов();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если СервисКриптографииDSSСлужебныйКлиент.ПередЗакрытиемФормы(
			ЭтотОбъект,
			Отказ,
			ПрограммноеЗакрытие,
			ЗавершениеРаботы) Тогда
		ЗакрытьФорму();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Изменен = Модифицированность;
	ПроверитьАдресаСервисов(Отказ);

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Если НовыйЭлемент Тогда
		ОповещениеСледующее = Новый ОписаниеОповещения("СоздатьНовуюУчетнуюЗапись", ЭтотОбъект);
		ПоказатьВопрос(ОповещениеСледующее, 
			НСтр("ru = 'Добавлена информация о новом сервере DSS.
			|Добавить новую учетную запись для этого сервера?'", 
			СервисКриптографииDSSСлужебныйКлиент.КодЯзыка()),
			РежимДиалогаВопрос.ДаНет,
			30);
	ИначеЕсли Изменен Тогда
		ОповещениеСледующее = Новый ОписаниеОповещения("ОбновитьПараметрСеанса", ЭтотОбъект);
		ПоказатьВопрос(ОповещениеСледующее, 
			НСтр("ru = 'Изменились настройки сервера DSS.
			|Необходимо полностью обновить сеансовые параметры.
			|Обновить?'", СервисКриптографииDSSСлужебныйКлиент.КодЯзыка()),
			РежимДиалогаВопрос.ДаНет,
			30);
	КонецЕсли;	
	
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	
	НовыйЭлемент = Ложь;
	Изменен = Ложь;
	ОтказОтПроверки = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура АдресСервераПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.АдресСервера) Тогда
		СформироватьНаименование();
		ПолучитьОписаниеСервиса(Ложь);
	КонецЕсли;
	
	ЗаполнитьАдресаСервисов();
	
КонецПроцедуры

&НаКлиенте
Процедура АдресСервераАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ДанныеВыбора = Неопределено;
	
	Если ЗначениеЗаполнено(Текст) Тогда
		НачалоАдреса = Сред(Текст, 1, 8);
		Если СтрНайти("https://", НачалоАдреса, , 1) = 0 
			И СтрНайти("http://", НачалоАдреса, , 1) = 0 Тогда
			ДанныеВыбора = Новый СписокЗначений;
			ДанныеВыбора.Добавить("https://" + Текст);
		КонецЕсли;	
	КонецЕсли;
	
	Если ДанныеВыбора <> Неопределено Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СервисПодписиПриИзменении(Элемент)
	
	СформироватьИдентификаторСЭП();
	
КонецПроцедуры

&НаКлиенте
Процедура СервисПодписиАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ДополнитьСписокСервером(Элемент, Текст, СтандартнаяОбработка, "SignServer");
	
КонецПроцедуры

&НаКлиенте
Процедура СервисПодписиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ПослеВыбораАдресаСервера(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СервисПроверкиАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)

	ДополнитьСписокСервером(Элемент, Текст, СтандартнаяОбработка, "Verify");
	
КонецПроцедуры

&НаКлиенте
Процедура СервисПроверкиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ПослеВыбораАдресаСервера(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СервисИдентификацииАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ДополнитьСписокСервером(Элемент, Текст, СтандартнаяОбработка, "STS");

КонецПроцедуры

&НаКлиенте
Процедура СервисИдентификацииОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ПослеВыбораАдресаСервера(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура АдресЛичногоКабинетаАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ДополнитьСписокСервером(Элемент, Текст, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура АдресЛичногоКабинетаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ПослеВыбораАдресаСервера(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СервисОбработкиДокументовОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ПослеВыбораАдресаСервера(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СервисОбработкиДокументовАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ДополнитьСписокСервером(Элемент, Текст, СтандартнаяОбработка, "DocumentStore");
	
КонецПроцедуры

&НаКлиенте
Процедура СервисАудитаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ПослеВыбораАдресаСервера(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СервисАудитаАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ДополнитьСписокСервером(Элемент, Текст, СтандартнаяОбработка, "AnalyticsService");
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура РасширенныеНастройки(Команда)
	
	ОповещениеСледующее = Новый ОписаниеОповещения("ПослеВыбораРасширенныхНастроек", ЭтотОбъект);
	
	МассивАвторизация = Новый Массив;
	
	Для Каждого СтрокаМассива Из Объект.ОграничениеАвторизации Цикл
		МассивАвторизация.Добавить(СтрокаМассива.СпособАвторизации);
	КонецЦикла;	
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТолькоПросмотр", ТолькоПросмотр);
	ПараметрыФормы.Вставить("СпособыАвторизации", МассивАвторизация);
	ПараметрыФормы.Вставить("ВерсияАПИ", Объект.ВерсияАПИ);
	ПараметрыФормы.Вставить("ТаймАут", Объект.ТаймАут);
	ПараметрыФормы.Вставить("Используется", Объект.Используется);
	ПараметрыФормы.Вставить("ШаблонПодтверждения", Объект.ШаблонПодтверждения);
	ПараметрыФормы.Вставить("Наименование", Объект.Наименование);
	ПараметрыФормы.Вставить("Заголовок", 
				?(ЗначениеЗаполнено(Объект.Ссылка), 
					СокрЛП(Объект.Ссылка), 
					НСтр("ru = 'новый элемент'", СервисКриптографииDSSСлужебныйКлиент.КодЯзыка())));
	
	ОткрытьФорму("Обработка.УправлениеПодключениемDSS.Форма.РасширенныеНастройкиСервера", ПараметрыФормы, ЭтотОбъект, , , , ОповещениеСледующее);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьИзФайла(Команда)
	
	ОписаниеСледующее 	= Новый ОписаниеОповещения("ПослеЗагрузкиФайлаНастроек", ЭтотОбъект);
	АдресФайла			= ПоместитьВоВременноеХранилище("", УникальныйИдентификатор);
	ПараметрыОперации	= СервисКриптографииDSSСлужебныйКлиент.ПодготовитьПараметрыОперации();
	
	СервисКриптографииDSSКлиент.ЗагрузитьДанныеИзФайла(ОписаниеСледующее, ".txt", АдресФайла, Истина, ПараметрыОперации);
	
КонецПроцедуры
	
&НаКлиенте
Процедура ПолучитьОписание(Команда)
	
	ПолучитьОписаниеСервиса();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ БСП

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура ПослеВыбораАдресаСервера(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ВыбранноеЗначение = Объект.АдресСервера + "/" Тогда
		СтандартнаяОбработка = Ложь;
		ТекущийЭлемент = Элемент;
		Элемент.ВыделенныйТекст = ВыбранноеЗначение;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьОписаниеСервиса(Интерактивно = Ложь)
	
	ОписаниеСледующее 	= Новый ОписаниеОповещения("ПолучитьОписаниеПослеПолучения", ЭтотОбъект);
	Если Интерактивно Тогда
		ПараметрыОперации	= СервисКриптографииDSSСлужебныйКлиент.ПодготовитьПараметрыОперации();
		СервисКриптографииDSSКлиент.ВыбратьНастройкиСервиса(ОписаниеСледующее, Объект.АдресСервера, ПараметрыОперации);
	Иначе
		ПараметрыОперации	= СервисКриптографииDSSСлужебныйКлиент.ПодготовитьПараметрыОперации(Ложь);
		ПараметрыОперации.Вставить("СинхронныйРежим", Ложь);		
		СервисКриптографииDSSКлиент.ПолучитьОписаниеСервиса(ОписаниеСледующее, Объект.АдресСервера, ПараметрыОперации);
	КонецЕсли;
	
	ИспользоватьДлительнуюОперацию(Истина);
	
КонецПроцедуры	
	
&НаКлиенте
Процедура ИспользоватьДлительнуюОперацию(Включить = Ложь)
	
	Элементы.ГруппаДлительнаяОперация.Видимость = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьСписок(СписокВыбора)
	
	Счетчик = СписокВыбора.Количество();
	
	Пока Счетчик > 1 Цикл
		СписокВыбора.Удалить(Счетчик - 1);
		Счетчик = Счетчик + 1;
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьНаименование()		
	
	АдресСервера	= Объект.АдресСервера;
	
	Если Объект.Наименование = ПрежнийСервер Тогда
		Объект.Наименование = АдресСервера;
	КонецЕсли;
	
	ПрежнийСервер = АдресСервера;
	
КонецПроцедуры	

&НаКлиенте
Процедура ЗаполнитьАдресаСервисов()
	
	АдресСервера = Объект.АдресСервера;
	Элементы.СервисИдентификации.СписокВыбора.Очистить();
	Элементы.СервисПодписи.СписокВыбора.Очистить();
	Элементы.СервисПроверки.СписокВыбора.Очистить();
	Элементы.АдресЛичногоКабинета.СписокВыбора.Очистить();
	Элементы.СервисАудита.СписокВыбора.Очистить();
	Элементы.СервисОбработкиДокументов.СписокВыбора.Очистить();
	
	Если ЗначениеЗаполнено(АдресСервера) Тогда
		
		ДополнитьСписокСервером(Элементы.СервисИдентификации, Объект.СервисИдентификации);
		ДополнитьСписокСервером(Элементы.СервисПодписи, Объект.СервисПодписи);
		ДополнитьСписокСервером(Элементы.СервисПроверки, Объект.СервисПроверки);
		ДополнитьСписокСервером(Элементы.АдресЛичногоКабинета, Объект.АдресЛичногоКабинета);
		
		ДополнитьСписокСервером(Элементы.СервисАудита, Объект.СервисАудита);
		ДополнитьСписокСервером(Элементы.СервисОбработкиДокументов, Объект.СервисОбработкиДокументов);
		
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(ПараметрЗакрытия = Неопределено)
	
	ПрограммноеЗакрытие = Истина;
	
	Если ПараметрЗакрытия = Неопределено Тогда
		ПараметрЗакрытия = СервисКриптографииDSSКлиент.ОтветСервисаПоУмолчанию(Изменен);
	КонецЕсли;
	
	Закрыть(ПараметрЗакрытия);
	
КонецПроцедуры

&НаКлиенте
Функция ВернутьПредставлениеАдреса(СписокВыбора, ТекущийАдрес)
	
	Результат = "";
	
	Если СписокВыбора.Количество() > 0 
		И СписокВыбора.НайтиПоЗначению(ТекущийАдрес) = Неопределено Тогда
		Для Счетчик = 1 По СписокВыбора.Количество() - 1 Цикл
			СтрокаСписка = СписокВыбора[Счетчик];
			Результат = Результат + СтрокаСписка.Значение;
			Прервать;
		КонецЦикла;	
	КонецЕсли;	
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ПроверитьАдресаСервисов(ОтказСобытия)
	
	Если ОтказСобытия Тогда
		Возврат;
	КонецЕсли;
	
	ТекстВопроса= "";
	Результат 	= Ложь;
	КодЯзыка	= СервисКриптографииDSSСлужебныйКлиент.КодЯзыка();
	
	Если НЕ ОтказОтПроверки И Модифицированность Тогда
		ПредставлениеОшибки = ВернутьПредставлениеАдреса(Элементы.СервисИдентификации.СписокВыбора, Объект.СервисИдентификации);
		Если ЗначениеЗаполнено(ПредставлениеОшибки) Тогда
			ТекстВопроса = ТекстВопроса 
							+ НСтр("ru = 'Рекомендуемый адрес ЦИ:'", КодЯзыка)
							+ Символы.ПС 
							+ ПредставлениеОшибки 
							+ Символы.ПС;
		КонецЕсли;	
		
		ПредставлениеОшибки = ВернутьПредставлениеАдреса(Элементы.СервисПодписи.СписокВыбора, Объект.СервисПодписи);
		Если ЗначениеЗаполнено(ПредставлениеОшибки) Тогда
			ТекстВопроса = ТекстВопроса 
							+ НСтр("ru = 'Рекомендуемый адрес СЭП:'", КодЯзыка) 
							+ Символы.ПС 
							+ ПредставлениеОшибки 
							+ Символы.ПС;
		КонецЕсли;	
		
		Если ИдВерсии > 1 Тогда
			ПредставлениеОшибки = ВернутьПредставлениеАдреса(Элементы.СервисОбработкиДокументов.СписокВыбора, Объект.СервисОбработкиДокументов);
			Если ЗначениеЗаполнено(ПредставлениеОшибки) Тогда
				ТекстВопроса = ТекстВопроса 
								+ НСтр("ru = 'Рекомендуемый адрес сервиса обработки документов:'", КодЯзыка) 
								+ Символы.ПС 
								+ ПредставлениеОшибки 
								+ Символы.ПС;
			КонецЕсли;	
			
			ПредставлениеОшибки = ВернутьПредставлениеАдреса(Элементы.СервисАудита.СписокВыбора, Объект.СервисАудита);
			Если ЗначениеЗаполнено(ПредставлениеОшибки) Тогда
				ТекстВопроса = ТекстВопроса 
								+ НСтр("ru = 'Рекомендуемый адрес сервиса аудита:'", КодЯзыка) 
								+ Символы.ПС 
								+ ПредставлениеОшибки 
								+ Символы.ПС;
			КонецЕсли;	
		КонецЕсли;
		
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(ТекстВопроса) Тогда
		ТекстВопроса = НСтр("ru = 'Обнаружено расхождение при заполнении настроек сервера.'", КодЯзыка) 
						+ Символы.ПС 
						+ ТекстВопроса 
						+ Символы.ПС + НСтр("ru = 'Продолжить?'", КодЯзыка);
		ОписаниеСледующее = Новый ОписаниеОповещения("ПроверкаАдресаСервисовОтвет", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеСледующее, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 30);
		Результат = Истина;
	КонецЕсли;
	
	ОтказСобытия = Результат;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьИдентификаторСЭП()
	
	СписокВыбора = Элементы.ИдентификаторСЭП.СписокВыбора;
	СписокВыбора.Очистить();
	
	ИдентификаторСервиса = СервисКриптографииDSSКлиент.СформироватьИдентификаторСЭП(Объект.СервисПодписи);
	Если ЗначениеЗаполнено(ИдентификаторСервиса) Тогда
		СписокВыбора.Добавить(ИдентификаторСервиса);
	КонецЕсли;	
	
	Элементы.ИдентификаторСЭП.КнопкаВыпадающегоСписка = СписокВыбора.Количество() > 0;
	
КонецПроцедуры	

&НаКлиенте
Процедура ДополнитьСписокСервером(Элемент, ТекстРедактирования, СтандартнаяОбработка = Неопределено, ТекстПодсказки = "")
	
	Если ПустаяСтрока(ТекстРедактирования) Тогда
		Возврат;
	КонецЕсли;
	
	НачалоСтроки = 0;
	КонецСтроки = 0;
	НачалоПозиции = 0;
	КонецПозиции = 0;
	Если СтандартнаяОбработка <> Неопределено Тогда
		Элемент.ПолучитьГраницыВыделения(НачалоСтроки, НачалоПозиции, КонецСтроки, КонецПозиции);
	КонецЕсли;
	АдресСервера = Объект.АдресСервера;
	
	Если ЗначениеЗаполнено(АдресСервера) Тогда
		Если Элемент.СписокВыбора.Количество() = 0 Тогда
			Элемент.СписокВыбора.Добавить("");
		КонецЕсли;
		
		ДлинаТекста = СтрДлина(ТекстРедактирования);
		Если СтрНайти(ТекстРедактирования, АдресСервера, , 1) = 0
			И СтрНайти(НРег(ТекстРедактирования), "http", , 1) = 0
			И НачалоПозиции > ДлинаТекста Тогда
			Элемент.СписокВыбора[0].Значение = АдресСервера + "/" + ТекстРедактирования;
		ИначеЕсли ЗначениеЗаполнено(ТекстПодсказки) И СтрНайти(ТекстРедактирования, ТекстПодсказки, , 1) = 0 Тогда
			Элемент.СписокВыбора[0].Значение = ТекстРедактирования + "/" + ТекстПодсказки;
		Иначе
			Элемент.СписокВыбора[0].Значение = ТекстРедактирования;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры						

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(КонтекстФормы)
	
	Элементы = КонтекстФормы.Элементы;
	ОбъектСправочника = КонтекстФормы.Объект;
	ЕстьДоступ = НЕ ЗначениеЗаполнено(ОбъектСправочника.ВнутреннийИдентификатор) ИЛИ КонтекстФормы.Администратор;
	
	КонтекстФормы.ТолькоПросмотр = НЕ ЕстьДоступ;
	
	Элементы.СервисИдентификации.КнопкаВыпадающегоСписка = Элементы.СервисИдентификации.СписокВыбора.Количество() > 0;
	Элементы.СервисПодписи.КнопкаВыпадающегоСписка = Элементы.СервисПодписи.СписокВыбора.Количество() > 0;
	Элементы.СервисПроверки.КнопкаВыпадающегоСписка = Элементы.СервисПроверки.СписокВыбора.Количество() > 0;
	Элементы.АдресЛичногоКабинета.КнопкаВыпадающегоСписка = Элементы.СервисПроверки.СписокВыбора.Количество() > 0;
	Элементы.СервисОбработкиДокументов.КнопкаВыпадающегоСписка = Элементы.СервисОбработкиДокументов.СписокВыбора.Количество() > 0;
	Элементы.СервисАудита.КнопкаВыпадающегоСписка = Элементы.СервисАудита.СписокВыбора.Количество() > 0;
	
	Элементы.ГруппаАудита.Видимость = КонтекстФормы.ИдВерсии > 1;
	Элементы.ГруппаОбработкиДокументов.Видимость = КонтекстФормы.ИдВерсии > 1;
	
КонецПроцедуры	

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()

	ПрежнийСервер = Объект.АдресСервера;
	ИдВерсии = СервисКриптографииDSSКлиентСервер.ИдентификаторВерсииСервера(Объект.ВерсияАПИ);
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры	

&НаСервере
Процедура ПриСменеВерсииАПИСервер()
	
	ИдВерсии = СервисКриптографииDSSКлиентСервер.ИдентификаторВерсииСервера(Объект.ВерсияАПИ);
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры	

&НаСервере
Процедура РазобратьФайлНастроек(АдресФайла)
	
	ДанныеФайла = ПолучитьИзВременногоХранилища(АдресФайла);
	ДанныеФайла	= ПолучитьСтрокуИзДвоичныхДанных(ДанныеФайла);
	НастройкиСервиса = СервисКриптографииDSSСлужебный.РазобратьФайлНастроекСервера(ДанныеФайла);
	
	Объект.АдресСервера = НастройкиСервиса.АдресСервера;
	Объект.СервисПодписи = НастройкиСервиса.СервисПодписи;
	Объект.СервисПроверки = НастройкиСервиса.СервисПроверки;
	Объект.СервисИдентификации = НастройкиСервиса.СервисИдентификации;
	Объект.СервисАудита = НастройкиСервиса.СервисАудита;
	Объект.СервисОбработкиДокументов = НастройкиСервиса.СервисОбработкиДокументов;
	Объект.ИдентификаторЦИ = НастройкиСервиса.ИдентификаторЦИ;
	Объект.ИдентификаторСЭП = НастройкиСервиса.ИдентификаторСЭП;
	Объект.ШаблонПодтверждения = НастройкиСервиса.ШаблонПодтверждения;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОбновитьНастройкиНаСервере(СсылкаСервера)
	
	СервисКриптографииDSSСлужебный.ЗаполнитьНастройкиПодключения(СсылкаСервера);
	
КонецПроцедуры	

#Область АсинхронныеВызовы

&НаКлиенте
Процедура СоздатьНовуюУчетнуюЗапись(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыбора = КодВозвратаДиалога.Да Тогда
		ПараметрыОперации = Новый Структура();
		ПараметрыОперации.Вставить("Основание", Объект.Ссылка);
		СервисКриптографииDSSКлиент.ОткрытьСведенияУчетнойЗаписи(Неопределено, Неопределено, ПараметрыОперации);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПараметрСеанса(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыбора = КодВозвратаДиалога.Да Тогда
		ОбновитьНастройкиНаСервере(Объект.Ссылка);
	КонецЕсли;
	
КонецПроцедуры	

// Параметры:
//  РезультатВызова				- Структура:
//    * Результат				- Структура:
//      ** СервисыСЭП 		- Массив из Структура:
//        *** АдресСервиса- Строка
//        *** Заголовок	- Строка
//      ** СервисыЦИ 		- Массив из Структура:
//        *** АдресСервиса- Строка
//        *** Заголовок	- Строка
//      ** СервисИдентификации- Строка
//      ** СервисПодписи	- Строка
//  ДополнительныеПараметры 	- Неопределено
//                          	- Структура
//
&НаКлиенте
Процедура ПолучитьОписаниеПослеПолучения(РезультатВызова, ДополнительныеПараметры) Экспорт
	
	ИспользоватьДлительнуюОперацию();
	ОчиститьСписок(Элементы.СервисИдентификации.СписокВыбора);
	ОчиститьСписок(Элементы.СервисПодписи.СписокВыбора);
	ОчиститьСписок(Элементы.СервисПроверки.СписокВыбора);
	
	Если РезультатВызова.Выполнено Тогда
		
		Если РезультатВызова.Результат.Свойство("СервисыСЭП") Тогда
			СписокВыбора = Элементы.СервисПодписи.СписокВыбора;
			Для каждого СтрокаМассива Из РезультатВызова.Результат.СервисыСЭП Цикл
				СписокВыбора.Добавить(СтрокаМассива.АдресСервиса, СтрокаМассива.Заголовок);
			КонецЦикла;
			
			СписокВыбора = Элементы.СервисИдентификации.СписокВыбора;
			Для каждого СтрокаМассива Из РезультатВызова.Результат.СервисыЦИ Цикл
				СписокВыбора.Добавить(СтрокаМассива.АдресСервиса, СтрокаМассива.Заголовок);
			КонецЦикла;
		Иначе	
			Объект.СервисИдентификации = РезультатВызова.Результат.СервисИдентификации;
			Объект.СервисПодписи = РезультатВызова.Результат.СервисПодписи;
		КонецЕсли;	
		
		УправлениеФормой(ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗагрузкиФайлаНастроек(РезультатВызова, ДополнительныеПараметры) Экспорт
	
	Если РезультатВызова.Выполнено Тогда
		РазобратьФайлНастроек(РезультатВызова.Результат.ДанныеФайла);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверкаАдресаСервисовОтвет(РезультатОтвета, ДополнительныеПараметры) Экспорт
	
	Если РезультатОтвета = КодВозвратаДиалога.Да Тогда
		ОтказОтПроверки = Истина;
		Записать();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораРасширенныхНастроек(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыбора.Выполнено Тогда
		Модифицированность = Истина;
		СмениласьВерсия = Объект.ВерсияАПИ <> РезультатВыбора.Результат.ВерсияАПИ;
		ЗаполнитьЗначенияСвойств(Объект, РезультатВыбора.Результат);
		Объект.ОграничениеАвторизации.Очистить();
		Для Каждого СтрокаМассива Из РезультатВыбора.Результат.СпособыАвторизации Цикл
			НоваяСтрока = Объект.ОграничениеАвторизации.Добавить();
			НоваяСтрока.СпособАвторизации = СтрокаМассива;
		КонецЦикла;
		
		Если СмениласьВерсия Тогда
			ПриСменеВерсииАПИСервер();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

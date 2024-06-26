﻿
#Область ПрограммныйИнтерфейс

// Создает данные формы для интеграции событий
//
// Параметры:
//  Форма	 - ФормаКлиентскогоПриложения	 -  Форма
// 
// Возвращаемое значение:
//  Структура - Данные формы
//
Функция СоздатьДанныеФормы(Форма) Экспорт

	ДанныеФормы = Новый Структура("Элементы", Новый Соответствие);
	
	Для каждого Элемент Из Форма.Элементы Цикл
		
		СтруктураЭлемента = Новый Структура();
		СтруктураЭлемента.Вставить("Тип", ТипЗнч(Элемент));
		СтруктураЭлемента.Вставить("Вид", "");
		СтруктураЭлемента.Вставить("Имя", Элемент.Имя);
		СтруктураЭлемента.Вставить("Заголовок", Элемент.Заголовок);
		СтруктураЭлемента.Вставить("ПутьКДанным", "");
		СтруктураЭлемента.Вставить("Обработчики", Новый Соответствие);
		
		Если СтруктураЭлемента.Тип = Тип("ПолеФормы") Тогда
			СтруктураЭлемента.Вид = ВидПоляФормыВСтроку(Элемент.Вид);
			СтруктураЭлемента.ПутьКДанным = Элемент.ПутьКДанным;
		КонецЕсли;
		
		МассивСобытий = кзоИнтеграция.ПолучитьПодключаемыеСобытияЭлементов();
		Для каждого ИмяСобытия Из МассивСобытий Цикл
			Если НЕ ДействиеПрименимоДляЭлемента(Элемент, ИмяСобытия) Тогда
				Продолжить;				
			КонецЕсли;	
			
			Если ИмяСобытия = "Команда" Тогда					
				Если ЗначениеЗаполнено(Элемент.ИмяКоманды) Тогда
					Команда = Форма.Команды.Найти(Элемент.ИмяКоманды);
					СтруктураЭлемента.Обработчики.Вставить(ИмяСобытия, Команда.Действие);
					
					Если НЕ ЗначениеЗаполнено(СтруктураЭлемента.Заголовок) Тогда
						СтруктураЭлемента.Заголовок = Команда.Заголовок;	
					КонецЕсли;
				КонецЕсли;
				
			Иначе
				СтруктураЭлемента.Обработчики.Вставить(ИмяСобытия, Элемент.ПолучитьДействие(ИмяСобытия));
			КонецЕсли;
		КонецЦикла;
		
		ДанныеФормы.Элементы.Вставить(Элемент.Имя, СтруктураЭлемента);
	КонецЦикла;
	
	Возврат ДанныеФормы;
	
КонецФункции

// Возвращает флаг применимости действия для элемента формы
//
// Параметры:
//  Элемент		 - ЭлементФормы	 - Элемент формы
//  ИмяСобытия	 - Строка		 - Событие
// 
// Возвращаемое значение:
//  Булево - Истина, если действие применимо
//
Функция ДействиеПрименимоДляЭлемента(Элемент, ИмяСобытия) Экспорт
	
	Результат = Ложь;
	
	Если ТипЗнч(Элемент) = Тип("ПолеФормы") Тогда
		Результат = ДействиеПрименимоДляПоляФормы(Элемент.Вид, ИмяСобытия);	
		
	ИначеЕсли ТипЗнч(Элемент) = Тип("КнопкаФормы") Тогда
		Результат = ДействиеПрименимоДляКнопкиФормы(ИмяСобытия);	
		
	КонецЕсли;
		
	Возврат Результат;
		
КонецФункции

// Возвращает флаг применимости действия для элемента формы типа "ПолеФормы" 
//
// Параметры:
//  ВидПоля		 - ВидПоляФормы	 - Вид элемента формы типа "ПолеФормы"
//  ИмяСобытия	 - Строка		 - Событие
// 
// Возвращаемое значение:
//  Булево - Истина, если действие применимо
//
Функция ДействиеПрименимоДляПоляФормы(ВидПоля, ИмяСобытия) Экспорт
	
	Результат = Ложь;
	
	Если ИмяСобытия = "ПриИзменении" Тогда
		Если ВидПоля = ВидПоляФормы.ПолеВвода
			ИЛИ ВидПоля = ВидПоляФормы.ПолеПереключателя
			ИЛИ ВидПоля = ВидПоляФормы.ПолеФлажка
			Тогда
			Результат = Истина;
		КонецЕсли;
	КонецЕсли;	
		
	Возврат Результат;
		
КонецФункции

// Возвращает флаг применимости действия для элемента формы типа "КнопкаФормы" 
//
// Параметры:
//  ИмяСобытия	 - Строка		 - Событие
// 
// Возвращаемое значение:
//  Булево - Истина, если действие применимо
//
Функция ДействиеПрименимоДляКнопкиФормы(ИмяСобытия) Экспорт
	
	Результат = Ложь;
	
	Если ИмяСобытия = "Команда" Тогда
		Результат = Истина;
	КонецЕсли;	
		
	Возврат Результат;
		
КонецФункции

#КонецОбласти

#Область Служебные

Функция ВидПоляФормыВСтроку(Вид)
	
	Соответствие = Новый Соответствие;
	
	Соответствие.Вставить(ВидПоляФормы.ПолеHTMLДокумента, "ПолеHTMLДокумента");
	Соответствие.Вставить(ВидПоляФормы.ПолеPDFДокумента, "ПолеPDFДокумента");
	Соответствие.Вставить(ВидПоляФормы.ПолеВвода, "ПолеВвода");
	Соответствие.Вставить(ВидПоляФормы.ПолеГеографическойСхемы, "ПолеГеографическойСхемы");
	Соответствие.Вставить(ВидПоляФормы.ПолеГрафическойСхемы, "ПолеГрафическойСхемы");
	Соответствие.Вставить(ВидПоляФормы.ПолеДендрограммы, "ПолеДендрограммы");
	Соответствие.Вставить(ВидПоляФормы.ПолеДиаграммы, "ПолеДиаграммы");
	Соответствие.Вставить(ВидПоляФормы.ПолеДиаграммыГанта, "ПолеДиаграммыГанта");
	Соответствие.Вставить(ВидПоляФормы.ПолеИндикатора, "ПолеИндикатора");
	Соответствие.Вставить(ВидПоляФормы.ПолеКалендаря, "ПолеКалендаря");
	Соответствие.Вставить(ВидПоляФормы.ПолеКартинки, "ПолеКартинки");
	Соответствие.Вставить(ВидПоляФормы.ПолеНадписи, "ПолеНадписи");
	Соответствие.Вставить(ВидПоляФормы.ПолеПереключателя, "ПолеПереключателя");
	Соответствие.Вставить(ВидПоляФормы.ПолеПериода, "ПолеПериода");
	Соответствие.Вставить(ВидПоляФормы.ПолеПланировщика, "ПолеПланировщика");
	Соответствие.Вставить(ВидПоляФормы.ПолеПолосыРегулирования, "ПолеПолосыРегулирования");
	Соответствие.Вставить(ВидПоляФормы.ПолеТабличногоДокумента, "ПолеТабличногоДокумента");
	Соответствие.Вставить(ВидПоляФормы.ПолеТекстовогоДокумента, "ПолеТекстовогоДокумента");
	Соответствие.Вставить(ВидПоляФормы.ПолеФлажка, "ПолеФлажка");
	Соответствие.Вставить(ВидПоляФормы.ПолеФорматированногоДокумента, "ПолеФорматированногоДокумента");
	
	Возврат Соответствие.Получить(Вид);
		
КонецФункции

#КонецОбласти
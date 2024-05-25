﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Позволяет настроить общие параметры подсистемы.
//
// Параметры:
//  ОбщиеПараметры - Структура:
//      * ИмяФормыПерсональныхНастроек            - Строка - имя формы для редактирования персональных настроек.
//      * ЗапрашиватьПодтверждениеПриЗавершенииПрограммы - Булево - по умолчанию Истина. Если установить в Ложь, то 
//                                                                  подтверждение при завершении работы программы не
//                                                                  будет запрашиваться,  если явно не разрешить в
//                                                                  персональных настройках программы.
//
//      * МинимальнаяВерсияПлатформы - Строка - минимальная версии платформы, требуемая для запуска программы.
//                                              Запуск программы на версии платформы ниже указанной будет невозможен.
//                                              Например, "8.3.6.1650".
//                                              Допускается указание нескольких версий платформы через точку с запятой.
//                                              В этом случае минимальная версия платформы будет выбрана, исходя из
//                                              фактически используемой.
//                                              Например, "8.3.14.1694; 8.3.15.2107; 8.3.16.1791" - при запуске
//                                              на предыдущих релизах 8.3.14 будет предложено перейти на 8.3.14.1694,
//                                              при запуске на 8.3.15 - 8.3.15.2107, и 8.3.16 - 8.3.16.1791, соответственно.
//
//      * РекомендуемаяВерсияПлатформы            - Строка - рекомендуемая версия платформы для запуска программы.
//                                                           Например, "8.3.8.2137".
//                                                           Допускается указание нескольких версий платформы через
//                                                           точку с запятой. См. пример в параметре МинимальнаяВерсияПлатформы.
//      * ОтключитьИдентификаторыОбъектовМетаданных - Булево - отключает заполнение справочников ИдентификаторыОбъектовМетаданных
//              и ИдентификаторыОбъектовРасширений, процедуру выгрузки и загрузки в узлах РИБ.
//              Для частичного встраивания отдельных функций библиотеки в конфигурации без постановки на поддержку.
//      * РекомендуемыйОбъемОперативнойПамяти - Число - объем памяти в гигабайтах, рекомендуемый для комфортной работы в
//                                                      программе. По умолчанию 4 Гб.
//
//    Устарели, следует использовать свойства МинимальнаяВерсияПлатформы и РекомендуемаяВерсияПлатформы:
//      * МинимальноНеобходимаяВерсияПлатформы    - Строка - полный номер версии платформы для запуска программы.
//                                                           Например, "8.3.4.365".
//                                                           Ранее определялись в
//                                                           ОбщегоНазначенияПереопределяемый.ПолучитьМинимальноНеобходимуюВерсиюПлатформы.
//      * РаботаВПрограммеЗапрещена               - Булево - начальное значение Ложь.
//
Процедура ПриОпределенииОбщихПараметровБазовойФункциональности(ОбщиеПараметры) Экспорт
	
	
	
КонецПроцедуры

// Определяет соответствие имен параметров сеанса и обработчиков для их установки.
// Вызывается для инициализации параметров сеанса из обработчика события модуля сеанса УстановкаПараметровСеанса
// (подробнее о нем см. синтакс-помощник).
//
// В указанных модулях должна быть размещена процедура обработчика, в которую передаются параметры:
//  ИмяПараметра           - Строка - имя параметра сеанса, который требуется установить.
//  УстановленныеПараметры - Массив - имена параметров, которые уже установлены.
// 
// Далее пример процедуры обработчика для копирования в указанные модули.
//
//// Параметры:
////  ИмяПараметра  - Строка
////  УстановленныеПараметры - Массив из Строка
////
//Процедура УстановкаПараметровСеанса(ИмяПараметра, УстановленныеПараметры) Экспорт
//	
//  Если ИмяПараметра = "ТекущийПользователь" Тогда
//		ПараметрыСеанса.ТекущийПользователь = Значение;
//		УстановленныеПараметры.Добавить("ТекущийПользователь");
//  КонецЕсли;
//	
//КонецПроцедуры
//
// Параметры:
//  Обработчики - Соответствие из КлючИЗначение:
//    * Ключ     - Строка - в формате "<ИмяПараметраСеанса>|<НачалоИмениПараметраСеанса*>".
//                   Символ '*'используется в конце имени параметра сеанса и обозначает,
//                   что один обработчик будет вызван для инициализации всех параметров сеанса
//                   с именем, начинающимся на слово НачалоИмениПараметраСеанса.
//
//    * Значение - Строка - в формате "<ИмяМодуля>.УстановкаПараметровСеанса".
//
//  Пример:
//   Обработчики.Вставить("ТекущийПользователь", "ПользователиСлужебный.УстановкаПараметровСеанса");
//
Процедура ПриДобавленииОбработчиковУстановкиПараметровСеанса(Обработчики) Экспорт
	
	
	
КонецПроцедуры

// Позволяет задать значения параметров, необходимых для работы клиентского кода
// при запуске конфигурации (в обработчиках событий ПередНачаломРаботыСистемы и ПриНачалеРаботыСистемы) 
// без дополнительных серверных вызовов. 
// Для получения значений этих параметров из клиентского кода
// см. СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске.
//
// Важно: недопустимо использовать команды сброса кэша повторно используемых модулей, 
// иначе запуск может привести к непредсказуемым ошибкам и лишним серверным вызовам.
//
// Параметры:
//   Параметры - Структура - имена и значения параметров работы клиента при запуске, которые необходимо задать.
//                           Для установки параметров работы клиента при запуске:
//                           Параметры.Вставить(<ИмяПараметра>, <код получения значения параметра>);
//
Процедура ПриДобавленииПараметровРаботыКлиентаПриЗапуске(Параметры) Экспорт
	
	
	
КонецПроцедуры

// Позволяет задать значения параметров, необходимых для работы клиентского кода
// конфигурации без дополнительных серверных вызовов.
// Для получения этих параметров из клиентского кода
// см. СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента.
//
// Параметры:
//   Параметры - Структура - имена и значения параметров работы клиента, которые необходимо задать.
//                           Для установки параметров работы клиента:
//                           Параметры.Вставить(<ИмяПараметра>, <код получения значения параметра>);
//
Процедура ПриДобавленииПараметровРаботыКлиента(Параметры) Экспорт
	
	
	
КонецПроцедуры

// Позволяет выполнить специальные минимальные быстрые действия перед запуском сеанса программы,
// которые невозможно выполнить на более позднем этапе. Например, настроить начальную страницу и
// другие параметры интерфейса в зависимости от режима работы.
//
// Следует вписывать вызовы в этот обработчик вместо обработчика события платформы
// УстановкаПараметровСеанса в модуле сеанса с проверкой ИменаПараметровСеанса = Неопределено.
// Вызов производится в привилегированном режиме, который устанавливает платформа перед
// вызовом обработчика события УстановкаПараметровСеанса.
//
// Вызывается после проверки минимальной версии платформы, заданной в процедуре
// ОбщегоНазначенияПереопределяемый.ПриОпределенииОбщихПараметровБазовойФункциональности.
// 
// Для повышения производительности не вызывается из сеансов фоновых заданий,
// кроме случая когда имя метода фонового задания указано в одном из регламентных заданий.
//
// Для проверки, что запускается клиентский сеанс следует использовать быстрое условие
// ТекущийРежимЗапуска() <> Неопределено, для проверки других видов сеанса следует использовать
// условие ПолучитьТекущийСеансИнформационнойБазы().ИмяПриложения = "<имя>", например WSConnection.
// Для определения регламентного задания следует использовать имя BackgroundJob, так как из
// сеансов фоновых заданий этот обработчик не вызывается.
// 
Процедура ПередЗапускомПрограммы() Экспорт

КонецПроцедуры

// Определяет объекты метаданных и отдельные реквизиты, которые исключаются из результатов поиска ссылок,
// не учитываются при монопольном удалении помеченных, замене ссылок и в отчете по местам использования.
// См. также ОбщегоНазначения.ИсключенияПоискаСсылок.
//
// Пример задачи: к документу "Реализация товаров и услуг" подключены подсистемы "Версионирование объектов" и "Свойства".
// Также этот документ может быть указан в других объектах метаданных - документах или регистрах.
// Часть ссылок имеют значение для бизнес-логики (например движения по регистрам) и должны выводиться пользователю.
// Другая часть ссылок - "техногенные" (ссылки на документ из данных подсистем "Версионирование объектов" и "Свойства")
// и должны скрываться от пользователя при удалении, анализе мест использования или запретов редактирования ключевых реквизитов.
// Список таких "техногенных" объектов нужно перечислить в этой процедуре.
//
// При этом для избежания появления ссылок на несуществующие объекты
// рекомендуется предусмотреть процедуру очистки указанных объектов метаданных.
//   * Для измерений регистров сведений - с помощью установки флажка "Ведущее",
//     тогда запись регистра сведений будет удалена вместе с удалением ссылки, указанной в измерении.
//   * Для других реквизитов указанных объектов - с помощью подписки на событие ПередУдалением всех типов объектов
//     метаданных, которые могут быть записаны в реквизиты указанных объектов метаданных.
//     В обработчике необходимо найти "техногенные" объекты, в реквизитах которых указана ссылка удаляемого объекта,
//     и выбрать, как именно очищать ссылку: очищать значение реквизита, удалять строку таблицы или удалять весь объект.
// Подробнее см. в документации к подсистеме "Удаление помеченных объектов".
//
// При исключении регистров допустимо исключать только Измерения.
// При необходимости исключить из поиска значения в ресурсах
// или в реквизитах регистров требуется исключить регистр целиком.
//
// Параметры:
//   ИсключенияПоискаСсылок - Массив - объекты метаданных или их реквизиты (ОбъектМетаданных, Строка),
//       которые не должно учитываться в бизнес-логике.
//       Стандартные реквизиты и табличные части могут быть указаны только в виде строковых имен (см. пример ниже).
//
// Пример:
//   ИсключенияПоискаСсылок.Добавить(Метаданные.РегистрыСведений.ВерсииОбъектов);
//   ИсключенияПоискаСсылок.Добавить(Метаданные.РегистрыСведений.ВерсииОбъектов.Измерения.Объект);
//   ИсключенияПоискаСсылок.Добавить("ПланВидовРасчета._ДемоОсновныеНачисления.СтандартнаяТабличнаяЧасть.БазовыеВидыРасчета.СтандартныйРеквизит.ВидРасчета");
//
Процедура ПриДобавленииИсключенийПоискаСсылок(ИсключенияПоискаСсылок) Экспорт
	
	
	
КонецПроцедуры

// Позволяет задать список подчиненных объектов и их связи с основными объектами.
// Подчиненные объекты рекомендуется использовать, если в процессе замены ссылок
// нужно создавать часть объектов или подбирать замену из существующих объектов.
//
// Параметры:
//  ПодчиненныеОбъекты - см. ОбщегоНазначения.ПодчиненныеОбъекты
//
// Пример:
//	СвязиПодчиненногоОбъекта = Новый Соответствие;
//	СвязиПодчиненногоОбъекта.Вставить("ПолеСвязи");
//	ПодчиненныйОбъект = ПодчиненныеОбъекты.Добавить();
//	ПодчиненныйОбъект.ПодчиненныйОбъект = Метаданные.Справочники.<ПодчиненныйСправочник>;
//	ПодчиненныйОбъект.ПоляСвязей = СвязиПодчиненногоОбъекта;
//	ПодчиненныйОбъект.ВыполнятьАвтоматическийПоискЗаменСсылок = Истина;
//
//	СвязиПодчиненногоОбъекта = Новый Массив;
//	СвязиПодчиненногоОбъекта.Вставить("ПолеСвязи");
//	ПодчиненныйОбъект = ПодчиненныеОбъекты.Добавить();
//	ПодчиненныйОбъект.ПодчиненныйОбъект = Метаданные.Справочники.<ПодчиненныйСправочник>;
//	ПодчиненныйОбъект.ПоляСвязей = СвязиПодчиненногоОбъекта;
//	ПодчиненныйОбъект.ВыполнятьАвтоматическийПоискЗаменСсылок = Истина;
//
//	ПодчиненныйОбъект = ПодчиненныеОбъекты.Добавить();
//	ПодчиненныйОбъект.ПодчиненныйОбъект = Метаданные.Справочники.<ПодчиненныйСправочник>;
//	ПодчиненныйОбъект.ПоляСвязей = "ПолеСвязи";
//	ПодчиненныйОбъект.ПриПоискеЗаменыСсылок = "<ОбщийМодуль>";
// 	
Процедура ПриОпределенииПодчиненныхОбъектов(ПодчиненныеОбъекты) Экспорт

	

КонецПроцедуры

// Выполняется после замены ссылок перед непосредственным удалением объектов.
// 
// Параметры:
//  Результат - см. ОбщегоНазначения.ЗаменитьСсылки
//  ПараметрыВыполнения - см. ОбщегоНазначения.ПараметрыЗаменыСсылок
//  ТаблицаПоиска - см. ОбщегоНазначения.МестаИспользования
//
Процедура ПослеЗаменыСсылок(Результат, ПараметрыВыполнения, ТаблицаПоиска) Экспорт

	

КонецПроцедуры

// Вызывается при обновлении информационной базы для учета переименований подсистем и ролей в конфигурации.
// В противном случае, возникнет рассинхронизация между метаданными конфигурации и 
// элементами справочника ИдентификаторыОбъектовМетаданных, что приведет к различным ошибкам при работе конфигурации.
// См. также ОбщегоНазначения.ИдентификаторОбъектаМетаданных, ОбщегоНазначения.ИдентификаторыОбъектовМетаданных.
//
// В этой процедуре последовательно для каждой версии конфигурации задаются переименования только подсистем и ролей, 
// а переименования остальных объектов метаданных задавать не следует, т.к. они обрабатываются автоматически.
//
// Параметры:
//  Итог - ТаблицаЗначений - таблица переименований, которую требуется заполнить.
//                           См. ОбщегоНазначения.ДобавитьПереименование.
//
// Пример:
//	ОбщегоНазначения.ДобавитьПереименование(Итог, "2.1.2.14",
//		"Подсистема._ДемоПодсистемы",
//		"Подсистема._ДемоСервисныеПодсистемы");
//
Процедура ПриДобавленииПереименованийОбъектовМетаданных(Итог) Экспорт
	
	
	
КонецПроцедуры

// Позволяет отключать подсистемы, например, для целей тестирования.
// Если подсистема отключена, то функции ОбщегоНазначения.ПодсистемаСуществует и 
// ОбщегоНазначенияКлиент.ПодсистемаСуществует вернут Ложь.
//
// В реализации этой процедуры нельзя использовать функцию ОбщегоНазначения.ПодсистемаСуществует, 
// т.к. это приводит к рекурсии.
//
// Параметры:
//   ОтключенныеПодсистемы - Соответствие из КлючИЗначение:
//     * Ключ - Строка - имя отключаемой подсистемы
//     * Значение - Булево - Истина
//
Процедура ПриОпределенииОтключенныхПодсистем(ОтключенныеПодсистемы) Экспорт
	
	
	
КонецПроцедуры

// Вызывается перед загрузкой приоритетных данных в подчиненном узле РИБ
// и предназначена для заполнения настроек размещения сообщения обмена данными или
// для реализации нестандартной загрузки приоритетных данных из главного узла РИБ.
//
// К приоритетным данным относятся предопределенные элементы, а также
// элементы справочника ИдентификаторыОбъектовМетаданных.
//
// Параметры:
//  СтандартнаяОбработка - Булево - начальное значение Истина; если установить Ложь, 
//                то стандартная загрузка приоритетных данных с помощью подсистемы
//                ОбменДанными будет пропущена (так же будет и в том случае,
//                если подсистемы ОбменДанными нет в конфигурации).
//
Процедура ПередЗагрузкойПриоритетныхДанныхВПодчиненномРИБУзле(СтандартнаяОбработка) Экспорт
	
	
	
КонецПроцедуры

// Определяет список версий программных интерфейсов, доступных через web-сервис InterfaceVersion.
//
// Параметры:
//  ПоддерживаемыеВерсии - Структура - в ключе указывается имя программного интерфейса,
//                                     а в значениях - массив строк с поддерживаемыми версиями этого интерфейса.
//
// Пример:
//
//  // СервисПередачиФайлов
//  Версии = Новый Массив;
//  Версии.Добавить("1.0.1.1");
//  Версии.Добавить("1.0.2.1"); 
//  ПоддерживаемыеВерсии.Вставить("СервисПередачиФайлов", Версии);
//  // Конец СервисПередачиФайлов
//
Процедура ПриОпределенииПоддерживаемыхВерсийПрограммныхИнтерфейсов(ПоддерживаемыеВерсии) Экспорт
	
КонецПроцедуры

// Задает параметры функциональных опций, действие которых распространяется на командный интерфейс и рабочий стол.
// Например, если значения функциональной опции хранятся в ресурсах регистра сведений,
// то параметры функциональных опций могут определять условия отборов по измерениям регистра,
// которые будут применяться при чтении значения этой функциональной опции.
//
// См. в синтакс-помощнике методы ПолучитьФункциональнуюОпциюИнтерфейса,
// УстановитьПараметрыФункциональныхОпцийИнтерфейса и ПолучитьПараметрыФункциональныхОпцийИнтерфейса.
//
// Параметры:
//   ОпцииИнтерфейса - Структура - значения параметров функциональных опций, установленных для командного интерфейса.
//       Ключ элемента структуры определяет имя параметра, а значение элемента - текущее значение параметра.
//
Процедура ПриОпределенииПараметровФункциональныхОпцийИнтерфейса(ОпцииИнтерфейса) Экспорт
	
КонецПроцедуры


// Вызывается при запуске сеанса для получения списка оповещений
// которые необходимо отправить с сервера на клиент (из регламентного задания).
// Смотри СтандартныеПодсистемыСервер.ПриОтправкеСерверногоОповещения
// и СтандартныеПодсистемыКлиент.ПриПолученииСерверногоОповещения.
//
// Параметры:
//  Оповещения - Соответствие из КлючИЗначение:
//   * Ключ     - Строка - смотри СерверныеОповещения.НовоеСерверноеОповещение.Имя
//   * Значение - см. СерверныеОповещения.НовоеСерверноеОповещение
//
// Пример:
//	Оповещение = СерверныеОповещения.НовоеСерверноеОповещение(
//		"СтандартныеПодсистемы.ЗавершениеРаботыПользователей.БлокировкаСеансов");
//	Оповещение.ИмяМодуляОтправки  = "СоединенияИБ";
//	Оповещение.ИмяМодуляПолучения = "СоединенияИБКлиент";
//	Оповещение.ПериодПроверки = 300;
//	
//	Оповещения.Вставить(Оповещение.Имя, Оповещение);
//
Процедура ПриДобавленииСерверныхОповещений(Оповещения) Экспорт
	
КонецПроцедуры

// Вызывается из глобального обработчика ожидания по необходимости, но не чаще раза в 60 сек,
// для получения данных с клиента, а также возврате результата на клиент, если нужно.
// Например, для передачи статистики о количестве открытых окон и
// возврате признака дальнейшей передачи статистики с клиента на сервер.
//
// Для получения данных клиента на сервере они должны быть заполнены в параметре Параметры процедуры
// ОбщегоНазначенияКлиентПереопределяемый.ПередПериодическойОтправкойДанныхКлиентаНаСервер.
//
// Для возврата данных с сервера на клиент заполните параметр Результаты,
// который затем будет передан в процедуру
// ОбщегоНазначенияКлиентПереопределяемый.ПослеПериодическогоПолученияДанныхКлиентаНаСервере.
//
// Параметры:
//  Параметры - Соответствие из КлючИЗначение:
//    * Ключ     - Строка       - имя параметра, полученного с клиента.
//    * Значение - Произвольный - значение параметра, полученного с клиента.
//  Результаты - Соответствие из КлючИЗначение:
//    * Ключ     - Строка       - имя параметра, возвращаемого на клиент.
//    * Значение - Произвольный - значение параметра, возвращаемого на клиент.
//
// Пример:
//	МоментНачала = ТекущаяУниверсальнаяДатаВМиллисекундах();
//	Попытка
//		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЦентрМониторинга") Тогда
//			МодульЦентрМониторингаСлужебный = ОбщегоНазначения.ОбщийМодуль("ЦентрМониторингаСлужебный");
//			МодульЦентрМониторингаСлужебный.ПриПериодическомПолученииДанныхКлиентаНаСервере(Параметры, Результаты);
//		КонецЕсли;
//	Исключение
//		СерверныеОповещения.ОбработатьОшибку(ИнформацияОбОшибке());
//	КонецПопытки;
//	СерверныеОповещения.ДобавитьПоказатель(Результаты, МоментНачала,
//		"ЦентрМониторингаСлужебный.ПриПериодическомПолученииДанныхКлиентаНаСервере");
//
Процедура ПриПериодическомПолученииДанныхКлиентаНаСервере(Параметры, Результаты) Экспорт
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики отправки и получения данных для обмена в распределенной информационной базе.

// Дополнительный обработчик одноименного события, возникающего при обмене данными в распределенной информационной базе.
// Выполняется после выполнения базовых алгоритмов библиотеки.
// Не выполняется, если отправка элемента данных была проигнорирована ранее.
//
// Параметры:
//  Источник                  - ПланОбменаОбъект - узел, для которого выполняется обмен.
//  ЭлементДанных             - Произвольный - см. описание одноименного обработчика в синтакс-помощнике.
//  ОтправкаЭлемента          - ОтправкаЭлементаДанных - см. описание одноименного обработчика в синтакс-помощнике.
//  СозданиеНачальногоОбраза  - Булево - см. описание одноименного обработчика в синтакс-помощнике.
//
Процедура ПриОтправкеДанныхПодчиненному(Источник, ЭлементДанных, ОтправкаЭлемента, СозданиеНачальногоОбраза) Экспорт
	
КонецПроцедуры

// Дополнительный обработчик одноименного события, возникающего при обмене данными в распределенной информационной базе.
// Выполняется после выполнения базовых алгоритмов библиотеки.
// Не выполняется, если отправка элемента данных была проигнорирована ранее.
//
// Параметры:
//  Источник          - ПланОбменаОбъект - узел, для которого выполняется обмен.
//  ЭлементДанных     - Произвольный - см. описание одноименного обработчика в синтакс-помощнике.
//  ОтправкаЭлемента  - ОтправкаЭлементаДанных - см. описание одноименного обработчика в синтакс-помощнике.
//
Процедура ПриОтправкеДанныхГлавному(Источник, ЭлементДанных, ОтправкаЭлемента) Экспорт
	
КонецПроцедуры

// Дополнительный обработчик одноименного события, возникающего при обмене данными в распределенной информационной базе.
// Выполняется после выполнения базовых алгоритмов библиотеки.
// Не выполняется, если получение элемента данных было проигнорировано ранее.
//
// Параметры:
//  Источник          - ПланОбменаОбъект - узел, для которого выполняется обмен.
//  ЭлементДанных     - Произвольный - см. описание одноименного обработчика в синтакс-помощнике.
//  ПолучениеЭлемента - ПолучениеЭлементаДанных - см. описание одноименного обработчика в синтакс-помощнике.
//  ОтправкаНазад     - Булево - см. описание одноименного обработчика в синтакс-помощнике.
//
Процедура ПриПолученииДанныхОтПодчиненного(Источник, ЭлементДанных, ПолучениеЭлемента, ОтправкаНазад) Экспорт
	
КонецПроцедуры

// Дополнительный обработчик одноименного события, возникающего при обмене данными в распределенной информационной базе.
// Выполняется после выполнения базовых алгоритмов библиотеки.
// Не выполняется, если получение элемента данных было проигнорировано ранее.
//
// Параметры:
//  Источник          - ПланОбменаОбъект - узел, для которого выполняется обмен.
//  ЭлементДанных     - Произвольный - см. описание одноименного обработчика в синтакс-помощнике.
//  ПолучениеЭлемента - ПолучениеЭлементаДанных - см. описание одноименного обработчика в синтакс-помощнике.
//  ОтправкаНазад     - Булево - см. описание одноименного обработчика в синтакс-помощнике.
//
Процедура ПриПолученииДанныхОтГлавного(Источник, ЭлементДанных, ПолучениеЭлемента, ОтправкаНазад) Экспорт
	
КонецПроцедуры

// Позволяет изменить признак того, что версия программы является, либо не является базовой.
//
// Параметры:
//  ЭтоБазовая - Булево - признак того, что версия программы является базовой. По умолчанию Истина, если в имени
//                        программы есть слово "Базовая".
// 
Процедура ПриОпределенииПризнакаЭтоБазоваяВерсияКонфигурации(ЭтоБазовая) Экспорт 
	
КонецПроцедуры

#КонецОбласти

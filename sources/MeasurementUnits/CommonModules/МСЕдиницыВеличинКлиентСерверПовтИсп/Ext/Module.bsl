﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Метрологическая служба. Единицы величин".
// ОбщийМодуль.МСЕдиницыВеличинКлиентСерверПовтИсп.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Предикат, указывающий используются ли обозначения и наименования единиц величин указанного вида.
//
// Параметры:
// 	ОбозначениеЕдиницыВеличин - МСЕдиницыВеличинОбозначения	- Вариант обозначения единиц величин.
//
// Возвращаемое значение: Булево
//
Функция ИспользуютсяОбозначения(Знач ОбозначениеЕдиницыВеличин) Экспорт

	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(
		"МСЕдиницыВеличинКлиентСерверПовтИсп.ИспользуютсяОбозначения",
		"ОбозначениеЕдиницыВеличин",
		ОбозначениеЕдиницыВеличин,
		Новый ОписаниеТипов("СправочникСсылка.ВариантыОбозначенийЕдиницВеличин"));
		
	Возврат ПолучитьФункциональнуюОпцию("МСЕдиницыВеличинИспользоватьОбозначения"
		+ ОбозначениеЕдиницыВеличин.Код);

КонецФункции

// Возвращает наименование реквизита, содержащего наименование в зависимости от функциональных опций.
//
// Параметры:
// 	ОбозначениеЕдиницыВеличин - МСЕдиницыВеличинОбозначения	- Вариант обозначения единиц величин.
//
// Возвращаемое значение: Строка
//
Функция ПолучитьРеквизитНаименования(Знач ОбозначениеЕдиницыВеличин = Неопределено) Экспорт

	Если ОбозначениеЕдиницыВеличин = Неопределено Тогда
		ОбозначениеЕдиницыВеличин = ПолучитьФункциональнуюОпцию("МСЕдиницыВеличинОбозначения");
	КонецЕсли;

	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(
		"МСЕдиницыВеличинКлиентСерверПовтИсп.ПолучитьРеквизитНаименования",
		"ОбозначениеЕдиницыВеличин",
		ОбозначениеЕдиницыВеличин,
		Новый ОписаниеТипов("СправочникСсылка.ВариантыОбозначенийЕдиницВеличин"));
		
	Возврат "Наименование" + ОбозначениеЕдиницыВеличин.Код;

КонецФункции

// Возвращает наименование реквизита, содержащего наименование в зависимости от функциональных опций.
//
// Параметры:
// 	ОбозначениеЕдиницыВеличин - МСЕдиницыВеличинОбозначения	- Вариант обозначения единиц величин.
//
// Возвращаемое значение: Строка
//
Функция ПолучитьРеквизитНаименованияПриставки(Знач ОбозначениеЕдиницыВеличин = Неопределено) Экспорт

	Если ОбозначениеЕдиницыВеличин = Неопределено Тогда
		ОбозначениеЕдиницыВеличин = ПолучитьФункциональнуюОпцию("МСЕдиницыВеличинОбозначения");
	КонецЕсли;

	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(
		"МСЕдиницыВеличинКлиентСерверПовтИсп.ПолучитьРеквизитНаименованияПриставки",
		"ОбозначениеЕдиницыВеличин",
		ОбозначениеЕдиницыВеличин,
		Новый ОписаниеТипов("СправочникСсылка.ВариантыОбозначенийЕдиницВеличин"));
		
	Возврат "Наименование" 
		+ ОбозначениеЕдиницыВеличин.Код
		+ ?( ПолучитьФункциональнуюОпцию("МСЕдиницыВеличинОбозначенияПриставок") = Перечисления.МСЕдиницыВеличинОбозначенияПриставок.ПоПостановлениюПравительстваРФ879,
			"",
			"ISO_80000_1"
		)
	;

КонецФункции

// Возвращает наименование реквизита, содержащего обозначение в зависимости от функциональных опций.
//
// Параметры:
// 	ОбозначениеЕдиницыВеличин - МСЕдиницыВеличинОбозначения	- Вариант обозначения единиц величин.
//
// Возвращаемое значение: Строка
//
Функция ПолучитьРеквизитОбозначения(Знач ОбозначениеЕдиницыВеличин = Неопределено) Экспорт

	Если ОбозначениеЕдиницыВеличин = Неопределено Тогда
		ОбозначениеЕдиницыВеличин = ПолучитьФункциональнуюОпцию("МСЕдиницыВеличинОбозначения");
	КонецЕсли;

	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(
		"МСЕдиницыВеличинКлиентСерверПовтИсп.ПолучитьРеквизитОбозначения",
		"ОбозначениеЕдиницыВеличин",
		ОбозначениеЕдиницыВеличин,
		Новый ОписаниеТипов("СправочникСсылка.ВариантыОбозначенийЕдиницВеличин"));
		
	Возврат "Обозначение" + ОбозначениеЕдиницыВеличин.Код;

КонецФункции

// Возвращает наименование реквизита, содержащего обозначение в зависимости от функциональных опций.
//
// Параметры:
// 	ОбозначениеЕдиницыВеличин - МСЕдиницыВеличинОбозначения	- Вариант обозначения
//	  единиц величин.
//
// Возвращаемое значение:
//   Строка - наименование реквизита
//
Функция ПолучитьРеквизитОбозначенияПриставки(Знач ОбозначениеЕдиницыВеличин = Неопределено) Экспорт

	Если ОбозначениеЕдиницыВеличин = Неопределено Тогда
		ОбозначениеЕдиницыВеличин = ПолучитьФункциональнуюОпцию("МСЕдиницыВеличинОбозначения");
	КонецЕсли;

	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(
		"МСЕдиницыВеличинКлиентСерверПовтИсп.ПолучитьРеквизитОбозначенияПриставки",
		"ОбозначениеЕдиницыВеличин",
		ОбозначениеЕдиницыВеличин,
		Новый ОписаниеТипов("СправочникСсылка.ВариантыОбозначенийЕдиницВеличин"));
		
	Возврат "Обозначение"
		+ ОбозначениеЕдиницыВеличин.Код
		+ ?( ПолучитьФункциональнуюОпцию("МСЕдиницыВеличинОбозначенияПриставок") = Перечисления.МСЕдиницыВеличинОбозначенияПриставок.ПоПостановлениюПравительстваРФ879,
			"",
			"ISO_80000_1"
		)
	;

КонецФункции

// Возвращает наименование реквизита, содержащего предлог, используемый перед единицей величины
// в знаменателе производной единицы.
//
// Параметры:
// 	ОбозначениеЕдиницыВеличин - МСЕдиницыВеличинОбозначения	- Вариант обозначения единиц величин.
//
// Возвращаемое значение: Строка
//
Функция ПолучитьРеквизитПредлогаДляЗнаменателя(Знач ОбозначениеЕдиницыВеличин = Неопределено) Экспорт

	Если ОбозначениеЕдиницыВеличин = Неопределено Тогда
		ОбозначениеЕдиницыВеличин = ПолучитьФункциональнуюОпцию("МСЕдиницыВеличинОбозначения");
	КонецЕсли;

	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(
		"МСЕдиницыВеличинКлиентСерверПовтИсп.ПолучитьРеквизитПредлогаДляЗнаменателя",
		"ОбозначениеЕдиницыВеличин",
		ОбозначениеЕдиницыВеличин,
		Новый ОписаниеТипов("СправочникСсылка.ВариантыОбозначенийЕдиницВеличин"));
		
	Возврат "ПредлогДляЗнаменателя" + ОбозначениеЕдиницыВеличин.Код;

КонецФункции

// Возвращает наименование реквизита, содержащего признак необходимости пробела после значения и перед
// обозначением единицы величины.
//
// Параметры:
// 	ОбозначениеЕдиницыВеличин - МСЕдиницыВеличинОбозначения	- Вариант обозначения единиц величин.
//
// Возвращаемое значение: Строка
//
Функция ПолучитьРеквизитПробелПередОбозначением(Знач ОбозначениеЕдиницыВеличин = Неопределено) Экспорт

	Если ОбозначениеЕдиницыВеличин = Неопределено Тогда
		ОбозначениеЕдиницыВеличин = ПолучитьФункциональнуюОпцию("МСЕдиницыВеличинОбозначения");
	КонецЕсли;

	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(
		"МСЕдиницыВеличинКлиентСерверПовтИсп.ПолучитьРеквизитПробелПередОбозначением",
		"ОбозначениеЕдиницыВеличин",
		ОбозначениеЕдиницыВеличин,
		Новый ОписаниеТипов("СправочникСсылка.ВариантыОбозначенийЕдиницВеличин"));
		
	Возврат "ПробелПередОбозначением" + ОбозначениеЕдиницыВеличин.Код;

КонецФункции

// Возвращает описание типов свойств наименований и обозначений единиц величин для последующего использования
// в ОбщегоНазначенияКлиентСервер.ПроверитьПараметр.
//
// Возвращаемое значение:
//   Структура - типы свойств наименований и обозначений
//
Функция ПолучитьТипыСвойствНаименованияИОбозначения() Экспорт

	Перем ОжидаемыеТипыСвойств;
	
	ОжидаемыеТипыСвойств = Новый Структура();
	
	Для Каждого ВариантОбозначения Из МСЕдиницыВеличинКлиентСерверПовтИсп.ПолучитьВариантыОбозначенийЕдиницВеличин() Цикл
		Если ПолучитьФункциональнуюОпцию("МСЕдиницыВеличинИспользоватьОбозначения" + ВариантОбозначения.Код) Тогда
			ОжидаемыеТипыСвойств.Вставить(МСЕдиницыВеличинКлиентСерверПовтИсп.ПолучитьРеквизитНаименования(ВариантОбозначения), Тип("Строка"));
			ОжидаемыеТипыСвойств.Вставить(МСЕдиницыВеличинКлиентСерверПовтИсп.ПолучитьРеквизитОбозначения(ВариантОбозначения), Тип("Строка"));
		КонецЕсли;
	КонецЦикла;

	Возврат ОжидаемыеТипыСвойств;

КонецФункции

// Возвращает массив вариантов обозначений единиц величин.
//
// Возвращаемое значение: ФиксированныйМассив
//
Функция ПолучитьВариантыОбозначенийЕдиницВеличин() Экспорт

	Перем Запрос;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВариантыОбозначенийЕдиницВеличин.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ВариантыОбозначенийЕдиницВеличин КАК ВариантыОбозначенийЕдиницВеличин
	|ГДЕ
	|	НЕ ВариантыОбозначенийЕдиницВеличин.ПометкаУдаления";
	
	Возврат Новый ФиксированныйМассив(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти

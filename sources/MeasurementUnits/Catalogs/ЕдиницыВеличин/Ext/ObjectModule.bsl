﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает наименование в зависимости от функциональных опций.
//
// Возвращаемое значение: Строка
//
Функция ПолучитьНаименование() Экспорт
	Возврат ЭтотОбъект[ПолучитьРеквизитНаименования()];
КонецФункции

// Возвращает обозначение в зависимости от функциональных опций.
//
// Возвращаемое значение: Строка
//
Функция ПолучитьОбозначение() Экспорт
	Возврат ЭтотОбъект[ПолучитьРеквизитОбозначения()];
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ЕдиницыВеличинКлиентСервер.ОбновитьВычисляемыеРеквизиты(ЭтотОбъект);
	
	Если Выражение.Количество() = 1 Тогда
		Приставка = Выражение[0].Приставка;
		БазоваяЕдиница = Выражение[0].БазоваяЕдиница;
	Иначе
		Приставка = Справочники.ПриставкиЕдиницВеличин.ПустаяСсылка();
		БазоваяЕдиница = Справочники.ЕдиницыВеличин.ПустаяСсылка();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(Знач ДанныеЗаполнения, Знач ТекстЗаполнения, СтандартнаяОбработка)
	
	//ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	//
	//СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	Перем ДополнительныеПараметры;
	
	Если ИмеетСпециальныеНаименованиеИОбозначение Тогда
		ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("Выражение"));
		ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("Выражение.БазоваяЕдиница"));
	КонецЕсли;

	Если ДопустимоПрименениеПриставок И (МаксимальныйПоказательСтепениПриставки < МинимальныйПоказательСтепениПриставки) Тогда
		
		Ошибка = НСтр("ru = 'Максимальный допустимый показатель степени приставки единицы величины не может быть меньше минимального допустимого.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Ошибка, , "Объект.МаксимальныйПоказательСтепениПриставки", , Отказ);
		
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Режим",  "КонтрольПоНаименованию");
	ДополнительныеПараметры.Вставить("Ссылка", Ссылка);

	Дубли = ПоискИУдалениеДублей.НайтиДублиЭлемента(Метаданные.Справочники.ЕдиницыВеличин.ПолноеИмя(), ЭтотОбъект, ДополнительныеПараметры);
	Если Дубли.Количество() > 0 Тогда
		Ошибка = НСтр("ru = 'Единица величины с таким наименованием уже существует.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Ошибка, , "Объект." + ПолучитьРеквизитНаименования(), , Отказ);
	КонецЕсли;

	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Режим",  "КонтрольПоОбозначению");
	ДополнительныеПараметры.Вставить("Ссылка", Ссылка);

	Дубли = ПоискИУдалениеДублей.НайтиДублиЭлемента(Метаданные.Справочники.ЕдиницыВеличин.ПолноеИмя(), ЭтотОбъект, ДополнительныеПараметры);
	Если Дубли.Количество() > 0 Тогда
		Ошибка = НСтр("ru = 'Единица величины с таким обозначением уже существует.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Ошибка, , "Объект." + ПолучитьРеквизитОбозначения(), , Отказ);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьРеквизитНаименования()
	Возврат ЕдиницыВеличинКлиентСерверПовтИсп.ПолучитьРеквизитНаименования();
КонецФункции

Функция ПолучитьРеквизитОбозначения()
	Возврат ЕдиницыВеличинКлиентСерверПовтИсп.ПолучитьРеквизитОбозначения();
КонецФункции

#КонецОбласти

#КонецЕсли

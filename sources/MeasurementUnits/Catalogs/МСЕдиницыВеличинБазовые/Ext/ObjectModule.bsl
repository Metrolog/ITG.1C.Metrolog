﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает приставку в зависимости от функциональных опций.
//
// Возвращаемое значение:
//   Строка - приставка
//
Функция ПолучитьНаименование() Экспорт
	Возврат ЭтотОбъект[ПолучитьРеквизитНаименования()];
КонецФункции

// Возвращает обозначение приставки в зависимости от функциональных опций.
//
// Возвращаемое значение:
//   Строка - обозначение приставки
//
Функция ПолучитьОбозначение() Экспорт
	Возврат ЭтотОбъект[ПолучитьРеквизитОбозначения()];
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

// Для внутреннего использования.
// 
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Режим",  "КонтрольПоНаименованию");
	ДополнительныеПараметры.Вставить("Ссылка", Ссылка);
	
	Дубли = ПоискИУдалениеДублей.НайтиДублиЭлемента("Справочник.МСЕдиницыВеличинБазовые", ЭтотОбъект, ДополнительныеПараметры);
	Если Дубли.Количество() > 0 Тогда
		Ошибка = НСтр("ru = 'Единица величины с таким наименованием уже существует.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Ошибка, , "Объект." + ПолучитьРеквизитНаименования(), , Отказ);
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Режим",  "КонтрольПоОбозначению");
	ДополнительныеПараметры.Вставить("Ссылка", Ссылка);
	
	Дубли = ПоискИУдалениеДублей.НайтиДублиЭлемента("Справочник.МСЕдиницыВеличинБазовые", ЭтотОбъект, ДополнительныеПараметры);
	Если Дубли.Количество() > 0 Тогда
		Ошибка = НСтр("ru = 'Единица величины с таким обозначением уже существует.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Ошибка, , "Объект." + ПолучитьРеквизитОбозначения(), , Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьРеквизитНаименования()
	Возврат МСЕдиницыВеличинКлиентСерверПовтИсп.ПолучитьРеквизитНаименования();
КонецФункции

Функция ПолучитьРеквизитОбозначения()
	Возврат МСЕдиницыВеличинКлиентСерверПовтИсп.ПолучитьРеквизитОбозначения();
КонецФункции

#КонецОбласти

#КонецЕсли

﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Метрологическая служба. Единицы величин".
// ОбщийМодуль.МСЕдиницыВеличинСервер.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Работа с обозначениями

// Формирует обозначение единицы величины по её выражению из базовых.
//
// Параметры:
// 	Единица		- Ссылка, Объект, Структура	- Сссылка на объект единицы величины.
//
// Возвращаемое значение:
//  Строка - Обозначение единицы величины.
//
Функция СформироватьОбозначениеЕдиницыВеличины(Знач Единица) Экспорт
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(
		"МСЕдиницыВеличинСервер.СформироватьОбозначениеЕдиницыВеличины",
		"Единица",
		Единица,
		Новый ОписаниеТипов("СправочникСсылка.МСЕдиницыВеличин, СправочникОбъект.МСЕдиницыВеличин, ДанныеФормыСтруктура"));
	Обозначение = "";
	Если Единица <> Справочники.МСЕдиницыВеличин.ПустаяСсылка() Тогда 
		Для каждого Множитель Из Единица.Выражение Цикл
			Если Строка(Множитель.ПоказательСтепени) <> "0" Тогда 
				ПредставлениеМножителя =
					МСЕдиницыВеличинКлиентСервер.ПолучитьОбозначение(Множитель.Приставка)
					+ МСЕдиницыВеличинКлиентСервер.ПолучитьОбозначение(Множитель.БазоваяЕдиница)
					+ РаботаСоСтрокамиЮникодКлиентСервер.ПолучитьСтрокуИзПоказателяСтепениКраткую(Множитель.ПоказательСтепени)
				;
				Обозначение = ?(НЕ ПустаяСтрока(Обозначение),Обозначение + "⋅","") + ПредставлениеМножителя;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	Возврат Обозначение;
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Работа с наименованиями

// Формирует наименование единицы величины по её выражению из базовых.
//
// Параметры:
// 	Единица		- Ссылка, Объект, Структура	- Сссылка на объект единицы величины.
//
// Возвращаемое значение:
//  Строка - Наименование единицы величины.
//
Функция СформироватьНаименованиеЕдиницыВеличины(Знач Единица) Экспорт
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(
		"МСЕдиницыВеличинСервер.СформироватьНаименованиеЕдиницыВеличины",
		"Единица",
		Единица,
		Новый ОписаниеТипов("СправочникСсылка.МСЕдиницыВеличин, СправочникОбъект.МСЕдиницыВеличин, ДанныеФормыСтруктура"));
	Если Единица <> Справочники.МСЕдиницыВеличин.ПустаяСсылка() Тогда 
		НаименованиеЧислителя = "";
		НаименованиеЗнаменателя = "";
		Предлог = "";
		Для Каждого Множитель Из Единица.Выражение Цикл
			МодульПоказателяСтепени = ?(Множитель.ПоказательСтепени < 0,
				-Множитель.ПоказательСтепени,
				Множитель.ПоказательСтепени
			);
			Падеж = ?(Множитель.ПоказательСтепени > 0, 1, 4);
			
			ПредставлениеМножителя =
				МСЕдиницыВеличинКлиентСервер.ПолучитьНаименование(Множитель.Приставка)
				+ СклонениеПредставленийОбъектов.ПросклонятьПредставление(
					МСЕдиницыВеличинКлиентСервер.ПолучитьНаименование(Множитель.БазоваяЕдиница)
					, Падеж, Множитель.БазоваяЕдиница)
			;
			Если Множитель.БазоваяЕдиница.ИспользоватьНаименованиеСтепениКакПрилагательное
				И МодульПоказателяСтепени >= 2
				И МодульПоказателяСтепени <= 3
			Тогда 
				ПредставлениеМножителя =
					РаботаСоСтрокамиЮникодСерверПовтИсп.ПолучитьНаименованиеИзПоказателяСтепениКакПрилагательное(МодульПоказателяСтепени, Падеж)
					+ " " + ПредставлениеМножителя
				;
			ИначеЕсли МодульПоказателяСтепени >= 2 Тогда
				ПредставлениеМножителя = ПредставлениеМножителя + " "
					+ РаботаСоСтрокамиЮникодСерверПовтИсп.ПолучитьНаименованиеИзПоказателяСтепени(МодульПоказателяСтепени)
				;
			КонецЕсли;
			
			Если Множитель.ПоказательСтепени > 0 Тогда
				НаименованиеЧислителя = ?(НЕ ПустаяСтрока(НаименованиеЧислителя), НаименованиеЧислителя + "-", "") + ПредставлениеМножителя;
			ИначеЕсли Множитель.ПоказательСтепени < 0 Тогда
				НаименованиеЗнаменателя = ?(НЕ ПустаяСтрока(НаименованиеЗнаменателя), НаименованиеЗнаменателя + "-", "") + ПредставлениеМножителя;
				Если ПустаяСтрока(Предлог) И (МодульПоказателяСтепени = 1) Тогда
					Предлог = Множитель.БазоваяЕдиница.ПредлогЗнаменателяНаименованияСоставнойЕдиницыВеличины;
				Иначе
					Предлог = "на";
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		Возврат 
			?(ПустаяСтрока(НаименованиеЧислителя), "единица", НаименованиеЧислителя)
			+ ?(ПустаяСтрока(НаименованиеЗнаменателя), "", " " + Предлог + " " + НаименованиеЗнаменателя)
		;
	Иначе
		Возврат "";
	КонецЕсли;
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#КонецОбласти

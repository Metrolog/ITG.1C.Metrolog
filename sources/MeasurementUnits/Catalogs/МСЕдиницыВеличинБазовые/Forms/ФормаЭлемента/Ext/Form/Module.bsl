﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	
	// СтандартныеПодсистемы.ЦентрМониторинга
	
	// Подсчитываем количество созданий формы, стандартный разделитель ".".
	Комментарий = Строка(ПолучитьСкоростьКлиентскогоСоединения());
	ЦентрМониторинга.ЗаписатьОперациюБизнесСтатистики("Справочник.МСЕдиницыВеличинБазовые.ПриСозданииНаСервере", 1, Комментарий);
	
	// Конец СтандартныеПодсистемы.ЦентрМониторинга
	
	// СтандартныеПодсистемы.СклонениеПредставленийОбъектов
	СклонениеПредставленийОбъектов.ПриСозданииНаСервере(ЭтотОбъект,
		Объект[МСЕдиницыВеличинКлиентСерверПовтИсп.ПолучитьРеквизитНаименования()]);
	// Конец СтандартныеПодсистемы.СклонениеПредставленийОбъектов
	
	Если Параметры.Ключ.Пустая() И Параметры.ЗначениеКопирования.Пустая() Тогда
		Объект.Выражение.Добавить().ПоказательСтепени = 1;
	КонецЕсли;
	
	УстановитьДоступность();

КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.СклонениеПредставленийОбъектов
	СклонениеПредставленийОбъектов.ПриЗаписиНаСервере(ЭтотОбъект,
		Объект[МСЕдиницыВеличинКлиентСерверПовтИсп.ПолучитьРеквизитНаименования()],
		ТекущийОбъект.Ссылка);
	// Конец СтандартныеПодсистемы.СклонениеПредставленийОбъектов
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.СклонениеПредставленийОбъектов

&НаКлиенте
Процедура Склонения(Команда)
	
	СклонениеПредставленийОбъектовКлиент.ОбработатьКомандуСклонения(ЭтотОбъект,
		Объект["Наименование" + Прав(Команда.Имя, СтрДлина(Команда.Имя)-СтрДлина("Склонения"))]);
			
КонецПроцедуры

// Конец СтандартныеПодсистемы.СклонениеПредставленийОбъектов

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
		
	// СтандартныеПодсистемы.СклонениеПредставленийОбъектов
	СклонениеПредставленийОбъектовКлиент.ПриИзмененииПредставления(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.СклонениеПредставленийОбъектов
		

КонецПроцедуры

&НаКлиенте
Процедура ПредикатыПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Клиент

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
    ЗапретРедактированияРеквизитовОбъектовКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтотОбъект);
КонецПроцедуры

// СтандартныеПодсистемы.СклонениеПредставленийОбъектов

&НаКлиенте 
Процедура Подключаемый_ПросклонятьПредставлениеПоВсемПадежам() 
	
	СклонениеПредставленийОбъектовКлиент.ПросклонятьПредставлениеПоВсемПадежам(ЭтотОбъект,
		Объект[МСЕдиницыВеличинКлиентСерверПовтИсп.ПолучитьРеквизитНаименования()]);

КонецПроцедуры

// Конец СтандартныеПодсистемы.СклонениеПредставленийОбъектов

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	УстановитьДоступность();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Клиент и Сервер

Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	Если Объект.ЭтоОсновнаяЕдиница Тогда
		
		Объект.ЭтоКогерентнаяЕдиница = Истина;
		Объект.ИмеетСпециальныеНаименованиеИОбозначение = Истина;
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы, "ЭтоКогерентнаяЕдиница", "Доступность",
			Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы, "ИмеетСпециальныеНаименованиеИОбозначение", "Доступность",
			Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы, "ГруппаВыражение", "Видимость",
			Ложь);
		
	Иначе
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы, "ЭтоКогерентнаяЕдиница", "Доступность",
			Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы, "ИмеетСпециальныеНаименованиеИОбозначение", "Доступность",
			Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы, "ГруппаВыражение", "Видимость",
			Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы, "ВыражениеПриставка", "Видимость",
			Объект.ЭтоКогерентнаяЕдиница <> Истина);
		// TODO: вопрос с "кг" здесь возникает... "кг" - когерентная единица, но при этом - с приставкой "кило"...
		
	КонецЕсли;
	
	Если Объект.ИмеетСпециальныеНаименованиеИОбозначение Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы, "ГруппаНаименованияИОбозначения", "Доступность",
			Истина);
			
		Для Каждого ВариантОбозначения Из Метаданные.Перечисления.МСЕдиницыВеличинОбозначения.ЗначенияПеречисления Цикл
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы, "ПредлогДляЗнаменателя" + ВариантОбозначения.Имя, "Видимость",
				Истина);
		КонецЦикла;
	
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы, "ИспользоватьНаименованиеСтепениКакПрилагательное", "Видимость",
			Истина);
			
	Иначе

		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы, "ГруппаНаименованияИОбозначения", "Доступность",
			Ложь);
		
		Для Каждого ВариантОбозначения Из Метаданные.Перечисления.МСЕдиницыВеличинОбозначения.ЗначенияПеречисления Цикл
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы, "ПредлогДляЗнаменателя" + ВариантОбозначения.Имя, "Видимость",
				Ложь);
		КонецЦикла;
	
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы, "ИспользоватьНаименованиеСтепениКакПрилагательное", "Видимость",
			Ложь);
			
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы, "ГруппаКоэффициент", "Видимость",
		(Объект.ЭтоКогерентнаяЕдиница <> Истина)
		И (Объект.ИмеетСпециальныеНаименованиеИОбозначение = Истина)
	);
			
КонецПроцедуры

#КонецОбласти
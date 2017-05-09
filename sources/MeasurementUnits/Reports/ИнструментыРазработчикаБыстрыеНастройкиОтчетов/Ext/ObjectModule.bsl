﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	// Получение таблицы с данными.
	ТаблицаЗначений = ДанныеОтчета();
	
	// Вывод данных в отчет.
	СтандартнаяОбработка = Ложь;
	НастройкиКД = КомпоновщикНастроек.ПолучитьНастройки();
	ВнешниеНаборыДанных = Новый Структура("ТаблицаЗначений", ТаблицаЗначений);
	
	КомпоновщикМакетаКД = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКД = КомпоновщикМакетаКД.Выполнить(СхемаКомпоновкиДанных, НастройкиКД, ДанныеРасшифровки); // Без расшифровки.
	
	ПроцессорКД = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКД.Инициализировать(МакетКД, ВнешниеНаборыДанных); // Без расшифровки.
	
	ПроцессорВыводаРезультатаКД = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВыводаРезультатаКД.УстановитьДокумент(ДокументРезультат);
	ПроцессорВыводаРезультатаКД.Вывести(ПроцессорКД);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДанныеОтчета()
	ТаблицаЗначений = Новый ТаблицаЗначений;
	ТаблицаЗначений.Колонки.Добавить("ИмяОтчета", Новый ОписаниеТипов("Строка"));
	ТаблицаЗначений.Колонки.Добавить("КлючВарианта", Новый ОписаниеТипов("Строка"));
	ТаблицаЗначений.Колонки.Добавить("КоличествоНастроек", Новый ОписаниеТипов("Число"));
	ТаблицаЗначений.Колонки.Добавить("Информация", Новый ОписаниеТипов("Строка"));
	ТаблицаЗначений.Колонки.Добавить("ТипПроблемы", Новый ОписаниеТипов("Строка"));
	ТаблицаЗначений.Колонки.Добавить("ИспользуетСКД", Новый ОписаниеТипов("Булево"));
	ТаблицаЗначений.Колонки.Добавить("ПодключенКХранилищу", Новый ОписаниеТипов("Булево"));
	ТаблицаЗначений.Колонки.Добавить("ПодключенКОсновнойФорме", Новый ОписаниеТипов("Булево"));
	ТаблицаЗначений.Колонки.Добавить("ПодключенКФормеНастроек", Новый ОписаниеТипов("Булево"));
	ТаблицаЗначений.Колонки.Добавить("ЕстьПроблемы", Новый ОписаниеТипов("Булево"));
	ТаблицаЗначений.Колонки.Добавить("ПредставлениеОтчета", Новый ОписаниеТипов("Строка"));
	ТаблицаЗначений.Колонки.Добавить("ПредставлениеВарианта", Новый ОписаниеТипов("Строка"));
	
	КэшФлажкаХранилища = Неопределено;
	КэшФлажкаОсновнойФормы = Неопределено;
	КэшФлажкаФормыНастроек = Неопределено;
	
	Для Каждого ОтчетМетаданные Из Метаданные.Отчеты Цикл
		НастройкиОтчета = Новый Структура("ИмяОтчета, ПредставлениеОтчета, ИспользуетСКД,
		|ПодключенКХранилищу, ПодключенКОсновнойФорме, ПодключенКФормеНастроек");
		НастройкиОтчета.ИмяОтчета = ОтчетМетаданные.Имя;
		НастройкиОтчета.ПредставлениеОтчета = ОтчетМетаданные.Представление();
		НастройкиОтчета.ПодключенКХранилищу = ОтчетПодключенКХранилищу(ОтчетМетаданные, КэшФлажкаХранилища);
		НастройкиОтчета.ПодключенКОсновнойФорме = ОтчетПодключенКОсновнойФорме(ОтчетМетаданные, КэшФлажкаОсновнойФормы);
		НастройкиОтчета.ПодключенКФормеНастроек = ОтчетПодключенКФормеНастроек(ОтчетМетаданные, КэшФлажкаФормыНастроек);
		НастройкиОтчета.ИспользуетСКД = (ОтчетМетаданные.ОсновнаяСхемаКомпоновкиДанных <> Неопределено);
		
		// Нужен ли вообще анализ.
		Если Не НастройкиОтчета.ИспользуетСКД Тогда
			СтрокаОтчета = ТаблицаЗначений.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаОтчета, НастройкиОтчета);
			СтрокаОтчета.Информация = НСтр("ru = 'Не использует СКД.'");
			Продолжить;
		КонецЕсли;
		
		ОтчетМенеджер = Отчеты[ОтчетМетаданные.Имя];
		СхемаКД = Неопределено;
		КомпоновщикНастроекКД = Неопределено;
		ВариантыНастроек = Неопределено;
		ИнформацияОбОшибке = Неопределено;
		
		// Чтение схемы отчета.
		Попытка
			ОтчетОбъект = ОтчетМенеджер.Создать();
			СхемаКД = ОтчетОбъект.СхемаКомпоновкиДанных;
			КомпоновщикНастроекКД = ОтчетОбъект.КомпоновщикНастроек;
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
		КонецПопытки;
		Если ВозниклаОшибкаПриЧтенииСхемы(НастройкиОтчета, ИнформацияОбОшибке, ТаблицаЗначений) Тогда
			Продолжить;
		КонецЕсли;
		
		// Чтение списка вариантов отчета из схемы отчета.
		Попытка
			ВариантыНастроек = СхемаКД.ВариантыНастроек;
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
		КонецПопытки;
		Если ВозниклаОшибкаПриЧтенииСпискаВариантов(НастройкиОтчета, ИнформацияОбОшибке, ТаблицаЗначений) Тогда
			Продолжить;
		КонецЕсли;
		
		// Если отчет не подключен к подсистеме, то эта информация выводится отдельным пунктом.
		Если Не НастройкиОтчета.ПодключенКХранилищу Тогда
			СтрокаОтчета = ТаблицаЗначений.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаОтчета, НастройкиОтчета);
			СтрокаОтчета.ЕстьПроблемы = Истина;
			СтрокаОтчета.Информация = НСтр("ru = 'Отчет не подключен к подсистеме ""Варианты отчетов"".'");
		КонецЕсли;
		
		// Если отчет не подключен к подсистеме, то эта информация выводится отдельным пунктом.
		Если НастройкиОтчета.ПодключенКОсновнойФорме <> НастройкиОтчета.ПодключенКФормеНастроек Тогда
			Если НастройкиОтчета.ПодключенКОсновнойФорме Тогда
				ТипПроблемы = НСтр("ru = 'Подключен к основной форме, но не подключен к форме настроек.'");
			Иначе
				ТипПроблемы = НСтр("ru = 'Не подключен к основной форме, но подключен к форме настроек.'");
			КонецЕсли;
			СтрокаОтчета = ТаблицаЗначений.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаОтчета, НастройкиОтчета);
			СтрокаОтчета.ЕстьПроблемы = Истина;
			СтрокаОтчета.ТипПроблемы = ТипПроблемы;
		КонецЕсли;
		
		// Регистрация найденных вариантов.
		Если НастройкиОтчета.ПодключенКОсновнойФорме Тогда
			ОтчетСсылка = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ОтчетМетаданные);
			Для Каждого ВариантНастроекКД Из ВариантыНастроек Цикл
				СтрокаВарианта = ТаблицаЗначений.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаВарианта, НастройкиОтчета);
				СтрокаВарианта.КлючВарианта          = ВариантНастроекКД.Имя;
				СтрокаВарианта.ПредставлениеВарианта = ВариантНастроекКД.Представление;
				
				// Чтение схемы варианта.
				Попытка
					НастройкиКД = ВариантНастроекКД.Настройки;
					КомпоновщикНастроекКД.ЗагрузитьНастройки(НастройкиКД);
				Исключение
					ИнформацияОбОшибке = ИнформацияОбОшибке();
				КонецПопытки;
				Если ВозниклаОшибкаПриЧтенииНастроекВарианта(СтрокаВарианта, ИнформацияОбОшибке) Тогда
					Продолжить;
				КонецЕсли;
				
				// Чтение схемы варианта.
				Попытка
					РезультатАнализа = ПроанализироватьПользовательскиеНастройки(
						КомпоновщикНастроекКД,
						ОтчетСсылка,
						СтрокаВарианта.КлючВарианта,
						ОтчетОбъект);
				Исключение
					ИнформацияОбОшибке = ИнформацияОбОшибке();
				КонецПопытки;
				Если ВозниклаОшибкаПриАнализеНастроекВарианта(СтрокаВарианта, ИнформацияОбОшибке) Тогда
					Продолжить;
				КонецЕсли;
				
				СтрокаВарианта.КоличествоНастроек = РезультатАнализа.КоличествоБыстрых;
				СтрокаВарианта.Информация         = РезультатАнализа.ПредставлениеБыстрых;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ТаблицаЗначений;
КонецФункции

Функция ВозниклаОшибкаПриЧтенииСхемы(НастройкиОтчета, ИнформацияОбОшибке, ТаблицаЗначений)
	Если ИнформацияОбОшибке = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	СтрокаОтчета = ТаблицаЗначений.Добавить();
	ЗаполнитьЗначенияСвойств(СтрокаОтчета, НастройкиОтчета);
	СтрокаОтчета.ЕстьПроблемы = Истина;
	СтрокаОтчета.Информация = НСтр("ru = 'Возникла ошибка при чтении схемы:'") + Символы.ПС + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	Возврат Истина;
КонецФункции

Функция ВозниклаОшибкаПриЧтенииСпискаВариантов(НастройкиОтчета, ИнформацияОбОшибке, ТаблицаЗначений)
	Если ИнформацияОбОшибке = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	СтрокаОтчета = ТаблицаЗначений.Добавить();
	ЗаполнитьЗначенияСвойств(СтрокаОтчета, НастройкиОтчета);
	СтрокаОтчета.ЕстьПроблемы = Истина;
	СтрокаОтчета.Информация = НСтр("ru = 'Возникла ошибка при чтении списка вариантов отчетов из схемы:'") + Символы.ПС + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	Возврат Истина;
КонецФункции

Функция ВозниклаОшибкаПриЧтенииНастроекВарианта(СтрокаВарианта, ИнформацияОбОшибке)
	Если ИнформацияОбОшибке = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	СтрокаВарианта.ЕстьПроблемы = Истина;
	СтрокаВарианта.Информация = НСтр("ru = 'Возникла ошибка при чтении настроек варианта отчета:'") + Символы.ПС + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	Возврат Истина;
КонецФункции

Функция ВозниклаОшибкаПриАнализеНастроекВарианта(СтрокаВарианта, ИнформацияОбОшибке)
	Если ИнформацияОбОшибке = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	СтрокаВарианта.ЕстьПроблемы = Истина;
	СтрокаВарианта.Информация = НСтр("ru = 'Возникла ошибка при анализе настроек варианта отчета:'") + Символы.ПС + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	Возврат Истина;
КонецФункции

Функция ПроанализироватьПользовательскиеНастройки(КомпоновщикНастроекКД, ОтчетСсылка, КлючВарианта, ОтчетОбъект)
	Результат = Новый Структура;
	Результат.Вставить("КоличествоБыстрых", 0);
	Результат.Вставить("ПредставлениеБыстрых", "");
	
	НастройкиОтчета = ВариантыОтчетов.НастройкиФормыОтчета(ОтчетСсылка, КлючВарианта, ОтчетОбъект);
	
	УсловияВывода = Новый Структура;
	УсловияВывода.Вставить("ТолькоПользовательские", Истина);
	УсловияВывода.Вставить("ТолькоБыстрые",          Истина);
	УсловияВывода.Вставить("ИдентификаторТекущегоУзлаКД", Неопределено);
	Анализ = ОтчетыСервер.РасширеннаяИнформацияОНастройках(КомпоновщикНастроекКД, НастройкиОтчета, ОтчетОбъект, УсловияВывода);
	БыстрыеНастройки = Анализ.ПользовательскиеНастройки.Скопировать(Новый Структура("ВыводРазрешен, Быстрая", Истина, Истина));
	Для Каждого СвойстваНастройки Из БыстрыеНастройки Цикл
		Если СвойстваНастройки.Тип = "ЗначениеПараметраНастроек" Тогда
			ПредставлениеНастройки = НСтр("ru = 'Параметр'") + " """ + Строка(СвойстваНастройки.НастройкаВариантаКД.Параметр) + """";
		ИначеЕсли СвойстваНастройки.Тип = "ЭлементОтбора" Тогда
			ПредставлениеНастройки = НСтр("ru = 'Отбор'") + " """ + Строка(СвойстваНастройки.ПолеКД) + """";
		ИначеЕсли СвойстваНастройки.Тип = "Отбор" Тогда
			ПредставлениеНастройки = НСтр("ru = 'Коллекция отборов'") + " """ + СвойстваНастройки.Представление + """";
		Иначе
			ПредставлениеНастройки = СвойстваНастройки.Тип + " """ + СвойстваНастройки.Представление + """";
		КонецЕсли;
		Результат.КоличествоБыстрых = Результат.КоличествоБыстрых + 1;
		Если Результат.ПредставлениеБыстрых <> "" Тогда
			Результат.ПредставлениеБыстрых = Результат.ПредставлениеБыстрых + "; ";
		КонецЕсли;
		Результат.ПредставлениеБыстрых = Результат.ПредставлениеБыстрых + ПредставлениеНастройки;
	КонецЦикла;
	Анализ = Неопределено;
	Возврат Результат;
КонецФункции

// Определяет способ внедрения подсистемы.
Функция ПоУмолчаниюВсеПодключеныКХранилищу()
	Возврат (Метаданные.ХранилищеВариантовОтчетов <> Неопределено И Метаданные.ХранилищеВариантовОтчетов.Имя = "ХранилищеВариантовОтчетов");
КонецФункции

// Определяет подключен ли отчет к подсистеме.
Функция ОтчетПодключенКХранилищу(ОтчетМетаданные, ПоУмолчаниюВсеПодключены = Неопределено)
	ХранилищеМетаданные = ОтчетМетаданные.ХранилищеВариантов;
	Если ХранилищеМетаданные = Неопределено Тогда
		Если ПоУмолчаниюВсеПодключены = Неопределено Тогда
			ПоУмолчаниюВсеПодключены = ПоУмолчаниюВсеПодключеныКХранилищу();
		КонецЕсли;
		ОтчетПодключен = ПоУмолчаниюВсеПодключены;
	Иначе
		ОтчетПодключен = (ХранилищеМетаданные = Метаданные.ХранилищаНастроек.ХранилищеВариантовОтчетов);
	КонецЕсли;
	Возврат ОтчетПодключен;
КонецФункции

// Определяет способ подключения общей формы отчета.
Функция ПоУмолчаниюВсеПодключеныКОсновнойФорме()
	ФормаМетаданные = Метаданные.ОсновнаяФормаОтчета;
	Возврат (ФормаМетаданные <> Неопределено И ФормаМетаданные = Метаданные.ОбщиеФормы.ФормаОтчета);
КонецФункции

// Определяет способ подключения общей формы отчета.
Функция ОтчетПодключенКОсновнойФорме(ОтчетМетаданные, ПоУмолчаниюВсеПодключены = Неопределено)
	ФормаМетаданные = ОтчетМетаданные.ОсновнаяФорма;
	Если ФормаМетаданные = Неопределено Тогда
		Если ПоУмолчаниюВсеПодключены = Неопределено Тогда
			ПоУмолчаниюВсеПодключены = ПоУмолчаниюВсеПодключеныКОсновнойФорме();
		КонецЕсли;
		ОтчетПодключен = ПоУмолчаниюВсеПодключены;
	Иначе
		ОтчетПодключен = (ФормаМетаданные = Метаданные.ОбщиеФормы.ФормаОтчета);
	КонецЕсли;
	Возврат ОтчетПодключен;
КонецФункции

// Определяет способ подключения общей формы отчета.
Функция ПоУмолчаниюВсеПодключеныКФормеНастроек()
	ФормаМетаданные = Метаданные.ОсновнаяФормаНастроекОтчета;
	Возврат (ФормаМетаданные <> Неопределено И ФормаМетаданные = Метаданные.ОбщиеФормы.ФормаНастроекОтчета);
КонецФункции

// Определяет способ подключения общей формы отчета.
Функция ОтчетПодключенКФормеНастроек(ОтчетМетаданные, ПоУмолчаниюВсеПодключены = Неопределено)
	ФормаМетаданные = ОтчетМетаданные.ОсновнаяФормаНастроек;
	Если ФормаМетаданные = Неопределено Тогда
		Если ПоУмолчаниюВсеПодключены = Неопределено Тогда
			ПоУмолчаниюВсеПодключены = ПоУмолчаниюВсеПодключеныКФормеНастроек();
		КонецЕсли;
		ОтчетПодключен = ПоУмолчаниюВсеПодключены;
	Иначе
		ОтчетПодключен = (ФормаМетаданные = Метаданные.ОбщиеФормы.ФормаНастроекОтчета);
	КонецЕсли;
	Возврат ОтчетПодключен;
КонецФункции

#КонецОбласти

#КонецЕсли
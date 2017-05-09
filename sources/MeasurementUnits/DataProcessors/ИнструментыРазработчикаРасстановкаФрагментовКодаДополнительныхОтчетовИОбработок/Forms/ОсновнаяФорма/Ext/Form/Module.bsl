﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ДобавитьУсловноеОформление();
	
	МетаданныеАктуальны = НЕ КонфигурацияБазыДанныхИзмененаДинамически() И НЕ КонфигурацияИзменена();
	Подсказка = 
	НСтр("ru = 'При работе с хранилищем рекомендуется захватывать все справочники и документы.
	|Для начала анализа варианта внедрения нажмите ""Выгрузить тексты модулей"".
	|Необходимо закрыть конфигуратор и другие соединения, которые могут препятствовать выгрузке текстов модулей.'");
	Элементы.Подсказка.Высота = СтрЧислоВхождений(Подсказка, Символы.ПС) + 1;
	
	// Формирование начальных данных.
	
	// Заполнение таблицы объектов, подключенных к подсистеме.
	ДобавитьТипыОбъектовМетаданных("ЗаполнениеОбъекта");
	ДобавитьТипыОбъектовМетаданных("ОтчетыОбъекта");
	ДобавитьТипыОбъектовМетаданных("СозданиеСвязанныхОбъектов");
	ОбъектыМетаданных.Сортировать("Вид, Представление");
	
	// Оформление элементов формы.
	ПоискКода = Новый Структура("ПриСозданииНаСервере, ВыполнитьКоманду, ВыполнитьКомандуСервер");
	ПоискКода.ПриСозданииНаСервере   = "ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтотОбъект);";
	ПоискКода.ВыполнитьКоманду       = "Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)";
	ПоискКода.ВыполнитьКомандуСервер = "Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)";
	ПоискКода = Новый ФиксированнаяСтруктура(ПоискКода);
	
	СуффиксИменМодулейФорм = ".Форма.Модуль.txt";
	
	РежимОтладки = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	#Если ВебКлиент Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Работа с текстами конфигурации в веб-клиенте не возможна.'"));
		Отказ = Истина;
		Возврат;
	#КонецЕсли
	
	#Если НЕ ВебКлиент Тогда
		Кавычка = """";
		КаталогBIN = КаталогПрограммы();
		ПутьККонфигурации = СтрокаСоединенияИнформационнойБазы();
		ПутьККонфигурации = СтрЗаменить(ПутьККонфигурации, Кавычка, Кавычка + Кавычка);
	#КонецЕсли
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодключитьВыбранные(Команда)
	Если Не ВыгрузкаМодулейВыполнена Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Перед подключением необходимо выгрузить тексты модулей'"));
		Возврат;
	КонецЕсли;
	
	РезультатРаботы = Новый Структура("Вывести, ТекстовыйДокумент, Заголовок", Ложь);
	
	Состояние(НСтр("ru = 'Изменение текстов выбранных модулей'"));
	ИзменитьВыбранныеСервер(РезультатРаботы);
	
	Состояние(НСтр("ru = 'Запись текстов выбранных модулей в новый каталог'"));
	ЗаписатьВыбранныеКлиент();
	
	Состояние(НСтр("ru = 'Загрузка измененных текстов выбранных модулей'"));
	ЗагрузитьТекстыИзКаталога();
	
	Состояние(НСтр("ru = 'Запуск конфигуратора'"));
	ОткрытьКонфигуратор();
	
	Если РезультатРаботы.Вывести Тогда
		РезультатРаботы.ТекстовыйДокумент.Показать(РезультатРаботы.Заголовок);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьТекстыМодулей(Команда)
	ЗачитатьДанныеЭтойПрограммы();
КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьКонфигуратор(Команда)
	ОткрытьКонфигуратор()
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ОпределитьОшибкиВнедренияКоторыеМожноИсправить()
	КодировкаМодулей = КодировкаТекста.UTF8;
	
	ЕстьОшибкиВнедрения = Ложь;
	
	Для Каждого СтрокаОбъектаМетаданных Из ОбъектыМетаданных Цикл
		Если ЗначениеЗаполнено(СтрокаОбъектаМетаданных.АдресТекстаМодуляФормыОбъекта) Тогда
			УдалитьИзВременногоХранилища(СтрокаОбъектаМетаданных.АдресТекстаМодуляФормыОбъекта);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СтрокаОбъектаМетаданных.АдресТекстаМодуляФормыСписка) Тогда
			УдалитьИзВременногоХранилища(СтрокаОбъектаМетаданных.АдресТекстаМодуляФормыСписка);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СтрокаОбъектаМетаданных.ФормаОбъектаПолноеИмя) Тогда
			ПолноеИмяФайлаМодуляФормыОбъекта = ВыгрузкаМодулейКаталог + СтрокаОбъектаМетаданных.ФормаОбъектаПолноеИмя + СуффиксИменМодулейФорм;
			ФайлМодуля = Новый Файл(ПолноеИмяФайлаМодуляФормыОбъекта);
			Если ФайлМодуля.Существует() Тогда
				Чтение = Новый ЧтениеТекста(ФайлМодуля.ПолноеИмя, КодировкаМодулей);
				Содержимое = Чтение.Прочитать();
				СтрокаОбъектаМетаданных.АдресТекстаМодуляФормыОбъекта = ПоместитьВоВременноеХранилище(Содержимое, УникальныйИдентификатор);
				Если СтрНайти(Содержимое, ПоискКода.ПриСозданииНаСервере) <> 0 Тогда
					Если СтрокаОбъектаМетаданных.ЗаполнениеОбъекта Тогда
						Если СтрНайти(Содержимое, ПоискКода.ВыполнитьКоманду) <> 0 И СтрНайти(Содержимое, ПоискКода.ВыполнитьКомандуСервер) <> 0 Тогда
							СтрокаОбъектаМетаданных.ФормаОбъектаПодключена = Истина;
						КонецЕсли;
					Иначе
						СтрокаОбъектаМетаданных.ФормаОбъектаПодключена = Истина;
					КонецЕсли;
				КонецЕсли;
			Иначе
				Если РежимОтладки Тогда
					СообщитьПользователю("- " + ПолноеИмяФайлаМодуляФормыОбъекта);
				КонецЕсли;
			КонецЕсли;
			
			Если НЕ СтрокаОбъектаМетаданных.ФормаОбъектаПодключена Тогда
				СтрокаОбъектаМетаданных.ФормаОбъектаТекстОшибки = НСтр("ru = 'Форма объекта не подключена к подсистеме'");
				СтрокаОбъектаМетаданных.Подключить = Истина;
				ЕстьОшибкиВнедрения = Истина;
			КонецЕсли;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СтрокаОбъектаМетаданных.ФормаСпискаПолноеИмя) Тогда
			ПолноеИмяФайлаМодуляФормыСписка = ВыгрузкаМодулейКаталог + СтрокаОбъектаМетаданных.ФормаСпискаПолноеИмя + СуффиксИменМодулейФорм;
			ФайлМодуля = Новый Файл(ПолноеИмяФайлаМодуляФормыСписка);
			Если ФайлМодуля.Существует() Тогда
				Чтение = Новый ЧтениеТекста(ФайлМодуля.ПолноеИмя, КодировкаМодулей);
				Содержимое = Чтение.Прочитать();
				СтрокаОбъектаМетаданных.АдресТекстаМодуляФормыСписка = ПоместитьВоВременноеХранилище(Содержимое, УникальныйИдентификатор);
				Если СтрНайти(Содержимое, ПоискКода.ПриСозданииНаСервере) <> 0 Тогда
					СтрокаОбъектаМетаданных.ФормаСпискаПодключена = Истина;
				КонецЕсли;
			Иначе
				Если РежимОтладки Тогда
					СообщитьПользователю("- " + ПолноеИмяФайлаМодуляФормыСписка);
				КонецЕсли;
			КонецЕсли;
			
			Если НЕ СтрокаОбъектаМетаданных.ФормаСпискаПодключена Тогда
				СтрокаОбъектаМетаданных.ФормаСпискаТекстОшибки = НСтр("ru = 'Форма списка не подключена к подсистеме'");
				СтрокаОбъектаМетаданных.Подключить = Истина;
				ЕстьОшибкиВнедрения = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ЕстьОшибкиВнедрения;
КонецФункции

&НаКлиенте
Процедура ЗаписатьВыбранныеКлиент()
	КодировкаМодулей = КодировкаТекста.UTF8;
	
	Найденные = ОбъектыМетаданных.НайтиСтроки(Новый Структура("Подключить", Истина));
	Для Каждого СтрокаОбъектаМетаданных Из Найденные Цикл
		Если НЕ СтрокаОбъектаМетаданных.ФормаОбъектаПодключена
			И ЗначениеЗаполнено(СтрокаОбъектаМетаданных.АдресТекстаМодуляФормыОбъекта) Тогда
			ТекстМодуляФормыОбъекта = ПолучитьИзВременногоХранилища(СтрокаОбъектаМетаданных.АдресТекстаМодуляФормыОбъекта);
			ЗаписьТекста = Новый ЗаписьТекста(ВыгрузкаМодулейКаталог + СтрокаОбъектаМетаданных.ФормаОбъектаПолноеИмя + СуффиксИменМодулейФорм, КодировкаМодулей);
			ЗаписьТекста.Записать(ТекстМодуляФормыОбъекта);
			ЗаписьТекста = Неопределено;
		КонецЕсли;
		
		Если НЕ СтрокаОбъектаМетаданных.ФормаСпискаПодключена
			И ЗначениеЗаполнено(СтрокаОбъектаМетаданных.АдресТекстаМодуляФормыСписка) Тогда
			ТекстМодуляФормыСписка = ПолучитьИзВременногоХранилища(СтрокаОбъектаМетаданных.АдресТекстаМодуляФормыСписка);
			ЗаписьТекста = Новый ЗаписьТекста(ВыгрузкаМодулейКаталог + СтрокаОбъектаМетаданных.ФормаСпискаПолноеИмя + СуффиксИменМодулейФорм, КодировкаМодулей);
			ЗаписьТекста.Записать(ТекстМодуляФормыСписка);
			ЗаписьТекста = Неопределено;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция ИзменитьВыбранныеСервер(РезультатРаботы)
	ФормыДляПодключенияОбработчика = Новый СписокЗначений;
	
	КодПодсистемыПриСозданииНаСервере = 
	"	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	|	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтотОбъект);
	|	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки";
	
	КодПодсистемыВыполнитьКоманду = 
	"// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	|
	|&НаКлиенте
	|Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	|	
	|	Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтотОбъект, Команда.Имя) Тогда
	|		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя);
	|	КонецЕсли;
	|	
	|КонецПроцедуры
	|
	|// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки";
	
	КодПодсистемыВыполнитьКомандуСервер = 
	"// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	|
	|&НаСервере
	|Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента)
	|	
	|	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтотОбъект, ИмяЭлемента);
	|	
	|КонецПроцедуры
	|
	|// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки";
	
	КодОбработчикиСобытийФормы = "#Область ОбработчикиСобытийФормы";
	КодОбработчикиКомандФормы = "#Область ОбработчикиКомандФормы";
	КодСлужебныеПроцедурыИФункции = "#Область СлужебныеПроцедурыИФункции";
	КодКонецОбласти = "#КонецОбласти";
	
	КодНаСервере = "&НаСервере";
	КодПроцедураПриСозданииНаСервере = "Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)";
	КодКонецПроцедуры = "КонецПроцедуры";
	КодАвтоТест = 
	"	Если Параметры.Свойство(""АвтоТест"") Тогда
	|		Возврат;
	|	КонецЕсли;";
	
	ДлинаОбработчикиСобытийФормы    = СтрДлина(КодОбработчикиСобытийФормы);
	ДлинаОбработчикиКомандФормы     = СтрДлина(КодОбработчикиКомандФормы);
	ДлинаСлужебныеПроцедурыИФункции = СтрДлина(КодСлужебныеПроцедурыИФункции);
	
	Найденные = ОбъектыМетаданных.НайтиСтроки(Новый Структура("Подключить", Истина));
	Для Каждого СтрокаОбъектаМетаданных Из Найденные Цикл
		// Встраивание подсистемы в форму объекта.
		Если НЕ СтрокаОбъектаМетаданных.ФормаОбъектаПодключена И НЕ СтрокаОбъектаМетаданных.ФормаОбъектаЕстьКритичныеОшибки Тогда
			
			Если ЗначениеЗаполнено(СтрокаОбъектаМетаданных.АдресТекстаМодуляФормыОбъекта) Тогда
				ТекстМодуля = ПолучитьИзВременногоХранилища(СтрокаОбъектаМетаданных.АдресТекстаМодуляФормыОбъекта);
			Иначе
				// Файл модуля может не выгрузиться если он пустой.
				ТекстМодуля = "";
				СтрокаОбъектаМетаданных.АдресТекстаМодуляФормыОбъекта = ПоместитьВоВременноеХранилище(ТекстМодуля, УникальныйИдентификатор);
			КонецЕсли;
			
			ТекстМодуля = СокрЛП(ТекстМодуля);
			
			ПодключитьКодПриСозданииНаСервере   = (СтрНайти(ТекстМодуля, ПоискКода.ПриСозданииНаСервере) = 0);
			ПодключитьКодВыполнитьКоманду       = СтрокаОбъектаМетаданных.ЗаполнениеОбъекта И (СтрНайти(ТекстМодуля, ПоискКода.ВыполнитьКоманду) = 0);
			ПодключитьКодВыполнитьКомандуСервер = СтрокаОбъектаМетаданных.ЗаполнениеОбъекта И (СтрНайти(ТекстМодуля, ПоискКода.ВыполнитьКомандуСервер) = 0);
			
			Если ПодключитьКодПриСозданииНаСервере Тогда
				ПозицияПроцедураПриСозданииНаСервере = СтрНайти(ТекстМодуля, КодПроцедураПриСозданииНаСервере);
				Если ПозицияПроцедураПриСозданииНаСервере = 0 Тогда
					ФормыДляПодключенияОбработчика.Добавить(СтрокаОбъектаМетаданных.ФормаОбъектаПолноеИмя);
					
					ПозицияНачалаОбработчикиСобытий = СтрНайти(ТекстМодуля, КодОбработчикиСобытийФормы);
					Если ПозицияНачалаОбработчикиСобытий = 0 Тогда
						ТекстМодуля = 
							КодОбработчикиСобытийФормы + Символы.ПС + Символы.ПС
							+ КодНаСервере + Символы.ПС
							+ КодПроцедураПриСозданииНаСервере + Символы.ПС
							+ КодАвтоТест + Символы.ПС + Символы.Таб + Символы.ПС
							+ КодПодсистемыПриСозданииНаСервере	+ Символы.ПС + Символы.Таб + Символы.ПС
							+ КодКонецПроцедуры	+ Символы.ПС + Символы.ПС
							+ КодКонецОбласти + Символы.ПС + Символы.ПС
							+ ТекстМодуля;
					Иначе
						ПозицияКонцаОбработчикиСобытий = ПозицияНачалаОбработчикиСобытий + ДлинаОбработчикиСобытийФормы - 1;
						
						ТекстМодуля = (
							Лев(ТекстМодуля, ПозицияКонцаОбработчикиСобытий) + Символы.ПС + Символы.ПС
							+ КодНаСервере + Символы.ПС
							+ КодПроцедураПриСозданииНаСервере + Символы.ПС
							+ КодАвтоТест + Символы.ПС + Символы.Таб + Символы.ПС
							+ КодПодсистемыПриСозданииНаСервере + Символы.ПС + Символы.Таб + Символы.ПС
							+ КодКонецПроцедуры	+ Символы.ПС + Символы.ПС
							+ Сред(ТекстМодуля, ПозицияКонцаОбработчикиСобытий + 1));
					КонецЕсли;
				Иначе
					Остаток = Сред(ТекстМодуля, ПозицияПроцедураПриСозданииНаСервере);
					ПозицияКонецПроцедуры = ПозицияПроцедураПриСозданииНаСервере + СтрНайти(Остаток, КодКонецПроцедуры) - 1;
					
					ТекстМодуля = (
						Лев(ТекстМодуля, ПозицияКонецПроцедуры - 4) 
						+ СокрП(Сред(ТекстМодуля, ПозицияКонецПроцедуры - 3, 2))
						+ Символы.ПС + Символы.Таб + Символы.ПС
						+ КодПодсистемыПриСозданииНаСервере
						+ Символы.ПС + Символы.Таб + Символы.ПС
						+ Сред(ТекстМодуля, ПозицияКонецПроцедуры));
				КонецЕсли;
			КонецЕсли;
			
			Если ПодключитьКодВыполнитьКоманду Тогда
				ПозицияОбработчикиКомандФормы = СтрНайти(ТекстМодуля, КодОбработчикиКомандФормы);
				Если ПозицияОбработчикиКомандФормы = 0 Тогда
					ПозицияСлужебныеПроцедурыИФункции = СтрНайти(ТекстМодуля, КодСлужебныеПроцедурыИФункции);
					Если ПозицияСлужебныеПроцедурыИФункции = 0 Тогда
						ТекстМодуля = 
							ТекстМодуля	+ Символы.ПС + Символы.ПС
							+ КодОбработчикиКомандФормы	+ Символы.ПС + Символы.ПС
							+ КодПодсистемыВыполнитьКоманду + Символы.ПС
							+ КодКонецОбласти + Символы.ПС + Символы.ПС;
					Иначе
						ТекстМодуля = 
							Лев(ТекстМодуля, ПозицияСлужебныеПроцедурыИФункции - 1)
							+ КодОбработчикиКомандФормы	+ Символы.ПС + Символы.ПС
							+ КодПодсистемыВыполнитьКоманду	+ Символы.ПС + Символы.ПС
							+ КодКонецОбласти + Символы.ПС + Символы.ПС
							+ Сред(ТекстМодуля, ПозицияСлужебныеПроцедурыИФункции);
					КонецЕсли;
				Иначе
					ПозицияКонецОбработчикиКомандФормы = ПозицияОбработчикиКомандФормы + ДлинаОбработчикиКомандФормы;
					
					ТекстМодуля = 
						Лев(ТекстМодуля, ПозицияКонецОбработчикиКомандФормы - 1)
						+ Символы.ПС + Символы.ПС
						+ КодПодсистемыВыполнитьКоманду
						+ Сред(ТекстМодуля, ПозицияКонецОбработчикиКомандФормы);
				КонецЕсли;
			КонецЕсли;
			
			Если ПодключитьКодВыполнитьКомандуСервер Тогда
				ПозицияСлужебныеПроцедурыИФункции = СтрНайти(ТекстМодуля, КодСлужебныеПроцедурыИФункции);
				Если ПозицияСлужебныеПроцедурыИФункции = 0 Тогда
					ТекстМодуля = 
						ТекстМодуля	+ Символы.ПС + Символы.ПС
						+ КодСлужебныеПроцедурыИФункции	+ Символы.ПС + Символы.ПС
						+ КодПодсистемыВыполнитьКомандуСервер + Символы.ПС + Символы.ПС
						+ КодКонецОбласти + Символы.ПС;
				Иначе
					ПозицияКонецСлужебныеПроцедурыИФункции = ПозицияСлужебныеПроцедурыИФункции + ДлинаСлужебныеПроцедурыИФункции;
					
					ТекстМодуля = 
						Лев(ТекстМодуля, ПозицияКонецСлужебныеПроцедурыИФункции - 1)
						+ Символы.ПС + Символы.ПС
						+ КодПодсистемыВыполнитьКомандуСервер
						+ Сред(ТекстМодуля, ПозицияКонецСлужебныеПроцедурыИФункции);
				КонецЕсли;
			КонецЕсли;
			
			Пока СтрНайти(ТекстМодуля, Символы.ПС + Символы.ПС + Символы.ПС) > 0 Цикл
				ТекстМодуля = СтрЗаменить(ТекстМодуля, Символы.ПС + Символы.ПС + Символы.ПС, Символы.ПС + Символы.ПС);
			КонецЦикла;
			
			Если Не СтрЗаканчиваетсяНа(ТекстМодуля, Символы.ПС) Тогда
				ТекстМодуля = ТекстМодуля + Символы.ПС;
			КонецЕсли;
			
			ПоместитьВоВременноеХранилище(ТекстМодуля, СтрокаОбъектаМетаданных.АдресТекстаМодуляФормыОбъекта);
			
		КонецЕсли;
		
		// Встраивание подсистемы в форму списка.
		Если НЕ СтрокаОбъектаМетаданных.ФормаСпискаПодключена И НЕ СтрокаОбъектаМетаданных.ФормаСпискаЕстьКритичныеОшибки Тогда
			
			Если ЗначениеЗаполнено(СтрокаОбъектаМетаданных.АдресТекстаМодуляФормыСписка) Тогда
				ТекстМодуля = ПолучитьИзВременногоХранилища(СтрокаОбъектаМетаданных.АдресТекстаМодуляФормыСписка);
			Иначе
				// Файл модуля может не выгрузиться если он пустой.
				ТекстМодуля = "";
				СтрокаОбъектаМетаданных.АдресТекстаМодуляФормыСписка = ПоместитьВоВременноеХранилище(ТекстМодуля, УникальныйИдентификатор);
			КонецЕсли;
			
			ТекстМодуля = СокрЛП(ТекстМодуля);
			
			ПодключитьКодПриСозданииНаСервере = (СтрНайти(ТекстМодуля, ПоискКода.ПриСозданииНаСервере) = 0);
			
			Если ПодключитьКодПриСозданииНаСервере Тогда
				ПозицияПроцедураПриСозданииНаСервере = СтрНайти(ТекстМодуля, КодПроцедураПриСозданииНаСервере);
				Если ПозицияПроцедураПриСозданииНаСервере = 0 Тогда
					ФормыДляПодключенияОбработчика.Добавить(СтрокаОбъектаМетаданных.ФормаСпискаПолноеИмя);
					
					ПозицияНачалаОбработчикиСобытий = СтрНайти(ТекстМодуля, КодОбработчикиСобытийФормы);
					Если ПозицияНачалаОбработчикиСобытий = 0 Тогда
						ТекстМодуля = 
							КодОбработчикиСобытийФормы + Символы.ПС + Символы.ПС
							+ КодНаСервере + Символы.ПС
							+ КодПроцедураПриСозданииНаСервере + Символы.ПС
							+ КодАвтоТест + Символы.ПС + Символы.Таб + Символы.ПС
							+ КодПодсистемыПриСозданииНаСервере + Символы.ПС + Символы.Таб + Символы.ПС
							+ КодКонецПроцедуры + Символы.ПС + Символы.ПС
							+ КодКонецОбласти + Символы.ПС + Символы.ПС
							+ ТекстМодуля;
					Иначе
						ПозицияКонцаОбработчикиСобытий = ПозицияНачалаОбработчикиСобытий + ДлинаОбработчикиСобытийФормы - 1;
						
						ТекстМодуля = 
							Лев(ТекстМодуля, ПозицияКонцаОбработчикиСобытий) + Символы.ПС + Символы.ПС
							+ КодНаСервере + Символы.ПС
							+ КодПроцедураПриСозданииНаСервере + Символы.ПС
							+ КодАвтоТест + Символы.ПС + Символы.Таб + Символы.ПС
							+ КодПодсистемыПриСозданииНаСервере + Символы.ПС + Символы.Таб + Символы.ПС
							+ КодКонецПроцедуры + Символы.ПС + Символы.ПС
							+ Сред(ТекстМодуля, ПозицияКонцаОбработчикиСобытий + 1);
					КонецЕсли;
				Иначе
					Остаток = Сред(ТекстМодуля, ПозицияПроцедураПриСозданииНаСервере);
					ПозицияКонецПроцедуры = ПозицияПроцедураПриСозданииНаСервере + СтрНайти(Остаток, КодКонецПроцедуры) - 1;
					
					ТекстМодуля = 
						Лев(ТекстМодуля, ПозицияКонецПроцедуры - 4) 
						+ СокрП(Сред(ТекстМодуля, ПозицияКонецПроцедуры - 3, 2)) + Символы.ПС + Символы.Таб + Символы.ПС
						+ КодПодсистемыПриСозданииНаСервере + Символы.ПС + Символы.Таб + Символы.ПС
						+ Сред(ТекстМодуля, ПозицияКонецПроцедуры);
				КонецЕсли;
			КонецЕсли;
			
			Пока СтрНайти(ТекстМодуля, Символы.ПС + Символы.ПС + Символы.ПС) > 0 Цикл
				ТекстМодуля = СтрЗаменить(ТекстМодуля, Символы.ПС + Символы.ПС + Символы.ПС, Символы.ПС + Символы.ПС);
			КонецЦикла;
			
			Если Не СтрЗаканчиваетсяНа(ТекстМодуля, Символы.ПС) Тогда
				ТекстМодуля = ТекстМодуля + Символы.ПС;
			КонецЕсли;
			
			ПоместитьВоВременноеХранилище(ТекстМодуля, СтрокаОбъектаМетаданных.АдресТекстаМодуляФормыСписка);
			
		КонецЕсли;
	КонецЦикла;
	
	Если ФормыДляПодключенияОбработчика.Количество() > 0 Тогда
		Если НЕ РезультатРаботы.Вывести Тогда
			РезультатРаботы.Вывести = Истина;
			РезультатРаботы.Заголовок = НСтр("ru = 'Оставшиеся шаги по подключению форм к подсистеме Дополнительные отчеты и обработки'");
			РезультатРаботы.ТекстовыйДокумент = Новый ТекстовыйДокумент;
		Иначе
			РезультатРаботы.ТекстовыйДокумент.ДобавитьСтроку("");
			РезультатРаботы.ТекстовыйДокумент.ДобавитьСтроку("----------------");
			РезультатРаботы.ТекстовыйДокумент.ДобавитьСтроку("");
		КонецЕсли;
		
		РезультатРаботы.ТекстовыйДокумент.ДобавитьСтроку(
			НСтр("ru = 'Для указанных ниже форм необходимо выбрать обработчик события ""ПриСозданииНаСервере"",
			|указав в нем процедуру ""ПриСозданииНаСервере""'") + ":");
		
		ФормыДляПодключенияОбработчика.СортироватьПоЗначению();
		Для Каждого ПолноеИмяФормы Из ФормыДляПодключенияОбработчика Цикл
			РезультатРаботы.ТекстовыйДокумент.ДобавитьСтроку(" - " + ПолноеИмяФормы);
		КонецЦикла;
	КонецЕсли;
	
	Возврат Истина;
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Сервер

&НаСервере
Процедура ДобавитьУсловноеОформление()
	Инструкция = СтандартныеПодсистемыСервер.ИнструкцияУсловногоОформления();
	Инструкция.Отборы.Вставить("ОбъектыМетаданных.ФормаОбъектаЕстьКритичныеОшибки", Истина);
	Инструкция.Отборы.Вставить("ОбъектыМетаданных.ФормаСпискаЕстьКритичныеОшибки", Истина);
	Инструкция.Поля = "ОбъектыМетаданных";
	Инструкция.Оформление.Вставить("ТолькоПросмотр", Истина);
	СтандартныеПодсистемыСервер.ДобавитьЭлементУсловногоОформления(ЭтотОбъект, Инструкция);
	
	Инструкция = СтандартныеПодсистемыСервер.ИнструкцияУсловногоОформления();
	Инструкция.Отборы.Вставить("ОбъектыМетаданных.ФормаОбъектаЕстьКритичныеОшибки", Истина);
	Инструкция.Поля = "ОбъектыМетаданныхФормаОбъектаТекстОшибки";
	Инструкция.Оформление.Вставить("ЦветТекста", ЦветаСтиля.ПоясняющийОшибкуТекст);
	СтандартныеПодсистемыСервер.ДобавитьЭлементУсловногоОформления(ЭтотОбъект, Инструкция);
	
	Инструкция = СтандартныеПодсистемыСервер.ИнструкцияУсловногоОформления();
	Инструкция.Отборы.Вставить("ОбъектыМетаданных.ФормаСпискаЕстьКритичныеОшибки", Истина);
	Инструкция.Поля = "ОбъектыМетаданныхФормаСпискаТекстОшибки";
	Инструкция.Оформление.Вставить("ЦветТекста", ЦветаСтиля.ПоясняющийОшибкуТекст);
	СтандартныеПодсистемыСервер.ДобавитьЭлементУсловногоОформления(ЭтотОбъект, Инструкция);
КонецПроцедуры

&НаСервере
Процедура ДобавитьТипыОбъектовМетаданных(ИмяКоманды)
	МассивТипов = Метаданные.ОбщиеКоманды.Найти(ИмяКоманды).ТипПараметраКоманды.Типы();
	СтруктураЗаполнения = Новый Структура(ИмяКоманды, Истина);
	
	Для Каждого Тип Из МассивТипов Цикл
		МассивИзОдногоТипа = Новый Массив;
		МассивИзОдногоТипа.Добавить(Тип);
		ОписаниеОдногоТипа = Новый ОписаниеТипов(МассивИзОдногоТипа);
		
		Найденные = ОбъектыМетаданных.НайтиСтроки(Новый Структура("ОписаниеТипа", ОписаниеОдногоТипа));
		Если Найденные.Количество() = 0 Тогда
			ОбъектМетаданных = Метаданные.НайтиПоТипу(Тип);
			Если ОбъектМетаданных = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			СтрокаОбъектаМетаданных = ОбъектыМетаданных.Добавить();
			СтрокаОбъектаМетаданных.ПолноеИмя     = ОбъектМетаданных.ПолноеИмя();
			СтрокаОбъектаМетаданных.Представление = ОбъектМетаданных.Представление();
			СтрокаОбъектаМетаданных.Вид           = Лев(СтрокаОбъектаМетаданных.ПолноеИмя, СтрНайти(СтрокаОбъектаМетаданных.ПолноеИмя, ".") - 1);
			СтрокаОбъектаМетаданных.ОписаниеТипа  = ОписаниеОдногоТипа;
			
			Если ОбъектМетаданных.ОсновнаяФормаОбъекта = Неопределено Тогда
				СтрокаОбъектаМетаданных.ФормаОбъектаЕстьКритичныеОшибки = Истина;
				СтрокаОбъектаМетаданных.ФормаОбъектаТекстОшибки = НСтр("ru = 'Форма объекта не определена'");
			Иначе
				СтрокаОбъектаМетаданных.ФормаОбъектаПолноеИмя = ОбъектМетаданных.ОсновнаяФормаОбъекта.ПолноеИмя();
			КонецЕсли;
			
			Если ОбъектМетаданных.ОсновнаяФормаСписка = Неопределено Тогда
				СтрокаОбъектаМетаданных.ФормаСпискаЕстьКритичныеОшибки = Истина;
				СтрокаОбъектаМетаданных.ФормаСпискаТекстОшибки = НСтр("ru = 'Форма списка не определена'");
			Иначе
				СтрокаОбъектаМетаданных.ФормаСпискаПолноеИмя = ОбъектМетаданных.ОсновнаяФормаСписка.ПолноеИмя();
			КонецЕсли;
			
		Иначе
			СтрокаОбъектаМетаданных = Найденные[0];
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(СтрокаОбъектаМетаданных, СтруктураЗаполнения);
	КонецЦикла;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Выгрузка / Загрузка текстов модулей.

&НаКлиенте
Процедура ЗачитатьДанныеЭтойПрограммы(ВыбранноеЗначение = -1, ПараметрыЧтения = Неопределено) Экспорт
	// Процедура выполняется по клику на кнопку.
	
	Если ПараметрыЧтения = Неопределено Тогда
		ПараметрыЧтения = ПараметрыЧтения();
	КонецЕсли;
	
	Если ВыбранноеЗначение <> -1 Тогда
		Если ПараметрыЧтения.ТекущийШаг = "ПроверкаИзмененийВКонфигурации" Тогда
			Если ВыбранноеЗначение = "ЗакрытьПрограмму" Тогда
				ЗавершитьРаботуСистемы(Истина);
				Возврат;
			ИначеЕсли ВыбранноеЗначение = "ИгнорироватьИзменения" Тогда
				ПараметрыЧтения.ПроверкаИзмененийВКонфигурации.Выполнено = Истина;
				МетаданныеАктуальны = Истина;
			Иначе
				Возврат;
			КонецЕсли;
		ИначеЕсли ПараметрыЧтения.ТекущийШаг = "ВводЛогинаПароля" Тогда
			Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
				ВыгрузкаМодулейПользователь = ВыбранноеЗначение.Пользователь;
				ВыгрузкаМодулейПароль       = ВыбранноеЗначение.Пароль;
				ЛогинПарольВводились        = Истина;
				ПараметрыЧтения.ВводЛогинаПароля.Выполнено = Истина;
			Иначе
				Возврат;
			КонецЕсли;
		ИначеЕсли ПараметрыЧтения.ТекущийШаг = "ПроверкаСоединений" Тогда
			Если ВыбранноеЗначение = КодВозвратаДиалога.Повторить Или ВыбранноеЗначение = КодВозвратаДиалога.Таймаут Тогда
				// См. далее - повторная проверка.
			Иначе
				Возврат;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если Не ПараметрыЧтения.ПроверкаИзмененийВКонфигурации.Выполнено Тогда
		Если МетаданныеАктуальны Тогда
			ПараметрыЧтения.ПроверкаИзмененийВКонфигурации.Выполнено = Истина;
		Иначе
			ТекстВопроса = НСтр("ru = 'Основная конфигурация отличается от конфигурации базы данных.
			|Перед запуском обработки по расстановке фрагментов кода
			|рекомендуется обновить конфигурацию базы данных.'");
			
			Кнопки = Новый СписокЗначений;
			Кнопки.Добавить("ИгнорироватьИзменения", НСтр("ru = 'Пропустить'"));
			Кнопки.Добавить("ЗакрытьПрограмму",      НСтр("ru = 'Закрыть программу'"));
			Кнопки.Добавить(КодВозвратаДиалога.Отмена);
			
			ПараметрыЧтения.ТекущийШаг = "ПроверкаИзмененийВКонфигурации";
			Обработчик = Новый ОписаниеОповещения("ЗачитатьДанныеЭтойПрограммы", ЭтотОбъект, ПараметрыЧтения);
			ПоказатьВопрос(Обработчик, ТекстВопроса, Кнопки, 60, "ИгнорироватьИзменения");
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если Не ПараметрыЧтения.ВводЛогинаПароля.Выполнено Тогда
		Если ЛогинПарольВводились Тогда
			ПараметрыЧтения.ВводЛогинаПароля.Выполнено = Истина;
		Иначе
			ИмяФормыАвторизации = ИмяФормыАвторизации();
			ПараметрыФормы = Новый Структура("Пользователь, Пароль", ВыгрузкаМодулейПользователь, ВыгрузкаМодулейПароль);
			ПараметрыЧтения.ТекущийШаг = "ВводЛогинаПароля";
			Обработчик = Новый ОписаниеОповещения("ЗачитатьДанныеЭтойПрограммы", ЭтотОбъект, ПараметрыЧтения);
			ОткрытьФорму(ИмяФормыАвторизации, ПараметрыФормы, ЭтотОбъект, , , , Обработчик);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если Не ПараметрыЧтения.ПроверкаСоединений.Выполнено Тогда
		Если МожноВыгрузитьМодули() Тогда
			ПараметрыЧтения.ПроверкаСоединений.Выполнено = Истина;
		Иначе
			ТекстВопроса = НСтр("ru = 'Для выгрузки текстов модулей конфигурации необходимо
			|закрыть конфигуратор и другие соединения,
			|которые могут препятствовать выгрузке.
			|Текущий сеанс завершать не нужно.'");
			
			Кнопки = Новый СписокЗначений;
			Кнопки.Добавить(КодВозвратаДиалога.Повторить);
			Кнопки.Добавить(КодВозвратаДиалога.Отмена);
			
			ПараметрыЧтения.ТекущийШаг = "ПроверкаСоединений";
			Обработчик = Новый ОписаниеОповещения("ЗачитатьДанныеЭтойПрограммы", ЭтотОбъект, ПараметрыЧтения);
			ПоказатьВопрос(Обработчик, ТекстВопроса, Кнопки, 15, КодВозвратаДиалога.Повторить, , КодВозвратаДиалога.Повторить);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Состояние(НСтр("ru = 'Выгрузка текстов модулей'"));
	ВыгрузитьТекстыВКаталог();
	
	Элементы.ВыгрузитьТекстыМодулей.КнопкаПоУмолчанию = Ложь;
	Элементы.ОжиданиеВыгрузки.Видимость = Ложь;
	ВыгрузкаМодулейВыполнена = Истина;
	Подсказка =
	НСтр("ru = 'При работе с хранилищем рекомендуется захватывать все справочники и документы.
	|Для расстановки фрагментов кода нажмите ""Подключить выбранные"".'");
	Элементы.Подсказка.Высота = СтрЧислоВхождений(Подсказка, Символы.ПС) + 1;
	
	Состояние(НСтр("ru = 'Чтение текстов модулей'"));
	Успех = НЕ ОпределитьОшибкиВнедренияКоторыеМожноИсправить();
	
	Если РежимОтладки Тогда
		СообщитьПользователю(ВыгрузкаМодулейКаталог);
	Иначе
		Состояние(НСтр("ru = 'Удаление временных файлов'"));
		УдалитьФайлы(ВыгрузкаМодулейКаталог, "*.*");
	КонецЕсли;
	
	Если Успех Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Все формы подключены к подсистеме.'"));
		ОткрытьКонфигуратор();
	Иначе
		Элементы.ПодключитьВыбранные.КнопкаПоУмолчанию = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПараметрыЧтения()
	ПараметрыЧтения = Новый Структура;
	ПараметрыЧтения.Вставить("ТекущийШаг", "");
	ПараметрыЧтения.Вставить("ПроверкаИзмененийВКонфигурации", Новый Структура);
	ПараметрыЧтения.ПроверкаИзмененийВКонфигурации.Вставить("Выполнено", Ложь);
	ПараметрыЧтения.Вставить("ВводЛогинаПароля", Новый Структура);
	ПараметрыЧтения.ВводЛогинаПароля.Вставить("Выполнено", Ложь);
	ПараметрыЧтения.Вставить("ПроверкаСоединений", Новый Структура);
	ПараметрыЧтения.ПроверкаСоединений.Вставить("Выполнено", Ложь);
	Возврат ПараметрыЧтения;
КонецФункции

&НаКлиенте
Функция ИмяФормыАвторизации()
	Остаток = ИмяФормы;
	ПозицияТочки = СтрНайти(Остаток, ".");
	ИмяФормыАвторизации = Лев(Остаток, ПозицияТочки - 1);
	Остаток = Сред(Остаток, ПозицияТочки + 1);
	ПозицияТочки = СтрНайти(Остаток, ".");
	ИмяФормыАвторизации = ИмяФормыАвторизации + "." + Лев(Остаток, ПозицияТочки - 1) + ".Форма.ПараметрыАвторизации";
	Возврат ИмяФормыАвторизации;
КонецФункции

&НаСервереБезКонтекста
Функция МожноВыгрузитьМодули()
	Сеансы = ПолучитьСеансыИнформационнойБазы();
	Для Каждого Сеанс Из Сеансы Цикл
		Если ВРег(Сеанс.ИмяПриложения) = "DESIGNER" Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	Возврат Истина;
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура СообщитьПользователю(ТекстСообщения)
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = ТекстСообщения;
	Сообщение.Сообщить();
КонецПроцедуры

&НаКлиенте
Функция ВыгрузитьТекстыВКаталог()
	Если ЗначениеЗаполнено(ВыгрузкаМодулейКаталог) Тогда
		УдалитьФайлы(Лев(ВыгрузкаМодулейКаталог, СтрДлина(ВыгрузкаМодулейКаталог) - 1));
	КонецЕсли;
	
	#Если НЕ ВебКлиент Тогда
	ВыгрузкаМодулейКаталог = ПолучитьИмяВременногоФайла("CodeUnload") + "\";
	#КонецЕсли
	
	СоздатьКаталог(ВыгрузкаМодулейКаталог);
	
	КодВозврата = NULL;
	ЗапуститьПриложение(Кавычка + КаталогBIN + "1cv8.exe" + Кавычка + " DESIGNER"
		+ " /IBConnectionString " + Кавычка + ПутьККонфигурации + Кавычка
		+ " /N "                  + Кавычка + ВыгрузкаМодулейПользователь + Кавычка
		+ " /P "                  + Кавычка + ВыгрузкаМодулейПароль + Кавычка
		+ " /DumpConfigFiles "    + Кавычка + ВыгрузкаМодулейКаталог + Кавычка
		+ " -Module"
		,
		,
		Истина,
		КодВозврата);
	//	/DumpConfigFiles <каталог выгрузки> [-Module] [-Template] [-Help] [-AllWritable] - выгрузка свойств объектов
	//	метаданных конфигурации.
	//		<Каталог выгрузки> - каталог расположения файлов свойств;
	//		Module - признак необходимости выгрузки модулей;
	//		Template - признак необходимости выгрузки шаблонов;
	//		Help - признак необходимости выгрузки справочной информации;
	//		AllWritable - признак выгрузки свойств только доступных для записи объектов.
	
	Возврат Истина;
КонецФункции

&НаКлиенте
Функция ЗагрузитьТекстыИзКаталога()
	#Если НЕ ВебКлиент Тогда
	Кавычка = """";
	
	КаталогBIN = КаталогПрограммы();
	
	ПутьККонфигурации = СтрокаСоединенияИнформационнойБазы();
	ПутьККонфигурации = СтрЗаменить(ПутьККонфигурации, Кавычка, Кавычка + Кавычка);
	
	КодВозврата = NULL;
	ЗапуститьПриложение(Кавычка + КаталогBIN + "1cv8.exe" + Кавычка + " DESIGNER"
		+ " /IBConnectionString " + Кавычка + ПутьККонфигурации + Кавычка
		+ " /N "                  + Кавычка + ВыгрузкаМодулейПользователь + Кавычка
		+ " /P "                  + Кавычка + ВыгрузкаМодулейПароль + Кавычка
		+ " /LoadConfigFiles "    + Кавычка + ВыгрузкаМодулейКаталог + Кавычка
		+ " -Module"
		+ " -AllWritable"
		,
		,
		Истина,
		КодВозврата);
	//	/LoadConfigFiles <каталог загрузки> [-Module] [-Template] [-Help] [-AllWritable] - загрузка свойств объектов
	//	метаданных конфигурации.
	//		<Каталог загрузки> - каталог расположения файлов свойств;
	//		Module - признак необходимости загрузки модулей;
	//		Template - признак необходимости загрузки шаблонов;
	//		Help - признак необходимости загрузки справочной информации;
	//		AllWritable - признак загрузки свойств только доступных для записи объектов.
	//	Если команда пакетного режима запуска прошла успешно, возвращает код возврата 0, в противном случае  - 1 (101, если
	//	в данных имеются ошибки).
	
	#КонецЕсли
	
	Возврат Истина;
КонецФункции

&НаКлиенте
Функция ОткрытьКонфигуратор()
	#Если НЕ ВебКлиент Тогда
	ЗапуститьПриложение(Кавычка + КаталогBIN + "1cv8.exe" + Кавычка + " DESIGNER"
		+ " /IBConnectionString " + Кавычка + ПутьККонфигурации + Кавычка
		+ " /N "                  + Кавычка + ВыгрузкаМодулейПользователь + Кавычка
		+ " /P "                  + Кавычка + ВыгрузкаМодулейПароль + Кавычка);
	#КонецЕсли
	
	Возврат Истина;
КонецФункции

#КонецОбласти

﻿&НаСервере
Перем СоответствиеТерминов;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗагружатьКонфигурациюИзФайлов = Истина;
	ВыгружатьКонфигурациюВФайлы = Истина;
	
	ПроверитьВерсиюИРежимСовместимостиПлатформы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КаталогВыгрузкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ДиалогВыбораПапки = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	Если Не ПустаяСтрока(КаталогВыгрузки) Тогда
		ДиалогВыбораПапки.Каталог = КаталогВыгрузки;
	КонецЕсли;
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриВыбореКаталога", ЭтотОбъект);
	ДиалогВыбораПапки.Показать(ОписаниеОповещения);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНайденныеМестаВнедрения

&НаКлиенте
Процедура НайденныеМестаВнедренияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.Прочитать(КаталогВыгрузки + Элемент.ТекущиеДанные.ИмяФайлаМодуля);
	ТекстовыйДокумент.Показать(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1: Модуль менеджера'"), Элемент.ТекущиеДанные.ИмяОбъекта), 
		КаталогВыгрузки + Элемент.ТекущиеДанные.ИмяФайлаМодуля);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьОбработку(Команда)
	
	РезультатВыполнения.Очистить();
	
	КаталогВыгрузки = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(КаталогВыгрузки);
	Если ВыгружатьКонфигурациюВФайлы И ВыгрузитьКонфигурациюВФайлы() > 0 Тогда
		Возврат;
	КонецЕсли;
	
	ОпределитьМестаВнедрения();
	КоличествоВставок = ВыполнитьВставкуКода();
	
	ВывестиСообщение(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Измененных модулей: %1.'"), КоличествоВставок));
	
	Если ЗагружатьКонфигурациюИзФайлов И ЗагрузитьКонфигурациюИзФайлов() > 0 Тогда
		Возврат;
	КонецЕсли;
	
	ВывестиСообщение(НСтр("ru = 'Обработка завершена.'"));
	Состояние(НСтр("ru = 'Обработка завершена'"), 100);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПроверитьВерсиюИРежимСовместимостиПлатформы()
	
	Информация = Новый СистемнаяИнформация;
	Если Не (Лев(Информация.ВерсияПриложения, 3) = "8.3"
		И (Метаданные.РежимСовместимости = Метаданные.СвойстваОбъектов.РежимСовместимости.НеИспользовать
		Или (Метаданные.РежимСовместимости <> Метаданные.СвойстваОбъектов.РежимСовместимости.Версия8_1
		И Метаданные.РежимСовместимости <> Метаданные.СвойстваОбъектов.РежимСовместимости.Версия8_2_13
		И Метаданные.РежимСовместимости <> Метаданные.СвойстваОбъектов.РежимСовместимости["Версия8_2_16"]
		И Метаданные.РежимСовместимости <> Метаданные.СвойстваОбъектов.РежимСовместимости["Версия8_3_1"]
		И Метаданные.РежимСовместимости <> Метаданные.СвойстваОбъектов.РежимСовместимости["Версия8_3_2"]
		И Метаданные.РежимСовместимости <> Метаданные.СвойстваОбъектов.РежимСовместимости["Версия8_3_3"]
		И Метаданные.РежимСовместимости <> Метаданные.СвойстваОбъектов.РежимСовместимости["Версия8_3_4"]
		И Метаданные.РежимСовместимости <> Метаданные.СвойстваОбъектов.РежимСовместимости["Версия8_3_5"]
		И Метаданные.РежимСовместимости <> Метаданные.СвойстваОбъектов.РежимСовместимости["Версия8_3_6"]))) Тогда
		
		ВызватьИсключение НСтр("ru = 'Обработка предназначена для запуска на версии платформы
			|1С:Предприятие 8.3.7 или выше'");
		
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ПриВыбореКаталога(ВыбранныеКаталоги, ДополнительныеПараметры) Экспорт
	Если ВыбранныеКаталоги = Неопределено Или ВыбранныеКаталоги.Количество() <> 1 Тогда
		Возврат;
	КонецЕсли;
	
	КаталогВыгрузки = ВыбранныеКаталоги[0];
КонецПроцедуры

&НаКлиенте
Процедура ВывестиСообщение(Знач ТекстСообщения, Знач Параметр1 = Неопределено, Знач Параметр2 = Неопределено)
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ТекстСообщения, Параметр1, Параметр2);
		
	ШаблонСообщения = "[%1] %2";
	РезультатВыполнения.Добавить(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ШаблонСообщения, Формат(ОбщегоНазначенияКлиент.ДатаСеанса(), "ДЛФ=T"), ТекстСообщения));
КонецПроцедуры

&НаКлиенте
Функция ВыгрузитьКонфигурациюВФайлы()
	Перем РезультатВыполненияКоманды;
	
#Если Не ВебКлиент Тогда
	
	ВывестиСообщение(НСтр("ru = 'Начало выгрузки конфигурации в файлы'"));
	Состояние(НСтр("ru = 'Выгрузка конфигурации...'"));
	
	Если ПустаяСтрока(КаталогВыгрузки) Тогда
		КаталогВыгрузки = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ПолучитьИмяВременногоФайла());
	КонецЕсли;
	Файл = Новый Файл(КаталогВыгрузки);
	Если Не Файл.Существует() Тогда
		СоздатьКаталог(КаталогВыгрузки);
	КонецЕсли;
	
	ШаблонКоманды = """[КаталогПрограммы]\1cv8.exe"" DESIGNER /DisableStartupMessages /DisableStartupDialogs "
		+ " /IBConnectionString ""[СтрокаСоединения]"""
		+ " /N ""[ИмяПользователя]"""
		+ " /P ""[Пароль]"""
		+ " /DumpConfigToFiles ""[КаталогВыгрузки]"" -Format Plain";
		
	ПараметрыКоманды = Новый Структура;
	ПараметрыКоманды.Вставить("КаталогПрограммы", КаталогПрограммы());
	ПараметрыКоманды.Вставить("СтрокаСоединения", СтрЗаменить(СтрокаСоединенияИнформационнойБазы(), """", """"""));
	ПараметрыКоманды.Вставить("ИмяПользователя", ИмяПользователя());
	ПараметрыКоманды.Вставить("Пароль", "");
	ПараметрыКоманды.Вставить("КаталогВыгрузки", КаталогВыгрузки);
	
	СтрокаКоманды = СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(ШаблонКоманды, ПараметрыКоманды);
	
	ЗапуститьПриложение(СтрокаКоманды, , Истина, РезультатВыполненияКоманды);
	
	ВывестиСообщение(НСтр("ru = 'Выгрузка конфигурации завершена с кодом %1'"), РезультатВыполненияКоманды);
	Возврат РезультатВыполненияКоманды;
#КонецЕсли
	
КонецФункции

&НаКлиенте
Функция ЗагрузитьКонфигурациюИзФайлов()
	Перем РезультатВыполненияКоманды;
	
#Если Не ВебКлиент Тогда
	
	ВывестиСообщение(НСтр("ru = 'Начало загрузки конфигурации из файлов'"));
	Состояние(НСтр("ru = 'Загрузка текстов модулей...'"));
	
	ШаблонКоманды = """[КаталогПрограммы]\1cv8.exe"" DESIGNER /DisableStartupMessages /DisableStartupDialogs "
		+ " /IBConnectionString ""[СтрокаСоединения]"""
		+ " /N ""[ИмяПользователя]"""
		+ " /P ""[Пароль]"""
		+ " /LoadConfigFromFiles ""[КаталогВыгрузки]""";
		
	ПараметрыКоманды = Новый Структура;
	ПараметрыКоманды.Вставить("КаталогПрограммы", КаталогПрограммы());
	ПараметрыКоманды.Вставить("СтрокаСоединения", СтрЗаменить(СтрокаСоединенияИнформационнойБазы(), """", """"""));
	ПараметрыКоманды.Вставить("ИмяПользователя", ИмяПользователя());
	ПараметрыКоманды.Вставить("Пароль", "");
	ПараметрыКоманды.Вставить("КаталогВыгрузки", КаталогВыгрузки);
	
	СтрокаКоманды = СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(ШаблонКоманды, ПараметрыКоманды);
	
	ЗапуститьПриложение(СтрокаКоманды, , Истина, РезультатВыполненияКоманды);
	
	ВывестиСообщение(НСтр("ru = 'Загрузка конфигурации завершена с кодом %1'"), РезультатВыполненияКоманды);
	Возврат РезультатВыполненияКоманды;
#КонецЕсли

КонецФункции

&НаКлиенте
Функция ВыполнитьВставкуКода()
	ВывестиСообщение(НСтр("ru = 'Выполняется вставка кода в модули'"));
	Результат = 0;
	Для Индекс = 0 По НайденныеМестаВнедрения.Количество() - 1 Цикл
		МестоВнедрения = НайденныеМестаВнедрения[Индекс];
		
		Состояние(НСтр("ru = 'Вставка кода в модули...'"), Окр((Индекс + 1) / НайденныеМестаВнедрения.Количество() * 20 + 80));
		ОбработкаПрерыванияПользователя();
		
		Файл = Новый Файл(КаталогВыгрузки + МестоВнедрения.ИмяФайлаМодуля);
		Если Не Файл.Существует() Тогда
			ЗаписьТекста = Новый ЗаписьТекста(КаталогВыгрузки + МестоВнедрения.ИмяФайлаМодуля);
			ЗаписьТекста.Записать(ШаблонПроцедурыДляПустогоМодуля());
			ЗаписьТекста.Закрыть();
			МестоВнедрения.МодульОбработан = Истина;
			Продолжить;
		КонецЕсли;
		
		ТекстМодуля = Новый ТекстовыйДокумент;
		ТекстМодуля.Прочитать(КаталогВыгрузки + МестоВнедрения.ИмяФайлаМодуля);
		НайденнаяПозицияВставки = СтрНайти(ТекстМодуля.ПолучитьТекст(), СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			"Процедура %1", ИмяВставляемойПроцедуры()));
		ВставкаНаходитсяВОбласти = Ложь;
		Если НайденнаяПозицияВставки > 0 Тогда
			МестоВнедрения.Пропустить = Истина;
			ТекстДоМестаВставки = НРег(Лев(ТекстМодуля.ПолучитьТекст(), НайденнаяПозицияВставки - 1));
			ВставкаНаходитсяВОбласти = СтрЧислоВхождений(ТекстДоМестаВставки, НРег("#Область")) > СтрЧислоВхождений(ТекстДоМестаВставки, НРег("#КонецОбласти"));
		КонецЕсли;
		
		НайденаОбластьПрограммныйИнтерфейс = Ложь;
		Если СтрНайти(ТекстМодуля.ПолучитьТекст(), ОбластьПрограммныйИнтерфейс()) > 0 Тогда
			НайденаОбластьПрограммныйИнтерфейс = Истина;
		КонецЕсли;
		
		ТекстДляВставки = ШаблонВставляемойПроцедуры();
		Если Не НайденаОбластьПрограммныйИнтерфейс Тогда
			ШаблонОбласти = 
				"
				|%1
				|%2
				|
				|#КонецОбласти";
			ТекстДляВставки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонОбласти,
				ОбластьПрограммныйИнтерфейс(), ТекстДляВставки);
		КонецЕсли;
	
		Если МестоВнедрения.Пропустить Тогда
			Если Не ВставкаНаходитсяВОбласти И Не НайденаОбластьПрограммныйИнтерфейс Тогда
				// Исправление области
				ЗаписьТекста = Новый ЗаписьТекста(КаталогВыгрузки + МестоВнедрения.ИмяФайлаМодуля);
				ЗаписьТекста.Записать(СтрЗаменить(ТекстМодуля.ПолучитьТекст(), ШаблонВставляемойПроцедуры(), ТекстДляВставки));
				ЗаписьТекста.Закрыть();
				МестоВнедрения.МодульОбработан = Истина;
				Результат = Результат + 1;
			КонецЕсли;
			Продолжить;
		КонецЕсли;
		
		ВозможноеМестоВставки = 1;
		Для НомерСтроки = 1 По ТекстМодуля.КоличествоСтрок() Цикл
			Строка = СокрЛП(ТекстМодуля.ПолучитьСтроку(НомерСтроки));
			Если НайденаОбластьПрограммныйИнтерфейс Тогда
				Если СтрНачинаетсяС(Строка, ОбластьПрограммныйИнтерфейс()) Тогда
					ВозможноеМестоВставки = НомерСтроки + 1;
					Прервать;
				КонецЕсли;
			Иначе
				Если СтрНачинаетсяС(Строка, "#Если") Или СтрНачинаетсяС(Строка, "Перем") Тогда
					ВозможноеМестоВставки = НомерСтроки + 1;
				ИначеЕсли СтрНачинаетсяС(Строка, "&") Или СтрНачинаетсяС(Строка, "Процедура") Или СтрНачинаетсяС(Строка, "Функция") Тогда
					Прервать;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
		ТекстМодуля.ВставитьСтроку(ВозможноеМестоВставки, ТекстДляВставки + Символы.ПС);
		
		ЗаписьТекста = Новый ЗаписьТекста(КаталогВыгрузки + МестоВнедрения.ИмяФайлаМодуля);
		ЗаписьТекста.Записать(ТекстМодуля.ПолучитьТекст());
		ЗаписьТекста.Закрыть();
		МестоВнедрения.МодульОбработан = Истина;
		Результат = Результат + 1;
	КонецЦикла;
	Возврат Результат;
КонецФункции

&НаСервере
Процедура ОпределитьМестаВнедрения()
	СоответствиеТерминов = СоответствиеТерминов();
	НайденныеМестаВнедрения.Очистить();
	Для Каждого Тип Из Метаданные.ОпределяемыеТипы.ВерсионируемыеДанные.Тип.Типы() Цикл
		ОбъектМетаданных = Метаданные.НайтиПоТипу(Тип);
		Если ОбъектМетаданных = Метаданные.Справочники.ИдентификаторыОбъектовМетаданных Тогда
			Продолжить;
		КонецЕсли;
		ИмяФайлаМодуляМенеджера = ИмяФайлаМодуля(ОбъектМетаданных, "МодульМенеджера");
		МестоВнедрения = НайденныеМестаВнедрения.Добавить();
		МестоВнедрения.ИмяОбъекта = ОбъектМетаданных.ПолноеИмя();
		МестоВнедрения.ИмяФайлаМодуля = ИмяФайлаМодуляМенеджера;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Функция ИмяВставляемойПроцедуры()
	Возврат "ПриОпределенииНастроекВерсионированияОбъектов";
КонецФункции

&НаКлиенте
Функция ШаблонВставляемойПроцедуры()
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		"
		|// СтандартныеПодсистемы.ВерсионированиеОбъектов
		|
		|// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
		|//
		|// Параметры:
		|//  Настройки - Структура - настройки подсистемы.
		|Процедура %1(Настройки) Экспорт
		|
		|КонецПроцедуры
		|
		|// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов", ИмяВставляемойПроцедуры());
		
КонецФункции

&НаКлиенте
Функция ОбластьПрограммныйИнтерфейс()
	Возврат "#" + "Область ПрограммныйИнтерфейс"; // Не локализуется
КонецФункции

&НаКлиенте
Функция ШаблонПроцедурыДляПустогоМодуля()
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		"#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
		|
		|#Область ПрограммныйИнтерфейс
		|
		|%1
		|
		|#КонецОбласти
		|
		|#КонецЕсли", СокрЛП(ШаблонВставляемойПроцедуры()));
КонецФункции

&НаСервере
Функция СоответствиеТерминов()
	
	СтруктураПредставлений = Новый Структура;
	
	// Виды объектов метаданных.
	СтруктураПредставлений.Вставить("РегистрБухгалтерии", "AccountingRegister");
	СтруктураПредставлений.Вставить("РегистрНакопления", "AccumulationRegister");
	СтруктураПредставлений.Вставить("БизнесПроцесс", "BusinessProcess");
	СтруктураПредставлений.Вставить("РегистрРасчета", "CalculationRegister");
	СтруктураПредставлений.Вставить("Справочник", "Catalog");
	СтруктураПредставлений.Вставить("ПланСчетов", "ChartOfAccounts");
	СтруктураПредставлений.Вставить("ПланВидовРасчета", "ChartOfCalculationTypes");
	СтруктураПредставлений.Вставить("ПланВидовХарактеристик", "ChartOfCharacteristicTypes");
	СтруктураПредставлений.Вставить("ГруппаКоманд", "CommandGroup");
	СтруктураПредставлений.Вставить("ОбщийРеквизит", "CommonAttribute");
	СтруктураПредставлений.Вставить("ОбщаяКоманда", "CommonCommand");
	СтруктураПредставлений.Вставить("ОбщаяФорма", "CommonForm");
	СтруктураПредставлений.Вставить("ОбщийМодуль", "CommonModule");
	СтруктураПредставлений.Вставить("ОбщаяКартинка", "CommonPicture");
	СтруктураПредставлений.Вставить("ОбщийМакет", "CommonTemplate");
	СтруктураПредставлений.Вставить("Конфигурация", "Configuration");
	СтруктураПредставлений.Вставить("Константа", "Constant");
	СтруктураПредставлений.Вставить("Обработка", "DataProcessor");
	СтруктураПредставлений.Вставить("ОпределяемыйТип", "DefinedType");
	СтруктураПредставлений.Вставить("Документ", "Document");
	СтруктураПредставлений.Вставить("ЖурналДокументов", "DocumentJournal");
	СтруктураПредставлений.Вставить("НумераторДокументов", "DocumentNumerator");
	СтруктураПредставлений.Вставить("Перечисление", "Enum");
	СтруктураПредставлений.Вставить("ПодпискаНаСобытие", "EventSubscription");
	СтруктураПредставлений.Вставить("ПланОбмена", "ExchangePlan");
	СтруктураПредставлений.Вставить("КритерийОтбора", "FilterCriterion");
	СтруктураПредставлений.Вставить("ФункциональнаяОпция", "FunctionalOption");
	СтруктураПредставлений.Вставить("ПараметрФункциональныхОпций", "FunctionalOptionsParameter");
	СтруктураПредставлений.Вставить("РегистрСведений", "InformationRegister");
	СтруктураПредставлений.Вставить("Язык", "Language");
	СтруктураПредставлений.Вставить("Отчет", "Report");
	СтруктураПредставлений.Вставить("Роль", "Role");
	СтруктураПредставлений.Вставить("РегламентноеЗадание", "ScheduledJob");
	СтруктураПредставлений.Вставить("Последовательность", "Sequence");
	СтруктураПредставлений.Вставить("ПараметрСеанса", "SessionParameter");
	СтруктураПредставлений.Вставить("ХранилищеНастроек", "SettingsStorage");
	СтруктураПредставлений.Вставить("Стиль", "Style");
	СтруктураПредставлений.Вставить("ЭлементСтиля", "StyleItem");
	СтруктураПредставлений.Вставить("Подсистема", "Subsystem");
	СтруктураПредставлений.Вставить("Задача", "Task");
	СтруктураПредставлений.Вставить("WebСервис", "WebService");
	СтруктураПредставлений.Вставить("WSСсылка", "WSReference");
	СтруктураПредставлений.Вставить("ПакетXDTO", "XDTOPackage");
	
	// Типы вложенных объектов метаданных.
	СтруктураПредставлений.Вставить("Модуль", "Module");
	СтруктураПредставлений.Вставить("МодульМенеджера", "ManagerModule");
	СтруктураПредставлений.Вставить("МодульОбъекта", "ObjectModule");
	СтруктураПредставлений.Вставить("МодульКоманды", "CommandModule");
	СтруктураПредставлений.Вставить("МодульНабораЗаписей", "RecordSetModule");
	СтруктураПредставлений.Вставить("МодульМенеджераЗначения", "ValueManagerModule");
	
	СтруктураПредставлений.Вставить("МодульВнешнегоСоединения", "ExternalConnectionModule");
	СтруктураПредставлений.Вставить("МодульУправляемогоПриложения", "ManagedApplicationModule");
	СтруктураПредставлений.Вставить("МодульОбычногоПриложения", "OrdinaryApplicationModule");
	СтруктураПредставлений.Вставить("МодульСеанса", "SessionModule");
	
	СтруктураПредставлений.Вставить("Справка", "Help");
	СтруктураПредставлений.Вставить("Форма", "Form");
	СтруктураПредставлений.Вставить("КартаМаршрута", "Flowchart");
	СтруктураПредставлений.Вставить("Картинка", "Picture");
	СтруктураПредставлений.Вставить("КомандныйИнтерфейс", "CommandInterface");
	
	СтруктураПредставлений.Вставить("Макет", "Template");
	СтруктураПредставлений.Вставить("Команда", "Command");
	СтруктураПредставлений.Вставить("Агрегаты", "Aggregates");
	СтруктураПредставлений.Вставить("Перерасчет", "Recalculation");
	СтруктураПредставлений.Вставить("Предопределенные", "Predefined");
	СтруктураПредставлений.Вставить("Состав", "Content");
	СтруктураПредставлений.Вставить("Права", "Rights");
	СтруктураПредставлений.Вставить("Расписание", "Schedule");
	
	Возврат СтруктураПредставлений;
	
КонецФункции

&НаСервере
Функция ИмяФайлаМодуля(ОбъектМетаданных, Знач ТипМодуля)
	
	ШаблонИмени = "[ИмяБазовогоТипа].[ИмяОбъекта].[ТипМодуля].txt";
	
	ИмяБазовогоТипа = СтрРазделить(ОбъектМетаданных.ПолноеИмя(), ".")[0];
	ИмяБазовогоТипа = СоответствиеТерминов[ИмяБазовогоТипа];
	ИмяОбъекта = ОбъектМетаданных.Имя;
	ТипМодуля = СоответствиеТерминов[ТипМодуля];
	
	ИмяФайлаМодуля = СтрЗаменить(ШаблонИмени, "[ИмяБазовогоТипа]", ИмяБазовогоТипа);
	ИмяФайлаМодуля = СтрЗаменить(ИмяФайлаМодуля, "[ИмяОбъекта]", ИмяОбъекта);
	ИмяФайлаМодуля = СтрЗаменить(ИмяФайлаМодуля, "[ТипМодуля]", ТипМодуля);
	
	Возврат ИмяФайлаМодуля;
	
КонецФункции

#КонецОбласти

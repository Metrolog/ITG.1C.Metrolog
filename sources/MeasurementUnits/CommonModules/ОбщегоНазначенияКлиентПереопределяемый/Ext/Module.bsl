﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность".
// В этом модуле содержится реализация обработчиков модуля приложения. 
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Выполняется перед интерактивным началом работы пользователя с областью данных или в локальном режиме.
//
// Соответствует обработчику ПередНачаломРаботыСистемы.
//
// Параметры:
//  Параметры - Структура - структура со свойствами:
//              Отказ                  - Булево - Возвращаемое значение. Если установить Истина,
//                                       то работа программы будет прекращена.
//              Перезапустить          - Булево - Возвращаемое значение. Если установить Истина и параметр.
//                                       Отказ тоже установлен в Истина, то выполняется перезапуск программы.
//              ДополнительныеПараметрыКоманднойСтроки - Строка - Возвращаемое значение. Имеет смысл
//                                       когда Отказ и Перезапустить установлены Истина.
//              ИнтерактивнаяОбработка - ОписаниеОповещения - Возвращаемое значение. Для открытия окна,
//                                       блокирующего вход в программу, следует присвоить в этот параметр
//                                       описание обработчика оповещения, который открывает окно.
//                                       См. пример ниже.
//              ОбработкаПродолжения   - ОписаниеОповещения - если открывается окно, блокирующее вход
//                                       в программу, то в обработке закрытия этого окна необходимо
//                                       выполнить оповещение ОбработкаПродолжения.
//                                       См. пример ниже.
//
// Пример открытия окна, блокирующего вход в программу:
//
//		Если ОткрытьОкноПриЗапуске Тогда
//			Параметры.ИнтерактивнаяОбработка = Новый ОписаниеОповещения("ОткрытьОкно", ЭтотОбъект);
//		КонецЕсли;
//
//	Процедура ОткрытьОкно(Параметры, ДополнительныеПараметры) Экспорт
//		// Показываем окно, по закрытию которого вызывается обработчик оповещения ОткрытьОкноЗавершение.
//		Оповещение = Новый ОписаниеОповещения("ОткрытьОкноЗавершение", ЭтотОбъект, Параметры);
//		Форма = ОткрытьФорму(... ,,, ... Оповещение);
//		Если Не Форма.Открыта() Тогда // Если ПриСозданииНаСервере Отказ установлен Истина.
//			ВыполнитьОбработкуОповещения(Параметры.ОбработкаПродолжения);
//		КонецЕсли;
//	КонецПроцедуры
//
//	Процедура ОткрытьОкноЗавершение(Результат, Параметры) Экспорт
//		...
//		ВыполнитьОбработкуОповещения(Параметры.ОбработкаПродолжения);
//		
//	КонецПроцедуры
//
Процедура ПередНачаломРаботыСистемы(Параметры) Экспорт
	
КонецПроцедуры

// Выполняется при интерактивном начале работы пользователя с областью данных или в локальном режиме.
//
// Соответствует обработчику ПриНачалеРаботыСистемы.
//
// Параметры:
//  Параметры - Структура - структура со свойствами:
//            * Отказ                  - Булево - Возвращаемое значение. Если установить Истина,
//                                       то работа программы будет прекращена.
//            * Перезапустить          - Булево - Возвращаемое значение. Если установить Истина и параметр.
//                                       Отказ тоже установлен в Истина, то выполняется перезапуск программы.
//            * ДополнительныеПараметрыКоманднойСтроки - Строка - Возвращаемое значение. Имеет смысл
//                                       когда Отказ и Перезапустить установлены Истина.
//            * ИнтерактивнаяОбработка - ОписаниеОповещения - Возвращаемое значение. Для открытия окна,
//                                       блокирующего вход в программу, следует присвоить в этот параметр
//                                       описание обработчика оповещения, который открывает окно.
//                                       См. пример выше (для обработчика ПередНачаломРаботыСистемы).
//            * ОбработкаПродолжения   - ОписаниеОповещения - если открывается окно, блокирующее вход
//                                       в программу, то в обработке закрытия этого окна необходимо
//                                       выполнить оповещение ОбработкаПродолжения.
//                                       См. пример выше (для обработчика ПередНачаломРаботыСистемы).
//
Процедура ПриНачалеРаботыСистемы(Параметры) Экспорт
	
	// _Демо начало примера
	ПараметрыРаботы = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	Если ПараметрыРаботы.РазделениеВключено И Не ПараметрыРаботы.ДоступноИспользованиеРазделенныхДанных Тогда
		Возврат;
	КонецЕсли;
	
	ПредлагатьПерейтиНаСайтПриЗапуске = ПараметрыРаботы.ПредлагатьПерейтиНаСайтПриЗапуске;
	Если ПредлагатьПерейтиНаСайтПриЗапуске Тогда
		Параметры.ИнтерактивнаяОбработка = Новый ОписаниеОповещения("ПредлагатьПерейтиНаСайтПриЗапуске", _ДемоСтандартныеПодсистемыКлиент);
	КонецЕсли;
	// _Демо конец примера
	
	// ИнтернетПоддержкаПользователей
	ИнтернетПоддержкаПользователейКлиент.ПриНачалеРаботыСистемы();
	// Конец ИнтернетПоддержкаПользователей

КонецПроцедуры

// Обработать параметры запуска программы.
// Реализация функции может быть расширена для обработки новых параметров.
//
// Параметры:
//  ЗначениеПараметраЗапуска - Строка - первое значение параметра запуска, 
//                                      до первого символа ";".
//  ПараметрыЗапуска  - Строка - параметр запуска, переданный в конфигурацию 
//                               с помощью ключа командной строки /C.
//  Отказ             - Булево - Возвращаемое значение. Если установить Истина,
//                               то выполнение процедуры ПриНачалеРаботыСистемы будет прервано.
//
Процедура ПриОбработкеПараметровЗапуска(ЗначениеПараметраЗапуска, ПараметрыЗапуска, Отказ) Экспорт

КонецПроцедуры

// Выполняется при интерактивном начале работы пользователя с областью данных или в локальном режиме.
// Вызывается после завершения действий ПриНачалеРаботыСистемы.
// Используется для подключения обработчиков ожидания, которые не должны вызываться
// в случае интерактивных действий перед и при начале работы системы.
//
// Начальная страница (рабочий стол) в этот момент еще не открыта, поэтому запрещено открывать
// формы напрямую, а следует использовать для этих целей обработчик ожидания.
// Запрещено использовать это событие для интерактивного взаимодействия с пользователем
// (ПоказатьВопрос и аналогичные действия). Для этих целей следует использовать
// событие ПриНачалеРаботыСистемы, который поддерживает продолжение своего выполнения.
//
Процедура ПослеНачалаРаботыСистемы() Экспорт
	
КонецПроцедуры

// Выполняется перед интерактивном завершении работы пользователя с областью данных или в локальном режиме.
// Соответствует обработчику ПередЗавершениемРаботыСистемы.
// Доопределяет список предупреждений пользователю перед завершением работы системы.
//
// Параметры:
//  Отказ - Булево - Признак отказа от выхода из программы. Если в теле процедуры-обработчика установить
//                   данному параметру значение Истина, то работа с программой не будет завершена.
//  Предупреждения - Массив - в массив можно добавить элементы типа Структура,
//                            свойства которой см. в СтандартныеПодсистемыКлиент.ПредупреждениеПриЗавершенииРаботы.
//
//
Процедура ПередЗавершениемРаботыСистемы(Отказ, Предупреждения) Экспорт
	
КонецПроцедуры

// Переопределяет заголовок приложения.
//
// Параметры:
//  ЗаголовокПриложения - Строка - текст заголовка приложения;
//  ПриЗапуске - Булево - Истина, если вызывается при начале работы программы.
Процедура ПриУстановкеЗаголовкаКлиентскогоПриложения(ЗаголовокПриложения, ПриЗапуске) Экспорт
	
	// _Демо начало примера
	ПараметрыКлиента = ?(ПриЗапуске, СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске(),
		СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента());
	ТекущийПроект = Неопределено;	
	Если ПараметрыКлиента.ДоступноИспользованиеРазделенныхДанных И ПараметрыКлиента.Свойство("ТекущийПроект", ТекущийПроект) 
		И Не ПараметрыКлиента.ТекущийПроект.Пустая() Тогда
		ЗаголовокПриложения = Строка(ПараметрыКлиента.ТекущийПроект) + " / " + ЗаголовокПриложения;
	КонецЕсли;
	// _Демо конец примера
		
КонецПроцедуры

#КонецОбласти

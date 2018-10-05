﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Стандартные подсистемы ИТГ. Числа".
// ОбщийМодуль.Числа.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает идентификатор подсистемы в в справочнике объектов
// метаданных.
//
Функция ИдентификаторПодсистемы() Экспорт
	
	Возврат ОбщегоНазначения.ИдентификаторОбъектаМетаданных(
		"Подсистема.СтандартныеПодсистемыИТГ.Подсистема.Числа");
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

#КонецОбласти
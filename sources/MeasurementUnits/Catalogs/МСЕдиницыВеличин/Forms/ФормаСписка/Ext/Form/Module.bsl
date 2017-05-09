﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Справочники.МСЕдиницыВеличин);
	
	// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов
	Элементы.ФормаИзменитьВыделенные.Видимость = МожноРедактировать;
	Элементы.СписокКонтекстноеМенюИзменитьВыделенные.Видимость = МожноРедактировать;
	// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов
	
	// СтандартныеПодсистемы.ПоискИУдалениеДублей
	Элементы.ФормаОбъединитьВыделенные.Видимость = МожноРедактировать;
	Элементы.СписокКонтекстноеМенюОбъединитьВыделенные.Видимость = МожноРедактировать;
	Элементы.ФормаЗаменитьИУдалить.Видимость = МожноРедактировать;
	Элементы.СписокКонтекстноеМенюЗаменитьИУдалить.Видимость = МожноРедактировать;
	// Конец СтандартныеПодсистемы.ПоискИУдалениеДублей

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

#КонецОбласти

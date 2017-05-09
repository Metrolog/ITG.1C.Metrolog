﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает сведения о внешней обработке.
Функция СведенияОВнешнейОбработке() Экспорт
	ПараметрыРегистрации = ДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке("2.2.2.1");
	ПараметрыРегистрации.Информация = НСтр("ru = 'Обработка формирования печатной формы документа ""Демо: Списание товаров"". Печатные формы создаются в формате популярных офисных пакетов. Используется для демонстрации возможностей подсистемы ""Дополнительные отчеты и обработки"".'");
	ПараметрыРегистрации.Вид = ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиПечатнаяФорма();
	ПараметрыРегистрации.Версия = "2.3.3.42";
	ПараметрыРегистрации.Назначение.Добавить("Документ._ДемоСписаниеТоваров");
	
	Команда = ПараметрыРегистрации.Команды.Добавить();
	Команда.Представление = НСтр("ru = 'Списание товаров в Microsoft Word (внешняя печатная форма)'");
	Команда.Идентификатор = "СписаниеТоваровMSWord";
	Команда.Использование = ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыВызовКлиентскогоМетода();
	Команда.ПоказыватьОповещение = Истина;
	
	Возврат ПараметрыРегистрации;
КонецФункции

#КонецОбласти

#КонецЕсли
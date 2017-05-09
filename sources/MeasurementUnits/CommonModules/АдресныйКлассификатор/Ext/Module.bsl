﻿////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Подсистема "Адресный классификатор".
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет наименование с сокращением региона по его коду.
//
// Параметры:
//    КодСубъектаРФ - Число, Строка - код региона.
//
// Возвращаемое значение:
//    Строка       - наименование и сокращение региона. 
//    Неопределено - если регион не найден.
//
Функция НаименованиеРегионаПоКоду(КодСубъектаРФ) Экспорт
	
	Запрос = Новый Запрос("
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	Наименование + "" "" + Сокращение КАК Наименование
		|ИЗ
		|	РегистрСведений.АдресныеОбъекты
		|ГДЕ
		|	Уровень = 1
		|	И КодСубъектаРФ = &КодСубъектаРФ
		|");
		
	ТипЧисло = Новый ОписаниеТипов("Число");
	ЧисловойКодСубъекта = ТипЧисло.ПривестиЗначение(КодСубъектаРФ);
		
	Запрос.УстановитьПараметр("КодСубъектаРФ", ЧисловойКодСубъекта );
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда 
		Возврат Выборка.Наименование;
	КонецЕсли;
	
	// Если не нашли, то подсмотрим еще и в классификаторе - макете.
	Классификатор = РегистрыСведений.АдресныеОбъекты.КлассификаторСубъектовРФ();
	Вариант = Классификатор.Найти(КодСубъектаРФ, "КодСубъектаРФ");
	Если Вариант = Неопределено Тогда
		// Не нашли
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат Вариант.Наименование + " " + Вариант.Сокращение;
КонецФункции

// Возвращает код региона по наименованию.
//
// Параметры:
//    Название - Строка - наименование или полное наименование (с сокращением) региона.
//
// Возвращаемое значение:
//    Число        - код региона.
//    Неопределено - если данные не найдены.
//
Функция КодРегионаПоНаименованию(Название) Экспорт
	
	Запрос = Новый Запрос("
		|ВЫБРАТЬ 
		|	Варианты.КодСубъектаРФ
		|ИЗ (
		|	ВЫБРАТЬ ПЕРВЫЕ 1
		|		1             КАК Порядок,
		|		КодСубъектаРФ КАК КодСубъектаРФ
		|	ИЗ
		|		РегистрСведений.АдресныеОбъекты
		|	ГДЕ
		|		Уровень = 1 
		|		И Наименование = &Название
		|
		|	ОБЪЕДИНИТЬ ВСЕ
		|
		|	ВЫБРАТЬ ПЕРВЫЕ 1
		|		2             КАК Порядок,
		|		КодСубъектаРФ КАК КодСубъектаРФ
		|	ИЗ
		|		РегистрСведений.АдресныеОбъекты
		|	ГДЕ
		|		Уровень = 1 
		|		И Наименование = &Наименование
		|		И Сокращение   = &Сокращение
		|) КАК Варианты
		|
		|УПОРЯДОЧИТЬ ПО
		|	Варианты.Порядок
		|");
		
	ЧастиСлова = АдресныйКлассификаторКлиентСервер.НаименованиеИСокращение(Название);
	Запрос.УстановитьПараметр("Наименование", ЧастиСлова.Наименование);
	Запрос.УстановитьПараметр("Сокращение",   ЧастиСлова.Сокращение);
	Запрос.УстановитьПараметр("Название",     Название);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда 
		Возврат Выборка.КодСубъектаРФ;
	КонецЕсли;

	// Если не нашли, то подсмотрим еще и в классификаторе - макете.
	Классификатор = РегистрыСведений.АдресныеОбъекты.КлассификаторСубъектовРФ();
	
	Фильтр = Новый Структура("Наименование", Название);
	Варианты = Классификатор.НайтиСтроки(Фильтр);
	Если Варианты.Количество() = 0 Тогда
		Фильтр.Вставить("Наименование", ЧастиСлова.Наименование);
		Фильтр.Вставить("Сокращение",   ЧастиСлова.Сокращение);
		Варианты = Классификатор.НайтиСтроки(Фильтр);
	КонецЕсли;
	
	Если Варианты.Количество() > 0 Тогда
		Возврат Варианты[0].КодСубъектаРФ;
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции

// Возвращает информацию по всем известным субъектам РФ (как классификатор так и загруженные).
//
// Возвращаемое значение:
//     ТаблицаЗначений - поставляемые данные. Содержит колонки:
//       * КодСубъектаРФ  - Число  - код классификатора субъекта, например 77 для Москвы.
//       * Наименование   - Строка - наименование субъекта по классификатору. Например "Московская".
//       * Сокращение     - Строка - наименование субъекта по классификатору. Например "обл".
//       * ПочтовыйИндекс - Число  - индекс региона. Если 0 - то индекс не определен.
//       * Идентификатор  - УникальныйИдентификатор - идентификатор ФИАС.
//
Функция КлассификаторСубъектовРФ() Экспорт
	
	Возврат РегистрыСведений.АдресныеОбъекты.КлассификаторСубъектовРФ();
	
КонецФункции

// Определяет количество субъектов РФ, по которым загружен адресный классификатор.
//
// Возвращаемое значение:
//    Число - количество регионов с загруженными данными.
//
Функция КоличествоЗагруженныхРегионов() Экспорт
	
	Если АдресныйКлассификаторСлужебный.ИсточникДанныхАдресногоКлассификатораВебСервис() Тогда
		Возврат КлассификаторСубъектовРФ().Количество();
	КонецЕсли;
	
	Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|	КОЛИЧЕСТВО(Регионы.КодСубъектаРФ) КАК КоличествоЗагруженных
		|ИЗ
		|	РегистрСведений.АдресныеОбъекты КАК Регионы
		|ГДЕ
		|	Регионы.Уровень = 1
		|	И 1 В (
		|		ВЫБРАТЬ ПЕРВЫЕ 1 1 ИЗ РегистрСведений.АдресныеОбъекты
		|		ГДЕ Уровень = 2 И КодСубъектаРФ = Регионы.КодСубъектаРФ
		|		ОБЪЕДИНИТЬ ВСЕ ВЫБРАТЬ ПЕРВЫЕ 1 1 ИЗ РегистрСведений.АдресныеОбъекты
		|		ГДЕ Уровень = 3 И КодСубъектаРФ = Регионы.КодСубъектаРФ
		|		ОБЪЕДИНИТЬ ВСЕ ВЫБРАТЬ ПЕРВЫЕ 1 1 ИЗ РегистрСведений.АдресныеОбъекты
		|		ГДЕ Уровень = 4 И КодСубъектаРФ = Регионы.КодСубъектаРФ
		|		ОБЪЕДИНИТЬ ВСЕ ВЫБРАТЬ ПЕРВЫЕ 1 1 ИЗ РегистрСведений.АдресныеОбъекты
		|		ГДЕ Уровень = 5 И КодСубъектаРФ = Регионы.КодСубъектаРФ
		|		ОБЪЕДИНИТЬ ВСЕ ВЫБРАТЬ ПЕРВЫЕ 1 1 ИЗ РегистрСведений.АдресныеОбъекты
		|		ГДЕ Уровень = 6 И КодСубъектаРФ = Регионы.КодСубъектаРФ
		|		ОБЪЕДИНИТЬ ВСЕ ВЫБРАТЬ ПЕРВЫЕ 1 1 ИЗ РегистрСведений.АдресныеОбъекты
		|		ГДЕ Уровень = 7 И КодСубъектаРФ = Регионы.КодСубъектаРФ
		|		ОБЪЕДИНИТЬ ВСЕ ВЫБРАТЬ ПЕРВЫЕ 1 1 ИЗ РегистрСведений.АдресныеОбъекты
		|		ГДЕ Уровень = 90 И КодСубъектаРФ = Регионы.КодСубъектаРФ
		|		ОБЪЕДИНИТЬ ВСЕ ВЫБРАТЬ ПЕРВЫЕ 1 1 ИЗ РегистрСведений.АдресныеОбъекты
		|		ГДЕ Уровень = 91 И КодСубъектаРФ = Регионы.КодСубъектаРФ
		|	)
		|");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.КоличествоЗагруженных;
	КонецЕсли;
	
	Возврат 0;
КонецФункции

// Проверка загруженности адресного классификатора.
//
// Возвращаемое значение:
//     Булево - Истина, если адресный классификатор загружен хотя бы по одному региону, Ложь - в противном случае.
//
Функция КлассификаторЗагружен() Экспорт
	
	Если АдресныйКлассификаторСлужебный.ИсточникДанныхАдресногоКлассификатораВебСервис() Тогда
		Возврат Истина;
	КонецЕсли;
	
	Запрос = Новый Запрос("
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	КодСубъектаРФ
		|ИЗ
		|	РегистрСведений.АдресныеОбъекты
		|ГДЕ
		|	Уровень > 1
		|");
	
	Возврат Не Запрос.Выполнить().Пустой();
КонецФункции

// Проверяет адреса на соответствие классификатору.
//
// Параметры:
//     Адреса - Массив - проверяемые адреса. Содержит структуры с полями:
//         * Адрес                             - ОбъектXDTO, Строка - Проверяемый адрес
//                                               ((http://www.v8.1c.ru/ssl/contactinfo) АдресРФ) или его
//                                               XML-сериализация.
//         * ФорматАдреса - Строка - Тип используемого для проверки по классификатору. Если "КЛАДР", то проверка
//                                   ведется только по уровням КЛАДР.
//
// Возвращаемое значение:
//     Массив - результаты анализа. Каждый элемент массива содержит структуры с полями:
//       * Ошибки   - Массив     - Описание ошибок поиска в классификаторе. Состоит из структур с полями.
//           ** Ключ     - Строка  - Служебный идентификатор места ошибки - путь XPath в объекте XDTO.
//           ** Текст    - Строка  - Текст ошибки.
//           ** Подсказка - Строка - Текст возможного исправления ошибки.
//       * Варианты - Массив     - Содержит описание найденных вариантов. Каждый элемент - структура с полями.
//           ** Идентификатор    - УникальныйИдентификатор  - идентификатор классификатора объекта - варианта.
//           ** Индекс           - Число - Почтовый индекс объекта - варианта.
//           ** КодКЛАДР         - Число - Код КЛАДР ближайшего объекта.
//           ** OKATO            - Число - Данные ФНС.
//           ** ОКТМО            - Число - Данные ФНС.
//           ** КодИФНСФЛ        - Число - Данные ФНС.
//           ** КодИФНСЮЛ        - Число - Данные ФНС.
//           ** КодУчасткаИФНСФЛ - Число - Данные ФНС.
//           ** КодУчасткаИФНСЮЛ - Число - Данные ФНС.
//
Функция ПроверитьАдреса(Адреса) Экспорт
	
	Результат = АдресныйКлассификаторСлужебный.РезультатПроверкиАдресовПоКлассификатору(Адреса);
	Возврат Результат.Данные;
	
КонецФункции

// Возвращает полное наименование адресного объекта по его сокращению.
// Если уровень не указан, то возвращает первое найденное совпадение.
//
// Параметры:
//  АдресноеСокращение	 - Строка - сокрушение адресного объекта.
//  Уровень				 - Число - код уровня адресного объекта.
//
// Возвращаемое значение:
//  Строка - полное наименование адресного объекта
//  Неопределено - если сокращение не найдено.
//
Функция ПолноеНаименованиеАдресногоСокращения(АдресноеСокращение, Уровень = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1 
		|	УровниСокращенийАдресныхСведений.Значение КАК Наименование
		|ИЗ
		|	РегистрСведений.УровниСокращенийАдресныхСведений КАК УровниСокращенийАдресныхСведений
		|ГДЕ
		|	УровниСокращенийАдресныхСведений.Сокращение = &Сокращение";
	
	Если ЗначениеЗаполнено(Уровень) Тогда 
		Запрос.Текст = Запрос.Текст + " И УровниСокращенийАдресныхСведений.Уровень = &Уровень";
		Запрос.УстановитьПараметр("Уровень", Уровень);
	КонецЕсли;
	Запрос.УстановитьПараметр("Сокращение", АдресноеСокращение);
	
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	
	Пока РезультатЗапроса.Следующий() Цикл
		Возврат РезультатЗапроса.Наименование;
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

// Определение кодов ОКАТО, ОКТМО, налоговых инспекций ФНС и др. адреса
//
// Параметры:
//  Адрес    - Строка - Адрес в формате XML
//  Источник - Строка - Необязательный. Источник получения кодов адреса:
//             "Сервис1С" - коды будут получены через веб-сервис 1С;
//             "ЗагруженныеДанные" - коды будут определены по загруженным данным адресного классификатора;
//             если параметрам не указан, то источник данных определяется автоматически.
// Возвращаемое значение:
//  Структура - Коды адреса, если адрес не найден, то все поля структуры содержат пустые значения.
//
Функция КодыАдреса(Адрес, Источник = Неопределено) Экспорт
	Возврат АдресныйКлассификаторСлужебный.КодыАдреса(Адрес, Источник);
КонецФункции

// Получает идентификаторы адреса через веб-сервис.
//
// Параметры:
//   Адрес                               - Строка - Строка XML контактной информации содержащая адрес.
// Возвращаемое значение:
//   Структура - набор пар ключ-значение.
//       * ИдентификаторАдресногоОбъекта - УникальныйИдентификатор - Идентификатор адресного объекта (улицы, нас. пункта).
//       * ИдентификаторДома             - УникальныйИдентификатор - Идентификатор дома адресного объекта.
//       * Отказ                         - Булево - Поставщик не доступен.
//       * ПодробноеПредставлениеОшибки  - Строка - Описание ошибки, если поставщик недоступен иначе Неопределено.
//       * КраткоеПредставлениеОшибки    - Строка - Описание ошибки, если поставщик недоступен иначе Неопределено.
//
Функция ИдентификаторыАдреса(Адрес) Экспорт
	Возврат АдресныйКлассификаторСлужебный.ОпределитьИдентификаторыАдреса(Адрес);
КонецФункции

#КонецОбласти


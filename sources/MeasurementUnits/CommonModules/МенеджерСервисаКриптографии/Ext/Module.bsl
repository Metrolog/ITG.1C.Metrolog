﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Менеджер сервиса криптографии".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ИзменениеНастроекПолученияВременныхПаролейПровайдером

Функция ПолучитьПроверочныйКод(ИдентификаторСертификата, Телефон, ИдентификаторЗаявления = Неопределено) Экспорт

	URL = АдресСервиса() + СтрШаблон("/hs/otp/%1/phone/requests", ВерсияПрограммногоИнтерфейса());
	
	ПараметрыЗапроса = Новый Структура("cert_id,phone", ИдентификаторСертификата, Телефон);
	Если ЗначениеЗаполнено(ИдентификаторЗаявления) Тогда
		ПараметрыЗапроса.Вставить("req_id", ИдентификаторЗаявления);
	КонецЕсли;
	
	ПоляОтвета = Новый Структура("req_id,num", "ИдентификаторЗаявления", "НомерКода");
	
	Возврат ВызватьHTTPМетод("POST", URL, ПараметрыЗапроса, ПоляОтвета);
		
КонецФункции

Функция ПроверитьТелефон(ИдентификаторЗаявления, КодПодтверждения) Экспорт
	
	URL = АдресСервиса() + СтрШаблон("/hs/otp/%1/phone/request/%2/code/%3",
										ВерсияПрограммногоИнтерфейса(),
										ИдентификаторЗаявления,
										Формат(КодПодтверждения, "ЧГ="));
										
	Возврат ВызватьHTTPМетод("POST", URL, Неопределено, Новый Структура);
	
КонецФункции

Функция НапечататьЗаявление(ИдентификаторЗаявления) Экспорт
	
	URL = АдресСервиса() + СтрШаблон("/hs/otp/%1/phone/request/%2",
										ВерсияПрограммногоИнтерфейса(),
										ИдентификаторЗаявления);
										
	Результат = ВызватьHTTPМетод("GET", URL, Неопределено, Новый Структура);
	Если Результат.Выполнено Тогда
		ИмяВременногоФайла = ПолучитьИмяВременногоФайла("mxl");
		Результат.Файл.Записать(ИмяВременногоФайла);
		
		ТабличныйДокумент = Новый ТабличныйДокумент;
		ТабличныйДокумент.Прочитать(ИмяВременногоФайла);
		
		УдалитьФайлы(ИмяВременногоФайла);
		
		Результат.Файл = ТабличныйДокумент;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ОтправитьЗаявление(ИдентификаторЗаявления, ФайлЗаявления) Экспорт
	
	URL = АдресСервиса() + СтрШаблон("/hs/otp/%1/phone/request/%2",
										ВерсияПрограммногоИнтерфейса(),
										ИдентификаторЗаявления);
										
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Disposition", 
		СтрШаблон("attachment; filename=%1", КодироватьСтроку(ФайлЗаявления.Имя, СпособКодированияСтроки.КодировкаURL)));
		
	Результат = ВызватьHTTPМетод("PUT", URL, ПолучитьИзВременногоХранилища(ФайлЗаявления.Адрес), Новый Структура, Заголовки);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область ИзменениеНастроекПолученияВременныхПаролейПользователем

Функция НачатьИзменениеНастроекПолученияВременныхПаролей(ИдентификаторСертификата, Телефон, ЭлектроннаяПочта, ТолькоПодтверждение = Ложь) Экспорт
	
	URL = АдресСервиса() + СтрШаблон("/hs/otp/%1/users_requests", ВерсияПрограммногоИнтерфейса());
	
	ПараметрыЗапроса = Новый Структура("cert_id", ИдентификаторСертификата);
	Если ЗначениеЗаполнено(Телефон) Тогда
		ПараметрыЗапроса.Вставить("phone", Телефон);
	КонецЕсли;
	Если ЗначениеЗаполнено(ЭлектроннаяПочта) Тогда
		ПараметрыЗапроса.Вставить("email", ЭлектроннаяПочта);
	КонецЕсли;
	Если ТолькоПодтверждение Тогда
		ПараметрыЗапроса.Вставить("only_confirm", ТолькоПодтверждение);
	КонецЕсли;
	
	ПоляОтвета = Новый Структура("req_id", "ИдентификаторЗаявления");
	
	Возврат ВызватьHTTPМетод("POST", URL, ПараметрыЗапроса, ПоляОтвета);
	
КонецФункции

Функция ЗавершитьИзменениеНастроекПолученияВременныхПаролей(ИдентификаторЗаявления, Код1, Код2) Экспорт
			
	URL = АдресСервиса() + СтрШаблон("/hs/otp/%1/user_request/%2", 
										ВерсияПрограммногоИнтерфейса(),
										ИдентификаторЗаявления);
										
	ПараметрыЗапроса = Новый Структура("req_id,code1,code2", ИдентификаторЗаявления, Код1, Код2);
	Если ЗначениеЗаполнено(Код2) Тогда
		ПараметрыЗапроса.Вставить("only_confirm", ЗначениеЗаполнено(Код2));
	КонецЕсли;

	Возврат ВызватьHTTPМетод("PUT", URL, ПараметрыЗапроса, Новый Структура);
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СоединениеССерверомИнтернета(ПараметрыСоединения)

	Прокси = ПолучениеФайловИзИнтернетаКлиентСервер.ПолучитьПрокси(ПараметрыСоединения.Схема);
	
	Таймаут = 30;
	Если ПараметрыСоединения.Свойство("Таймаут") Тогда
		Таймаут = ПараметрыСоединения.Таймаут;
	КонецЕсли;
	
	Попытка
		Соединение = Новый HTTPСоединение(
			ПараметрыСоединения.Хост,
			ПараметрыСоединения.Порт,
			ПараметрыСоединения.Логин,
			ПараметрыСоединения.Пароль, 
			Прокси,
			Таймаут,
			?(НРег(ПараметрыСоединения.Схема) = "http", Неопределено, Новый ЗащищенноеСоединениеOpenSSL));
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();	
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Электронная подпись в модели сервиса.Соединение с сервером интернета'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
		ВызватьИсключение;
	КонецПопытки;
	
	Возврат Соединение;
	
КонецФункции

Функция ПолучитьПараметрыСоединения(URL)
	
	ПараметрыСоединения = ОбщегоНазначенияКлиентСервер.СтруктураURI(URL);
	ПараметрыСоединения.Схема = ?(ЗначениеЗаполнено(ПараметрыСоединения.Схема), ПараметрыСоединения.Схема, "http");	
	ПараметрыСоединения.Вставить("Таймаут", 20);
	
	УстановитьПривилегированныйРежим(Истина);
	Владелец = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Константы.АдресСервисаПодключенияЭлектроннойПодписиВМоделиСервиса);
	ПараметрыСоединения.Вставить("Логин", ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(Владелец, "Логин", Истина));
	ПараметрыСоединения.Вставить("Пароль", ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(Владелец, "Пароль", Истина));
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ПараметрыСоединения;
	
КонецФункции

Функция АдресСервиса()
	
	УстановитьПривилегированныйРежим(Истина);

	Возврат Константы.АдресСервисаПодключенияЭлектроннойПодписиВМоделиСервиса.Получить();
	
КонецФункции

Функция ВерсияПрограммногоИнтерфейса()
	
	Возврат "v1";
	
КонецФункции

Функция JsonВСтруктуру(СтрокаJSON)
	
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(СтрокаJSON);
	Объект = ПрочитатьJSON(ЧтениеJSON);
	ЧтениеJSON.Закрыть();
	
	Возврат Объект;
	
КонецФункции

Функция СтруктураВJson(Объект)
	
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();
	ЗаписатьJSON(ЗаписьJSON, Объект);
	
	Возврат ЗаписьJSON.Закрыть();
	
КонецФункции

Функция ВызватьHTTPМетод(HTTPМетод, URL, ПараметрыЗапроса, СоответствиеПолейОтвета, Заголовки = Неопределено)
	
	ПараметрыСоединения = ПолучитьПараметрыСоединения(URL);
	Соединение = СоединениеССерверомИнтернета(ПараметрыСоединения);
	
	Запрос = Новый HTTPЗапрос(ПараметрыСоединения.ПутьНаСервере);
	Если ТипЗнч(ПараметрыЗапроса) = Тип("Структура") Тогда
		Запрос.Заголовки.Вставить("Content-Type", "application/javascript");
		Запрос.УстановитьТелоИзСтроки(СтруктураВJson(ПараметрыЗапроса));
	ИначеЕсли ТипЗнч(ПараметрыЗапроса) = Тип("ДвоичныеДанные") Тогда
		Запрос.Заголовки.Вставить("Content-Type", "application/octet-stream");
		Запрос.УстановитьТелоИзДвоичныхДанных(ПараметрыЗапроса);
	КонецЕсли;
	Если ЗначениеЗаполнено(Заголовки) Тогда
		Для Каждого Заголовок Из Заголовки Цикл
			Запрос.Заголовки.Вставить(Заголовок.Ключ, Заголовок.Значение);
		КонецЦикла;
	КонецЕсли;
		
	Ответ = Соединение.ВызватьHTTPМетод(HTTPМетод, Запрос);
	
	Результат = Новый Структура;	
	Если Ответ.КодСостояния = 200 Тогда
		Результат.Вставить("Выполнено", Истина);
		
		Если Ответ.Заголовки.Получить("Content-Type") = "application/javascript" Тогда
			ПараметрыОтвета = JsonВСтруктуру(Ответ.ПолучитьТелоКакСтроку());
			Для Каждого Поле Из СоответствиеПолейОтвета Цикл
				Если ПараметрыОтвета.Свойство(Поле.Ключ) Тогда
					Результат.Вставить(Поле.Значение, ПараметрыОтвета[Поле.Ключ]);
				КонецЕсли;
			КонецЦикла;
		ИначеЕсли Ответ.Заголовки.Получить("Content-Type") = "application/octet-stream" Тогда
			Результат.Вставить("Файл", Ответ.ПолучитьТелоКакДвоичныеДанные());
			Результат.Вставить("Имя", СтрЗаменить(Ответ.Заголовки.Получить("Content-Disposition"), "attachment; filename=", ""));
		КонецЕсли;
	ИначеЕсли Ответ.КодСостояния = 400 Тогда
		Результат.Вставить("Выполнено", Ложь);
		ПараметрыОтвета = JsonВСтруктуру(Ответ.ПолучитьТелоКакСтроку());
		Результат.Вставить("КодОшибки", ПолучитьКодОшибки(ПараметрыОтвета.err_code));
		Результат.Вставить("ОписаниеОшибки", СокрЛП(ПараметрыОтвета.err_msg));
	Иначе
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Электронная подпись в модели сервиса.Менеджер сервиса криптографии'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Ошибка,,, Ответ.ПолучитьТелоКакСтроку());
		Результат.Вставить("Выполнено", Ложь);
		Результат.Вставить("КодОшибки", "НеизвестнаяОшибка");
		Результат.Вставить("ОписаниеОшибки", "Неизвестная ошибка");
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьКодОшибки(err_code)
	
	КодыОшибок = Новый Соответствие;
	КодыОшибок.Вставить("CertificateNotFound", "СертификатНеНайден");
	КодыОшибок.Вставить("RequestNotFound", "ЗаявлениеНеНайдено");
	КодыОшибок.Вставить("Code1IsIncorrect", "Код1Неверный");
	КодыОшибок.Вставить("Code2IsIncorrect", "Код2Неверный");
	КодыОшибок.Вставить("CodeIsIncorrect", "КодНеверный");
	КодыОшибок.Вставить("NewPhoneIsEqualToTheCurrent", "НовыйТелефонРавенТекущему");
	КодыОшибок.Вставить("NewEmailIsEqualToTheCurrent", "НоваяЭлектроннаяПочтаРавнаТекущему");
	
	Возврат КодыОшибок.Получить(err_code);
	
КонецФункции

#КонецОбласти
﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ПравоДоступа("Администрирование", Метаданные) Тогда
		
		Сообщить(НСтр("ru = 'Настройка доступна только администратору'", "ru"));
		Отказ = Истина;
		Возврат;
		
	КонецЕсли;	
	
	Задание = РегламентныеЗадания.НайтиПредопределенное("НеотработанныеЗаказы");
	КоличествоДней = Задание.Расписание.ПериодПовтораДней;
	
	Если Объект.ПериодПроверкиНеотработанныхЗаказов = 0 Тогда
		Объект.ПериодПроверкиНеотработанныхЗаказов = 30;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Задание = РегламентныеЗадания.НайтиПредопределенное("НеотработанныеЗаказы");
	Задание.Расписание.ПериодПовтораДней = КоличествоДней;
	Задание.Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьСтрокиСЧислом();
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоДнейПриИзменении(Элемент)
	
	УстановитьСтрокиСЧислом();
	
КонецПроцедуры

&НаКлиенте
Процедура ИнтервалПроверкиИнтервалПроверкиЗаказовПриИзменении(Элемент)
	
	УстановитьСтрокиСЧислом();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтрокиСЧислом()
	
	КоличествоДнейСтрока = 
		СтрокаСЧислом(НСтр("ru = ';день;;дня;дней;дня'", "ru"), КоличествоДней, ВидЧисловогоЗначения.Количественное);
		
	ИнтервалПроверкиСтрока = 
		СтрокаСЧислом(НСтр("ru = ';дня;;дней;дней;дней'", "ru"), Объект.ПериодПроверкиНеотработанныхЗаказов, ВидЧисловогоЗначения.Количественное);
		
КонецПроцедуры


&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	БотСервер.ИзменениеНастройки();

КонецПроцедуры


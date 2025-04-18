﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ОБЪЕКТА

// новый релиз

Процедура ОбработкаПроведения(Отказ, Режим)

	// Создание движений в регистре накопления ТоварныеЗапасы
	Движения.ТоварныеЗапасы.Записывать = Истина;
	Для каждого ТекСтрокаТовары Из Товары Цикл

		Движение = Движения.ТоварныеЗапасы.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Период = Дата;
		Движение.Товар = ТекСтрокаТовары.Товар;
		Движение.Склад = Склад;
		
		// Начало изменений Пухов Олег 2025.04.07
		//Движение.Количество = ТекСтрокаТовары.Количество;
		Движение.Количество = БазовоеКоличество(ТекСтрокаТовары.Количество, ТекСтрокаТовары.ЕдиницаИзмерения);
		// Конец изменений Пухов Олег 2025.04.07

	КонецЦикла;

	// Создание движения в регистре накопления Взаиморасчеты
	Движения.Взаиморасчеты.Записывать = Истина;
	Движение = Движения.Взаиморасчеты.Добавить();
	Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
	Движение.Период = Дата;
	Движение.Контрагент = Поставщик;
	Движение.Валюта = Валюта;

	Если Валюта.Пустая() Тогда

		Движение.Сумма = Товары.Итог("Сумма");

	Иначе

		Курс = РегистрыСведений.КурсыВалют.ПолучитьПоследнее(Дата, Новый Структура("Валюта", Валюта)).Курс;

		Если Курс = 0 Тогда
			Движение.Сумма = Товары.Итог("Сумма");
		Иначе
			Движение.Сумма = Товары.Итог("Сумма") / Курс;
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Контрагенты") Тогда

		ЗапросПоКонтрагенту = Новый Запрос("ВЫБРАТЬ
		                                   |	Контрагенты.ЭтоГруппа
		                                   |ИЗ
		                                   |	Справочник.Контрагенты КАК Контрагенты
		                                   |ГДЕ
		                                   |	Контрагенты.Ссылка = &КонтрагентСсылка");
		ЗапросПоКонтрагенту.УстановитьПараметр("КонтрагентСсылка", ДанныеЗаполнения);
		Выборка = ЗапросПоКонтрагенту.Выполнить().Выбрать();
		Если Выборка.Следующий() И Выборка.ЭтоГруппа Тогда
			Возврат;
		КонецЕсли;
		
		Поставщик = ДанныеЗаполнения.Ссылка;
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	//Удалим из списка проверяемых реквизитов валюту, если по организации не ведется 
	//валютный учет
	Если НЕ ПолучитьФункциональнуюОпцию("ВалютныйУчет", Новый Структура("Организация", Организация)) Тогда
		ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("Валюта"));
	КонецЕсли;	
	
КонецПроцедуры

// Начало изменений Пухов Олег 2025.04.07
Функция БазовоеКоличество(Количество, ЕдиницаИзмерения)
	
	БазовоеКоличество = Количество;
	Если ЗначениеЗаполнено(Количество)
		И ЗначениеЗаполнено(ЕдиницаИзмерения) Тогда
		
		РеквизитыЕдиницы = ОбщегоНазначения.ЗначенияСвойствОбъекта(ЕдиницаИзмерения, "БазоваяЕдиница, Кратность");
		Если ЗначениеЗаполнено(РеквизитыЕдиницы.БазоваяЕдиница)
			И ЗначениеЗаполнено(РеквизитыЕдиницы.Кратность) Тогда
			
			БазовоеКоличество = Количество * РеквизитыЕдиницы.Кратность;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат БазовоеКоличество;
	
КонецФункции
// Конец изменений Пухов Олег 2025.04.07

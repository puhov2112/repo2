﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

#Если МобильныйКлиент Тогда 
	МеткиNDEF = СредстваNFC.МеткиNDEF;
	Если МеткиNDEF.ПоддерживаетсяЗаписьНаМетку() Тогда   
		ОповещениеОПоявленииМетки = Новый ОписаниеОповещения("ПриПоявленииМеткиЗаписатьСообщениеNDEF", ЭтотОбъект, ПараметрКоманды);
		МеткиNDEF.ВключитьАктивноеСканирование(, ОповещениеОПоявленииМетки);
	Иначе
		сообщить("Нет возможности для записи метки!");
	КонецЕсли;
#КонецЕсли

КонецПроцедуры

&НаКлиенте
Асинх Процедура ПриПоявленииМеткиЗаписатьСообщениеNDEF(Метка, ДополнительныеДанные) Экспорт
	
#Если МобильныйКлиент Тогда 
	если Метка = Неопределено тогда
		возврат;
	конецЕсли;
	
	попытка 
		записи = Новый Массив(1);
		записи[0] = Новый ТекстоваяЗаписьNDEF(Строка(ДополнительныеДанные.УникальныйИдентификатор()));
		фиксированныеЗаписи = Новый ФиксированныйМассив(записи);
		сообщение = Новый СообщениеNDEF(фиксированныеЗаписи);
		
		ждать Метка.ЗаписатьСообщениеАсинх(сообщение);
	исключение
		сообщить("Произошла ошибка, попробуйте еще раз.");
	конецпопытки;
#КонецЕсли
	
КонецПроцедуры

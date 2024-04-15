#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	СформироватьДвиженияОсновныеНачисления();
	СформироватьДвиженияДополнительныеНачисления();
	СформироватьДвиженияУдержания();
	
	РассчитатьОклад();	
	РассчитатьОтпускные();
	РассчитатьНДФЛ();
	ФормированиеДвиженийПоРН();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СформироватьДвиженияОсновныеНачисления()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВКМ_НачисленияЗарплатыНачисления.НомерСтроки КАК НомерСтроки,
	|	ВКМ_НачисленияЗарплатыНачисления.Сотрудник КАК Сотрудник,
	|	ВКМ_НачисленияЗарплатыНачисления.ВидРасчета КАК ВидРасчета,
	|	ВКМ_НачисленияЗарплатыНачисления.ДатаНачала КАК ДатаНачала,
	|	ВКМ_НачисленияЗарплатыНачисления.ГрафикРаботы КАК ГрафикРаботы,
	|	НАЧАЛОПЕРИОДА(ВКМ_НачисленияЗарплатыНачисления.ДатаНачала, МЕСЯЦ) КАК ПериодДействия,
	|	ВКМ_НачисленияЗарплатыНачисления.ДатаОкончания КАК ДатаОкончания
	|ПОМЕСТИТЬ ВТ_ОкладВДокументе
	|ИЗ
	|	Документ.ВКМ_НачисленияЗарплаты.Начисления КАК ВКМ_НачисленияЗарплатыНачисления
	|ГДЕ
	|	ВКМ_НачисленияЗарплатыНачисления.Ссылка = &Ссылка
	|	И ВКМ_НачисленияЗарплатыНачисления.ВидРасчета = &Оклад
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ОкладВДокументе.НомерСтроки КАК НомерСтроки,
	|	ВКМ_УсловияОплатыСотрудников.Период КАК Период
	|ПОМЕСТИТЬ ВТ_ТекущиеПериодыОклада
	|ИЗ
	|	ВТ_ОкладВДокументе КАК ВТ_ОкладВДокументе
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВКМ_УсловияОплатыСотрудников КАК ВКМ_УсловияОплатыСотрудников
	|		ПО ВТ_ОкладВДокументе.Сотрудник = ВКМ_УсловияОплатыСотрудников.Сотрудник
	|			И ВТ_ОкладВДокументе.ПериодДействия >= ВКМ_УсловияОплатыСотрудников.Период
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ОкладВДокументе.Сотрудник КАК Сотрудник,
	|	ВТ_ОкладВДокументе.ВидРасчета КАК ВидРасчета,
	|	ВТ_ОкладВДокументе.ДатаНачала КАК ПериодДействияНачало,
	|	ВТ_ОкладВДокументе.ГрафикРаботы КАК ГрафикРаботы,
	|	ВКМ_УсловияОплатыСотрудников.Оклад КАК Показатель,
	|	ВТ_ОкладВДокументе.ДатаОкончания КАК ПериодДействияКонец,
	|	NULL КАК БазовыйПериодНачало,
	|	NULL КАК БазовыйПериодКонец
	|ИЗ
	|	ВТ_ОкладВДокументе КАК ВТ_ОкладВДокументе
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ТекущиеПериодыОклада КАК ВТ_ТекущиеПериодыОклада
	|		ПО ВТ_ОкладВДокументе.НомерСтроки = ВТ_ТекущиеПериодыОклада.НомерСтроки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ВКМ_УсловияОплатыСотрудников КАК ВКМ_УсловияОплатыСотрудников
	|		ПО ВТ_ОкладВДокументе.Сотрудник = ВКМ_УсловияОплатыСотрудников.Сотрудник
	|			И (ВТ_ТекущиеПериодыОклада.Период = ВКМ_УсловияОплатыСотрудников.Период)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВКМ_НачисленияЗарплатыНачисления.Сотрудник,
	|	ВКМ_НачисленияЗарплатыНачисления.ВидРасчета,
	|	ВКМ_НачисленияЗарплатыНачисления.ДатаНачала,
	|	ВКМ_НачисленияЗарплатыНачисления.ГрафикРаботы,
	|	0,
	|	ВКМ_НачисленияЗарплатыНачисления.ДатаОкончания,
	|	НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(ВКМ_НачисленияЗарплатыНачисления.ДатаНачала, МЕСЯЦ, -12), МЕСЯЦ),
	|	КОНЕЦПЕРИОДА(ДОБАВИТЬКДАТЕ(ВКМ_НачисленияЗарплатыНачисления.ДатаОкончания, МЕСЯЦ, -1), МЕСЯЦ)
	|ИЗ
	|	Документ.ВКМ_НачисленияЗарплаты.Начисления КАК ВКМ_НачисленияЗарплатыНачисления
	|ГДЕ
	|	ВКМ_НачисленияЗарплатыНачисления.Ссылка = &Ссылка
	|	И ВКМ_НачисленияЗарплатыНачисления.ВидРасчета = &Отпуск";
	
	Запрос.УстановитьПараметр("ССылка", Ссылка);
	Запрос.УстановитьПараметр("Оклад", ПланыВидовРасчета.ВКМ_ОсновныеНачисления.Оклад);
	Запрос.УстановитьПараметр("Отпуск", ПланыВидовРасчета.ВКМ_ОсновныеНачисления.Отпуск);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий()Цикл
		
		Движение = Движения.ВКМ_ОсновныеНачисления.Добавить();
		ЗаполнитьЗначенияСвойств(Движение,Выборка);
		Движение.ПериодРегистрации = Дата;
		
	КонецЦикла;
	
	Движения.ВКМ_ОсновныеНачисления.Записать();	
	
КонецПроцедуры

Процедура СформироватьДвиженияДополнительныеНачисления()
	
		Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВКМ_НачисленияЗарплатыНачисления.НомерСтроки КАК НомерСтроки,
	|	ВКМ_НачисленияЗарплатыНачисления.Сотрудник КАК Сотрудник,
	|	ВКМ_НачисленияЗарплатыНачисления.ВидРасчета КАК ВидРасчета,
	|	ВКМ_НачисленияЗарплатыНачисления.ДатаНачала КАК ДатаНачала,
	|	ВКМ_НачисленияЗарплатыНачисления.ДатаОкончания КАК ДатаОкончания,
	|	НАЧАЛОПЕРИОДА(ВКМ_НачисленияЗарплатыНачисления.ДатаНачала, МЕСЯЦ) КАК ПериодДействия
	|ПОМЕСТИТЬ ВТ_ПроцентЗаВыпРаботыВДок
	|ИЗ
	|	Документ.ВКМ_НачисленияЗарплаты.Начисления КАК ВКМ_НачисленияЗарплатыНачисления
	|ГДЕ
	|	ВКМ_НачисленияЗарплатыНачисления.Ссылка = &Ссылка
	|	И ВКМ_НачисленияЗарплатыНачисления.ВидРасчета = &ПроцентЗаВыпРаботы
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВКМ_УсловияОплатыСотрудников.Период КАК Период,
	|	ВТ_ПроцентЗаВыпОаботыВДок.НомерСтроки КАК НомерСтроки
	|ПОМЕСТИТЬ ВТ_ПериодыПроцентов
	|ИЗ
	|	ВТ_ПроцентЗаВыпРаботыВДок КАК ВТ_ПроцентЗаВыпОаботыВДок
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВКМ_УсловияОплатыСотрудников КАК ВКМ_УсловияОплатыСотрудников
	|		ПО ВТ_ПроцентЗаВыпОаботыВДок.Сотрудник = ВКМ_УсловияОплатыСотрудников.Сотрудник
	|			И ВТ_ПроцентЗаВыпОаботыВДок.ПериодДействия >= ВКМ_УсловияОплатыСотрудников.Период
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ПроцентЗаВыпРаботыВДок.НомерСтроки КАК НомерСтроки,
	|	ВТ_ПроцентЗаВыпРаботыВДок.ВидРасчета КАК ВидРасчета,
	|	ВТ_ПроцентЗаВыпРаботыВДок.ДатаНачала КАК ДатаНачала,
	|	ВТ_ПроцентЗаВыпРаботыВДок.ДатаОкончания КАК ДатаОкончания,
	|	ВКМ_УсловияОплатыСотрудников.ПроцентОтРабот КАК Показатель,
	|	ВТ_ПроцентЗаВыпРаботыВДок.Сотрудник КАК Сотрудник,
	|	ВКМ_ВыполненныеСотрудникомРаботыОстаткиИОбороты.СуммаКОплатеПриход КАК Результат
	|ИЗ
	|	РегистрНакопления.ВКМ_ВыполненныеСотрудникомРаботы.ОстаткиИОбороты(&НачалоПериода, &КонецПериода, , , ) КАК ВКМ_ВыполненныеСотрудникомРаботыОстаткиИОбороты
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ПроцентЗаВыпРаботыВДок КАК ВТ_ПроцентЗаВыпРаботыВДок
	|			ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ПериодыПроцентов КАК ВТ_ПериодыПроцентов
	|			ПО ВТ_ПроцентЗаВыпРаботыВДок.НомерСтроки = ВТ_ПериодыПроцентов.НомерСтроки
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ВКМ_УсловияОплатыСотрудников КАК ВКМ_УсловияОплатыСотрудников
	|			ПО ВТ_ПроцентЗаВыпРаботыВДок.Сотрудник = ВКМ_УсловияОплатыСотрудников.Сотрудник
	|				И (ВТ_ПериодыПроцентов.Период = ВКМ_УсловияОплатыСотрудников.Период)
	|		ПО ВКМ_ВыполненныеСотрудникомРаботыОстаткиИОбороты.Сотрудник = ВТ_ПроцентЗаВыпРаботыВДок.Сотрудник";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("ПроцентЗаВыпРаботы", ПланыВидовРасчета.ВКМ_ДополнительныеНачисления.ПроцентЗаВыпРаботы);
	Запрос.УстановитьПараметр("НачалоПериода", НачалоМесяца(Дата));
	Запрос.УстановитьПараметр("КонецПериода", КонецМесяца(Дата));
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий()Цикл
		
		Движение = Движения.ВКМ_ДополнительныеНачисления.Добавить();
		ЗаполнитьЗначенияСвойств(Движение,Выборка);
		Движение.ПериодРегистрации = Дата;
		
	КонецЦикла;
	
	Движения.ВКМ_ДополнительныеНачисления.Записать();	
	
КонецПроцедуры	

Процедура СформироватьДвиженияУдержания()

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВКМ_НачисленияЗарплатыУдержания.НомерСтроки КАК НомерСтроки,
	               |	ВКМ_НачисленияЗарплатыУдержания.Сотрудник КАК Сотрудник,
	               |	ВКМ_НачисленияЗарплатыУдержания.ВидРасчета КАК ВидРасчета,
	               |	ВКМ_НачисленияЗарплатыУдержания.ДатаНачала КАК ПериодДействияНачало,
	               |	ВКМ_НачисленияЗарплатыУдержания.ДатаОкончания КАК ПериодДействияКонец,
	               |	НАЧАЛОПЕРИОДА(ВКМ_НачисленияЗарплатыУдержания.ДатаНачала, МЕСЯЦ) КАК ПериодДействия,
	               |	НАЧАЛОПЕРИОДА(ВКМ_НачисленияЗарплатыУдержания.ДатаНачала, МЕСЯЦ) КАК БазовыйПериодНачало,
	               |	КОНЕЦПЕРИОДА(ВКМ_НачисленияЗарплатыУдержания.ДатаОкончания, МЕСЯЦ) КАК БазовыйПериодКонец
	               |ИЗ
	               |	Документ.ВКМ_НачисленияЗарплаты.Удержания КАК ВКМ_НачисленияЗарплатыУдержания
	               |ГДЕ
	               |	ВКМ_НачисленияЗарплатыУдержания.Ссылка = &Ссылка
	               |	И ВКМ_НачисленияЗарплатыУдержания.ВидРасчета = &НДФЛ";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("НДФЛ", ПланыВидовРасчета.ВКМ_Удержания.НДФЛ);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий()Цикл
		
		Движение = Движения.ВКМ_Удержания.Добавить();
		ЗаполнитьЗначенияСвойств(Движение,Выборка);
		Движение.ПериодРегистрации = Дата;
		
	КонецЦикла;
	
	Движения.ВКМ_Удержания.Записать();
	
КонецПроцедуры

Процедура РассчитатьОклад()
	
	МинимальнаяДатаНачала = Дата("39991231");
	МаксимальнаяДатаОкончания = Дата("00010101");
	
	ЕстьОклад = Ложь;
	
	Для Каждого Движение Из Движения.ВКМ_ОсновныеНачисления Цикл
		
		Если Движение.ВидРасчета <> ПланыВидовРасчета.ВКМ_ОсновныеНачисления.Оклад Тогда 
			Продолжить;
		КонецЕсли;
		
		ЕстьОклад = Истина;
		
		Если МинимальнаяДатаНачала > Движение.ПериодДействияНачало Тогда
			МинимальнаяДатаНачала = Движение.ПериодДействияНачало;
		КонецЕсли;
		
		Если МаксимальнаяДатаОкончания < Движение.ПериодДействияКонец Тогда 
			МаксимальнаяДатаОкончания = Движение.ПериодДействияКонец;
		КонецЕсли;	
		
	КонецЦикла;
	
	Если НЕ ЕстьОклад Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ВКМ_ОсновныеНачисленияДанныеГрафика.НомерСтроки КАК НомерСтроки,
	|	ЕСТЬNULL(ВКМ_ОсновныеНачисленияДанныеГрафика.ЗначениеПериодДействия, 0) КАК План,
	|	ЕСТЬNULL(ВКМ_ОсновныеНачисленияДанныеГрафика.ЗначениеФактическийПериодДействия, 0) КАК Факт
	|ИЗ
	|	РегистрРасчета.ВКМ_ОсновныеНачисления.ДанныеГрафика(
	|			Регистратор = &Ссылка
	|				И ВидРасчета = &Оклад) КАК ВКМ_ОсновныеНачисленияДанныеГрафика";
	
	Запрос.УстановитьПараметр("Оклад", ПланыВидовРасчета.ВКМ_ОсновныеНачисления.Оклад);
	Запрос.УстановитьПараметр("КонецПериода", КонецМесяца(МаксимальнаяДатаОкончания));
	Запрос.УстановитьПараметр("НачалоПериода", НачалоМесяца(МинимальнаяДатаНачала));
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий()Цикл
		
		Движение = Движения.ВКМ_ОсновныеНачисления[Выборка.НомерСтроки - 1];
		
		Если Выборка.План <> 0 Тогда
			Движение.Результат = Движение.Показатель / Выборка.План * Выборка.Факт;
		КонецЕсли;
		
		Движение.КоличествоДней = Выборка.Факт / 8;
		
	КонецЦикла;
	
	Движения.ВКМ_ОсновныеНачисления.Записать();	
	
КонецПроцедуры


Процедура РассчитатьОтпускные()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВКМ_ОсновныеНачисления.НомерСтроки КАК НомерСтроки,
	|	ВКМ_ОсновныеНачисленияБазаВКМ_ОсновныеНачисления.РезультатБаза КАК РезультатБаза,
	|	ВКМ_ОсновныеНачисленияДанныеГрафика.ЗначениеФактическийПериодДействия КАК Факт,
	|	ВКМ_ОсновныеНачисленияБазаВКМ_ОсновныеНачисления.КоличествоДнейБаза КАК КоличествоДнейБаза
	|ИЗ
	|	РегистрРасчета.ВКМ_ОсновныеНачисления КАК ВКМ_ОсновныеНачисления
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрРасчета.ВКМ_ОсновныеНачисления.БазаВКМ_ОсновныеНачисления(
	|				&Измерение,
	|				&Измерение,
	|				,
	|				Регистратор = &Регистратор
	|					И ВидРасчета = &Отпуск) КАК ВКМ_ОсновныеНачисленияБазаВКМ_ОсновныеНачисления
	|		ПО ВКМ_ОсновныеНачисления.НомерСтроки = ВКМ_ОсновныеНачисленияБазаВКМ_ОсновныеНачисления.НомерСтроки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрРасчета.ВКМ_ОсновныеНачисления.ДанныеГрафика(Регистратор = &Регистратор) КАК ВКМ_ОсновныеНачисленияДанныеГрафика
	|		ПО ВКМ_ОсновныеНачисления.НомерСтроки = ВКМ_ОсновныеНачисленияДанныеГрафика.НомерСтроки
	|ГДЕ
	|	ВКМ_ОсновныеНачисления.Регистратор = &Регистратор
	|	И ВКМ_ОсновныеНачисления.ВидРасчета = &Отпуск";
	
	Запрос.УстановитьПараметр("Регистратор", Ссылка);
	Запрос.УстановитьПараметр("Отпуск", ПланыВидовРасчета.ВКМ_ОсновныеНачисления.Отпуск);
	
	Измерение = Новый Массив;
	Измерение.Добавить("Сотрудник");
	Запрос.УстановитьПараметр("Измерение", Измерение);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий()Цикл
		
		Движение = Движения.ВКМ_ОсновныеНачисления[Выборка.НомерСтроки - 1];
		Движение.КоличествоДней = Выборка.Факт / 8;
		
		Если Выборка.КоличествоДнейБаза = 0 Тогда
			Движение.Результат = 0;
			Продолжить;
		КонецЕсли;
		
		Движение.Результат = (Выборка.РезультатБаза / Выборка.КоличествоДнейБаза) * Выборка.Факт / 8;

	КонецЦикла;
	
	Движения.ВКМ_ОсновныеНачисления.Записать(,Истина);	
	
КонецПроцедуры

Процедура РассчитатьНДФЛ()

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЕСТЬNULL(ВКМ_УдержанияБазаВКМ_ОсновныеНачисления.РезультатБаза, 0) КАК РезультатБаза,
	               |	ЕСТЬNULL(ВКМ_УдержанияБазаВКМ_ДополнительныеНачисления.РезультатБаза, 0) КАК РезультатБазаДоп,
	               |	ВКМ_УдержанияБазаВКМ_ОсновныеНачисления.НомерСтроки КАК НомерСтроки,
	               |	ВКМ_УдержанияБазаВКМ_ДополнительныеНачисления.НомерСтроки КАК НомерСтрокиДоп
	               |ИЗ
	               |	РегистрРасчета.ВКМ_Удержания.БазаВКМ_ОсновныеНачисления(
	               |			&Измерения,
	               |			&Измерения,
	               |			,
	               |			Регистратор = &Ссылка
	               |				И ВидРасчета = &НДФЛ) КАК ВКМ_УдержанияБазаВКМ_ОсновныеНачисления
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВКМ_НачисленияЗарплаты.Удержания КАК ВКМ_НачисленияЗарплатыУдержания
	               |			ПРАВОЕ СОЕДИНЕНИЕ РегистрРасчета.ВКМ_Удержания.БазаВКМ_ДополнительныеНачисления(
	               |					&Измерения,
	               |					&Измерения,
	               |					,
	               |					Регистратор = &Ссылка
	               |						И ВидРасчета = &НДФЛ) КАК ВКМ_УдержанияБазаВКМ_ДополнительныеНачисления
	               |			ПО (ВКМ_УдержанияБазаВКМ_ДополнительныеНачисления.Сотрудник = ВКМ_НачисленияЗарплатыУдержания.Сотрудник)
	               |		ПО ВКМ_УдержанияБазаВКМ_ОсновныеНачисления.Сотрудник = ВКМ_НачисленияЗарплатыУдержания.Сотрудник";
	
	Запрос.УстановитьПараметр("Ссылка",Ссылка);
	Запрос.УстановитьПараметр("НДФЛ", ПланыВидовРасчета.ВКМ_Удержания.НДФЛ);
	
	Измерения = Новый Массив;
	Измерения.Добавить("Сотрудник");
	Запрос.УстановитьПараметр("Измерения", Измерения);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий()Цикл
		
		Движение = Движения.ВКМ_Удержания[Выборка.НомерСтроки - 1];
		Движение.Результат = (Выборка.РезультатБаза + Выборка.РезультатБазаДоп) * 13 / 100;
		
	КонецЦикла;
	
	Движения.ВКМ_Удержания.Записать(,Истина);
	
КонецПроцедуры

Процедура ФормированиеДвиженийПоРН()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	МАКСИМУМ(ВКМ_НачисленияЗарплатыНачисления.НомерСтроки) КАК НомерСтроки,
	|	ВКМ_НачисленияЗарплатыНачисления.Сотрудник КАК Сотрудник,
	|	СУММА(ВКМ_ОсновныеНачисления.Результат - ВКМ_Удержания.Результат) КАК Сумма
	|ИЗ
	|	Документ.ВКМ_НачисленияЗарплаты.Начисления КАК ВКМ_НачисленияЗарплатыНачисления
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрРасчета.ВКМ_ОсновныеНачисления КАК ВКМ_ОсновныеНачисления
	|		ПО ВКМ_НачисленияЗарплатыНачисления.Ссылка = ВКМ_ОсновныеНачисления.Регистратор
	|			И ВКМ_НачисленияЗарплатыНачисления.Сотрудник = ВКМ_ОсновныеНачисления.Сотрудник
	|			И ВКМ_НачисленияЗарплатыНачисления.НомерСтроки = ВКМ_ОсновныеНачисления.НомерСтроки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрРасчета.ВКМ_Удержания КАК ВКМ_Удержания
	|		ПО ВКМ_НачисленияЗарплатыНачисления.Ссылка = ВКМ_Удержания.Регистратор
	|			И ВКМ_НачисленияЗарплатыНачисления.Сотрудник = ВКМ_Удержания.Сотрудник
	|ГДЕ
	|	ВКМ_НачисленияЗарплатыНачисления.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ВКМ_НачисленияЗарплатыНачисления.Сотрудник
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СУММА(ВКМ_ОсновныеНачисленияБазаВКМ_ОсновныеНачисления.Результат / 2) КАК Сумма,
	|	ВКМ_НачисленияЗарплатыНачисления.Сотрудник КАК Сотрудник,
	|	МИНИМУМ(ВКМ_НачисленияЗарплатыНачисления.НомерСтроки) КАК НомерСтроки
	|ИЗ
	|	РегистрРасчета.ВКМ_ОсновныеНачисления.БазаВКМ_ОсновныеНачисления(
	|			&Измерения,
	|			&Измерения,
	|			,
	|			Регистратор = &Ссылка
	|				И Сотрудник В
	|					(ВЫБРАТЬ
	|						ВКМ_НачисленияЗарплатыНачисления.Сотрудник КАК Сотрудник
	|					ИЗ
	|						Документ.ВКМ_НачисленияЗарплаты.Начисления КАК ВКМ_НачисленияЗарплатыНачисления
	|					ГДЕ
	|						ВКМ_НачисленияЗарплатыНачисления.Ссылка = &Ссылка)) КАК ВКМ_ОсновныеНачисленияБазаВКМ_ОсновныеНачисления
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВКМ_НачисленияЗарплаты.Начисления КАК ВКМ_НачисленияЗарплатыНачисления
	|		ПО ВКМ_ОсновныеНачисленияБазаВКМ_ОсновныеНачисления.Сотрудник = ВКМ_НачисленияЗарплатыНачисления.Сотрудник
	|			И ВКМ_ОсновныеНачисленияБазаВКМ_ОсновныеНачисления.Регистратор = ВКМ_НачисленияЗарплатыНачисления.Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ВКМ_НачисленияЗарплатыНачисления.Сотрудник
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(ВКМ_НачисленияЗарплатыНачисления.НомерСтроки) КАК НомерСтроки,
	|	ВКМ_НачисленияЗарплатыНачисления.Сотрудник КАК Сотрудник,
	|	СУММА(ВКМ_ДополнительныеНачисления.Результат / 2) КАК Сумма
	|ИЗ
	|	Документ.ВКМ_НачисленияЗарплаты.Начисления КАК ВКМ_НачисленияЗарплатыНачисления
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрРасчета.ВКМ_ДополнительныеНачисления КАК ВКМ_ДополнительныеНачисления
	|		ПО ВКМ_НачисленияЗарплатыНачисления.Ссылка = ВКМ_ДополнительныеНачисления.Регистратор
	|			И ВКМ_НачисленияЗарплатыНачисления.Сотрудник = ВКМ_ДополнительныеНачисления.Сотрудник
	|ГДЕ
	|	ВКМ_НачисленияЗарплатыНачисления.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ВКМ_НачисленияЗарплатыНачисления.Сотрудник";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Измерения = Новый Массив;
	Измерения.Добавить("Сотрудник");
	Запрос.УстановитьПараметр("Измерения",Измерения);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	ВыборкаОсновная = РезультатЗапроса[0].Выбрать();
	
	Пока ВыборкаОсновная.Следующий()Цикл
		
		Движение = Движения.ВКМ_ВзаиморасчетыССотрудниками.ДобавитьПриход();
		Движение.Период = Дата;
		Движение.Сотрудник = ВыборкаОсновная.Сотрудник;
		Движение.Сумма = ВыборкаОсновная.Сумма;
		
	КонецЦикла;
	
	ВыборкаБаза = РезультатЗапроса[1].Выбрать();
	
	Пока ВыборкаБаза.Следующий()Цикл
		
		Движение = Движения.ВКМ_ВзаиморасчетыССотрудниками.ДобавитьПриход();
		Движение.Период = Дата;
		Движение.Сотрудник = ВыборкаБаза.Сотрудник;
		Движение.Сумма = ВыборкаБаза.Сумма;
		
	КонецЦикла;
	
	ВыборкаДополнительная = РезультатЗапроса[2].Выбрать();
	
	Пока ВыборкаДополнительная.Следующий()Цикл
		
		Движение = Движения.ВКМ_ВзаиморасчетыССотрудниками.ДобавитьПриход();
		Движение.Период = Дата;
		Движение.Сотрудник = ВыборкаДополнительная.Сотрудник;
		Движение.Сумма = ВыборкаДополнительная.Сумма;
		
	КонецЦикла;
	
	Движения.ВКМ_ВзаиморасчетыССотрудниками.Записать();
	
КонецПроцедуры


#КонецОбласти





#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	
	Если ПравоДоступа("Добавление", Метаданные.Документы.РеализацияТоваровУслуг) Тогда
		
        КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
        КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.РеализацияТоваровУслуг.ПолноеИмя();
        КомандаСоздатьНаОсновании.Представление = ОбщегоНазначения.ПредставлениеОбъекта(Метаданные.Документы.РеализацияТоваровУслуг);
        КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		
		Возврат КомандаСоздатьНаОсновании;
		
	КонецЕсли;

	Возврат Неопределено;
	
КонецФункции

	//++ВКМ_Добавлен алгоритм печати документа.
	Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
		
		// Акт об оказании услуг
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.Идентификатор = "АктОбОказанныхУслугах";
		КомандаПечати.Представление = НСтр("ru = 'Реализация товаров и услуг'");
		КомандаПечати.Порядок = 5;	
		
	КонецПроцедуры
	
	Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
		
		ПечатнаяФорма = УправлениеПечатью.СведенияОПечатнойФорме(КоллекцияПечатныхФорм, "АктОбОказанныхУслугах");
		Если ПечатнаяФорма <> Неопределено Тогда
			ПечатнаяФорма.ТабличныйДокумент = ПечатьАкта(МассивОбъектов, ОбъектыПечати);
			ПечатнаяФорма.СинонимМакета = НСтр("ru = 'Акт об оказанных услугах'");
			ПечатнаяФорма.ПолныйПутьКМакету = "Документ.РеализацияТоваровУслуг.ПФ_MXL_АктОбОказанныхУслугах";
		КонецЕсли;	
		
	КонецПроцедуры

#КонецОбласти

	#Область СлужебныеПроцедурыИФункции
	
	Функция ПечатьАкта(МассивОбъектов, ОбъектыПечати)
		
		ТабличныйДокумент = Новый ТабличныйДокумент;
		ТабличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_АктОбОказанныхУслугах";
		
		Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.РеализацияТоваровУслуг.ПФ_MXL_АктОбОказанныхУслугах");
		
		ДанныеДокументов = ПолучитьДанныеДокументов(МассивОбъектов);
		
		ПервыйДокумент = Истина;
		
		Пока ДанныеДокументов.Следующий() Цикл
			
			Если Не ПервыйДокумент Тогда
				// Все документы нужно выводить на разных страницах.
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			КонецЕсли;
			
			ПервыйДокумент = Ложь;
			
			НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
			
			ВывестиЗаголовокАкта(ДанныеДокументов, ТабличныйДокумент, Макет);
			
			ВывестиРеквизитыСторон(ДанныеДокументов, ТабличныйДокумент, Макет);
			
			ВывестиУслуги(ДанныеДокументов, ТабличныйДокумент, Макет);
			
			ВывестиСуммуПрописью(ДанныеДокументов, ТабличныйДокумент, Макет);
			
			ВывестиПодвал(ДанныеДокументов, ТабличныйДокумент, Макет);
			
			// В табличном документе необходимо задать имя области, в которую был 
			// выведен объект. Нужно для возможности печати комплектов документов.
			УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, 
			НомерСтрокиНачало, ОбъектыПечати, ДанныеДокументов.Ссылка);		
			
		КонецЦикла;	
		
		Возврат ТабличныйДокумент;
		
	КонецФункции
	
	Функция ПолучитьДанныеДокументов(МассивОбъектов)
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	РеализацияТоваровУслуг.Ссылка КАК Ссылка,
		|	РеализацияТоваровУслуг.Номер КАК Номер,
		|	РеализацияТоваровУслуг.Дата КАК Дата,
		|	РеализацияТоваровУслуг.Организация КАК Организация,
		|	РеализацияТоваровУслуг.Контрагент КАК Контрагент,
		|	РеализацияТоваровУслуг.Договор КАК Договор,
		|	РеализацияТоваровУслуг.Услуги.(
		|		Ссылка КАК Ссылка,
		|		НомерСтроки КАК НомерСтроки,
		|		Номенклатура КАК Номенклатура,
		|		Количество КАК Количество,
		|		Цена КАК Цена,
		|		Сумма КАК Сумма,
		|		ВКМ_АбонентскаяПлата КАК АбонентскаяПлата
		|	) КАК Услуги,
		|	РеализацияТоваровУслуг.СуммаДокумента КАК СуммаДокумента
		|ИЗ
		|	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
		|ГДЕ
		|	РеализацияТоваровУслуг.Ссылка В(&МассивОбъектов)";
		
		Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
		
		Возврат Запрос.Выполнить().Выбрать();
		
	КонецФункции
	
	Процедура ВывестиЗаголовокАкта(ДанныеДокументов, ТабличныйДокумент, Макет)
		
		ОбластьЗаголовокДокумента = Макет.ПолучитьОбласть("Заголовок");
		
		ДанныеПечати = Новый Структура;
		
		ШаблонЗаголовка = "Акт об оказании услуг %1 от %2";
		ТекстЗаголовка = СтрШаблон(ШаблонЗаголовка,
		ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ДанныеДокументов.Номер),
		Формат(ДанныеДокументов.Дата, "ДЛФ=DD"));
		ДанныеПечати.Вставить("ТекстЗаголовка", ТекстЗаголовка);
		
		ОбластьЗаголовокДокумента.Параметры.Заполнить(ДанныеПечати);
		ТабличныйДокумент.Вывести(ОбластьЗаголовокДокумента);
		
	КонецПроцедуры
	
	Процедура ВывестиРеквизитыСторон(ДанныеДокументов, ТабличныйДокумент, Макет)
		
		ОбластьОрганизация = Макет.ПолучитьОбласть("Организация");
		ОбластьКонтрагент = Макет.ПолучитьОбласть("Контрагент");
		ОбластьДоговорКонтрагента = Макет.ПолучитьОбласть("ДоговорКонтрагента");
		
		ДанныеПечати = Новый Структура;
		ДанныеПечати.Вставить("Организация", ДанныеДокументов.Организация);
		ДанныеПечати.Вставить("Контрагент", ДанныеДокументов.Контрагент);
		ДанныеПечати.Вставить("ДоговорКонтрагента", ДанныеДокументов.Договор);
		
		ОбластьОрганизация.Параметры.Заполнить(ДанныеПечати);
		ТабличныйДокумент.Вывести(ОбластьОрганизация);
		
		ОбластьКонтрагент.Параметры.Заполнить(ДанныеПечати);
		ТабличныйДокумент.Вывести(ОбластьКонтрагент);
		
		ОбластьДоговорКонтрагента.Параметры.Заполнить(ДанныеПечати);
		ТабличныйДокумент.Вывести(ОбластьДоговорКонтрагента);
		
		
	КонецПроцедуры
	
	Процедура ВывестиУслуги(ДанныеДокументов, ТабличныйДокумент, Макет)
		
		ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");
		ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
		//ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
		ОбластьИтого = Макет.ПолучитьОбласть("Итого");
		
		ТабличныйДокумент.Вывести(ОбластьШапкаТаблицы);	
		
		ВыборкаУслуги = ДанныеДокументов.Услуги.Выбрать();
		Пока ВыборкаУслуги.Следующий() Цикл
			ОбластьСтрока.Параметры.Заполнить(ВыборкаУслуги);
			ТабличныйДокумент.Вывести(ОбластьСтрока);
		КонецЦикла;
		
		//ТабличныйДокумент.Вывести(ОбластьПодвал);
		
		ДанныеПечати = Новый Структура;
		ДанныеПечати.Вставить("Всего", ДанныеДокументов.СуммаДокумента);
		
		ОбластьИтого.Параметры.Заполнить(ДанныеПечати);
		ТабличныйДокумент.Вывести(ОбластьИтого);
		
	КонецПроцедуры
	
	Процедура ВывестиСуммуПрописью(ДанныеДокументов, ТабличныйДокумент, Макет)	
		
		ОбластьСуммаПрописью = Макет.ПолучитьОбласть("СуммаПрописью");
		
		ДанныеПечати = Новый Структура;
		ДанныеПечати.Вставить("СуммаПрописью",ЧислоПрописью(ДанныеДокументов.СуммаДокумента,
		            "Л=ru_RU;ДП=Истина", "рубль,рубля,рублей,м,копейка,копейки,копеек,ж,2"));		
		
		ОбластьСуммаПрописью.Параметры.Заполнить(ДанныеПечати);
		
		ТабличныйДокумент.Вывести(ОбластьСуммаПрописью);
		
	КонецПроцедуры
	
	Процедура ВывестиПодвал(ДанныеДокументов, ТабличныйДокумент, Макет)
		
		
		ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
		
		ТабличныйДокумент.Вывести(ОбластьПодвал);
		
	КонецПроцедуры
	
	
	#КонецОбласти
	//--ВКМ_Добавлен алгоритм печати документа.

#КонецЕсли
# Коннектор к Google Search Console для Power BI

### Все коннекторы и поддержка:
В рамках подписки "ПРО" на Boosty https://boosty.to/morinad вы получите:
1) Все коннекторы mez для Power BI. 
2) Поддержку и ответы на вопросы.
3) Полезные наработки, скрипты и файлы.

### Наши курсы по Power Query, Power BI и автоматизации:
1) Основы Power BI (бесплатный курс): https://directprorf.ru/basics?utm_source=github
2) Power BI для рекламных отчётов: https://directprorf.ru/powerbi?utm_source=github
3) Из API в Excel и Power BI + коннекторы: https://directprorf.ru/excel?utm_source=github
4) Коннекторы для Маркетплейсов: https://directprorf.ru/marketplaces?utm_source=github
5) Продвинутый Power Query: https://directprorf.ru/pro?utm_source=github
6) Создание коннекторов в Power Query: https://directprorf.ru/connectors?utm_source=github
7) API ChatGPT для автоматизации бизнеса: https://directprorf.ru/chatgpt?utm_source=github


### Как воспользоваться коннектором:

1) Скачайте файлы коннекторов googleToken.mez и SearchConsole.mez и поместите в папку C:\Users\USERNAME\Documents\Power BI Desktop\Custom Connectors, подставив USERNAME своего компьютера.

https://github.com/morinad/google_token-oauth_by_link/raw/main/googleToken.mez
https://github.com/morinad/google_search_console_power_bi/raw/main/SearchConsole/SearchConsole.mez

2) Откройте Power BI, зайдите в Файл -> Параметры и настройки -> Параметры -> Глобальные -> Безопасность, выберите "Разрешить загрузку любого расширения без проверок и предупреждений".

3) Перейдите по ссылке, выберите аккаунт и получите код: https://accounts.google.com/ServiceLogin?continue=https://accounts.google.com/o/oauth2/auth?scope%3Dhttps://www.googleapis.com/auth/webmasters.readonly%26response_type%3Dcode%26access_type%3Doffline%26redirect_uri%3Durn:ietf:wg:oauth:2.0:oob%26client_id%3D184724904685-9djgus8luf6ksjoc06ae8absssum5mf9.apps.googleusercontent.com%26from_login%3D1

4) Нажмите на кнопку "Получить данные", в поиске найдите коннектор googleToken. Выбрав коннектор, укажите систему Google Search Console и вставьте код, полученный в пункте 3. На выходе вы получите refresh_token. Сохраните refresh_token в заметки, чтобы не потерять.

5) Используйте refresh_token в коннекторе SearchConsole для получения данных. 

### ВАЖНО:

Для подсчёта среднего CTR добавьте меру, которая делит сумму кликов на сумму показов. 

Для подсчёта средней позиции сначала добавьте столбец произведений показов на позицию, а затем добавьте меру, где делите сумму по этому столбцу на сумму показов. Так вы получите среднюю позицию показов.

Вы можете получать статистику по фразам, странам, устройствам и страницам, указав нужные параметры в 5-м аргументе, например: "query,country,device,page". 
Не обязательно указывать все параметры, можно просто "query" или только "device" или "page,country". 

Очень важный момент - сумма кликов по "query" или "page" может быть не равна общей сумме кликов за период без разбивки. 
Если выбрали query - сверять можно с данными по фразам. Если выбрали page - сверяйте только с данными по страницам, итд.


### Полезные ссылки:

Справка API: https://developers.google.com/webmaster-tools/search-console-api-original/v3/searchanalytics/query

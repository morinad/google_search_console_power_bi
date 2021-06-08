# Коннектор к Google Search Console для Power BI

### Наши курсы:
1) Основы Power BI (3 часа): https://directprorf.ru/basics?utm_source=github
2) Курс по коннекторам в Excel (4 часа): https://directprorf.ru/excel?utm_source=github
3) Большой курс по обработке данных в Power Query (8 часов): https://directprorf.ru/pq?utm_source=github

По всем вопросам, связанным с курсами и коннекторами: https://t.me/alexdirect или +79169787746.

### Как воспользоваться коннектором:

1) Скачайте файлы коннекторов tokenGSC.mez и SearchConsole.mez и поместите в папку C:\Users\USERNAME\Documents\Power BI Desktop\Custom Connectors, подставив USERNAME своего компьютера.: 
https://github.com/morinad/google_search_console_power_bi/raw/main/tokenGSC/tokenGSC.mez
https://github.com/morinad/google_search_console_power_bi/raw/main/SearchConsole/SearchConsole.mez

2) Откройте Power BI, зайдите в Файл -> Параметры и настройки -> Параметры -> Глобальные -> Безопасность, выберите "Разрешить загрузку любого расширения без проверок и предупреждений".

3) Перейдите по ссылке, выберите аккаунт и получите код: https://accounts.google.com/ServiceLogin?continue=https://accounts.google.com/o/oauth2/auth?scope%3Dhttps://www.googleapis.com/auth/webmasters.readonly%26response_type%3Dcode%26access_type%3Doffline%26redirect_uri%3Durn:ietf:wg:oauth:2.0:oob%26client_id%3D184724904685-9djgus8luf6ksjoc06ae8absssum5mf9.apps.googleusercontent.com%26from_login%3D1

4) Нажмите на кнопку "Получить данные", в поиске найдите коннектор tokenGSC. Выбрав коннектор, укажите код, полученный в пункте 3. На выходе вы получите refresh_token.

5) Используйте refresh_token в коннекторе SearchConsole для получения данных. 

6) Для подсчёта среднего CTR добавьте меру, которая делит сумму кликов на сумму показов. 
Для подсчёта средней позиции сначала добавьте столбец произведений показов на позицию, а затем добавьте меру, где делите сумму по этому столбцу на сумму показов. Так вы получите среднюю позицию показов.


### Полезные ссылки:

Справка API: https://developers.google.com/webmaster-tools/search-console-api-original/v3/searchanalytics/query

section SearchConsole;

client_id = "184724904685-9djgus8luf6ksjoc06ae8absssum5mf9.apps.googleusercontent.com";
client_secret = "7hcVi_TEl5wmELtC4UIQQGNL";


redirect_uri = "https://preview.powerbi.com/views/oauthredirect.html";
windowWidth = 1200;
windowHeight = 1000;


[DataSource.Kind="SearchConsole", Publish="SearchConsole.UI"]

shared SearchConsole.Data = Value.ReplaceType(SearchConsole.Stat, FuncType);

FuncType = type function (
      site  as (type text meta [
        Documentation.FieldCaption = "Your site with https:",
        Documentation.FieldDescription = "Enter your site URL",
        Documentation.SampleValues = {"https://directprorf.ru"}
    ]),
      token  as (type text meta [
        Documentation.FieldCaption = "Your refresh token:",
        Documentation.FieldDescription = "Enter your Google Search Console refresh Token",
        Documentation.SampleValues = {"1//gfgFG33qJfk23mbh1fghKMnqhh3p"}
    ]),
    
    
    start as (type text meta [
        Documentation.FieldCaption = "Start date:",
        Documentation.FieldDescription = "Enter the first date of your statistics. You can specify date in YYYY-MM-DD format or use dynamic formats: today, yesterday, 69daysAgo.",
        Documentation.SampleValues = {"2020-02-28"}
    ]),
     end as (type text meta [
        Documentation.FieldCaption = "End date:",
        Documentation.FieldDescription = "Enter the last date of your statistics. You can specify date in YYYY-MM-DD format or use dynamic formats: today, yesterday, 69daysAgo.",
        Documentation.SampleValues = {"yesterday"}
    ]),

       params  as (type nullable text meta [
        Documentation.FieldCaption = "Your parameters in table:",
        Documentation.FieldDescription = "Enter your Google Search Console parameters",
        Documentation.SampleValues = {"device,country,query,page"}
    ])

    )
    as table meta [
        Documentation.Name = "Search Console Function",
        Documentation.LongDescription = 
        "Created to get data from Google.Ads. Use all dimensions and metrics according to chosen report type.",
        Documentation.Examples = {
        [
            Description = "Returns Impressions,Clicks,Cost by Date and Campaigns.",
            Code = "SearchConsole.Data(""123-456-7890"", ""CAMPAIGN_PERFORMANCE_REPORT"", ""2020-02-20"",""yesterday"", "" "")",
            Result = "Table with 6 default columns"
        ],
        [
            Description = "Returns Cost by Date and Device.",
            Code = "SearchConsole.Data(""123-456-7890"", ""ACCOUNT_PERFORMANCE_REPORT"", ""100daysAgo"",""today"", ""Date,Device,Cost"")",
            Result ="Table with 3 chosen columns"
        ],
        [
            Description = "Choose report type (on the left menu) and then choose your dimensions and metrics:",
            Code = "https://developers.google.com/adwords/api/docs/appendix/reports/all-reports",
            Result = "The best report!"
        ]
        }
    ];


SearchConsole.Stat = ( site as text, token as text, start as text, end as text, params as nullable text ) =>
let
    par = if params="" or params = null then {} else Text.Split(params,","),
    Источник = List.Dates(Date.From(dateFunc(start)), 1+Number.From(Date.From(dateFunc(end))-Date.From(dateFunc(start))), #duration(1,0,0,0)),
    #"Преобразовано в таблицу" = Table.FromList(Источник, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Переименованные столбцы" = Table.RenameColumns(#"Преобразовано в таблицу",{{"Column1", "Дата"}}),
    #"Измененный тип" = Table.TransformColumnTypes(#"Переименованные столбцы",{{"Дата", type date}}),
    #"Вставлено: месяц" = Table.AddColumn(#"Измененный тип", "Даты", each Date.ToText([Дата],"yyyy-MM-dd")),
    
    #"Измененный тип1" = Table.TransformColumnTypes(#"Вставлено: месяц",{{"Даты", type text}}),
    #"Добавлен пользовательский объект" = Table.AddColumn(#"Измененный тип1", "Пользовательский", each getStat(site, token, [Даты], [Даты],par)),
    #"Удаленные ошибки" = Table.RemoveRowsWithErrors(#"Добавлен пользовательский объект", {"Пользовательский"}),
   
    #"Развернутый элемент Пользовательский" = Table.ExpandTableColumn(#"Удаленные ошибки", "Пользовательский", {"keys", "clicks", "impressions", "ctr", "position"}, {"keys", "clicks", "impressions", "ctr", "position"}), 
    #"Удаленные столбцы" = Table.RemoveColumns(#"Развернутый элемент Пользовательский",{"Даты"}),
    #"Переименованные столбцы1" = Table.RenameColumns(#"Удаленные столбцы",{{"Дата", "date"}}),
    #"Измененный тип2" =  Table.TransformColumnTypes(#"Переименованные столбцы1",{{"keys", type text}, {"clicks", Int64.Type}, {"impressions", Int64.Type}, {"ctr", Percentage.Type}, {"position", type number}}) 
    in #"Измененный тип2" 

;
    
  
  
  
getStat=  ( site as text, token as text, start as text, end as text, par  ) =>

let
    sites = Text.Replace(Text.Replace(site,"/","%2F"),":","%3A"),
    AuthKey = "Bearer "&getToken(token),
    requestHeaders = [Authorization=AuthKey, #"Content-Type"="application/json", Accept="application/json"],
    parametersToPost = [startDate = dateFunc(start), endDate = dateFunc(end), dimensions=par ,rowLimit = "1000"],
    url = "https://searchconsole.googleapis.com/webmasters/v3/sites/" & sites & "/searchAnalytics/query",
    Response = Json.Document(Web.Contents(url, [Headers=requestHeaders, Content=Json.FromValue(parametersToPost), ManualStatusHandling = {404,400}])),
    rows = {0..Number.RoundDown( List.Count(Response[rows])/1000)},
    #"Преобразовано в таблицу" = Table.FromList(rows, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Измененный тип" = Table.TransformColumnTypes(#"Преобразовано в таблицу",{{"Column1", Int64.Type}}),
    #"Переименованные столбцы" = Table.RenameColumns(#"Измененный тип",{{"Column1", "page"}}),
    #"Умноженный столбец" = Table.TransformColumns(#"Переименованные столбцы", {{"page", each _ * 1000, type number}}),
    #"Добавлен пользовательский объект" = Table.AddColumn(#"Умноженный столбец", "Пользовательский", each
     Json.Document( Web.Contents(url, [Headers=requestHeaders, Content=Json.FromValue(parametersToPost&[startRow=[page]]), ManualStatusHandling = {404,400}]))),
    #"Развернутый элемент Пользовательский" = Table.ExpandRecordColumn(#"Добавлен пользовательский объект", "Пользовательский", {"rows"}, {"rows"}),
    #"Развернутый элемент rows" = Table.ExpandListColumn(#"Развернутый элемент Пользовательский", "rows"),
    #"Развернутый элемент rows1" = Table.ExpandRecordColumn(#"Развернутый элемент rows", "rows", {"keys", "clicks", "impressions", "ctr", "position"}, {"keys", "clicks", "impressions", "ctr", "position"}),
    #"Удаленные столбцы" = Table.RemoveColumns(#"Развернутый элемент rows1",{"page"}),
    #"Извлеченные значения" = Table.TransformColumns(#"Удаленные столбцы", {"keys", each Text.Combine(List.Transform(_, Text.From), ";;"), type text}),
    #"Замененные ошибки" = Table.ReplaceErrorValues(#"Извлеченные значения", {{"keys", "all"}})
in
    try Response[error][message] otherwise #"Замененные ошибки";


dateFunc= (dat)=>
       if dat = "yesterday" then Date.ToText(Date.AddDays(Date.From(DateTime.LocalNow()) , -1),"yyyy-MM-dd") 
       else if dat = "today" then Date.ToText(Date.From(DateTime.LocalNow()),"yyyy-MM-dd")
       else if (try Number.From(Text.BeforeDelimiter(dat,"daysAgo")) otherwise 0) >0 then Date.ToText(Date.AddDays(Date.From(DateTime.LocalNow()),-1*Number.From(Text.BeforeDelimiter(dat,"daysAgo"))),"yyyy-MM-dd") 
       else dat;


getToken= (tkn as text)=>
let
tok=Text.Replace(tkn,"\",""),
app_credentials ="client_id="&client_id&"&client_secret="&client_secret,
url = app_credentials & "&refresh_token=" & tok & "&grant_type=refresh_token",
GetJson = Web.Contents("https://accounts.google.com/o/oauth2/token",  [ManualStatusHandling={404,400},Headers = [#"Content-Type"="application/x-www-form-urlencoded"], Content = Text.ToBinary(url) ]),
FormatAsJson = try Json.Document(GetJson)[access_token] otherwise "Bad refresh token"
in
FormatAsJson;

// Data Source Kind description
SearchConsole = [
    TestConnection = (dataSourcePath) => { "SearchConsole.Data",
    Json.Document(dataSourcePath)[site],
    Json.Document(dataSourcePath)[token],
    Json.Document(dataSourcePath)[start],
    Json.Document(dataSourcePath)[end],
    Json.Document(dataSourcePath)[params]
    },
    Authentication = [
        // Key = []
        // UsernamePassword = [],
        // Windows = [],
        Implicit = []
    ],
    Label = Extension.LoadString("DataSourceLabel")
];




SearchConsole.UI = [
    Beta = false,
    Category = "Other",
    ButtonText = { "Google Search Console Connector", "Google Search Console Connector Help" },
    LearnMoreUrl = "https://www.youtube.com/channel/UCqSLNYLN_3mf6nA1Xf7fu1g/",
    SourceImage = SearchConsole.Icons,
    SourceTypeImage = SearchConsole.Icons
];



SearchConsole.Icons = [
    Icon16 = { Extension.Contents("SearchConsole16.png"), Extension.Contents("SearchConsole20.png"), Extension.Contents("SearchConsole24.png"), Extension.Contents("SearchConsole32.png") },
    Icon32 = { Extension.Contents("SearchConsole32.png"), Extension.Contents("SearchConsole40.png"), Extension.Contents("SearchConsole48.png"), Extension.Contents("SearchConsole64.png") }
];
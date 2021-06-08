// This file contains your Data Connector logic
section tokenGSC;

client_id = "184724904685-9djgus8luf6ksjoc06ae8absssum5mf9.apps.googleusercontent.com";
client_secret = "7hcVi_TEl5wmELtC4UIQQGNL";


[DataSource.Kind="tokenGSC", Publish="tokenGSC.Publish"]


shared tokenGSC.Get = ( code as text ) =>
  let
    app_credentials= "client_id="&client_id&"&client_secret=" & client_secret,
    code = "code=" & code,

    url = code & "&" & app_credentials & "&redirect_uri=urn:ietf:wg:oauth:2.0:oob&grant_type=authorization_code",
    GetJson = Web.Contents("https://accounts.google.com",
      [
        RelativePath = "/o/oauth2/token",
        Headers = [#"Content-Type"="application/x-www-form-urlencoded"],
        Content = Text.ToBinary(url),
        ManualStatusHandling = {400,404}
      ]
    ),
    Json2 = Json.Document(GetJson),
    refreshTokenOutput = try Json2[refresh_token] otherwise Text.Combine({Json2[error]?, Json2[error_description]?, "Bad authToken"}, " / ")
in
    refreshTokenOutput;


tokenGSC = [
    Authentication = [
        // Key = [],
        // UsernamePassword = [],
        // Windows = [],
        Implicit = []
    ],
    Label = Extension.LoadString("DataSourceLabel")
];

// Data Source UI publishing description
tokenGSC.Publish = [
    Beta = true,
    Category = "Other",
    ButtonText = { Extension.LoadString("ButtonTitle"), Extension.LoadString("ButtonHelp") },
    LearnMoreUrl = "https://powerbi.microsoft.com/",
    SourceImage = tokenGSC.Icons,
    SourceTypeImage = tokenGSC.Icons
];

tokenGSC.Icons = [
    Icon16 = { Extension.Contents("tokenGSC16.png"), Extension.Contents("tokenGSC20.png"), Extension.Contents("tokenGSC24.png"), Extension.Contents("tokenGSC32.png") },
    Icon32 = { Extension.Contents("tokenGSC32.png"), Extension.Contents("tokenGSC40.png"), Extension.Contents("tokenGSC48.png"), Extension.Contents("tokenGSC64.png") }
];

# JSAPIRefApp

## iOS:

Please note that mobile advertising Id is not working on simulator, if you are testing this on simulator, provide your own `network_user_id` in the `index.html` file.

`partner_config_hash` is also required for the ads to show up

## Android:

Inside class `WebViewActivity` set variable `partnerConfigHash`. Variable `clientId` is automatically fetched and set to Android Advertising Id. 

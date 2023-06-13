*** Settings ***
Library    SeleniumLibrary
Library    XML
Resource   ../private_variables.robot

*** Variables ***
# Login Elements
${login_btn}    dt_login_button
${email_field}    txtEmail
${password_field}    txtPass

# Header
${profile_icon_btn}    //a[@href="/account/personal-details"]

# Profile Settings
${api_token_page}    //a[@href="/account/api-token"]

# API Token Page
${scope_card}    //div[@class="composite-checkbox api-token__checkbox"]
${read_checkbox}    //input[@name="read"]//parent::label
${trade_checkbox}    //input[@name="trade"]//parent::label
${payments_checkbox}    //input[@name="payments"]//parent::label
${trading_information_checkbox}    //input[@name="trading_information"]//parent::label
${admin_checkbox}    //input[@name="admin"]//parent::label
${token_name_input}    //input[@name="token_name"]
${error_msg}    //div[@class="dc-field dc-field--error"]
${create_token_btn}    //button[@class="dc-btn dc-btn__effect dc-btn--primary dc-btn__large dc-btn__button-group da-api-token__button"]
${token_list}    //table[@class="da-api-token__table"]

*** Keywords ***
Login To Deriv
    Open Browser    https://app.deriv.com    Chrome
    Set Window Size    1280    1024
    Maximize Browser Window
    Wait Until Element Is Enabled    ${login_btn}    15
    Click Element    ${login_btn}
    Wait Until Element Is Enabled    ${email_field}    15
    Input Text    ${email_field}    ${user_email}
    Input Password    ${password_field}    ${user_password}
    Click Element    //button[@name="login"]

Navigate To API Token Page
    Wait Until Element Is Enabled    ${profile_icon_btn}    15
    Click Element    ${profile_icon_btn}
    Wait Until Element Is Enabled    ${api_token_page}    15
    Click Element    ${api_token_page}
    Wait Until Element Is Visible    (${scope_card})    15

Check API Scope Descriptions
    Page Should Contain Element    ${scope_card}    limit=5
    Page Should Contain    This scope will allow third-party apps to view your account activity, settings, limits, balance sheets, trade purchase history, and more.
    Page Should Contain    This scope will allow third-party apps to buy and sell contracts for you, renew your expired purchases, and top up your demo accounts.
    Page Should Contain    This scope will allow third-party apps to withdraw to payment agents and make inter-account transfers for you.
    Page Should Contain    This scope will allow third-party apps to view your trading history.
    Page Should Contain    This scope will allow third-party apps to open accounts for you, manage your settings and token usage, and more.

Clear Token Name Field
    Press Keys    ${token_name_input}    CTRL+A+BACKSPACE

*** Test Cases ***
TC101 - User logs in and navigates to the API token page
    Login To Deriv
    Navigate To API Token Page
    Check API Scope Descriptions
   
TC203 - User inputs in "a" in the token name field
    Set Focus To Element    ${token_name_input}
    Element Should Be Focused    ${token_name_input}
    Input Text    ${token_name_input}    a
    Wait Until Element Is Visible    ${error_msg}    15
    Element Should Contain    ${error_msg}    Length of token name must be between 2 and 32 characters.
    Sleep    5

TC204 - User inputs in "abcdefghijklmnopqrstuvwxyz1234567" in the token name field
    Clear Token Name Field
    Input Text    ${token_name_input}    abcdefghijklmnopqrstuvwxyz1234567
    Wait Until Element Is Visible    ${error_msg}    15
    Element Should Contain    ${error_msg}    Maximum 32 characters.
    Sleep    5

TC205 - User inputs in "@test" in the token name field
    Clear Token Name Field
    Input Text    ${token_name_input}    @test
    Wait Until Element Is Visible    ${error_msg}    15
    Element Should Contain    ${error_msg}    Only letters, numbers, and underscores are allowed.
    Clear Token Name Field
    Sleep    5

TC301 - User selects the "Read" scope and provides a token name "Token1" and clicks the “Create” button
    Click Element    ${read_checkbox}
    Input Text    ${token_name_input}    Token1
    Wait Until Element Is Enabled    ${create_token_btn}    15
    Click Element    ${create_token_btn}
    Wait Until Element Contains    ${token_list}    Token1
    Wait Until Element Contains    ${token_list}    Read
    Sleep    5

TC302 - User selects the "Trade" scope and provides a token name "Token2" and clicks the “Create” button
    Click Element    ${trade_checkbox}
    Input Text    ${token_name_input}    Token2
    Wait Until Element Is Enabled    ${create_token_btn}    15
    Click Element    ${create_token_btn}
    Wait Until Element Contains    ${token_list}    Token2
    Wait Until Element Contains    ${token_list}    Trade
    Sleep    5
    
TC303 - User selects the "Payments" scope and provides a token name "Token3" and clicks the “Create” button
    Click Element    ${payments_checkbox}
    Input Text    ${token_name_input}    Token3
    Wait Until Element Is Enabled    ${create_token_btn}    15
    Click Element    ${create_token_btn}
    Wait Until Element Contains    ${token_list}    Token3
    Wait Until Element Contains    ${token_list}    Payments
    Sleep    5
    
TC304 - User selects the "Trading information" scope and provides a token name "Token4" and clicks the “Create” button
    Click Element    ${trading_information_checkbox}
    Input Text    ${token_name_input}    Token4
    Wait Until Element Is Enabled    ${create_token_btn}    15
    Click Element    ${create_token_btn}
    Wait Until Element Contains    ${token_list}    Token4
    Wait Until Element Contains    ${token_list}    Trading information
    Sleep    5
    
TC305 - User selects the "Admin" scope and provides a token name "Token5" and clicks the “Create” button
    Click Element    ${admin_checkbox}
    Input Text    ${token_name_input}    Token5
    Wait Until Element Is Enabled    ${create_token_btn}    15
    Click Element    ${create_token_btn}
    Wait Until Element Contains    ${token_list}    Token5
    Wait Until Element Contains    ${token_list}    Admin
    Sleep    5
    
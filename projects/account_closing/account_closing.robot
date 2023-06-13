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

# Deriv Trader
${trading_chart}    //div[@class="ciq-chart"]

# Profile Settings
${account_closing_page}    //a[@href="/account/closing-account"]

# Account Closing First Page
${cancel_btn}    //button[@class="dc-btn dc-btn--secondary dc-btn__large closing-account__button--cancel"]
${close_my_account_btn}    //button[@class="dc-btn dc-btn--primary dc-btn__large closing-account__button--close-account"]

# Account Closing Second Page
${account_reasons_title}    //p[@class="dc-text closing-account-reasons__title"]
${back_btn}    //button[@class="dc-btn dc-btn__effect dc-btn--secondary dc-btn__large"]
${continue_btn}    //button[@class="dc-btn dc-btn__effect dc-btn--primary dc-btn__large"]
${first_option}    //input[@name="financial-priorities"]//parent::label
${second_option}    //input[@name="stop-trading"]//parent::label
${third_option}    //input[@name="not-interested"]//parent::label
${fourth_option}    //input[@name="another-website"]//parent::label
${fifth_option}    //input[@name="not-user-friendly"]//parent::label
${sixth_option}    //input[@name="difficult-transactions"]//parent::label
${seventh_option}    //input[@name="lack-of-features"]//parent::label
${eighth_option}    //input[@name="unsatisfactory-service"]//parent::label
${ninth_option}    //input[@name="other-reasons"]//parent::label
${disabled_checkbox}    //span[@class="dc-checkbox__box dc-checkbox__box--disabled"]

# Account Closing Final Warning
${popup_modal}    //div[@class="account-closure-warning-modal"]
${go_back_btn}    //div[@class="dc-form-submit-button account-closure-warning-modal__close-account-button dc-form-submit-button--relative"]/button[1]
${close_account_btn}    //div[@class="dc-form-submit-button account-closure-warning-modal__close-account-button dc-form-submit-button--relative"]/button[2]

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

Navigate To Account Closing Page
    Wait Until Element Is Enabled    ${profile_icon_btn}    15
    Click Element    ${profile_icon_btn}
    Wait Until Element Is Enabled    ${account_closing_page}    15
    Click Element    ${account_closing_page}
    Page Should Contain Element    ${close_my_account_btn}

Check Account Closing First Page
    Page Should Contain    Are you sure?
    Page Should Contain    If you close your account:
    Page Should Contain    You can't trade on Deriv.
    Page Should Contain    You can't make transactions.
    Page Should Contain    Before closing your account:
    Page Should Contain    Close all your positions.
    Page Should Contain    Withdraw your funds.
    Page Should Contain    We shall delete your personal information as soon as our legal obligations are met, as mentioned in the section on Data Retention in our Security and privacy policy

Check Account Closing Second Page
    Wait Until Element Is Visible    ${continue_btn}
    Element Should Contain    ${account_reasons_title}    Please tell us why you’re leaving. (Select up to 3 reasons.)
    
*** Test Cases ***
TC101 - User logs in and navigates to the account closing page
    Login To Deriv
    Navigate To Account Closing Page
    Check Account Closing First Page
    Sleep    3

TC102 - User clicks "Close my account" button
    Click Element    ${close_my_account_btn}
    Check Account Closing Second Page
    Sleep    3

TC103 - User clicks "Back" button
    Click Element    ${back_btn}
    Check Account Closing First Page
    Sleep    3

TC104 - User clicks "Cancel" button
    Wait Until Element Is Enabled    ${cancel_btn}
    Click Element    ${cancel_btn}
    Wait Until Page Contains Element    ${trading_chart}
    Page Should Contain Element    ${trading_chart}
    Sleep    3

TC201 - User does not select any reason
    Navigate To Account Closing Page
    Wait Until Element Is Visible    ${close_my_account_btn}    15
    Click Element    ${close_my_account_btn}
    Wait Until Element Is Visible    ${continue_btn}
    Element Should Be Disabled    ${continue_btn}
    Sleep    3

TC202 - User selects and deselects a reason
    Click Element    ${first_option}
    Set Browser Implicit Wait    1
    Click Element    ${first_option}
    Set Browser Implicit Wait    1
    Element Should Be Disabled    ${continue_btn}

    Click Element    ${second_option}
    Set Browser Implicit Wait    1
    Click Element    ${second_option}
    Set Browser Implicit Wait    1
    Element Should Be Disabled    ${continue_btn}

    Click Element    ${third_option}
    Set Browser Implicit Wait    1
    Click Element    ${third_option}
    Set Browser Implicit Wait    1
    Element Should Be Disabled    ${continue_btn}

    Click Element    ${fourth_option}
    Set Browser Implicit Wait    1
    Click Element    ${fourth_option}
    Set Browser Implicit Wait    1
    Element Should Be Disabled    ${continue_btn}

    Click Element    ${fifth_option}
    Set Browser Implicit Wait    1
    Click Element    ${fifth_option}
    Set Browser Implicit Wait    1
    Element Should Be Disabled    ${continue_btn}

    Click Element    ${sixth_option}
    Set Browser Implicit Wait    1
    Click Element    ${sixth_option}
    Set Browser Implicit Wait    1
    Element Should Be Disabled    ${continue_btn}

    Click Element    ${seventh_option}
    Set Browser Implicit Wait    1
    Click Element    ${seventh_option}
    Set Browser Implicit Wait    1
    Element Should Be Disabled    ${continue_btn}

    Click Element    ${eighth_option}
    Set Browser Implicit Wait    1
    Click Element    ${eighth_option}
    Set Browser Implicit Wait    1
    Element Should Be Disabled    ${continue_btn}

    Click Element    ${ninth_option}
    Set Browser Implicit Wait    1
    Click Element    ${ninth_option}
    Set Browser Implicit Wait    1
    Element Should Be Disabled    ${continue_btn}
    
    Sleep    3

TC203 - User selects 1-3 reasons
    Click Element    ${first_option}
    Set Browser Implicit Wait    1
    Element Should Be Enabled    ${continue_btn}

    Click Element    ${second_option}
    Set Browser Implicit Wait    1
    Element Should Be Enabled    ${continue_btn}

    Click Element    ${third_option}
    Set Browser Implicit Wait    1
    Element Should Be Enabled    ${continue_btn}
    
    Page Should Contain Element    ${disabled_checkbox}    limit=6
    Sleep    3

TC301 - User clicks "Continue" button in the second page of account closing
    Click Element    ${continue_btn}
    Wait Until Element Is Visible    ${popup_modal}    15
    Element Should Contain    ${popup_modal}    Close your account?
    Element Should Contain    ${popup_modal}    Closing your account will automatically log you out. We shall delete your personal information as soon as our legal obligations are met.
    Page Should Contain Button    ${go_back_btn}
    Page Should Contain Button    ${close_account_btn}
    
    Sleep    3

TC401 - User clicks "Go Back" button in the final warning modal
    Click Button    ${go_back_btn}
    Set Browser Implicit Wait    1
    Wait Until Element Is Not Visible    ${popup_modal}
    Page Should Not Contain Element    ${popup_modal}

    Sleep    3
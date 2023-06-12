*** Settings ***
Library      SeleniumLibrary
Library      String
Library      Collections
Library      RequestsLibrary
Library    XML


*** Variables ***
@{chrome_arguments}	    --disable-infobars    --headless    --disable-gpu    --window-size=1280,1024
${HOME URL}    https://deriv.com
${markets_section}   //*[@id="market-fold"]
${deriv_life}    //*[text()="deriv life"]//parent::div

# Footer
${youtube}    //a[@href="https://www.youtube.com/@deriv"]
${reddit}    //a[@href="https://www.reddit.com/user/Deriv_official/"]
${telegram}    //a[@href="https://t.me/derivdotcomofficial"]
${facebook}    //a[@href="https://www.facebook.com/derivdotcom"]
${twitter}    //a[@href="https://twitter.com/derivdotcom/"]
${instagram}    //a[@href="https://www.instagram.com/deriv_official/"]
${linkedin}    //a[@href="https://www.linkedin.com/company/derivdotcom/"]
${swap_calculator}    https://deriv.com/trader-tools/swap-calculator/
${calculator_table}    //form[@action="#"]
${symbol}    //ul[@id="symbol"]

# Trade types
${CFDs}    //h2[text()= "CFDs"]
${options}    //h2[text()="Options"]
${multiplier}    //h2[text()="Multipliers"]    

# Trade Platforms
${deriv_mt5}    //h2[text() = "deriv MT5"]
${derivx}    //h2[text() = "deriv X"]
${deriv_ez}    //h2[text() = "deriv EZ"]
${smart_trader}    //h2[text() = "SmartTrader"]
${deriv_trader}    //h2[text() = "deriv Trader"]
${deriv_go}    //h2[text() = "deriv GO"]
${deriv_bot}    //h2[text() = "deriv Bot"]
${binary_bot}    //h2[text() = "Binary Bot"]



*** Keywords ***
Chrome Headless
    ${chrome_options}=    Set Chrome Options
    Create Webdriver    Chrome    chrome_options=${chrome_options}

Set Chrome Options
    [Documentation]    Set Chrome options for headless mode
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    FOR    ${option}    IN    @{chrome_arguments}
        Call Method    ${options}    add_argument    ${option}
    END
    [Return]    ${options}    

Go To Homepage
    Chrome Headless
    Go To   ${HOME URL}
    Set window size     1300    800
    Wait until page contains element    dm-nav-login-button
Go To Swap Calculator
    Chrome Headless
    Go To   ${swap_calculator}
    Set window size     1300    800
    Wait until page contains element    //h1[text()="Swap Calculator"]
Open Trade Menu
    Click Element    //p[text()="Trade"] 
    Wait Until Page Contains     Trade types
    Mouse Over    //p[text()="Trade"]
Open About US Menu
    Click Element    //button[@id="radix-5-trigger-_t_About us_t_"]
    Wait Until Page Contains Element   //a[@href="/who-we-are/"]    30

Check Trade Types
    Page Should Contain Element    ${CFDs}
    Page Should Contain    Trade with leverage and tight spreads for better returns on successful trades.
    Page Should Contain Element     ${options}
    page should contain    Earn a range of payouts without risking more than your initial stake.
    Page Should Contain Element     ${multiplier}
    Page Should Contain    Get the upside of CFDs without the downside of losing more than your stake.

Check Trading Platforms   
    Page Should Contain Element    ${deriv_mt5}
    Page Should Contain    Trade on Deriv MT5, the all-in-one CFD trading platform.
    Page Should Contain Element    ${derivx}
    Page Should Contain    A highly customisable and easy-to-use CFD trading platform.
    Page Should Contain Element    ${deriv_ez}
    Page Should Contain    Trade on global markets from anywhere with our mobile-first CFD trading platform.
    Page Should Contain Element    ${smart_trader}
    Page Should Contain    Trade the world’s markets with our popular user-friendly platform.
    Page Should Contain Element    ${deriv_trader}
    Page Should Contain    A whole new trading experience on a powerful yet easy to use platform.
    Page Should Contain Element    ${deriv_go}
    Page Should Contain    Trade multipliers on forex, cryptocurrencies, and synthetic indices with our mobile app.
    Page Should Contain Element    ${deriv_bot}
    Page Should Contain    Automated trading at your fingertips. No coding needed.
    Page Should Contain Element    ${binary_bot}
    Page Should Contain    Our classic "drag-and-drop" tool for creating trading bots, featuring pop-up trading charts, for advanced users.
Fill Form
    [Arguments]    ${field}    ${value}
    Click Element    ${field}
    Input Text    ${field}    ${value}

Select Symbol
    Click Element    ${symbol}
    Click Element    id:AUDUSD 

Switch To Financial
        Click Element    //p[contains(@class,"typography__Text") and text()="Financial"]

Check Swap Charge
     ${expected_swap}=    Evaluate    100*100000*10*0.5
     ${formatted_results}=    Evaluate    "{:,}".format($expected_swap)
     SeleniumLibrary.Element Text Should Be    //*[text()="USD"]//preceding-sibling::div     ${formatted_results}

*** Test Cases ***
#check all trade types and paltforms exist in the main page
Check Traders Menu
    Go To Homepage
    Open Trade Menu
    Check Trade Types
    Check Trading Platforms
    
#make sure Deriv Life link in main page is linked correctly to https://derivlife.com/ .
Check Deriv Life
    Go To Homepage
    Open About US Menu
    Click Element    ${deriv_life}
    Switch Window    NEW    10
    Page Should Contain    Making an impact that matters

#check social media link is correct
Check Social Networks
    Switch Window     Online trading platform | Forex, commodities, synthetic indices, stocks, and stock indices | Deriv
    Scroll Element Into View    //footer
    Page Should Contain Element    ${youtube}
    Page Should Contain Element    ${telegram}
    Page Should Contain Element    ${facebook}
    Page Should Contain Element    ${twitter}
    Page Should Contain Element    ${instagram}
    Page Should Contain Element    ${linkedin}
    
#check swap calculator works fine
Swap Calculator
    Go To Swap Calculator
    Scroll Element Into View    ${calculator_table}
    Switch To Financial 
    Select Symbol
    Fill Form    id:volume    100
    Fill Form    id:pointValue    10
    Fill Form    id:swapRate    0.5
    Click Button    css:[type="submit"]
    Check Swap Charge

    
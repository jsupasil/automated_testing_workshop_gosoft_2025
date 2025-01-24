*** Settings ***
Library    env_loader.py
Library        SeleniumLibrary
Suite Setup    เปิดเว็บเบราว์เซอร์และเข้า allonline
Test Setup    เข้าสู่ระบบ
Test Teardown    ออกจากระบบ
Suite Teardown    Close Browser

Test Template    ลูกค้าสั่งซื้อสินค้าสำเร็จ

*** Variables ***
${URL}    https://www.allonline.7eleven.co.th
${BROWSER}    chrome
${EMAIL}    %{EMAIL}
${PASSWORD}    %{PASSWORD}
${USERNAME}    %{USERNAME}

${TEST_CARD_NAME}    %{TEST_CARD_NAME}
${TEST_CARD_NUMBER}    %{TEST_CARD_NUMBER}
${TEST_EXPIRE_DATE}    %{TEST_EXPIRE_DATE}
${TEST_CVV}    %{TEST_CVV}



*** Test Cases ***                                 ชื่อสินค้า    จำนวนสินค้า    ราคาสินค้า    ราคารวม    ค่าจัดส่ง    ยอดสุทธิ    คะแนน    ชื่อลูกค้า    นามสกุลลูกค้า    โทรศัพท์    บ้านเลขที่    หมู่    จังหวัด    อำเภอ    ตำบล    รหัสไปรษณีย์    ชื่อบัตรเครดิต    หมายเลขบัตรเครดิต    วันหมดอายุ    CVV
ลูกค้าสั่งซื้ออสินค้าเลือกจัดส่งตามที่อยู่และชำระเงินด้วยบัตรเครดิต    ยำยำช้างน้อย รสบาร์บีคิว 120 กรัม    5    32    160    35    195    548    พันกร    ชมจันทร์    0619917765    45/9    7    สมุทรปราการ    บางพลี    บางปลา    10540    ${TEST_CARD_NAME}    ${TEST_CARD_NUMBER}    ${TEST_EXPIRE_DATE}    ${TEST_CVV} 


*** Keywords ***
ลูกค้าสั่งซื้อสินค้าสำเร็จ
    [Arguments]    ${ชื่อสินค้า}    ${จำนวนสินค้า}    ${ราคาสินค้า}    ${ราคารวม}    ${ค่าจัดส่ง}    ${ยอดสุทธิ}    ${คะแนน}    ${ชื่อลูกค้า}    ${นามสกุลลูกค้า}    ${โทรศัพท์}    ${บ้านเลขที่}    ${หมู่}    ${จังหวัด}    ${อำเภอ}    ${ตำบล}    ${รหัสไปรษณีย์}    ${ชื่อบัตรเครดิต}    ${หมายเลขบัตรเครดิต}    ${วันหมดอายุ}    ${CVV}
    เลือกซื้อสินค้า    ${ชื่อสินค้า}    ${จำนวนสินค้า}    ${ราคาสินค้า}    ${ราคารวม}
    เลือกวิธีจัดส่งสินค้า    ${ชื่อลูกค้า}    ${นามสกุลลูกค้า}    ${โทรศัพท์}    ${บ้านเลขที่}    ${หมู่}    ${จังหวัด}    ${อำเภอ}    ${ตำบล}    ${รหัสไปรษณีย์} 
    เลือกวิธีชำระเงิน    ${ชื่อบัตรเครดิต}    ${หมายเลขบัตรเครดิต}    ${วันหมดอายุ}    ${CVV}    ${ราคารวม}    ${ค่าจัดส่ง}    ${ยอดสุทธิ}    ${คะแนน}


###################################    SETUP & TEARDOWN    ######################################
เปิดเว็บเบราว์เซอร์และเข้า allonline
    Open Browser    url=${URL}    browser=${BROWSER}

เข้าสู่ระบบ
    Wait Until Element Is Visible    xpath://a[@href='/login/']
    Click Element    xpath=//a[@href='/login/']
    Input Text    name:email    ${EMAIL}
    Input Password    name:password    ${PASSWORD}
    Click Element    xpath=//a[text()="เข้าสู่ระบบ"]
    Wait Until Element Is Visible    id:login-dropdown

ออกจากระบบ
    Go To    ${URL}
    Click Element    id:login-dropdown
    Click Element    xpath://a[contains(text(), "ออกจากระบบ")]


###################################    เลือกซื้อสินค้า    ######################################
เลือกซื้อสินค้า
    [Arguments]    ${ชื่อสินค้า}    ${จำนวนสินค้า}    ${ราคาสินค้า}    ${ราคารวม}
    ค้นหาสินค้า และตรวจสอบ    ${ชื่อสินค้า}
    เลือกสินค้าและระบุใส่จำนวน    ${ชื่อสินค้า}    ${จำนวนสินค้า}    ${ราคาสินค้า}
    เพิ่มลงตะกร้า        ${ชื่อสินค้า}    ${จำนวนสินค้า}    ${ราคาสินค้า}    ${ราคารวม}
    ดำเนินการชำระเงิน

ค้นหาสินค้า และตรวจสอบ
    [Arguments]    ${ชื่อสินค้า}
    Input Text    name:q    ${ชื่อสินค้า}
    Press Keys    name:q    RETURN
    # Wait Until Element Is Visible    class:header-category
    Element Should Be Visible    xpath://*[contains(@title, "${ชื่อสินค้า}")]

เลือกสินค้าและระบุใส่จำนวน
    [Arguments]    ${ชื่อสินค้า}    ${จำนวนสินค้า}    ${ราคาสินค้า}
    Click Element    xpath://*[contains(@title, "${ชื่อสินค้า}")]
    # Wait Until Element Is Visible    id:title-product
    Element Should Contain    id:title-product    ${ชื่อสินค้า}
    Element Should Contain    xpath=//*[@id="article-form"]/div[2]/span/div/div[1]/span    ${ราคาสินค้า}
    Wait Until Element Is Visible    name:order_count
    Input Text    name:order_count    ${จำนวนสินค้า}
    

เพิ่มลงตะกร้า
    [Arguments]    ${ชื่อสินค้า}    ${จำนวนสินค้า}    ${ราคาสินค้า}    ${ราคารวม}
    Click Button    xpath://button[contains(normalize-space(.), "เพิ่มลงตะกร้า")]
    # Wait Until Element Is Visible    class:cart-indicator
    Click Element    xpath=//a[@href='/account/basket/']
    Element Should Be Visible    id:mini-basket-val            #pop up ตะกร้าควรปรากฏ
    Page Should Contain    ${ราคารวม}

ดำเนินการชำระเงิน
    Wait Until Element Is Visible    xpath=//a[@href='/checkout/' and contains(text(), 'ชำระค่าสินค้า')]
    Click Element    xpath=//a[@href='/checkout/' and contains(text(), 'ชำระค่าสินค้า')]
    Page Should Contain    รายละเอียดการจัดส่งสินค้า


###################################    เลือกวิธีจัดส่งสินค้า    ######################################
เลือกวิธีจัดส่งสินค้า
    [Arguments]    ${ชื่อลูกค้า}    ${นามสกุลลูกค้า}    ${โทรศัพท์}    ${บ้านเลขที่}    ${หมู่}    ${จังหวัด}    ${อำเภอ}    ${ตำบล}    ${รหัสไปรษณีย์}
    เลือกเพิ่มที่อยู่ใหม่
    ใส่ที่อยู่ที่จัดส่ง    ${ชื่อลูกค้า}    ${นามสกุลลูกค้า}    ${โทรศัพท์}    ${บ้านเลขที่}    ${หมู่}    ${จังหวัด}    ${อำเภอ}    ${ตำบล}    ${รหัสไปรษณีย์}    


เลือกเพิ่มที่อยู่ใหม่
    Click Element    xpath=//a[@href='#address']
    Click Element    xpath=//*[contains(text(), "เพิ่มที่อยู่ใหม่")]

ใส่ที่อยู่ที่จัดส่ง
    [Arguments]    ${ชื่อลูกค้า}    ${นามสกุลลูกค้า}    ${โทรศัพท์}    ${บ้านเลขที่}    ${หมู่}    ${จังหวัด}    ${อำเภอ}    ${ตำบล}    ${รหัสไปรษณีย์}
    Input Text    id:new-address-name    ${ชื่อลูกค้า}
    Input Text    id:new-address-lastname    ${นามสกุลลูกค้า}
    Input Text    id:new-address-mobile    ${โทรศัพท์}
    Input Text    id:new-address-addrno    ${บ้านเลขที่}
    Input Text    id:new-address-moo    ${หมู่}
    Scroll Element Into View    id:footer                 #เลื่อนหน้าให้ปุ่มไม่ชนกับ pop up cookie

    Click Element    id:select2-new-address-province-container
    Wait Until Element Is Visible    id:select2-new-address-province-results
    Input Text    xpath:/html/body/span/span/span[1]/input    ${จังหวัด}
    Press Keys    xpath:/html/body/span/span/span[1]/input    RETURN

    Click Element    id:select2-new-address-district-container
    Wait Until Element Is Visible    id:select2-new-address-district-container
    Input Text    xpath:/html/body/span/span/span[1]/input    ${อำเภอ}
    Press Keys    xpath:/html/body/span/span/span[1]/input    RETURN

    Click Element    id:select2-new-address-sub-district-container
    Wait Until Element Is Visible    id:select2-new-address-sub-district-container
    Input Text    xpath:/html/body/span/span/span[1]/input    ${ตำบล}
    Press Keys    xpath:/html/body/span/span/span[1]/input    RETURN
    
    Wait Until Element Is Visible    xpath=//*[@id="map-location"]/div/div[3]/div[12]/div[1]/div/img
    Click Element    id:selected-location
    Scroll Element Into View    id:conf-dif-addr             #เลื่อนหน้าให้ปุ่มไม่ชนกับ pop up cookie
    Click Element    id:conf-dif-addr                        #กดปุ่มยืนยันที่อยู่
    # Wait Until Element Is Not Visible    id:def-locate
    Click Button    id:continue-payment-btn                  #กดปุ่มดำเนินการชำระเงิน
    Page Should Contain    วิธีการชำระเงิน
    # Wait Until Element Is Visible    id:xxx


###################################    เลือกวิธีชำระเงิน    ######################################
เลือกวิธีชำระเงิน    
    [Arguments]    ${ชื่อบัตรเครดิต}    ${หมายเลขบัตรเครดิต}    ${วันหมดอายุ}    ${CVV}    ${ราคารวม}    ${ค่าจัดส่ง}    ${ยอดสุทธิ}    ${คะแนน}
    เลือกชำระด้วยบัตรเครดิต และตรวจสอบ    ${ราคารวม}    ${ค่าจัดส่ง}    ${ยอดสุทธิ}    ${คะแนน}
    ระบุข้อมูลบัตรเครดิต    ${ชื่อบัตรเครดิต}    ${หมายเลขบัตรเครดิต}    ${วันหมดอายุ}    ${CVV}    ${ยอดสุทธิ}
    
    # Wait Until Element Is Visible    id:xxx
    
เลือกชำระด้วยบัตรเครดิต และตรวจสอบ
    [Arguments]    ${ราคารวม}    ${ค่าจัดส่ง}    ${ยอดสุทธิ}    ${คะแนน}
    Click Button    xpath=//*[@id="payment-options"]/div[1]/button
    Scroll Element Into View    xpath=//*[@id="sector-special-rate"]/div/div[2]/div[3]/div         #เลื่อนหน้าให้ปุ่มไม่ชนกับ pop up cookie
    # Wait For Expected Condition    Element Should Be Clickable    xpath=//*[@id="stepModel"]/div[1]/div[2]/footer/div/div/button
    Element Should Contain    xpath=//*[@id="js-invoice-details-tbody"]/tr[1]/td[2]/b    ${ราคารวม}
    Element Should Contain    xpath=//*[@id="js-invoice-details-tbody"]/tr[2]/td[2]/b    ${ค่าจัดส่ง}
    Element Should Contain    id:totalAmount    ${ยอดสุทธิ}
    Element Should Contain    xpath=//*[@id="js-invoice-details-tbody"]/tr[17]/td[2]/b    ${คะแนน}
    Click Button    xpath=//*[@id="stepModel"]/div[1]/div[2]/footer/div/div/button                 #กดปุ่มชำระเงิน

ระบุข้อมูลบัตรเครดิต
    [Arguments]    ${ชื่อบัตรเครดิต}    ${หมายเลขบัตรเครดิต}    ${วันหมดอายุ}    ${CVV}    ${ยอดสุทธิ}
    Wait Until Element Is Visible    id:cardName    timeout=15
    Input Text    id:cardName    ${ชื่อบัตรเครดิต}
    Input Text    id:cardNumber    ${หมายเลขบัตรเครดิต}
    Input Text    id:expiryDate    ${วันหมดอายุ}
    Input Password    id:cvCode    ${CVV}
    # Click Button    id:subFormPay                 #กดปุ่มจ่ายตัง







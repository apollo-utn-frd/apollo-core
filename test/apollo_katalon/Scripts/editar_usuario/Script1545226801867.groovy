import static com.kms.katalon.core.checkpoint.CheckpointFactory.findCheckpoint
import static com.kms.katalon.core.testcase.TestCaseFactory.findTestCase
import static com.kms.katalon.core.testdata.TestDataFactory.findTestData
import static com.kms.katalon.core.testobject.ObjectRepository.findTestObject
import com.kms.katalon.core.checkpoint.Checkpoint as Checkpoint
import com.kms.katalon.core.cucumber.keyword.CucumberBuiltinKeywords as CucumberKW
import com.kms.katalon.core.mobile.keyword.MobileBuiltInKeywords as Mobile
import com.kms.katalon.core.model.FailureHandling as FailureHandling
import com.kms.katalon.core.testcase.TestCase as TestCase
import com.kms.katalon.core.testdata.TestData as TestData
import com.kms.katalon.core.testobject.TestObject as TestObject
import com.kms.katalon.core.webservice.keyword.WSBuiltInKeywords as WS
import com.kms.katalon.core.webui.keyword.WebUiBuiltInKeywords as WebUI
import internal.GlobalVariable as GlobalVariable
import org.openqa.selenium.Cookie
import org.openqa.selenium.WebDriver
import com.kms.katalon.core.webui.driver.DriverFactory

WebUI.openBrowser('')

WebUI.navigateToUrl('http://localhost:3000/')

Cookie ck = new Cookie("_interslice_session", "7XCZXW9bsD60Xr5DDWFqYr6Q8CVKwPoGh8KzzD%2Fcyu8BYnTpQVCMWlSXHJ9%2BlrME40hykVhXdAz7pkOSXz3%2BUXNmJOcDY4m6oX6mUMWSRPfi%2Be9iUe9Bh2PmCEJP76TBgHcefIlO7Q5ifg39zDHvO0KT8aqd3ylxnyb5Ysi23M4tM0bPa4YHAqG8UACWY%2Fuepi8nV9ewN9jy%2BeVF1J5L--Tw%2FoMrMMwV8SGVKX--omw8p%2BmEdSzBOWSiPt6lDA%3D%3D");
WebDriver driver = DriverFactory.getWebDriver()
driver.manage().addCookie(ck)

WebUI.navigateToUrl('http://localhost:3000/home')

WebUI.click(findTestObject('Object Repository/Page_Apollo_Editar/Page_Apollo/a_Bruce'))

WebUI.click(findTestObject('Object Repository/Page_Apollo_Editar/Page_Apollo/a_Editar usuario'))

WebUI.setText(findTestObject('Object Repository/Page_Apollo_Editar/Page_Apollo/input_Nombre_name'), 'Bruce_K')

WebUI.setText(findTestObject('Object Repository/Page_Apollo_Editar/Page_Apollo/input_Apellido_lastname'), 'Wayne_K')

WebUI.setText(findTestObject('Object Repository/Page_Apollo_Editar/Page_Apollo/textarea_Im Batman'), 'I\'m Katalon')

WebUI.click(findTestObject('Object Repository/Page_Apollo_Editar/Page_Apollo/input_concat(I  m Batman)_comm'))

WebUI.click(findTestObject('Object Repository/Page_Apollo_Editar/Page_Apollo/button_'))

WebUI.closeBrowser()


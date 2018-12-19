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

WebUI.click(findTestObject('Object Repository/Page_Apollo_rv/Page_Apollo/a_Ruta de Viaje'))

WebUI.click(findTestObject('Object Repository/Page_Apollo_rv/Page_Apollo/div'))

WebUI.click(findTestObject('Object Repository/Page_Apollo_rv/Page_Apollo/div'))

WebUI.setText(findTestObject('Object Repository/Page_Apollo_rv/Page_Apollo/input_Titulo_title'), 'test katalon')

WebUI.setText(findTestObject('Object Repository/Page_Apollo_rv/Page_Apollo/textarea_Descripcin_descriptio'), 'test katalon')

WebUI.setText(findTestObject('Object Repository/Page_Apollo_rv/Page_Apollo/input_A_placestitle'), 'a')

WebUI.setText(findTestObject('Object Repository/Page_Apollo_rv/Page_Apollo/textarea_A_placesdescription'), 'a')

WebUI.setText(findTestObject('Object Repository/Page_Apollo_rv/Page_Apollo/input_B_placestitle'), 'b')

WebUI.setText(findTestObject('Object Repository/Page_Apollo_rv/Page_Apollo/textarea_B_placesdescription'), 'b')

WebUI.click(findTestObject('Object Repository/Page_Apollo_rv/Page_Apollo/input_B_commit'))

WebUI.closeBrowser()


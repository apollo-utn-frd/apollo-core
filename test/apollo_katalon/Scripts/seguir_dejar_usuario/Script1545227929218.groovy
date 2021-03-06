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

WebUI.navigateToUrl('http://localhost:3000/users/7e33e351544141c2b878d2c435345d8b')

WebUI.click(findTestObject('Object Repository/Page_Apollo_Seguir/Page_Apollo/button_Seguir'))

WebUI.click(findTestObject('Object Repository/Page_Apollo_Seguir/Page_Apollo/a_APOLLO'))

WebUI.click(findTestObject('Object Repository/Page_Apollo_Seguir/Page_Apollo/li_Seguidos'))

WebUI.click(findTestObject('Object Repository/Page_Apollo_Seguir/Page_Apollo/span_raven'))

WebUI.click(findTestObject('Object Repository/Page_Apollo_Seguir/Page_Apollo/button_Dejar de seguir'))

WebUI.click(findTestObject('Object Repository/Page_Apollo_Seguir/Page_Apollo/strong_APOLLO'))

WebUI.click(findTestObject('Object Repository/Page_Apollo_Seguir/Page_Apollo/span_2'))

WebUI.closeBrowser()


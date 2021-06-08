import { Selector } from 'testcafe';
import { Crypto } from 'testcafe';
import colors from 'colors';
var faker = require('faker');

function numberGen(len) {       //Function to Generate random number; length of number = value specified in 'len'
	 //  var genNum= Math.floor(Math.pow(10, len)*Math.random()).toString()
	  var text = "";
		var charset = "0123456789";
		for( var i=0; i < len; i++ ) {
		text += charset.charAt(Math.floor(Math.random() * charset.length));}
		return text;
};

const dataSet = require('./dataIUT.json');
const crt = require('crypto')

var Code = "Code_"+faker.random.alphaNumeric(4).toUpperCase();
var Desc = "Desc_"+faker.random.alphaNumeric(4).toUpperCase();
var EntityName = "EntityName_"+faker.random.alphaNumeric(4).toUpperCase();
var EntAbb = "EntAbb_"+faker.random.alphaNumeric(2).toUpperCase();
var BankName = "BA_"+faker.random.alphaNumeric(4).toUpperCase();
var AccNumber = faker.random.alphaNumeric(9).toUpperCase();
var DriverName = "DvName_"+faker.random.alphaNumeric(4).toUpperCase();
var EmpName = "Emp_"+faker.random.alphaNumeric(5).toUpperCase();
var EmpNumber = numberGen(9);
var SSN = numberGen(9);
var PeopleName = "PeoName_"+faker.random.alphaNumeric(4).toUpperCase();       
var OrgName = "OrgName_"+faker.random.alphaNumeric(5).toUpperCase();
var Abb = "OrgAbb_"+faker.random.alphaNumeric(5).toUpperCase();
         
fixture `Smoke_Maintenance`
    .page `https://rma194automation.dxc-rmcl.com/riskmasterux`;

dataSet.forEach(data => {
test('EmployeeCreation', async t => {        
    await t
        .maximizeWindow()
        .typeText(Selector('#username'), data.Username)
        .pressKey('tab')
        .typeText(Selector('#login-password'), data.Password)
        .pressKey('enter')
        .click(Selector('[ng-model="dsnSelected"]'))
        .click(Selector('[role="option"]').find('span').withText(data.DSN))
        .click(Selector('[ng-model="zoneSelected"]'))
        .click(Selector('[role="option"]').find('a').withText('Maintenance'))
        .click(Selector('#loginbox').find('button').withText('Continue'))
        //Login Into Application

        .click(Selector('#menuBar').find('a').withText('Maintenance').nth(0))
        .click(Selector('#menu_MaintenanceRoot').find('a').withText('Employee'))
        .switchToIframe(Selector('[id^="employees"]'))
        await t.typeText(Selector('#employeenumber'), EmpNumber).setTestSpeed(0.6)
        await t.typeText(Selector('#lastname'), EmpName).setTestSpeed(0.6)
        .click(Selector('[role="button"]').find('span').withText('Employment Info'))
        .typeText(Selector('#lookup_deptassignedeid'), data.Department).setTestSpeed(0.6)
        .pressKey('tab')
        .click(Selector('[role="button"]').find('span').withText('Employee'))
        await t.typeText(Selector('#taxid'), SSN).setTestSpeed(0.6)
        .pressKey('tab')
        .click(Selector('#Save').find('i').withText('save'))
        const ele1 = Selector('[class="row main_menu right-panel-bg-hover"]').find('i').withText('add').with({ visibilityCheck: true })
        await t.expect(ele1.exists).ok('', { timeout: 20000 })
        //Employee Saved

        .click(Selector('#lastname'))
        .pressKey('ctrl+a delete')
        .typeText(Selector('#lastname'), "Edited"+EmpName).setTestSpeed(0.6)
        .pressKey('tab')
        .click(Selector('#Save').find('i').withText('save'))
        await t.expect(ele1.exists).ok('', { timeout: 20000 })
        //Employee Edited

        .click(Selector('#Delete\\ Record').find('i').withText('delete'))
        .click(Selector('#btnRoll').find('i').withText('done'))
        .wait(2000)
		console.log("Employee Maintenance Verified!".green);
        //Employee Deleted

        await t.switchToMainWindow()
        .click(Selector('#morebtn').find('i').withText('more_vert'))
        .click(Selector('#menu_othersMenu').find('a').withText('exit_to_appLogout'))
        .click(Selector('#btnRoll').find('i').withText('done'));
        //Logout Of Application
});});
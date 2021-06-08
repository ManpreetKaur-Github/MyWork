import { Selector } from 'testcafe';
import {Crypto} from 'testcafe';
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

const crt = require('crypto')
const dataSet = require('./dataIUT.json');

var EmpNumber = numberGen(9);
var EmpName = "EmployeeName_"+faker.random.alphaNumeric(3).toUpperCase();
      

fixture `Smoke_WC`
    .page `https://rma194automation.dxc-rmcl.com/riskmasterux`
	.beforeEach(t => t.resizeWindow(1200, 1100));

dataSet.forEach(data => {
test('WCAutoChecks', async t => {
    await t
        .maximizeWindow()
        .typeText(Selector('#username'), data.Username)
        .pressKey('tab')
        .typeText(Selector('#login-password'), data.Password)
        .pressKey('enter')
        .click(Selector('[ng-model="dsnSelected"]'))
        .click(Selector('[role="option"]').find('span').withText(data.DSN))
        .click(Selector('[ng-model="zoneSelected"]'))
        .click(Selector('[role="option"]').find('a').withText('Claims'))
        .click(Selector('#loginbox').find('button').withText('Continue'))
        //console.log("LoggedIn!".green);
        //Login Into Application

        await t.click(Selector('#menuBar').find('a').withText('Document').nth(0))
        .click(Selector('#menu_DocumentRoot').find('a').withText('Workers’ Comp'))
        .switchToIframe(Selector('[id^="claimwc"]'))
        .click(Selector('#lookup_empemployeenumber'))
        await t.typeText(Selector('#lookup_empemployeenumber'), EmpNumber).setTestSpeed(0.6)
        .pressKey('tab')
        .typeText(Selector('#lookup_ev_depteid'), data.Department).setTestSpeed(0.6)
        .pressKey('enter')
        .click(Selector('#btn_claimtypecode_openlookup').find('.glyphicon.glyphicon-option-horizontal'))
        .click(Selector('[class="ui-grid-cell-contents ng-scope"]').find('span').withText(data.WCClaimType))
        .wait(2000)
        .click(Selector('#btn_policyLOBCode_openlookup').find('.glyphicon.glyphicon-option-horizontal'))
        .click(Selector('[class="ui-grid-cell-contents ng-scope"]').find('span').withText(data.WCPolicyLOB))
        .click(Selector('#btn_claimstatuscode_openlookup').find('.glyphicon.glyphicon-option-horizontal'))
        .click(Selector('[class="ui-grid-cell-contents ng-scope"]').find('span').withText(data.ClaimStatus))
        .click(Selector('#btn_ev_timeofevent'))
        .click(Selector('#ev_dateofevent').nth(1))
        var date = new Date();
        var d = (date.getMonth()+1)+'/'+(date.getDate()-1)+'/'+date.getFullYear();
        await t.typeText(Selector('#ev_dateofevent').nth(1), d).setTestSpeed(0.6)
        .typeText(Selector('#dateofclaim').nth(1), d).setTestSpeed(0.6)
        .click(Selector('#btn_timeofclaim').find('.glyphicon.glyphicon-time'))
        .click(Selector('#btn_filingstateid_openlookup'))
        .click(Selector('[class="ui-grid-cell-contents ng-scope"]').find('span').withText('Alberta'))
        .click(Selector('[role="button"]').find('span').withText('Employee Info').nth(1))
		var SSN = numberGen(9); 
        await t.typeText(Selector('#emptaxid'), SSN).setTestSpeed(0.6)
        .click(Selector('#emplastname'))
        await t.typeText(Selector('#emplastname'), EmpName).setTestSpeed(0.6)
        .pressKey('tab')
        .click(Selector('[role="button"]').find('span').withText('Employment Info').nth(1))
        .typeText(Selector('#lookup_empdeptassignedeid1'), data.Department).setTestSpeed(0.6)
        .pressKey('tab')
        .click(Selector('[role="button"]').find('span').withText('Claim Info').nth(1))
        .click(Selector('#Save').find('i').withText('save'))
        console.log("WC Created!".green);
        //WC Saved

        await t.click(Selector('#Financials\\/Reserves').find('.commonIcomoon.icomoon-safe.icon-safe'))
        .wait(1000)
        .click(Selector('#AddReserve').find('i').withText('add'))
        .click(Selector('#cmbReserveType'))
        .click(Selector('#cmbReserveType').find('option').withText(data.ReserveType))
        .typeText(Selector('#txtAmount').nth(1), '123').setTestSpeed(0.6)
        .click(Selector('#cmbStatusAdd'))
        .click(Selector('#cmbStatusAdd').find('option').withText(data.ReserveStatus))
        .click(Selector('#Save').find('i').withText('save'))
        .switchToMainWindow()
        .click(Selector('#dvbreadcrumbscroll').find('i').withText('reply'))
        .switchToIframe(Selector('[id^="claimwc"]'))
        console.log("WC-Reserve Created!".green);
        //Reserve Creation Done

        await t.click(Selector('[class="ui-grid-cell-contents"]').nth(1).find('[class^="ui-grid-selection-row-header-buttons ui-grid-icon-"]'))
        .click('#ScheduleCheck .material-icons.mdi.mdi-timetable')
        .click('#cbopayeetype')
        .click(Selector('#cbopayeetype').find('option').withText('C-Claimant'))
        .click(Selector('[role="button"]').find('span').withText('Detailed Information'))
        .click(Selector('#cruduiGridAddBtn').nth(1).find('.glyphicon.glyphicon-plus-sign'))
        .click('#btn_transTypeCode_openlookup')
        .click(Selector('[class="ui-grid-cell-contents ng-scope"]').find('span').nth(1))
        .typeText(Selector('#amount').nth(1), '12').setTestSpeed(0.6)
        .click(Selector('#Save i').withText('save'))
        .click(Selector('[role="button"]').find('span').withText('Scheduled Checks'))
        .click(Selector('#Save i').withText('save'))
        .wait(2000)
        var ControlNumber = await Selector('#ctlnumber').innerText;
        console.log("WC-Auto Check Created Successfully".green);
        //Auto Check Created

        await t.switchToMainWindow()
        .click(Selector('#dvbreadcrumbscroll i').withText('reply'))
        .switchToIframe('[id^="claimwc"]')
        .click(Selector('#PaymentHistory i').withText('history'))
        .switchToIframe('#externalapp')
        .click(Selector('#btnAutoChecks i').withText('schedule'))
        const ele2 = Selector('[role="gridcell"]').find('span').withText(ControlNumber).with({ visibilityCheck: true })
        await t.expect(ele2.exists).ok('', { timeout: 20000 })
        const ele3 = Selector('[role="gridcell"]').find('span').withText(EmpName).with({ visibilityCheck: true })
        await t.expect(ele3.exists).ok('', { timeout: 20000 })
        .click(Selector('#btnBackToPayment i').withText('arrow_back'))
        console.log("WC-Payment History Verified".green);
        //Payment History Verified

        await t.switchToMainWindow()
        .click(Selector('#morebtn i').withText('more_vert'))
        .click(Selector('#menu_othersMenu i').withText('exit_to_app'))
        .click(Selector('#btnRoll i').withText('done'));
        //console.log("Logged Out!!".green);
});});
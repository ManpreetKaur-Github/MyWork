import { Selector,Crypto } from 'testcafe';
import Colors from 'colors';
var faker = require('faker');

const crt = require('crypto')
const dataSet = require('./dataIUT.json');

var AdjLastName = "AdjLastName_"+faker.random.alphaNumeric(4).toUpperCase();
var AdjFirstName = "AdjFirstName_"+faker.random.alphaNumeric(4).toUpperCase();
var ClmLastName = "ClmntLastName_"+faker.random.alphaNumeric(4).toUpperCase();
var ClmFirstName = "ClmntFirstName_"+faker.random.alphaNumeric(4).toUpperCase();
var CreateNote = "CreateNote_"+faker.random.alphaNumeric(4).toUpperCase();
var TaskName = "TaskName_"+faker.random.alphaNumeric(4).toUpperCase();
var NotesText = "NotesText_"+faker.random.alphaNumeric(4).toUpperCase();

fixture `Smoke_GC`
    .page `https://rma194automation.dxc-rmcl.com/riskmasterux`
    .beforeEach(t => t.resizeWindow(1200, 1100));

dataSet.forEach(data => {
test('GCCreationWithPaymentReserve', async t => {
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
        //console.log("Logged In!".green);  
        //Login Into Application
    await t    
        .click(Selector('#menuBar').find('a').withText('Document').nth(0))
        .click(Selector('#menu_DocumentRoot').find('a').withText('General Claim'))
        await t.wait(10000)
        .switchToIframe(Selector('#claimgc_-1'))
		var date = new Date();
        var d = (date.getMonth()+1)+'/'+(date.getDate()-1)+'/'+date.getFullYear();
        await t.typeText(Selector('#ev_dateofevent').nth(1), d).setTestSpeed(0.6)
        .wait(1000)
        .typeText(Selector('#dateofclaim').nth(1), d).setTestSpeed(0.6)
        .click(Selector('#btn_ev_timeofevent').find('.glyphicon.glyphicon-time'))
        .click(Selector('#btn_timeofclaim').find('.glyphicon.glyphicon-time'))
        .click(Selector('#btn_claimstatuscode_openlookup').find('.glyphicon.glyphicon-option-horizontal'))

        const ele1 = Selector('[class="ui-grid-cell-contents ng-scope"]').find('span').withText(data.ClaimStatus).with({ visibilityCheck: true })
        await t.expect(ele1.exists).ok('', { timeout: 20000 })
        .click(ele1)

        .click(Selector('#btn_claimtypecode_openlookup').find('.glyphicon.glyphicon-option-horizontal'))
        const ele2 = Selector('[class="ui-grid-cell-contents ng-scope"]').find('span').withText(data.GCClaimType).with({ visibilityCheck: true })
        await t.expect(ele2.exists).ok('', { timeout: 20000 })
        .click(ele2)
        .click(Selector('#lookup_ev_depteid'))
        .typeText(Selector('#lookup_ev_depteid'), data.Department).setTestSpeed(0.6)
        .pressKey('tab')
        .click(Selector('#btn_policyLOBCode_openlookup').find('.glyphicon.glyphicon-option-horizontal'))

        await t.click(Selector('[class="ui-grid-cell-contents ng-scope"]').find('span').withText(data.GCPolicyLOB))
        .click(Selector('#Save').find('i').withText('save'))
        console.log("GC saved!".green); 
        //GC Claim Save
    await t
        .click(Selector('#Financials\\/Reserves').find('.commonIcomoon.icomoon-safe.icon-safe'))
        .wait(1000)
        .click(Selector('#AddReserve').find('i').withText('add'))
        .click(Selector('#cmbReserveType'))
        .click(Selector('#cmbReserveType').find('option').withText(data.ReserveType))
        .typeText(Selector('#txtAmount').nth(1), '123').setTestSpeed(0.6)
        .click(Selector('#cmbStatusAdd'))
        .click(Selector('#cmbStatusAdd').find('option').withText(data.ReserveStatus))
        .click(Selector('#Save').find('i').withText('save'))
        console.log("GC-Reserves Created!".green); 
        //Reserve Creation Done

    await t    
        .switchToMainWindow()
        .click(Selector('#dvbreadcrumbscroll').find('i').withText('reply'))
        .switchToIframe(Selector('[id^="claimgc"]'))
        

        .click(Selector('[class="ui-grid-cell-contents"]').nth(1).find('[class^="ui-grid-selection-row-header-buttons ui-grid-icon-"]'))
        .click(Selector('#MakePayment').find('[class^="commonIcomoon material-icons-clr icon-payment icon"]'))
		.click(Selector('#bankaccount'))
		.click(Selector('#bankaccount').find('option').withText("Claim Payment"))
        .click(Selector('#cbopayeetype'))
        .click(Selector('#cbopayeetype').find('option').withText(data.PayeeType))
        .typeText(Selector('#lookup_rmalookupfinanciallastname2_lastName'), data.LastName).setTestSpeed(0.6)
        .pressKey('tab')
        .click(Selector('[role="button"]').find('span').withText('Transaction Detail'))
        .click(Selector('#cruduiGridAddBtn'))
        .click(Selector('#cmbTransactionType'))
        .click(Selector('#cmbTransactionType').find('option').withText(data.TransactionType))
        .typeText(Selector('#amount').nth(1), '12').setTestSpeed(0.6)
        .click(Selector('#Save').find('i').withText('save'))
        .click(Selector('[role="button"]').find('span').withText('Transaction'))
        .click(Selector('#Save').find('i').withText('save'))
        .wait(2000)
        console.log("GC-Payment Created!".green);
        //Payment Creation
    await t
        .switchToMainWindow()
        .click(Selector('#dvbreadcrumbscroll').find('i').withText('reply'))
        .switchToIframe(Selector('[id^="claimgc"]'))
        .click(Selector('#PaymentHistory').find('i').withText('history'))
        .switchToIframe(Selector('#externalapp'))
        const ele4 = Selector('[role="gridcell"]').find('span').with({ visibilityCheck: true })
        await t.expect(ele4.exists).ok('', { timeout: 20000 })
        const ele5 = Selector('[role="gridcell"]').find('span').withText("Payment").with({ visibilityCheck: true })
        await t.expect(ele5.exists).ok('', { timeout: 20000 })
        console.log("GC-Payment History!".green);
        //Transaction History Verifications
    await t
        .switchToMainWindow()
        .click(Selector('#morebtn').find('i').withText('more_vert'))
        .click(Selector('#menu_othersMenu').find('a').withText('exit_to_appLogout'))
        .click(Selector('#btnRoll').find('i').withText('done'));
        //console.log("Logged out!".green);  
        //Logout From Application
});});
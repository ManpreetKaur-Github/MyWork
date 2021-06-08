import { Selector } from 'testcafe';
import {Crypto} from 'testcafe';
import colors from 'colors';

const crt = require('crypto')
const dataSet = require('./dataIUT.json');

fixture `Smoke_GCCarrier`
    .page `https://rma194automation.dxc-rmcl.com/riskmasterux`;

dataSet.forEach(data => {
test('CarrierGCCreation', async t => {
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
        .click(Selector('#menu_DocumentRoot').find('a').withText('General Claim'))
        .switchToIframe(Selector('[id^="claimgc"]'))
        var date = new Date();
        var d = (date.getMonth()+1)+'/'+(date.getDate()-1)+'/'+date.getFullYear();
        await t.wait(1000)
        .typeText(Selector('#ev_dateofevent').nth(1), d).setTestSpeed(0.6)
        .wait(1000)
        .typeText(Selector('#dateofclaim').nth(1), d).setTestSpeed(0.6)
        .click(Selector('#btn_ev_timeofevent').find('.glyphicon.glyphicon-time'))
        .click(Selector('#btn_timeofclaim').find('.glyphicon.glyphicon-time'))
        .click(Selector('#btn_claimstatuscode_openlookup').find('.glyphicon.glyphicon-option-horizontal'))

        const ele1 = Selector('[class="ui-grid-cell-contents ng-scope"]').find('span').withText(data.ClaimStatus).with({ visibilityCheck: true })
        await t.expect(ele1.exists).ok('', { timeout: 20000 })
        .click(ele1)
        .click(Selector('#lookup_ev_depteid'))
        .typeText(Selector('#lookup_ev_depteid'), data.Department).setTestSpeed(0.6)
        .pressKey('tab')
		
		.click(Selector('#lookup_policyLOBCode'))
        .typeText(Selector('#lookup_policyLOBCode'), data.GCCarrierPolicyLOB).setTestSpeed(0.6)
        .pressKey('tab')

        .click(Selector('#lookup_claimtypecode'))
        .typeText(Selector('#lookup_claimtypecode'), data.GCCarrierClaimType).setTestSpeed(0.6)
        .pressKey('tab')        

        .click(Selector('#multipolicyid').find('.btn.btn-primary').nth(0))
        .click(Selector('#sel12\\ '))
        .click(Selector('#sel12\\ ').find('option').withText(data.PolicySystem))
        .switchToIframe(Selector('#externalapp'))
        .click(Selector('#submitquery').find('i').withText('search'))
        .click(Selector('#docrefresh').find('a').withText(data.PolicyName))
        .click(Selector('#Button1').find('i').withText('keyboard_arrow_right'))
        .click(Selector('#exTab1').find('a').withText('Interest List'))
        .click(Selector('#tab_default_2').find('.ng-pristine.ng-untouched.ng-valid.ng-empty').nth(1))
        .click(Selector('#exTab1').find('a').withText('Unit List'))
        .click(Selector('#tab_default_3').find('div').nth(2).find('div').find('table').find('tbody').find('tr').find('td').find('input'))
        .click(Selector('#tab_default_1').nth(1).find('div').nth(2).find('div').find('table').find('tbody').nth(2).find('tr').find('td').find('input'))
        .click(Selector('#btnselect').find('i').withText('save'))
        .click(Selector('#A1').find('i').withText('file_download'))
        .switchToMainWindow()
        .switchToIframe(Selector('[id^="claimgc"]'))
        .click(Selector('.glyphicon.glyphicon-remove.closeBtn'))
        .click(Selector('#Save').find('i').withText('save'))
        console.log("GC-Carrier Saved".green);
        //Carrier GC Saved

      /*  await t.click(Selector('#Financials\\/Reserves').find('.commonIcomoon.icomoon-safe.icon-safe'))
        .click(Selector('#MakePayment').find('[class^="commonIcomoon material-icons-clr icon-payment icon"]'))
        .click(Selector('#btnRoll').find('i').withText('done'))
        .click(Selector('#cboclaimant'))
        .click(Selector('#cboclaimant').find('option').withText('Jerry'))
		.click(Selector('#bankaccount'))
		.click(Selector('#bankaccount').find('option').withText("Claim Payment"))
        .click(Selector('#cbopayeetype'))
        .click(Selector('#cbopayeetype').find('option').withText('C-Claimant'))
        .click(Selector('[role="button"]').find('span').withText('Transaction Detail'))
        .click(Selector('#cruduiGridAddBtn'))
        .click(Selector('#cmbPolicy'))
        .click(Selector('#cmbPolicy').find('option').withText(data.PolicyName))
        .click(Selector('#cmbUnit'))
        .click(Selector('#cmbUnit').find('option').withText(data.PolicyUnit))
        .click(Selector('#cmbCoverageType'))
        .click(Selector('#cmbCoverageType').find('option').withText(data.PolicyCoverage))
        .click(Selector('#cmbCoverageLossType'))
        .click(Selector('#cmbCoverageLossType').find('option').withText(data.PolicyLossCode))
        .click(Selector('#cmbReserveTypeFt'))
        .click(Selector('#cmbReserveTypeFt').find('option').withText(data.ReserveType))
        .click(Selector('#cmbTransactionType'))
        .click(Selector('#cmbTransactionType').find('option').withText(data.TransactionType))
        .typeText(Selector('#amount').nth(1), '12').setTestSpeed(0.6)
        .click(Selector('#Save').find('i').withText('save'))
        .click(Selector('[role="button"]').find('span').withText('Transaction').nth(1))
        .click(Selector('#Save').find('i').withText('save'))
		console.log("GC-First And Final Payment Saved".green);
        //Payment Saved
		
		await t.switchToMainWindow()
        .click(Selector('#dvbreadcrumbscroll').find('i').withText('reply'))
        .switchToIframe(Selector('[id^="claimgc"]'))
        .click(Selector('#PaymentHistory').find('i').withText('history'))
        .switchToIframe(Selector('#externalapp'))
        const ele4 = Selector('[role="gridcell"]').find('span').with({ visibilityCheck: true })
        await t.expect(ele4.exists).ok('', { timeout: 20000 })
        const ele5 = Selector('[role="gridcell"]').find('span').withText("Payment").with({ visibilityCheck: true })
        await t.expect(ele5.exists).ok('', { timeout: 20000 })
        console.log("GCCarrier-Payment History Verified".green);
        //Payment History Verification*/

        await t.switchToMainWindow()
        .click(Selector('#morebtn').find('i').withText('more_vert'))
        .click(Selector('#menu_othersMenu').find('i').withText('exit_to_app'))
        .click(Selector('#btnRoll').find('i').withText('done'));
        //console.log("LoggedOut!".green);
        //Logout From Application
});});
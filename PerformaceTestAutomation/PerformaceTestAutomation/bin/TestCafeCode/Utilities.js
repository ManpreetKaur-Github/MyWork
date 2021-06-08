import { Selector } from 'testcafe';
import {Crypto} from 'testcafe';
import colors from 'colors';

const crt = require('crypto')
const dataSet = require('./dataIUT.json');

fixture `Utilities`
    .page `https://rma194automation.dxc-rmcl.com/riskmasterux`
    .beforeEach(t => t.resizeWindow(1200, 1100));

dataSet.forEach(data => {
test('Smoke_Utilities', async t => {
    function randomString(size) {  
        return crt
        .randomBytes(size)
        .toString('hex')
        .slice(0, size)
    };
    await t
        await t.maximizeWindow()
        .typeText(Selector('#username'), data.Username)
        .pressKey('tab')
        .typeText(Selector('#login-password'), data.Password)
        .pressKey('enter')
        .click(Selector('[ng-model="dsnSelected"]'))
        .click(Selector('[role="option"]').find('span').withText(data.DSN))
        .click(Selector('[ng-model="zoneSelected"]'))
        .click(Selector('[role="option"]').find('a').withText('Utilities'))
        .click(Selector('#loginbox').find('button').withText('Continue'))
        //Login Into Application
       
        .switchToIframe(Selector('#utilities'))
        .click(Selector('[title="General System Parameter Setup"]').find('span').withText('General System Parameter Setup'))
        .switchToMainWindow()
        .switchToIframe(Selector('[id^="GeneralSystemParameterSetup"]'))
        .click(Selector('#EvPrefix')).pressKey('ctrl+a delete')
        var evt = "E"+randomString(3).toUpperCase();
        await t.typeText(Selector('#EvPrefix'), evt)
        .click(Selector('#Save'))
        .wait(3000)
		console.log("General System Parameter Screen Verified!".green);
        //General System Parameters Setup Verification

        await t.switchToMainWindow()
        .click(Selector('#divworkinprogress').find('span').withText('Utilities').nth(1))
        .switchToIframe(Selector('#utilities'))
        .click(Selector('[title="Line Of Business Parameter Setup"]').find('span').withText('Line Of Business Parameter Setup'))
        .switchToMainWindow()
        .switchToIframe(Selector('[id^="LOBParameters"]'))
        .click(Selector('#lstLOB'))
        .click(Selector('#lstLOB').find('option').withText('GC - General Claims'))
        .wait(3000)
		console.log("LOB Parameter Screen Verified!".green);
        //LOB Parameters Setup Verification

        await t.switchToMainWindow()
        .click(Selector('#divworkinprogress').find('span').withText('Utilities').nth(1))
        .switchToIframe(Selector('#utilities'))
        .click(Selector('[title="Payment Parameter Setup"]').find('span').withText('Payment Parameter Setup'))
        .switchToMainWindow()
        .switchToIframe(Selector('[id^="PaymentParameterSetup"]'))
        .click(Selector("#MaxAutoChecksBatch")).pressKey('ctrl+a delete')
        .typeText(Selector('#MaxAutoChecksBatch'), '10')
        .click(Selector('#Save'))
        .wait(3000)
		console.log("Payment Parameter Screen Verified!".green);
        //Payment Parameters Setup Verification

        await t.switchToMainWindow()
        .click(Selector('#morebtn').find('i').withText('more_vert'))
        .click(Selector('#menu_othersMenu').find('a').withText('exit_to_appLogout'))
        .click(Selector('#btnRoll').find('i').withText('done'));
        //Logout Of Application
});});
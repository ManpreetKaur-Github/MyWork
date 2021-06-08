import { Selector } from 'testcafe';
import {Crypto} from 'testcafe';
import Colors from 'colors'

const crt = require('crypto')
const dataSet = require('./dataIUT.json');

fixture `Smoke_Search`
    .page `https://rma194automation.dxc-rmcl.com/riskmasterux`
    .beforeEach(t => t.resizeWindow(1200, 1100));

dataSet.forEach(data => {
test('SearchClaims', async t => {
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
        await t.click(Selector('#loginbox').find('button').withText('Continue'))
        console.log("LoggedIn!".green)
        //Login Into Application

        await t.click(Selector('#menuBar').find('a').withText('Search'))
        .click(Selector('#menu_SearchRoot').find('a').withText('Claim'))
        .switchToIframe(Selector('[id^="sclaim"]'))
        .click(Selector('[name="LINE_OF_BUS_CODE"]').find('button'))
        .click(Selector('[class="ui-grid-cell-contents ng-scope"]').find('span').withText('Property Claims'))
        .click(Selector('#submitquery').find('i').withText('search'))
        .switchToMainWindow()
        .switchToIframe(Selector('[id^="sclaim_"]'))
        .click(Selector('[class="ui-grid-cell-contents ng-scope"]').find('span'))
        .switchToMainWindow()
        .switchToIframe(Selector('[id^="claimp"]'))        
        const ele1 = Selector('[class="row main_menu right-panel-bg-hover"]').find('i').withText('add').with({ visibilityCheck: true })
        await t.expect(ele1.exists).ok('', { timeout: 20000 })
        console.log("PC Verified!".green);
        //PC Claims Verified 

        await t.switchToMainWindow()
        .click(Selector('#clearAll'))
        .click(Selector('#menuBar').find('a').withText('Search'))
        .click(Selector('#menu_SearchRoot').find('a').withText('Claim'))
        .switchToIframe(Selector('[id^="sclaim"]'))
        .click(Selector('[name="LINE_OF_BUS_CODE"]').find('button'))
        .click(Selector('[class="ui-grid-cell-contents ng-scope"]').find('span').withText('Vehicle Accident Claims'))
        .click(Selector('#submitquery').find('i').withText('search'))
        .switchToMainWindow()
        .switchToIframe(Selector('[id^="sclaim_"]'))
        .click(Selector('[class="ui-grid-cell-contents ng-scope"]').find('span'))
        .switchToMainWindow()
        .switchToIframe(Selector('[id^="claimva"]'))
        await t.expect(ele1.exists).ok('', { timeout: 20000 })
        console.log("VA Verified!".green);
        //VA Claims Verified

        await t.switchToMainWindow()
        .click(Selector('#morebtn').find('i').withText('more_vert'))
        .click(Selector('#menu_othersMenu').find('a').withText('exit_to_appLogout'))
        .click(Selector('#btnRoll').find('i').withText('done'));
        console.log("LoggedOut!!".green)
        //Logout From Application
});});
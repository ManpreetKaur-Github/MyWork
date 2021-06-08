import { Selector,Crypto } from 'testcafe';
import Colors from 'colors';
var faker = require('faker');

const crt = require('crypto')
const dataSet = require('./dataIUT.json');
var DriverName = "DvName_"+faker.random.alphaNumeric(5).toUpperCase();

fixture `Smoke_Event`
    .page `https://rma194automation.dxc-rmcl.com/riskmasterux`
    .beforeEach(t => t.resizeWindow(1200, 1100));

dataSet.forEach(data => {
test('EventCreationWithPI', async t => {
        await t.maximizeWindow()
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
        .click(Selector('#menu_DocumentRoot').find('a').withText('Event'))
        .switchToIframe(Selector('[id^="event"]'))
        .click(Selector('#btn_eventtypecode_openlookup').find('.glyphicon.glyphicon-option-horizontal'))
        const ele1 = Selector('[class="ui-grid-cell-contents ng-scope"]').find('span').withText(data.EventType).with({ visibilityCheck: true })
        await t.expect(ele1.exists).ok('', { timeout: 20000 })
        .click(ele1)
        var date = new Date();
        var d = (date.getMonth()+1)+'/'+(date.getDate()-1)+'/'+date.getFullYear();
        await t.typeText(Selector('#dateofevent').nth(1), d).setTestSpeed(0.6)
        .click(Selector('#btn_timeofevent').find('.glyphicon.glyphicon-time'))
        .pressKey('tab')
        .click(Selector('#btn_eventstatuscode_openlookup').find('.glyphicon.glyphicon-option-horizontal'))
        const ele2 = Selector('[class="ui-grid-cell-contents ng-scope"]').find('span').withText(data.ClaimStatus).with({ visibilityCheck: true })
        await t.expect(ele2.exists).ok('', { timeout: 20000 })
        .click(ele2)        
        .typeText(Selector('#lookup_depteid'), data.Department).setTestSpeed(0.6)
        .pressKey('tab')
        .typeText(Selector('#datereported').nth(1), d).setTestSpeed(0.6)
        .click(Selector('#btn_timereported')).pressKey('tab')
        .click(Selector('#Save').find('i').withText('save'))
        .wait(5000);
        console.log("Event Created Successfully!".green);  
        //Event Saved

   await t
        .click(Selector('#associated-pi').find('i').withText('add'))
        .click(Selector('#frmList').find('i').withText('add').nth(1))
        .click(Selector('#drivertyped'))
        .click(Selector('#drivertyped').find('option').withText(data.DriverType))
        //var DriverName = "DriverName_"+randomString(5).toUpperCase()
        await t.typeText(Selector('#lookup_lastname'), DriverName).setTestSpeed(0.6)
        .click(Selector('#Save').find('i').withText('save'))
        .wait(1000)
        .click(Selector('#lookup_lastname')).pressKey('ctrl+a delete')
        .typeText(Selector('#lookup_lastname'), "Edited"+DriverName).setTestSpeed(0.6)
        .click(Selector('#Save').find('i').withText('save'))
        .wait(1000)
        .switchToMainWindow()
        .click(Selector('#dvbreadcrumbscroll').find('i').withText('reply'))
        .switchToIframe(Selector('[id^="event"]'))
        .click(Selector('#associated-pi').find('span').nth(1))
        .click(Selector('#Delete\\ Record').find('i').withText('delete'))
        .click(Selector('#btnRoll').find('i').withText('done'))
        .wait(2000);
        console.log("PI Created,Edited,Deleted Successfully!".green);  
        //PI On Event Created
    await t
        .switchToMainWindow()
        .click(Selector('#menuBar').find('a').withText('My Work'))
        .click(Selector('#menu_MyWorkRoot').find('a').withText('Recent Events'))
        .switchToIframe(Selector('#recentevents'))
        const ele3 = Selector('[class="rowPointer"]').find('td').with({ visibilityCheck: true })
        await t.expect(ele3.exists).ok('', { timeout: 20000 });
        console.log("Recent Events Screen Verified!".green);  
        //Recent Events Screen Verified
    await t
        .switchToMainWindow()
        .click(Selector('#morebtn').find('i').withText('more_vert'))
        .click(Selector('#menu_othersMenu').find('a').withText('exit_to_appLogout'))
        .click(Selector('#btnRoll').find('i').withText('done'));
        //console.log("Logged out!".green);  
        //Logout From Application
});});
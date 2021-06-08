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
test('GCCreationWithOtherEntities', async t => {
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
        .click(Selector('#Enhanced\\ Notes').find('i').withText('library_books'))
        .switchToIframe(Selector('#externalapp'))
        .click(Selector('#btnCreateNote').find('i').withText('assignment'))
        //var CreateNote = "CreateNote_"+randomString(5).toUpperCase()
        await t.typeText(Selector('#editor').find('.fr-element.fr-view'), CreateNote).setTestSpeed(0.6)
        .click(Selector('#btn_noteslookup_openlookup'))
        .click(Selector('[class="ui-grid-cell-contents ng-scope"]').find('span').withText(data.EnhNotesType))
        .click(Selector('#btnSave').find('i').withText('save'))
        .click(Selector('#btnBackToNotes').find('i').withText('arrow_back'))
        console.log("Enhanced Notes Created!".green); 
        //Enhanced Notes Created
    
    await t
        .typeText(Selector('[class="ui-grid-header-cell-label ng-binding"]').withText('Note Text').parent('[role="columnheader"]').find('input'),CreateNote).setTestSpeed(0.6)
        .click(Selector('[class="ui-grid-cell-contents"]').nth(1).find('[class^="ui-grid-selection-row-header-buttons ui-grid-icon-"]'))
        .click(Selector('#btnEditNote').find('i').withText('edit'))
        .pressKey('ctrl+a delete')
        .typeText(Selector('#editor').find('.fr-element.fr-view'), "Edited"+CreateNote).setTestSpeed(0.6)
        .pressKey('tab')
        .click(Selector('#btnSave').find('i').withText('save'))
        .click(Selector('#btnBackToNotes').find('i').withText('arrow_back'))
        //Enhnaced Notes Edited

        .typeText(Selector('[class="ui-grid-header-cell-label ng-binding"]').withText('Note Text').parent('[role="columnheader"]').find('input'),"Edited"+CreateNote).setTestSpeed(0.6)
        .click(Selector('[class="ui-grid-cell-contents"]').nth(1).find('[class^="ui-grid-selection-row-header-buttons ui-grid-icon-"]'))
        .click(Selector('#btnDeleteNotes').find('i').withText('delete'))
        .click(Selector('#btnRoll').find('i').withText('done'))
        .switchToMainWindow()
        .switchToIframe(Selector('[id^="claim"'))
        .click(Selector('#P1').nth(1))
        //Enhanced Notes Deleted and Screen Closed

        .switchToMainWindow()
        .click(Selector('#morebtn').find('i').withText('more_vert'))
        .click(Selector('#menu_othersMenu').find('a').withText('exit_to_appLogout'))
        .click(Selector('#btnRoll').find('i').withText('done'));
        //console.log("Logged out!".green);  
        //Logout From Application
});});
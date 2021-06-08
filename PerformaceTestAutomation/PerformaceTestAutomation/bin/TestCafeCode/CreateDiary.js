import { Selector } from 'testcafe';
import { Crypto } from 'testcafe';
import { colors } from 'colors';
import { ClientFunction } from 'testcafe';
var faker = require('faker');
function randomString(size) {  
        return crt
        .randomBytes(size)
        .toString('hex')
        .slice(0, size)
    };

function numberGen(len) {       //Function to Generate random number; length of number = value specified in 'len'
	 //  var genNum= Math.floor(Math.pow(10, len)*Math.random()).toString()
	  var text = "";
		var charset = "0123456789";
		for( var i=0; i < len; i++ ) {
		text += charset.charAt(Math.floor(Math.random() * charset.length));}
		return text;
};

const dataSet = require('./dataIUT.json');
const crt   = require('crypto')

var TaskName = "Task"+faker.random.alphaNumeric(4).toUpperCase();

fixture `CreateDiary`
    .page `https://rma194automation.dxc-rmcl.com/riskmasterux`
    .beforeEach(t => t.resizeWindow(1200, 1100));
dataSet.forEach(data => {    
test('CreateDiary', async t => {
    //==================Login Code With JASON Starts================================       
        await t
        .maximizeWindow()
        //.wait(20000)
        .typeText(Selector('#username'), data.Username)
        .pressKey('tab')
        .typeText(Selector('#login-password'), data.Password)
        .pressKey('enter')
        .click(Selector('[ng-model="dsnSelected"]'))
        .click(Selector('[role="option"]').find('span').withText(data.DSN))
        .click(Selector('[ng-model="zoneSelected"]'))
        .click(Selector('[role="option"]').find('a').withText('Claims'))
        .click(Selector('#loginbox').find('button').withText('Continue'))
        //.wait(30000)
    //==================Login Code With JSON Ends================================

    //==================Diary Creation Starts================================
        .click(Selector('#menuBar').find('.caret').nth(1))
        .click(Selector('#menu_DiariesRoot').find('a').withText('Diary List'))
        .switchToIframe(Selector('#diarylist'))
		.wait(10000)
        .click(Selector('#btnCreate').find('i').withText('note_add'))
        .wait(20000)
        //var TaskName = "Smoke_Task_"+randomString(4).toUpperCase()
        await t.click(Selector('#entryName')).typeText(Selector('#entryName'), TaskName).setTestSpeed(0.6)
        .click(Selector('#Save').find('i').withText('save'))
		console.log("Diary is created with Task Name: "+TaskName.green);
   //============================Diary Creation Ends========================================

   //============================Diary Completion Starts=======================================
        await t.typeText(Selector('#taskName'), TaskName).setTestSpeed(0.6)
        .click(Selector('[class="glyphicon glyphicon-search searchFilterIcon "]').nth(1))

        .click(Selector('[class^="ui-grid-selection-row-header-buttons ui-grid-icon-"]').nth(1))
        .click(Selector('#btnComplete').find('i').withText('done_all'))
        .click(Selector('#txtCompleteRes'))
        .typeText(Selector('#txtCompleteRes'), 'Diary Completed').setTestSpeed(0.6)
        .click(Selector('#btnDone').find('i').withText('done_all'))
        .wait(3000)
    //=========================Diary Completion Ends=========================================

    //==================Verify Completed Diary is not in the Grid Starts=====================
        // Lines to make sure recently created diary exist or not ? --- Currently not working so commented
        .click(Selector('#taskName'))
        .typeText(Selector('#taskName'), TaskName).setTestSpeed(0.6)
        .click(Selector('[class="glyphicon glyphicon-search searchFilterIcon "]').nth(1))

        const e1e2 = Selector('[class^="ngCellText ui-grid-cell-contents ui-grid-cell"]').find('b').withText(TaskName)
        await t.expect(e1e2.exists).notOk('', { timeout: 20000 })
        console.log("Diary: "+TaskName.green+" Not found in the List".red);
    //==================Verify Completed Diary is not in the Grid Ends=====================

    //===========================Logout Code Starts==========================================
        await t.switchToMainWindow() 
        .click(Selector('#morebtn').find('i').withText('more_vert'))
        .click(Selector('#menu_othersMenu').find('a').withText('exit_to_appLogout'))
        .click(Selector('#btnRoll').find('i').withText('done'));
    //=============================Logout Code Ends========================================== 
});});

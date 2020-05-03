/**************************************************************
Class Name: SiteLoginController 
Author:Peter Carlsson          Last modified by:G Janardhanreddy
Date:25/03/2014                Date:19/3/2015

********©2013 Musqot marketing technology Pvt ltd **************/
/**
* An apex page controller that exposes the site login functionality
*/
global with sharing class SiteLoginController {
    global String username {get; set;}
    global String password {get; set;}
    global PageReference login() {
    
     return Site.login('', '', '');
    }
  global SiteLoginController () {}
}
/**
 * Async Loader (philipp gressly freimann, April 2013)
 * Source:   http://friendlybit.com/js/lazy-loading-asyncronous-javascript/
 *
 * Loads scripts using "myAttachScript" before the first script in your document.
 * The scripts will be started, when the body is loaded (onload, load).
 *
 * Call this in your <head> using the following script:
 *    <script type  = "text/javascript"
 *             src  = "js/async_loader.js" ></script>
 */

function createTagNS(type) {
  var tag;
  var ns = "http://www.w3.org/1999/xhtml";
  if(document.createElementNS) { // firefox knows ElementNS
    tag = document.createElementNS(ns, type);
  } else {
    tag = document.createElement  (type)    ;
  }
  return tag; 
} 


function createScriptElement(name) {
  var scriptTag;
  scriptTag       = createTagNS("script");
  scriptTag.async = true;
  scriptTag.setAttribute("type", "text\/javascript");
  scriptTag.setAttribute("src" , name);
  return scriptTag;
}

/**
 * A nameless function, which is loaded at the beginning. 
 * This script loads oder scripts.
 */
(function() {

  function async_loader(scriptName) {
    var newScript     = createScriptElement(scriptName)           ;
    var firstScript   = document.getElementsByTagName('script')[0];
    firstScript.parentNode.insertBefore(newScript, firstScript)   ;
  }

  function myAttachScript(scriptName) {
    // Browser Compatibility:
    if (window.attachEvent) {
      window.attachEvent('onload', async_loader(scriptName));
    } else {
      window.addEventListener('load', async_loader(scriptName), false);
    }
  }

  myAttachScript("js/dom/domHelper.js");
  myAttachScript("js/registerHandlers.js");
  myAttachScript("js/testsuite.js");

})();

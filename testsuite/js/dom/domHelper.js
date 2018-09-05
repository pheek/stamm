/**
 * @author  : Philipp Gressly Freimann (phi@gress.ly)
 * @version : 2013 April 24
 * @version : 2016 10 31
 *
 * Helper functions to manipulate the DOM.
 * (Reading out input fields (such as numbers) and writing directly into paragraphs.)
 */


//////////////////////////////////////////////////////////////////////////////////////
// A) READ

/**
 * This function tries to read a number from a given input field.
 * If this field does not have a number in it (or if the field does not exist),
 * the value zero (0) is returned.
 */
function readNumberFromFieldViaId(id) {
  var str = readStringFromFieldViaId(id);
  if(null != str && str.length > 0 && isFinite(str)) {
    return +str;
  } else {
    return 0.0;
  }
}

/**
 * Read anything out of an input field. Return "null", if the given id does not exist.
 */
function readStringFromFieldViaId(id) {
  var feld;
  feld = document.getElementById(id);
  if(feld) {
      return feld.value;
  } else {
      return null;
  }
}

////////////////////////////////////////////////////////////////////////////////////
// B) Writing aids

/**
 * Set the (first) Text child [in the tag <tag id="tagID">]
 * to the given text.
 */
function setFirstTextChild(tagID, text) { 
  var oldTag   = document.getElementById(tagID);
  var txtnode  = document.createTextNode(text);
  if(oldTag.firstChild) {
    oldTag.replaceChild(txtnode, oldTag.firstChild);
   } 
  else {
    oldTag.appendChild(txtnode);
   }
}


/**
 * Append tag into existing tag.
 * The new tag is created and filled with the given text (netTaxTextContent).
 * The new tag is added as last element in the existing tag.
 */
function addNewTagToExistingTag(existingTagID, newTagID, newTagType, newTagTextContent) {
  var oldTag = document.getElementById(existingTagID);
  var newTag = makeTextTag(newTagType, newTagID, newTagTextContent);
  oldTag.parentNode.appendChild(newTag);
}

/**
 * Append a new Paragraph at the end of the Document.
 * This new paragraph will contain the given text.
 */
function outputIntoNewParagraph(text) {
  var body = document.getElementsByTagName("body")[0];
  var newPara = makeTextTag("p", "", text);
  body.appendChild(newPara);
}

/**
 * If a paragraph has id "paraID", the text is replaced.
 * Otherwise, a new Paragraph is created having the given text and paraID.
 * This new paragraph will be added at the end of the document (body).
 */
function outputIntoNewOrExistingParagraph(text, paraID) {
  var oldPara = document.getElementById(paraID);
  if(! oldPara) {
    var body = document.getElementsByTagName("body")[0];
    var newPara = makeTextTag("p", paraID, text);
    body.appendChild(newPara);
  } else {
    removeAllChildren(oldPara);
    var txtNode = document.createTextNode(text);
    oldPara.appendChild(txtNode);
  }
}


/**
 * Helper function to generate a new tag containing given text.
 */
function makeTextTag(type, tagID, text) {
  var newTag;
  newTag = createTagNS(type);
  var txtnode  = document.createTextNode(text);
  if(tagID && tagID.length > 0) {
    newTag.setAttribute("id", tagID);
  }
  newTag.appendChild(txtnode); 
  return newTag; 
}

/////////////////////////////////////////////////////////////////////////////
// C general helper functions

/**
 * removes all children from a given node
 */
function removeAllChildren(ele) {
  while(ele.hasChildNodes()) {
    ele.removeChild(ele.lastChild);
  }
}


/**
 * Replace a Tag <tag id="tagID"> with a new <tag>
 * containing a given value (text).
 * The new Tag will have the same type (nodeName) as the given tag.
 * (if the element is not empty, this is aequivalent to 
 *  document.getElementById(tagID).innerHTML = text).
 */
function replaceTag(tagID, text) {
  var oldTag     = document.getElementById(tagID);
  var tagType    = oldTag.nodeName;
  var parentNode = oldTag.parentNode;
  var newTag     = makeTextTag(tagType, tagID, text);
  parentNode.replaceChild(newTag, oldTag); 
}



// ECMAScript6 missing function "endsWith()"
// this selection (if) is copied from here:
// https://developer.mozilla.org/de/docs/Web/JavaScript/Reference/Global_Objects/String/endsWith

if (!String.prototype.endsWith) {
	String.prototype.endsWith = function(searchString, position) {
		var subjectString = this.toString();
		if ('number' !== typeof position      ||
		    !isFinite(position)               ||
				Math.floor(position) !== position ||
				position > subjectString.length)
		{
			position = subjectString.length;
		}
		position -= searchString.length;
		var lastIndex = subjectString.indexOf(searchString, position);
		return -1 !== lastIndex  && lastIndex === position;
	};
}

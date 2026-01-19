// Declare variables for getting the xml file for the XSL transformation (folio_xml) and to load the image in IIIF on the page in question (number).
let tei = document.getElementById("folio");
let tei_xml = tei.innerHTML;
let extension = ".xml";
let folio_xml = tei_xml.concat(extension);
let page = document.getElementById("page");
let pageN = page.innerHTML;
let number = Number(pageN);

// Loading the IIIF manifest
var mirador = Mirador.viewer({
  "id": "my-mirador",
  "manifests": {
    "https://iiif.bodleian.ox.ac.uk/iiif/manifest/53fd0f29-d482-46e1-aa9d-37829b49987d.json": {
      provider: "Bodleian Library, University of Oxford"
    }
  },
  "window": {
    allowClose: false,
    allowWindowSideBar: true,
    allowTopMenuButton: false,
    allowMaximize: false,
    hideWindowTitle: true,
    panels: {
      info: false,
      attribution: false,
      canvas: true,
      annotations: false,
      search: false,
      layers: false,
    }
  },
  "workspaceControlPanel": {
    enabled: false,
  },
  "windows": [
    {
      loadedManifest: "https://iiif.bodleian.ox.ac.uk/iiif/manifest/53fd0f29-d482-46e1-aa9d-37829b49987d.json",
      canvasIndex: number,
      thumbnailNavigationPosition: 'off'
    }
  ]
});


// function to transform the text encoded in TEI with the xsl stylesheet "Frankenstein_text.xsl", this will apply the templates and output the text in the html <div id="text">
function documentLoader() {

  Promise.all([
    fetch(folio_xml).then(response => response.text()),
    fetch("Frankenstein_text.xsl").then(response => response.text())
  ])
    .then(function ([xmlString, xslString]) {
      var parser = new DOMParser();
      var xml_doc = parser.parseFromString(xmlString, "text/xml");
      var xsl_doc = parser.parseFromString(xslString, "text/xml");

      var xsltProcessor = new XSLTProcessor();
      xsltProcessor.importStylesheet(xsl_doc);
      var resultDocument = xsltProcessor.transformToFragment(xml_doc, document);

      var criticalElement = document.getElementById("text");
      criticalElement.innerHTML = ''; // Clear existing content
      criticalElement.appendChild(resultDocument);
    })
    .catch(function (error) {
      console.error("Error loading documents:", error);
    });
}

// function to transform the metadate encoded in teiHeader with the xsl stylesheet "Frankenstein_meta.xsl", this will apply the templates and output the text in the html <div id="stats">
function statsLoader() {

  Promise.all([
    fetch(folio_xml).then(response => response.text()),
    fetch("Frankenstein_meta.xsl").then(response => response.text())
  ])
    .then(function ([xmlString, xslString]) {
      var parser = new DOMParser();
      var xml_doc = parser.parseFromString(xmlString, "text/xml");
      var xsl_doc = parser.parseFromString(xslString, "text/xml");

      var xsltProcessor = new XSLTProcessor();
      xsltProcessor.importStylesheet(xsl_doc);
      var resultDocument = xsltProcessor.transformToFragment(xml_doc, document);

      var criticalElement = document.getElementById("stats");
      criticalElement.innerHTML = ''; // clear existing content
      criticalElement.appendChild(resultDocument);
      NavigationButtons(); // essential for prev/next buttons

    })
    .catch(function (error) {
      console.error("Error loading documents:", error);
    });
}

// Initial document load
documentLoader();
statsLoader();
function selectHand(event) {
  var visible_mary = document.getElementsByClassName(' #MWS');
  var visible_percy = document.getElementsByClassName(' #PBS');
  // Convert the HTMLCollection to an array for forEach compatibility
  var MaryArray = Array.from(visible_mary);
  var PercyArray = Array.from(visible_percy);
  if (event.target.value == 'both') {
    //write an forEach() method that shows all the text written and modified by both hand (in black?). The forEach() method of Array instances executes a provided function once for each array element.
    // STARTING HERE!
    MaryArray.forEach((item) => {
      item.classList.remove("MaryStyle", "PercyStyle", "DimStyle");
    });

    PercyArray.forEach((item) => {
      item.classList.remove("MaryStyle", "PercyStyle", "DimStyle");
    });
  } else if (event.target.value == 'Mary') {
    //write an forEach() method that shows all the text written and modified by Mary in a different color (or highlight it) and the text by Percy in black. 
    MaryArray.forEach((item) => {
      item.classList.add("MaryStyle");
      item.classList.remove("PercyStyle", "DimStyle");
    });

    PercyArray.forEach((item) => {
      item.classList.add("DimStyle");
      item.classList.remove("MaryStyle", "PercyStyle");
    });

  } else {
    //write an forEach() method that shows all the text written and modified by Percy in a different color (or highlight it) and the text by Mary in black.
    PercyArray.forEach((item) => {
      item.classList.add("PercyStyle");
      item.classList.remove("MaryStyle", "DimStyle");
    });

    MaryArray.forEach((item) => {
      item.classList.add("DimStyle");
      item.classList.remove("MaryStyle", "PercyStyle");
    });
  }
  console.log('Percy elements:', document.getElementsByClassName('#PBS').length);
  console.log('Mary elements:', document.getElementsByClassName('#MWS').length);
}

// write another function that will toggle the display of the deletions by clicking on a button
function toggleDeletions() {
  const deletions = document.querySelectorAll('del');

  deletions.forEach((del) => {
    del.classList.toggle('HideText');
  });
}

function toggleNotes() {
  const notes = document.querySelectorAll('.note-marker, .note-popup');

  notes.forEach((note) => {
    note.classList.toggle('HideText');
  });
}

// EXTRA: write a function that will display the text as a reading text by clicking on a button or another dropdown list, meaning that all the deletions are removed and that the additions are shown inline (not in superscript)
function toggleReadingText() {
  document.body.classList.toggle('reading-text');
}

function hideMetaMark() {
  document
    .querySelectorAll('.infraAdd.MetaMark')
    .forEach(el => el.classList.toggle('hidden'));
}

function hideNotes() {
  document.querySelectorAll('.note-marker, .note-popup')
    .forEach(el => el.classList.add('HideText'));
}


// PAGE NABIGATION
function NavigationButtons() {
  const folio = document.getElementById("folio").textContent.trim();

  const num = parseInt(folio);
  const side = folio.slice(-1);    // "r" or "v"

  // PREVIOUS
  if (folio === "21r") {
    document.getElementById("prevLink").style.display = "none";
  } else {
    let prev;
    if (side === "v") {
      prev = num + "r";
    } else {
      prev = (num - 1) + "v";
    }
    document.getElementById("prevLink").href = prev + '.html';
  }

  // NEXT
  if (folio === "25v") {
    document.getElementById("nextLink").style.display = "none";
  } else {
    let next;
    if (side === "r") {
      next = num + "v";
    } else {
      next = (num + 1) + "r";
    }
    document.getElementById("nextLink").href = next + '.html';
  }
}


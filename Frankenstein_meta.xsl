<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei"
    version="2.0">

<xsl:template match="tei:TEI">
  <div class="page">
<!-- STARTING HERE -->
  <!-- TOP BAR -->
  <div class="topbar">
      <div class="nav-buttons">
        <a id="prevLink" class="nav-btn prev" href="#">← Previous</a>
        <a id="nextLink" class="nav-btn next" href="#">Next →</a>
      </div>
  </div>

  <!-- INFO AREA  -->
  <div class="info-grid">

    <section class="panel">
      <h4>About the manuscript page</h4>
      <div class="panel-body">
        <xsl:value-of select="//tei:sourceDesc"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="//tei:licence"/>
      </div>
    </section>

  <section class="panel">
  <h4>Page stats and controls</h4>

  <div class="stats-controls">

    <ul class="statsList">
      <li>Total words with deletions included:
        <b>
          <xsl:variable name="pageText">
            <xsl:for-each select=".//text()[not(ancestor::tei:metamark)]">
              <xsl:value-of select="normalize-space(.)"/>
              <xsl:text> </xsl:text>
            </xsl:for-each>
          </xsl:variable>

          <xsl:choose>
            <xsl:when test="string-length(normalize-space($pageText)) = 0">0</xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="
                string-length(normalize-space($pageText))
                - string-length(translate(normalize-space($pageText), ' ', '')) + 1"/>
            </xsl:otherwise>
          </xsl:choose>
        </b>
      </li>

      <li>Total words without deletions:
        <b>
          <xsl:variable name="pageText2">
            <xsl:for-each select=".//text()[not(ancestor::tei:del) and not(ancestor::tei:metamark)]">
              <xsl:value-of select="normalize-space(.)"/>
              <xsl:text> </xsl:text>
            </xsl:for-each>
          </xsl:variable>

          <xsl:value-of select="
            string-length(normalize-space($pageText2))
            - string-length(translate(normalize-space($pageText2), ' ', '')) + 1"/>
        </b>
      </li>
    </ul>

    <div class="text-buttons">
      <button class="control-button"
        onclick="toggleReadingText();hideMetaMark();hideNotes()"
        title="Toggle to put all the super- and infrascript in line with regular text. Hide note markers.">
        Reading text
      </button>

      <button class="control-button"
        onclick="toggleDeletions()"
        title="Show or hide all deleted text.">
        Show / hide deletions
      </button>

      <button class="control-button"
        onclick="toggleNotes()"
        title="Show or hide notes and note markers.">
        Show / hide notes
      </button>
    </div>

  </div>
  </section>


    <section class="panel">
      <h4>All edits made on this page</h4>
      <table class="statsTable">
        <thead>
          <tr>
            <th class="nameCol">Hand</th>
            <th>Deletions</th>
            <th>Additions</th>
            <th>Total</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td class="nameCol">Mary</td>
            <td><xsl:value-of select="count(//tei:del[@hand = '#MWS'])"/></td>
            <td><xsl:value-of select="count(//tei:add[@hand = '#MWS'])"/></td>
            <td><xsl:value-of select="count(//tei:del[@hand= '#MWS'] | //tei:add[@hand= '#MWS'])"/></td>
          </tr>
          <tr>
            <td class="nameCol">Percy</td>
            <td><xsl:value-of select="count(//tei:del[@hand = '#PBS'])"/></td>
            <td><xsl:value-of select="count(//tei:add[@hand = '#PBS'])"/></td>
            <td><xsl:value-of select="count(//tei:del[@hand= '#PBS'] | //tei:add[@hand= '#PBS'])"/></td>
          </tr>
          <tr>
            <td class="nameCol">Both</td>
            <td><xsl:value-of select="count(//tei:del[@hand = '#PBS' or @hand = '#MWS'])"/></td>
            <td><xsl:value-of select="count(//tei:add[@hand = '#PBS' or @hand = '#MWS'])"/></td>
            <td><xsl:value-of select="count(//tei:del[@hand = '#PBS' or @hand = '#MWS'] | //tei:add[@hand = '#PBS' or @hand = '#MWS'])"/></td>
          </tr>
        </tbody>
      </table>
    </section>

  </div>


  </div>
</xsl:template>


</xsl:stylesheet>

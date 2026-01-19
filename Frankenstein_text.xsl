<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei"
    version="2.0">

    
    <!-- <xsl:output method="xml" omit-xml-declaration="yes" indent="yes" /> -->
    <xsl:template match="tei:teiHeader"/>

    <xsl:template match="tei:body">
        <div class="row">
        <div class="col-3"><br/><br/><br/><br/><br/>
            <xsl:for-each select="//tei:add[@place = 'marginleft']">
                <div class="marginLeft">
                    <xsl:choose>
                        <xsl:when test="parent::tei:del">
                            <del>
                                <xsl:attribute name="class">
                                    <xsl:value-of select="attribute::hand" />
                                </xsl:attribute>
                                <xsl:apply-templates/></del><br/>
                        </xsl:when>
                        <xsl:otherwise>
                            <span>
                                <xsl:attribute name="class">
                                    <xsl:value-of select="attribute::hand" />
                                </xsl:attribute>
                            <xsl:apply-templates/><br/>
                            </span>
                        </xsl:otherwise>
                    </xsl:choose>
                </div>
            </xsl:for-each> 
        </div>
        <div class="col-9">
            <div class="transcription">
                <xsl:apply-templates select="//tei:div"/>
            </div>
        </div>
        </div> 
    </xsl:template>
    
    <xsl:template match="tei:div">
        <div class="#MWS"><xsl:apply-templates/></div>
    </xsl:template>

    
    <xsl:template match="tei:p">
        <p><xsl:apply-templates/></p>
    </xsl:template>

  <!-- processes the marginal additions again to give them a class to hide them in the 'main' text in css. By hiding them using css, they can also be made visible again when showing a reading text, for example-->
    <xsl:template match="tei:add[@place = 'marginleft']">
        <span class="marginAdd">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
  
    <!-- <xsl:template match="tei:del">
        <del>
            <xsl:attribute name="class">
                <xsl:value-of select="@hand"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </del>
    </xsl:template>
     -->

    

<xsl:template match="tei:add[@place = 'supralinear' or @place = 'margintop' or @place = 'above']">
  <span>
    <xsl:attribute name="class">
      <xsl:text>supraAdd</xsl:text>
      <xsl:if test="@hand">
        <xsl:text> </xsl:text>
        <xsl:value-of select="@hand"/>
      </xsl:if>
    </xsl:attribute>
    <xsl:apply-templates/>
  </span>
</xsl:template>

    

<!-- add additional templates below, for example to transform the tei:lb in <br/> empty elements, tei:hi[@rend = 'sup'] in <sup> elements, the underlined text, additions with the attribute "overwritten" etc. -->

<xsl:template match="tei:add[@place='infralinear']">
  <span>
    <xsl:attribute name="class">
      <xsl:text>infraAdd</xsl:text>
      <xsl:if test="@type='MetaMark'">
        <xsl:text> MetaMark</xsl:text>
      </xsl:if>
      <xsl:if test="@hand">
        <xsl:text> </xsl:text>
        <xsl:value-of select="@hand"/>
      </xsl:if>
    </xsl:attribute>
    <xsl:apply-templates/>
  </span>
</xsl:template>


<xsl:template match="tei:*[@rend='indent']">
  <span class="rend-indent">
    <xsl:apply-templates/>
  </span>
</xsl:template>

<!-- new delete tag -->
  <xsl:template match="tei:del">
    <del>
      <xsl:attribute name="class">

        <!-- type classes -->
        <xsl:if test="@type">
          <xsl:value-of select="normalize-space(@type)"/>
          <xsl:text> </xsl:text>
        </xsl:if>

        <!-- rend class -->
        <xsl:if test="@rend">
          <xsl:value-of select="normalize-space(@rend)"/>
          <xsl:text> </xsl:text>
        </xsl:if>

        <!-- hand class-->
        <xsl:if test="@hand">
          <xsl:text>hand </xsl:text>
          <xsl:value-of select="@hand"/>
        </xsl:if>

      </xsl:attribute>

      <xsl:apply-templates/>
    </del>


  </xsl:template>
<!-- LINE BREAKS -->
<xsl:template match="tei:lb">
  <br class="lb"/>
</xsl:template>

<!-- HI: SUPERSCRIPT -->
<xsl:template match="tei:hi[@rend='sup']">
  <sup class="hiSup">
    <xsl:apply-templates/>
  </sup>
</xsl:template>

<!-- HI: UNDERLINE -->
<xsl:template match="tei:hi[@rend='u']">
  <span class="Underlined">
    <xsl:apply-templates/>
  </span>
</xsl:template>

<!-- HI: CIRCLED (page number) -->
<xsl:template match="tei:hi[@rend='circled']">
  <span class="hiCircled">
    <xsl:apply-templates/>
  </span>
</xsl:template>

<!-- ADD: OVERWRITTEN TEXT -->
<xsl:template match="tei:add[@place='overwritten']">
  <span>
    <xsl:attribute name="class">
      <xsl:text>overwrittenAdd </xsl:text>
      <xsl:value-of select="@hand"/>
    </xsl:attribute>
    <xsl:apply-templates/>
  </span>
</xsl:template>

<!-- NOTES -->
<xsl:template match="tei:note">
<span class="note-wrap">
<!--  note marker so readers can see there is a note  -->
<span class="note-marker" tabindex="0" aria-label="Note">†</span>
<span class="note-popup">
<xsl:value-of select="normalize-space(.)"/>
</span>
</span>
</xsl:template>


<!-- LIST -->
<xsl:template match="tei:list">
  <ul class="tei:list">
    <xsl:apply-templates/>
  </ul>
</xsl:template>

<xsl:template match="tei:item">
  <li class="tei:item">
    <xsl:apply-templates/>
  </li> 
</xsl:template>

<!-- RENDER -->
<xsl:template match="tei:hi[@rend='right']">
  <span class="hiRight">
    <xsl:apply-templates/>
  </span>
</xsl:template>

<xsl:template match="tei:hi[@rend='indent']">
  <span class="hiIndent">
    <xsl:apply-templates/>
  </span>
</xsl:template>

<!-- CHOICE -->
<xsl:template match="tei:choice">
  <span class="choice">
    <span class="corr">
      <xsl:apply-templates select="tei:corr"/>
    </span>
    <span class="sic">
      <xsl:apply-templates select="tei:sic"/>
    </span>
  </span>
</xsl:template>

<!-- default: suppress sic content itself -->
<xsl:template match="tei:sic//text()"/>



</xsl:stylesheet>
<!-- don't add anything underneath here you imbecile -->
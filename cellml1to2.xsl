<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:cellml10="http://www.cellml.org/cellml/1.0#"
	xmlns:cellml11="http://www.cellml.org/cellml/1.1#" 
	xmlns:cmeta="http://www.cellml.org/metadata/1.0#"
	xmlns:cellml2="http://www.cellml.org/cellml/2.0#">

	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	
	<xsl:template match="/cellml10:model | /cellml11:model">
		<xsl:element name="model" namespace="http://www.cellml.org/cellml/2.0#">
			<xsl:apply-templates select="@name | @cmeta:id" />
			<xsl:apply-templates select="*" />
		</xsl:element>
	</xsl:template>

	<xsl:template match="cellml10:component | cellml11:component">
		<xsl:element name="component" namespace="http://www.cellml.org/cellml/2.0#">
			<xsl:apply-templates select="@name | @cmeta:id" />
			<xsl:apply-templates select="*" />
		</xsl:element>
	</xsl:template>

	<xsl:template match="cellml10:variable | cellml11:variable">
		<xsl:element name="variable" namespace="http://www.cellml.org/cellml/2.0#">
			<xsl:apply-templates select="@name | @cmeta:id" />
			<xsl:choose>
				<xsl:when test="@private_interface and @public_interface">
					<xsl:choose>
						<xsl:when test="@private_interface='none' and @public_interface='none'">
							<xsl:attribute name="interface">none</xsl:attribute>
						</xsl:when>
						<xsl:when test="@private_interface='none'">
							<xsl:attribute name="interface">public</xsl:attribute>
						</xsl:when>
						<xsl:when test="@public_interface='none'">
							<xsl:attribute name="interface">private</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="interface">public_and_private</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="@private_interface">
					<xsl:choose>
						<xsl:when test="@private_interface='none'">
							<xsl:attribute name="interface">none</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="interface">private</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="@public_interface">
					<xsl:choose>
						<xsl:when test="@public_interface='none'">
							<xsl:attribute name="interface">none</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="interface">public</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="cellml10:group | cellml11:group">
		<xsl:if test="./cellml10:relationship_ref[@relationship='encapsulation'] | ./cellml11:relationship_ref[@relationship='encapsulation']">
			<xsl:element name="encapsulation" namespace="http://www.cellml.org/cellml/2.0#">
				<xsl:apply-templates select="@cmeta:id" />
				<xsl:apply-templates select="*"/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="cellml10:component_ref | cellml11:component_ref">
		<xsl:element name="component_ref" namespace="http://www.cellml.org/cellml/2.0#">
			<xsl:apply-templates select="@cmeta:id" />
			<xsl:attribute name="component">
				<xsl:value-of select="@component"/>
			</xsl:attribute>
			<xsl:apply-templates select="*"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="@name">
		<xsl:attribute name="name">
			<xsl:value-of select="." />
  		</xsl:attribute>
	</xsl:template>
	
	<xsl:template match="@cmeta:id">
		<xsl:attribute name="id">
  			<xsl:value-of select="." />
  		</xsl:attribute>
	</xsl:template>


	<xsl:template match="*">
		<!-- don't do anything with elements we don't know -->
	</xsl:template>
</xsl:stylesheet>

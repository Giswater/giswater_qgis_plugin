<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" xsi:schemaLocation="http://www.opengis.net/sld http://schemas.opengis.net/sld/1.1.0/StyledLayerDescriptor.xsd" xmlns:se="http://www.opengis.net/se" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:ogc="http://www.opengis.net/ogc" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.1.0">
  <NamedLayer>
    <se:Name>CONDUITS</se:Name>
    <UserStyle>
      <se:Name>CONDUITS</se:Name>
      <se:FeatureTypeStyle>
        <se:Rule>
          <se:Name>Single symbol</se:Name>
          <!--SymbolLayerV2 FilledLine not implemented yet-->
          <se:LineSymbolizer>
            <se:VendorOption name="placement">centralPoint</se:VendorOption>
            <se:Stroke>
              <se:GraphicStroke>
                <se:Graphic>
                  <se:Mark>
                    <se:WellKnownName>triangle</se:WellKnownName>
                    <se:Fill>
                      <se:SvgParameter name="fill">#f6fe63</se:SvgParameter>
                    </se:Fill>
                    <se:Stroke>
                      <se:SvgParameter name="stroke">#414108</se:SvgParameter>
                      <se:SvgParameter name="stroke-width">1</se:SvgParameter>
                    </se:Stroke>
                  </se:Mark>
                  <se:Size>7</se:Size>
                  <se:Rotation>
                    <ogc:Literal>90</ogc:Literal>
                  </se:Rotation>
                </se:Graphic>
              </se:GraphicStroke>
            </se:Stroke>
          </se:LineSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:MinScaleDenominator>1</se:MinScaleDenominator>
          <se:MaxScaleDenominator>1000</se:MaxScaleDenominator>
          <se:TextSymbolizer>
            <se:Label>
              <!--SE Export for format('%1\nL=%2 m%3%4\n%5\nH = %6 m', name, round("CONDUITS.length", 1), if("CONDUITS.offset_upstream", format('\nInOffset:  %1 m', "CONDUITS.offset_upstream"), ''), if("CONDUITS.offset_downstream", format('\nOutOffset:  %1 m', "CONDUITS.offset_downstream"), ''), if("XSECTIONS.curve_name" IS NULL, "XSECTIONS.shape", "XSECTIONS.curve_name"), "XSECTIONS.height") not implemented yet-->Placeholder</se:Label>
            <se:Font>
              <se:SvgParameter name="font-family">JetBrains Mono</se:SvgParameter>
              <se:SvgParameter name="font-size">13</se:SvgParameter>
            </se:Font>
            <se:LabelPlacement>
              <se:LinePlacement>
                <se:PerpendicularOffset>11</se:PerpendicularOffset>
                <se:GeneralizeLine>true</se:GeneralizeLine>
              </se:LinePlacement>
            </se:LabelPlacement>
            <se:Fill>
              <se:SvgParameter name="fill">#000000</se:SvgParameter>
              <se:SvgParameter name="fill-opacity">0.8</se:SvgParameter>
            </se:Fill>
            <se:Graphic>
              <se:Mark>
                <se:WellKnownName>square</se:WellKnownName>
                <se:Fill>
                  <se:SvgParameter name="fill">#ffffff</se:SvgParameter>
                </se:Fill>
                <se:Stroke>
                  <se:SvgParameter name="stroke">#f6fe63</se:SvgParameter>
                  <se:SvgParameter name="stroke-width">1</se:SvgParameter>
                </se:Stroke>
              </se:Mark>
              <se:Size>4</se:Size>
            </se:Graphic>
            <se:Priority>0</se:Priority>
            <se:VendorOption name="graphic-resize">stretch</se:VendorOption>
            <se:VendorOption name="graphic-margin">2 2</se:VendorOption>
          </se:TextSymbolizer>
        </se:Rule>
      </se:FeatureTypeStyle>
    </UserStyle>
  </NamedLayer>
</StyledLayerDescriptor>

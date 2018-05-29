---
output: html_document
---
<head>
 <style>
 img.example {
 width: 30%;
 height: 250px;
 margin-bottom: 10px;
 margin-right: 10px;
 }
 .font {
 font-size: large;
 display: table;
 }
 hr {
 margin-top: 20px;
 margin-bottom: 50px;
 border-top: 2px solid;
 border-top-color: #CECECE;
 }
 </style>
</head>

# WIlsON: Webbased Interactive Omics visualizatioN

<p class="font" class="justify">
 The WIlsON app is based on a specialized tab-delimited input file format called <a href="https://github.molgen.mpg.de/loosolab/wilson-apps/wiki/CLARION-Format">CLARION</a>. All types of data which can be broken down to a feature with assigned numerical values can be deployed on the WIlsON server (e.g. multi-omics). A user can then generate various plots following four basic steps:</br>
 
 <ol class="font">
 <li>Filter for features of interest based on categorical (annotation) or numerical values (e.g. transcripts, genes, proteins, probes)</li>
 <li>Select plot type</li>
 <li>Adjust plot parameters</li>
 <li>Render/download result</li>
 </ol>
</p>

## <a name="examples"></a> Examples

<img src="images/example_barplot.png" class="example" />
<img src="images/example_boxplot.png" class="example"/>
<img src="images/example_global_correlation_heatmap.png" class="example"/>
<img src="images/example_heatmap_1.png" class="example"/>
<img src="images/example_heatmap_2.png" class="example"/>
<img src="images/example_lineplot.png" class="example"/>
<img src="images/example_scatterplot_1.png" class="example"/>
<img src="images/example_scatterplot_2.png" class="example"/>
<img src="images/example_scatterplot_3.png" class="example"/>

</br>
## Please check the <a href="https://github.molgen.mpg.de/loosolab/wilson-apps/wiki">**documentation**</a> for a detailed introduction to WIlsON!
## Access the demo datasets <a href="https://github.molgen.mpg.de/loosolab/wilson-apps/tree/master/wilson-basic/data">**here**</a>.


</br><hr>
## <a name="contact_license"></a> Contact and License
<p class="font" class="justify">
</br>
Wilson was created by Hendrik Schultheis, Jens Preussner, Carsten Kuenne, and Mario Looso.
</br></br>
Bioinformatics Core Unit, Max Planck Institute for Heart and Lung Research, Bad Nauheim, Germany.
</br></br>
Copyright (C) 2017. This project is licensed under the MIT license.
</br></br>
The source code for the modular Wilson R package is available on <a href="https://github.molgen.mpg.de/loosolab/wilson">Github.</a>
</br>
The source code for the Wilson application implementing that package is available on <a href="https://github.molgen.mpg.de/loosolab/wilson-apps">Github.</a>
</br>
The container for the Wilson application ist available on <a href="https://hub.docker.com/r/loosolab/wilson/">Docker.</a>
</p>

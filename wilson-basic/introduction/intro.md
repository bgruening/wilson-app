---
output: html_document
---
<head>
 <style>
 img.example {
 width: 15%;
 height: 15%;
 }
 img.plot {
 width: 30%;
 height: 30%;
 float: left;
 margin-right: 20px;
 }
 .font {
 font-size: large;
 display: table;
 }
 p.plot {
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
 The WIlsON app is based on a tab-delimited input file format derived from a "summarized experiment" of interest (format is called CLARION, see Introduction-->Data Format). All types of data which can be broken down to a feature with assigned numerical values can be deployed on the WIlsON server (e.g. multi-omics). A user can then generate various plots following four basic steps:</br>
 
 <ol class="font">
 <li>Filter for features of interest based on categorical or numerical values (e.g. transcripts, genes, proteins, probes)</li>
 <li>Select plot type</li>
 <li>Adjust plot parameters</li>
 <li>Render/download result</li>
 </ol>
</p>

## <a name="examples"></a> Examples

<img src="images/example_boxplot.png" class="example" />
<img src="images/example_barplot.png" class="example"/>
<img src="images/example_violinplot.png" class="example"/>
<img src="images/example_lineplot.png" class="example"/>
<img src="images/example_pca2.png" class="example"/>
<img src="images/example_global_corr_heatmap1.png" class="example"/>
<img src="images/example_global_corr_heatmap2.png" class="example"/>
<img src="images/example_scatterplot1.png" class="example"/>
<img src="images/example_scatterplot8.png" class="example"/>
<img src="images/example_scatterplot9.png" class="example"/>
<img src="images/example_heatmap4.png" class="example"/>
<img src="images/example_heatmap2.png" class="example"/>

<hr>
## <a name="basic_structure"></a> Basic Structure

<p class="font" class="justify">
 The layout of each page is fairly similar. The top bar permits selection of a plotting application while the remaining space is usually divided the following way:
</p>

<img src="images/layout.png" style="width: 70%; height: 70%"/>
### Sidebar
<p class="font">
 It shows the currently selected features as well as global parameters depending on the plot/filter.
</p>
### Options
<p class="font">
 These tabs provide access to several subsections:  plots, plot variants, filters or data tables. Tables contain the specific subset of data used for the plot.
</p>
### Plot area / result
<p class="font">
 This area will show the result of the current rendering/filtering: either a plot or the data as a table.
</p>
### Interface
<p class="font">
 The bottom interface contains most of the parameters defining a plot, including axis transformation, coloring etc.
</p>

<hr>
## <a name="feature_selection"></a> Feature Selection

<p class="font justify">
 As mentioned above, the first step of WILsON is to select the tab "Feature Selection" at the top menue. This allows to select a subset of data to be used for plotting by applying filtering steps (without filtering all features of the dataset will be plotted).
 The table at the top of the "Feature Selection" page displays the current selection. Several tabs located below the table are intended for filtering steps based on various criteria available per feature. WILsON supports a presorting for sample, condition, and contrasts among others.
 The "highlight" pane supports the creation of a subset of the selected features. The highlighted data can be used in certain plots which support highlighting (e.g. scatterplot) to either add a fixed color or labels.
 After filtering, plots of interest can be selected and generated via the tabs on top.
</p>

### Table
<img src="images/feature_selector_table.png"/>

<p class="font" class="justify">
 <i>This is an example on a dataset filtered for various criteria. Within the selected feature table browsing, sorting and selection is supported. Some cells are truncated due to long text blocks('...'): to display these data just hover over the specific cell.</i>
</p>

### Filter
<p class="font">
 Based on the columns content (textual, numeric) WIlsON's Feature Selector will provide appropriate filter interfaces to enable an efficient way to select data.
</p>

#### **Textual (Annotation)**
<img src="images/feature_selector_annotation_field.png"/>
<p class="font"><i>
 Annotations can be filtered by clicking a dropdown menu containing all available values. The filter box supports querying as well. 'Backspace' can be used to deselect prior selections.
</i>
</p>

#### **Numeric (Value)**
<img src="images/feature_selector_range_slider.png"/>
<p class="font"><i>
 This filter is intented to select a numeric range. The 'inner' or 'outer' options allows the definition of either the range within the set markers (inner) or outside of the marker (outer), which is also displayed trough the slider coloring. As the step size is scaled according to the spread of the data, editable value fields aside the slider can be utilized to change the minimum and maximum value (slider range is recalculated).
</i>
</p>

### Additional options
<p class="font">
 Once the data is filtered, the remaining subset of features is displayed in the table on top of the feature selection page (see table above). This selection can be narrowed down further by e.g. a keyword search field on the top right of the table. Additionally, manual selection of rows by marking is supported as well. Sorting on specific columns by clicking the <b>column title</b> can help to find specific features of interest. Once the table is sorted correctly, it can be filtered for a specific number of entries.
</p>

<img src="images/feature_selector_row_selector.png"/></br>
<p class="font">
<i>Specific <b>rows</b> (row numbers) can be selected from the feature table via the slider shown above, a powerful filter in combination with column sorting and numeric filtering on e.g. fold changes. This could be used to e.g. generate a list of the top 50 up and down regulated genes on chromosome 3.
</i>
</p>

<hr>
## <a name="plots"></a> Plots

### Gene View
<p class="font plot">
<img src="images/lineplot.png" class="plot"/>
 The Gene Viewer consists of multiple plot types including line-, box-, violin- & barplots. It supports the visualization and comparison of individual genes and/or conditions.
</p>

### Data Reduction
#### PCA (Principal Component Analysis)
<p class="font plot">
 <img src="images/example_pca2.png" class="plot"/>
 A PCA is used to get an overview on the variation of the data based on the selected features. By default the two dimensions with the highest variation are selected (PC1 and PC2) and presented in a two-dimensional scatterplot.
</p>

#### Global Correlation Heatmap
<p class="font plot">
 <img src="images/global_corr_heatmap.png" class="plot"/>
 Similar to the PCA, this plot will show the global clustering of samples or conditions based on the selected features. A distance matrix is created using one of various options (e.g. euclidean, pearson, spearman, etc.) and visualized by a heatmap.
</p>

### Scatterplot
<p class="font plot">
 <img src="images/scatterplot.png" class="plot"/>
 This plot illustrates the dependency of two (X/Y axes) or three (X/Y/color) attributes. It supports a density estimation (kernel smoothing) and trend lines. The axes to be displayed can be chosen among the numeric columns to e.g. create Volcano, MA, or other kinds of scatter plots. The scatterplot supports highlighting of a subset of data (feature selection, pane highlight).
</p>

### Heatmap
<p class="font plot">
 <img src="images/heatmap.png" class="plot"/>
 Various parameters permit the creation of highly customized heatmaps of the selected features. Among these are different kinds of clusterings, transformations (log2, log10, rlog, zscore), and color schemes. The Heatmap module supports interactive and static heatmaps.
</p>

<hr>
## <a name="interactivity"></a> Interactivity
<p class="font">
Thanks to the plotly package, several plots are available as an interactive version offering a range of additional options:
</p>

<ul class="font">
  <li>Zoom / pan plot (either via UI or directly in plot)</li>
  <li>Mouse-over popup text box containing information of the selected feature</li>
  <li>Download currently selected viewport</li>
</ul>

<p class="font">
<b>It should be noted that the plotly plot versions generate a higher computational load (slower) than the default ggplot2 versions.</b>
</br>
</p>
<img src="images/plotly_ui.png" width="50%" height="50%"/>

<hr>
## <a name="help"></a> Help

<p class="font">
 <ul class="font">
 <li>All plots include an interactive help section. Click on <img src="images/guide_button.png"/> for a step by step tour on how to use the current interface.</li>
 <li>Even more details are given with the <img src="images/help_button.png"/> symbols.</li>
 </ul>
</p>

<hr>
## <a name="use_cases"></a> Use Cases

### Case 1
<p class="font">
<b>Dataset:</b> RNASeq Zhang 2015</br>
<b>Task:</b> Create a heatmap comparing expression levels between wildtype (wt) and mutant (mt). Only select genes which are significantly differentially expressed and further use the top 10 regarding the mean over all samples (BaseMean).</br>
</br>
 In order to filter, use the Feature Selection tab in a first step. For this example we want to filter for significantly differentially expressed genes, which is done on the <b>contrast</b> level. Set the following thresholds using inner/outer in combination with the range slider: fitted log2 fold change less than -2 <b>or</b> greater than 2 <b>and</b> p-value smaller than 0.1. As the latter might be difficult to select due to the tiny interval, change the max value of the slider using the box on the right side (essentially a zoom). Thereafter apply the filter by clicking on the select button above.
</p>
</p>
<img src="images/use_case_1_filter.png"/>

<p class="font">
 Now the filtered table will be shown on top of the page. To select the genes with the <b>highest BaseMean</b> click on the BaseMean column until the columns values are descending (arrow down). Further narrow it down by utilising the slider directly below the table to select the <b>top 10</b> genes.
</p>
<img src="images/use_case_1_filter_result.png" width="100%"/>

<p class="font">
 Now with this selection of features move on to the heatmap module (here not interactive). Select the <b>samples</b> and click on the plot button.
</p>
<img src="images/use_case_1_select_columns.png"/>
<img src="images/use_case_1_heatmap_1.png"/>

<p class="font">
 The resulting plot is troubled by the large range of the values (5000-25000) which can hinder the recognition of patterns. A row-wise z-score <b>Transformation</b> might help.
</p>
<img src="images/use_case_1_transformation.png"/>
<img src="images/use_case_1_heatmap_2.png"/>

<p class="font">
 Since the z-score transformation leads to a diverging (2-sided: -x..0..+x) distribution of values, another color palette would be optimal. Set <b>Data distribution</b> to diverging and select the <i>spectral color</i> scheme.
</p>
<img src="images/use_case_1_color_scheme.png"/>
<img src="images/use_case_1_heatmap_3.png"/>

<p class="font">
 As the values are not evenly distributed the color legend is not centered at 0 to solve this <b>winsorize</b> to -1 and 1 for a nicely centered color legend.
</p>
<img src="images/use_case_1_winsorize.png"/>
<img src="images/use_case_1_heatmap_4.png"/>

<p class="font">
 For an easier interpretation set the <b>row labels</b> to show the Gene names rather than the Gene ID.
</p>
<img src="images/use_case_1_column_label.png"/>
<img src="images/use_case_1_heatmap_finished.png"/>

### Case 2
<p class="font">
<b>Dataset:</b> RNASeq Zhang 2015</br>
<b>Task:</b> Compare wildtype (wt) versus mutant (mt) and show the significance. Also highlight/ label all genes which highly differentiate between conditions.</br>
</br>
 As this example is about a comparison on the whole dataset there is no need for filtering so far. Simply load up the correct dataset and proceed to the scatterplot (here static simple scatter). Now select from the column type condition for the x-axis wildtype (wt) and the y-axis mutant (mt).
</p>
<img src="images/use_case_2_select_xy.png" style="margin-bottom: 20px"/>
<img src="images/use_case_2_scatterplot_1.png"/>

<p class="font">
 With most of the genes being located in the lower part of the range there is a lot of overlapping. A log2 <b>Transformation</b> applied on both x- and y-axis will solve this.
</p>
<img src="images/use_case_2_transformation.png" style="margin-bottom: 20px"/>
<img src="images/use_case_2_scatterplot_2.png"/>

<p class="font">
 This plot already shows a comparison between wt and mt so the next step is adding the significance via <b>z-axis color mapping</b>. To achieve this select the p-adjusted value (Padj) from the column type contrast.
</p>
<img src="images/use_case_2_select_z.png" style="margin-bottom: 20px"/>
<img src="images/use_case_2_scatterplot_3.png"/>

<p class="font">
 In addition select a fitting <b>color scheme</b> in this example inferno is used.
</p>
<img src="images/use_case_2_color_scheme.png" style="margin-bottom: 20px"/>
<img src="images/use_case_2_scatterplot_4.png"/>

<p class="font">
 Set the <b>pointsize</b> to 1.6 for a better distinction between points.
</p>
<img src="images/use_case_2_pointsize.png" style="margin-bottom: 20px"/>
<img src="images/use_case_2_scatterplot_5.png"/>

<p class="font">
 For more insides about the datas distribution enable a <b>2D kernel density estimate</b> and disable the <b>reference line</b> aswell.
</p>
<img src="images/use_case_2_density.png" style="margin-bottom: 20px"/>
<img src="images/use_case_2_scatterplot_6.png"/>

<p class="font">
 Regarding the comparison between wt and mt the scatterplot is done. The last missing part is to add the highlighting of highly differentiated genes between conditions. To do so go back to <b>featureSelection</b>, select the <b>highlight-tab</b> and filter for the respecting features.
</p>
<img src="images/use_case_2_highlight_tab.png" width="35%"/>

<p class="font">
 Filter for highly differentiated genes between conditions by first expanding the contrast box and second setting the Fitted Log2FoldChange to select values less than -3 or higher than 3. Apply the filter by clicking the filter button.</br>
 Note: The filter will display an empty table on default meaning there is nothing highlighted.
</p>
<img src="images/use_case_2_highlight_filter.png"/>

<p class="font">
 Return back to the scatterplot. Set the highlight/ label options in <b>Global Parameters</b> (left side) choose Highlight to enable highlighting based on the beforehand filtered features, select a specific color for the respecting points (here green) and define a label (here Ensemble gene).
</p>
<img src="images/use_case_2_highlight_options.png" style="margin-bottom: 20px"/>
<img src="images/use_case_2_scatterplot_final.png"/>

### Case 3
<p class="font">
 <b>Dataset:</b> RNASeq Zhang 2015</br>
<b>Task:</b> Create scatterplot of non-coding RNAs including labeling of those with the most prominent up-regulation</br>
</br>
 First select non-coding RNAs on the <b>feature</b> level: <b>Ensembl biotype</b> = <i>miRNA, lincRNA, antisense</i>. Then switch to the <b>Scatterplot/Simple Scatter</b> tab: choose the <b>X-axis</b> data to be type <i>condition</i>, column <i>wt</i>, transformation <i>log2</i>, and <b>Y-axis</b> data to be type <i>condition</i>, column <i>mt</i>, transformation <i>log2</i>. This will compare the mean normalized counts per condition of the selected non-coding RNAs.
</p>
<img src="images/use_case_3_1_uncolored.png"/>

<p class="font">
In order to color the scatterplot by Log2FC please choose Z-axis to be type <b>contrast</b> and column <i>Unfitted Log2FoldChange (mt/wt)</i>. Furthermore set the <b>Color scheme</b> to <i>Diverging/BuWtRd</i>. The resulting plot shows RNAs up-regulated in the <i>mt</i> condition using red dots. But the colors are slightly pale and do not seem to be centered around 0.
</p>
<img src="images/use_case_3_2_pale.png"/>

<p class="font">
Tick <b>Winsorize to upper/lower</b>, then set <b>Lower limit</b> to <i>-1</i> and <b>Upper limit</b> to <i>1</i> to modify the color palette range to be more intense and centered around 0.
</p>
<img src="images/use_case_3_3_intense.png"/>

<p class="font">
Next please go back to the <b>Feature Selection</b> tab and switch from the Data to the <b>Highlight</b> sub-tab to select a subset of features to be labeled inside the plot. Open the <b>contrast</b> level and select <b>BaseMean</b> <i>>= 100</i> and <b>Unfitted Log2FoldChange (mt/wt)</b> <i>>= 0.5</i> to get RNAs with a certain minimum expression and up-regulated in the mutant. Now switch to the <b>Scatterplot/Simple Scatter</b> tab again and set the <b>Highlight/Label Selected Features</b> on the side bar to <i>Highlight</i>. Furthermore change <b>Select label column</b> to <i>Ensembl gene</i> to use the gene symbol for display as a label.
</p>
<img src="images/use_case_3_4_label.png"/>



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

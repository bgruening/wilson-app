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

<p class="font">
 The WIlsON app is based on a clearly defined tab-delimited input file format derived from the "summarized experiment" format called CLARION. All types of data which can be broken down to a feature with assigned numerical values can be deployed on the WIlsON server (e.g. multi-omics). A user can then generate various plots following four basic steps:</br>
 
 <ol class="font">
 <li>Filter for features of interest based on categorical or numerical values (e.g. transcripts, genes, proteins, probes)</li>
 <li>Select plot type</li>
 <li>Adjust plot parameters</li>
 <li>Render/download result</li>
 </ol>
</p>

## <a name="examples"></a> Examples

<img src="example_boxplot.png" class="example" />
<img src="example_barplot.png" class="example"/>
<img src="example_violinplot.png" class="example"/>
<img src="example_lineplot.png" class="example"/>
<img src="example_pca2.png" class="example"/>
<img src="example_global_corr_heatmap1.png" class="example"/>
<img src="example_global_corr_heatmap2.png" class="example"/>
<img src="example_scatterplot1.png" class="example"/>
<img src="example_scatterplot8.png" class="example"/>
<img src="example_scatterplot9.png" class="example"/>
<img src="example_heatmap4.png" class="example"/>
<img src="example_heatmap2.png" class="example"/>

<hr>
## <a name="basic_structure"></a> Basic Structure

<p class="font">
 The layout of each page is fairly similar. The top bar permits selection of a plotting application while the remaining space is usually divided the following way:
</p>

<img src="layout.png" style="width: 70%; height: 70%"/>
### Sidebar
<p class="font">
 It shows the currently selected features and also sometimes global parameters depending on the plot/filter.
</p>
### Options
<p class="font">
 These tabs provide access to different subsections: different plots, plot variants, filters or data tables. Tables contain the specific subset of data used for the plot.
</p>
### Plot area / result
<p class="font">
 This part of the page will show the result of the current computation: either a plot or the data as a table.
</p>
### Interface
<p class="font">
 The bottom interface contains most of the parameters defining the plot.
</p>

<hr>
## <a name="feature_selection"></a> Feature Selection

<p class="font">
 As mentioned above to start using WIlsON the first step should be almost always to select the tab "Feature Selection" at the top of the page. This will allow to select a subset of data to be used for plotting (otherwise all features of the dataset will be plotted).
 </br>
 The table at the top of the "Feature Selection" page shows the currently selected features. Several tabs will be located below that permit the filtering based on annotation or numerical data available per feature.</br>
 With a click on "highlight" it is possible to create a second subset of features. The highlighted data will be used in certain plots which support highlighting (e.g. scatterplot) to either add a fixed color or exclusively display this subset of features.</br>
 After everything is filtered, please proceed to the plots which are also selected via the tabs on top.
</p>

### Table
<img src="feature_selector_table.png"/>

<p class="font">
 This is an example on how the data will be displayed after filtering. With this table you are able to browse trough the currently selected dataset. Also you may have noticed that some of the cells are truncated ('...'): to see these data just hover over the specific cell.
</p>

### Filter
<p class="font">
 Based on the columns content being textual or numeric, WIlsON's featureSelector will provide a different filter module enabling an efficient way to select data. 
</p>

#### Textual (Annotation)
<img src="feature_selector_annotation_field.png"/>
<p class="font">
 Annotations can be filtered by clicking a dropdown menu containing all available items. Furthermore these items can be filtered by entering a search text. Use 'Backspace' to deselect unwanted selections.
</p>

#### Numeric (Value)
<img src="feature_selector_range_slider.png"/>
<p class="font">
 This filter permits to select a range of numeric values. To do so choose one of the options 'inner' or 'outer': this will either select the range between the points (inner) or outside of the points (outer), which is also displayed trough the slider coloring. The range is picked by dragging the points which can also be moved together by clicking between them. As the step size can be rather large compared to the distributed data, the selectable values on the slider can be changed. This is done by effectively changing the minimum and maximum value which causes the slider to recalculate its range and step size. This is accomplished by changing the values for the number fields located lefft and right of the slider.
</p>

### Additional options (coming soon)
<p class="font">
 After the data is filtered, the remaining subset of features is diplayed on top of the page (see table above). This pool can further be filtered by a keyword search field on the top right of the table. Additionally the table can be reordered with a click on one of the column names which will be done after searching.
</p>

<img src="feature_selector_row_selector.png"/></br>
<p class="font">
 Finally specific rows can be selected via this slider which is working like the numeric slider above. And to specifiy even further they also can be selected/ deselected by clicking on the specific row.
</p>

<hr>
## <a name="plots"></a> Plots

### Gene View
<p class="font plot">
<img src="lineplot.png" class="plot"/>
 The Gene Viewer consists of multiple plot types including line-, box-, violin- & barplots. You can use it to view and compare individual genes or conditions.
</p>

### Data Reduction
#### PCA (Principal Component Analysis)
<p class="font plot">
 <img src="example_pca2.png" class="plot"/>
 A PCA is used to get an overview of the variation of the data based on the selected features. By default the two dimensions with the most variation are selected, which will result in a two-dimensional scatterplot showing groups of similar samples.
</p>

#### Global Correlation Heatmap
<p class="font plot">
 <img src="global_corr_heatmap.png" class="plot"/>
 Similar to the PCA, this plot will show the global clustering of samples or conditions based on the selected features. A distance matrix is created using one of various options (e.g. euclidean, pearson, spearman, etc.) and clustered using a heatmap.
</p>

### Scatterplot
<p class="font plot">
 <img src="scatterplot.png" class="plot"/>
 This plot can be used to display the dependence of two (X/Y axes) or three (color) attributes. Also a density estimation (kernel smoothing) and a reference line can be enabled. The axes to be displayed can be freely chosen among the numeric columns to e.g. create Volcano, MA, or other kinds of scatter plots, if the respective data was supplied. Furthermore a subset of data can be used to highlight specific points in the set.
</p>

### Heatmap
<p class="font plot">
 <img src="heatmap.png" class="plot"/>
 Various parameters permit the creation of highly customized heatmaps of the selected features. Among these are different kinds of clusterings, transformations (log2, log10, rlog, zscore), and color schemes.
</p>

<hr>
## <a name="interactivity"></a> Interactivity
<p class="font">
Thanks to the plotly package several of the plots are interactive. These plots yield two major advantages zooming and supplementary information.
To be able to zoom use the UI on the top right of the plot. It will only appear if the mouse hovers over the plot.
The UI grants the ability to:
</p>

<ul class="font">
  <li>download currently selected viewport</li>
  <li>zoom/ pan plot (either via UI or directly in plot)</li>
  <li>select subset (currently not implemented)</li>
  <li>compare datapoints (currently not implemented)</li>
</ul>

<p class="font">
Furthermore on hover a hovertext will appear which contains information to the specific point.</br>
</br>
<b>Note: Interactive plots are really great. But as great as they are sometimes they just can't get it right. In such cases please resort to their none interactive counterparts.</b>
</p>
<img src="plotly_ui.png" width="50%" height="50%"/>

<hr>
## <a name="help"></a> Help

<p class="font">
 <ul class="font">
 <li>Click on <img src="guide_button.png"/> for a step by step guide on how to use the current page.</li>
 <li>For more information search for <img src="help_button.png"/>.</li>
 </ul>
</p>

<hr>
## <a name="use_cases"></a> Use Cases

### Case 1
<p class="font">
<b>Create a heatmap of significantly differentially expressed protein coding genes involved in BMP signaling pathway</b></br>
</br>
 To create a plot like this data is needed which internally is forwarded to the plot. On default the whole dataset will be used. Which means that if we don't filter, go to the heatmap and select in this case all the samples we will get a warning message:
</p>
<img src="case1_1_no_filter.png" width="70%" height="70%"/>

<p class="font">
 So back to the Feature Selection where a reasonable subset can be created.</br>
 For this instance we want to filter for significantly differentially expressed genes. To do so we need to filter for contrasts therefore we expand the contrasts box.
</p>
<img src="case1_2_contrast1.png" width="70%" height="70%"/>

<p class="font">
 Now as the filter elements are shown it is possible to filter for a log2 fold change less than -1 and greater than 1. And also for a p-adjusted value smaller than 0.01 but as it is difficult to select such a small value on this slider we rearrange it's intervall by setting the maximum value 0.02 which essentially causes the slider to zoom.
</p>
<img src="case1_2_contrast2.png" width="70%" height="70%"/>

<p class="font">
 Moreover only protein coding genes which are involved in the BMP signaling pathway should be filtered. Which are selected after expanding the feature box.
</p>
<img src="case1_2_feature.png" width="70%" height="70%"/>

<p class="font">
 Last but not least the now selected filter must be applied to create a subset. This is done by clicking on the select button which should lead to a table like this.
</p>
<img src="case1_3_table.png" width="70%" height="70%"/>

<p class="font">
 Now with a meaningful subset we return to the heatmap (here not interactive). If the samples aren't selected from our previous attempt we select them and click on the plot button.
</p>
<img src="case1_4_plot1.png"/>

<p class="font">
 This already rather nice looking plot can be improved by applying a row-wise zscore transformation. Which will compensate a high range on the data so differences can be seen a lot easier.
</p>
<img src="case1_4_plot2.png"/>

<p class="font">
 The last touch for this heatmap should be to use a more fitting color scheme. With the z-score transformation the plots data is now diverging. This can be selected via 'data distribution' thus enabling diverging color schemes below. In this example the scheme 'spectral' was selected. Also for clarification a label can be set for the legend as we used the z-score transformation it will be 'z score' for this plot.
</p>
<img src="case1_4_ui.png" width="70%" height="70%" style="margin-bottom:20px"/>
<img src="case1_4_plot3.png"/>

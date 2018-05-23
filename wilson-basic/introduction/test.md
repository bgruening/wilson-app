---
output: html_document
---

# Data Format
<p class="font">
  <b>CLARION: generiC fiLe formAt foR quantItative cOmparsions of high throughput screeNs</b>
  <br><br>
   CLARION is a data format especially developed to be used with WIlsON, which relies on a tab-delimited table with a metadata header to describe the following columns. It is based on the Summarized Experiment format and supports all types of data which can be reduced to features and their annotation (e.g. genes, transcripts, proteins, probes) with assigned numerical values (e.g. count, score, log2foldchange, z-score, p-value). The feature annotations (e.g. symbol, GO category, KEGG pathways, etc.) and numerical values can later be used for filtering and plotting. Minimally, a row in such a table has to contain a unique identifier for the feature (e.g. accession) and one numerical value. Most result tables derived from RNA-Seq, ChIP/ATAC-Seq, Proteomics, Microarrays, and many other analyses can thus be easily reformatted to become compatible without having to modify the code of WIlsON for each specific experiment.
   <br><br>It is suggested to use a spreadsheet software (e.g. Excel) to perform a manual reformat of the original tab-delimited table (shown in green in the following figure) in order to avoid errors due to shifted columns. In order to become CLARION, two blocks of descriptive information have to be inserted above the original table called header (red) and metadata (blue).
  <br><br>
  <img src="images/clarion_excel_colored.png" width="100%">
  <br>
  <p class="font">
  The format consists of three blocks of tab-delimited data layered on top of each other. These follow distinct structures:
  <ul class="font">
    <li><b>Header</b> (blue): Parameters concerning the global experiment. Most of these are for connection to surrounding workflows and can be ignored.</li>
    <li><b>Metadata</b> (red): Parameters describing the content of each data column. Most importantly, these categorize the columns into 4 different <b>levels</b>: feature (= annotation; can only be used for filtering and plot labeling) and sample/condition/contrast (= numeric values; can be used for filtering and plotting). The grouping of the numeric values into multiple levels is intended to simplify later user selections inside the web interface and has no further use as of now. The <b>type</b> category designates e.g. the unique identifier column (<i>unique_id</i>) and the column having the default name for the feature (<i>name</i>). The remaining categories (<b>factor</b>/<b>label</b>/<b>sub_label</b>) are optional and mostly change the labels shown inside the web interface.</li>
    <li><b>Data</b> (green): Matrix of tab-delimited data columns bearing textual and numerical information per feature (= the original table).</li>
  </ul>
  </p>
</p>

</br>
## <a name="header"></a> Header:
<img src="images/header.png"/>
<p class="font">
  <ul class="font">
    <li>Line identifier: '!'</li>
    <li>Syntax: name = value</li>
    <li>Mandatory columns are marked with an asterisk (*) in the following description.</li>
  </ul>
</p>
### Parameters:
<p class="font">
  <ul class="font">
    <li><b>format</b>: Name of the file format (must be Clarion)</li>
    <li><b>version</b>: Version of the file format (1.0)</li>
    <li><b>experiment_id</b>: Unique id to be used for the experiment</li>
    <li><b>delimiter(*)</b>: In-field delimiter for multi-value fields (e.g. multiple KEGG pathways). Multi-character delimiters are possible (e.g. ", "). This permits filtering according to the single elements found in this column (e.g. "regulation of transcription, transporter activity" would be interpreted as having the separate values "regulation of transcription" and "transporter activity").</li>
  </ul>
</p>

</br>
## <a name="metadata"></a> Metadata:
<img src="images/metadata.png"/>
<p class="font">
  <ul class="font">
    <li>Line identifier: '#'</li>
    <li>Mandatory columns are marked with an asterisk (*) in the following description.</li>
  </ul>
</p>
### Columns:
<p class="font">
  <ul class="font">
    <li><b>key</b>*:</li>
      <ul class="font">
        <li>Reference to data matrix (column headline)</li>
        <li>Must be unique</li>
      </ul>
    <li><b>factor1 - factorN</b>:</li>
      <ul class="font"><li>Denotes experimental factors (e.g. wildtype, mutant, time point) per sample and condition</li></ul>
      <ul class="font"><li>One or more columns (factor1, factor2, ..., factorN)</li></ul>
      <ul class="font"><li>Used for grouping</li></ul>
    <li><b>level</b>*:</li>
      <ul class="font">
        <li>Classifies content of column</li>
        <li>Must be one of:</li>
        <ul class="font">
          <li><i>sample:</i> Data relating to a single sample</li>
          <li><i>condition:</i> Data relating to a single condition (combination of all samples; e.g. average count)</li>
          <li><i>contrast:</i> Data relating to a single contrast (pairwise comparison of conditions)</li>
          <li><i>feature:</i> Annotation relating to a feature (e.g. gene, transcript, probe, protein, ...)</li>
        </ul>
      </ul>
    <li><b>type(*)</b>:</li>
      <ul class="font">
        <li>Mandatory for multi-value fields</li>
        <li>Further classify content level</li>
        <li>Must be one of:</li>
        <li>For level = feature = values to be filtered for</li>
        <ul class="font">
          <li><i>unique_id:</i> Unique identifier (e.g. ENSMUSG00000023944)</li>
          <li><i>name:</i> Main feature name / symbol / label (e.g. Hsp90ab1)</li>
          <li><i>category:</i> Single value per field; categorical data (e.g. protein_coding)</li>
          <li><i>array:</i> Multiple delimited values per field; categorical data (e.g. Cholinergic synapse|Choline metabolism in cancer)</li>
        </ul>
        <li>For levels = sample, condition, contrast = values to be plotted</li>
        <ul class="font">
          <li><i>score:</i> count, intensity, ...</li>
          <li><i>ratio:</i> foldchange, log2foldchange, ...</li>
          <li><i>probability:</i> pvalue, padj, ...</li>
          <li><i>array:</i> Multiple numeric values per field; e.g. coverage/windows, ...</li>
        </ul>
        <li>Attention: if the type is not given, the first feature column is expected to hold a unique identifier!</li>
      </ul>
    <li><b>label</b>:</li>
      <ul class="font">
        <li>Optional label alternative to column name</li>
        <li>Can be used for plotting</li>
        <li>Should be unique</li>
        <li>For level = contrast delimited by '|' (condition1|condition2)</li>
      </ul>
    <li><b>sub_label</b>:</li>
      <ul class="font"><li>Optional more detailed label to offer a logical subselection of a column using the interface</li></ul>
  </ul>
</p>

</br>
## <a name="data"></a> Data:
<img src="images/data.png"/>
<p class="font">
  <ul class="font">
    <li>Traditional tab-delimited data matrix</li>
    <li>Minimum: one column with a unique id; one column with a numerical value</li>
    <li>If types are missing first column will be treated as unique_id</li>
  </ul>
</p>
